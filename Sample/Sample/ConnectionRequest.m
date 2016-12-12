//
//  ConnectionRequest.m
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import "ConnectionRequest.h"
#import "ConnectionManager.h"

@interface ConnectionRequest (){
    BOOL isUploadingImage;
}

@end

@implementation ConnectionRequest

@synthesize requestID;

-(instancetype)initWithDelegate:(id<ConnectionRequestDelegate>)delegate andrequestURL:(NSString *)requestURL andHTTPMethod:(ConnectionRequestHTTPMethod)requestMethod andParameters:(NSMutableDictionary *)parameters andIncluedAuthenticationToken:(BOOL) incluedAuthenticationToken andShowLoading:(BOOL)showLoading andRequestID:(OperationID)aRequestID andIsCoreRequest:(BOOL)isACoreRequest{
    self = [super init];
    self.delegate = delegate;
    self.requestURL = requestURL;
    self.requestMethod = requestMethod;
    self.isRequestCanceled = NO;
    self.data = [NSMutableData data];
    self.incluedAuthenticationToken = incluedAuthenticationToken;
    self.parameters = parameters;
    self.showLoading = showLoading;
    self.isCompleteURL = NO;
    self.isCoreRequest = isACoreRequest;
    requestID = aRequestID;
    isUploadingImage = NO;
    
    return self;
}

-(NSURL *)setUpURL{
    NSString *urlString;
    NSString *andString = @"";
    BOOL isFirstKeyAdded = self.incluedAuthenticationToken;
    
    if(self.isCompleteURL){
        urlString = self.requestURL;
    }else{
        urlString = [NSString stringWithFormat:@"%@%@",[[BackEndConfigurationsDataCenter sharedCenter] getServiceURL],self.requestURL];
    }
    
    if(self.requestMethod == ConnectionRequestHTTPMethodGET){
        if(self.incluedAuthenticationToken){
//            urlString = [NSString stringWithFormat:@"%@?auth_token=%@",urlString,[UserIdentificationDataCenter sharedCenter].authenticationToken];
        }else if(self.parameters != nil && self.parameters.count > 0){
            urlString = [NSString stringWithFormat:@"%@?",urlString];
        }
        
        for (NSString *key in [self.parameters keyEnumerator]) {
            andString = isFirstKeyAdded ? @"&" : @"";
            urlString = [NSString stringWithFormat:@"%@%@%@=%@",urlString,andString,key,[self.parameters objectForKey:key]];
        }
    }
    
    return [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]];
}

-(NSData *) setUpRequestBody{
    NSError *error;
    if(self.parameters == nil){
        self.parameters = [NSMutableDictionary new];
    }
    if(self.incluedAuthenticationToken){
//        [self.parameters setValue:[UserIdentificationDataCenter sharedCenter].authenticationToken forKey:@"auth_token"];
    }
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:self.parameters options:0 error:&error];
    
    return bodyData;
}

-(void)setUpHeaders{
    [self.request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

-(void)setUpRequest{
    self.request = [NSMutableURLRequest requestWithURL:[self setUpURL]];
    
    if(self.requestMethod == ConnectionRequestHTTPMethodGET){
        [self.request setHTTPMethod:@"GET"];
    }else if(self.requestMethod == ConnectionRequestHTTPMethodPOST){
        [self.request setHTTPMethod:@"POST"];
        [self setUpHeaders];
        [self.request setHTTPBody:[self setUpRequestBody]];
    }else if(self.requestMethod == ConnectionRequestHTTPMethodDELETE){
        [self.request setHTTPMethod:@"DELETE"];
        [self setUpHeaders];
        [self.request setHTTPBody:[self setUpRequestBody]];
    }else if(self.requestMethod == ConnectionRequestHTTPMethodPUT){
        [self.request setHTTPMethod:@"PUT"];
        [self setUpHeaders];
        [self.request setHTTPBody:[self setUpRequestBody]];
    }
}

-(void)initiateRequest{
    if(!isUploadingImage){
        [self setUpRequest];
    }

    [[ConnectionManager sharedManager] addRequest:self];
}

-(void)connectionManagerDidRecieveError:(NSError *)error{    
    if(_delegate != nil && [_delegate respondsToSelector:@selector(request:didRecieveError:)]){
        [_delegate request:self didRecieveError:error];
    }
}

-(void)connectionManagerDidCompleteLoadingData{    
    if(_delegate != nil && [_delegate respondsToSelector:@selector(request:didCompleteLoadingData:)]){
        [_delegate request:self didCompleteLoadingData:self.data];
    }
}

-(void)uploadImage:(UIImage *)image withKey:(NSString *)key{
    isUploadingImage = YES;
    CGSize newSize = CGSizeMake(64.0f, 64.0f);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSString *urlString;
    
    urlString = [NSString stringWithFormat:@"%@%@",[[BackEndConfigurationsDataCenter sharedCenter] getServiceURL],self.requestURL];
    
    if(self.incluedAuthenticationToken){
//        urlString = [NSString stringWithFormat:@"%@?auth_token=%@",urlString,[UserIdentificationDataCenter sharedCenter].authenticationToken];
    }
    
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]]];
    
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 1.0);
    
    [_request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [_request setHTTPShouldHandleCookies:NO];
    [_request setTimeoutInterval:60];
    [_request setHTTPMethod:@"PUT"];
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [_request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=avatar.png\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [_request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [self initiateRequest];
}

@end
