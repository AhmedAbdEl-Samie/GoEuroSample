//
//  ConnectionManager.m
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import "ConnectionManager.h"
#import "NetworkManager.h"
#import "LoadingView.h"

static ConnectionManager* sharedInstance = nil;
static dispatch_once_t sharedManagerCreationOnceToken;

@interface ConnectionManager (){
    BOOL isCurrentlyContainingOnlyCoreRequests;
}

@end

@implementation ConnectionManager

+(ConnectionManager *) sharedManager{
    dispatch_once(&sharedManagerCreationOnceToken, ^{
        sharedInstance = [[ConnectionManager alloc] init];
        [sharedInstance validateGlobalVariables];
    });
    return sharedInstance;
}


-(void) deleteAllConnections{
    for (ConnectionRequest* req in downlaodRequests) {
        req.isRequestCanceled = YES;
    }
    
    for (NSString* key in [activeRequests keyEnumerator]) {
        ((ConnectionRequest *)[activeRequests objectForKey:key]).isRequestCanceled = YES;
        [activeRequests removeObjectForKey:key];
    }
    
    for (NSString* key in activeTasks) {
        NSURLSessionDataTask* task = [activeTasks objectForKey:key];
        [task cancel];
    }
}

-(void)startDownloadRequests{
    if([[NetworkManager sharedManager] isConnectedToInternet]){
        isCurrentlyContainingOnlyCoreRequests = NO;
        for (int n=(int)[activeTasks count]; n<noOfAllowedDownloadThreads && n<[downlaodRequests count]; n++) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            ConnectionRequest* request = [downlaodRequests objectAtIndex:0];
            [downlaodRequests removeObjectAtIndex:0];
            
            if(request.showLoading){
                [[LoadingView sharedView] show];
            }
            
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request.request];
            
            [activeTasks setObject:dataTask forKey:[NSString stringWithFormat:@"%d",(int)dataTask]];
            [activeRequests setObject:request forKey:[NSString stringWithFormat:@"%d",(int)dataTask]];
            
            [dataTask resume];
        }
    }else{
        if(isCurrentlyContainingOnlyCoreRequests && downlaodRequests.count > 0){
            [[NetworkManager sharedManager] showNetworkErrorWithRetryOption:YES andCancelOption:NO];
        }else if(downlaodRequests.count > 0){
            [[NetworkManager sharedManager] showNetworkErrorWithRetryOption:YES andCancelOption:YES];
        }
        
    }
}

-(void)retryDownloadRequests{
    [self startDownloadRequests];
}

-(void)cancelRequestsOtherThanCore{
    for (int n=0; n<[downlaodRequests count]; n++) {
        ConnectionRequest* request = [downlaodRequests objectAtIndex:n];
        if(!request.isCoreRequest){
            [downlaodRequests removeObjectAtIndex:n];
            n-=1;
        }
    }
    
    for (NSString* key in [activeRequests keyEnumerator]) {
        if(!((ConnectionRequest *)[activeRequests objectForKey:key]).isCoreRequest){
            [activeRequests removeObjectForKey:key];
            NSURLSessionDataTask* task = [activeTasks objectForKey:key];
            [task cancel];
        }
    }
    
    if(downlaodRequests.count > 0){
        isCurrentlyContainingOnlyCoreRequests = YES;
    }
    
    [self retryDownloadRequests];
}

-(void) setMaxDownloadThreads:(int)noOfThread{
    if (noOfThread<=0) {
        noOfAllowedDownloadThreads = 1;
    }
}

-(void) validateGlobalVariables{
    
    isCurrentlyContainingOnlyCoreRequests = NO;
    
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                            delegate:self
                                       delegateQueue:[NSOperationQueue mainQueue]];
    
    [self setMaxDownloadThreads:noOfAllowedDownloadThreads];
    if(!downlaodRequests){
        downlaodRequests = [NSMutableArray new];
    }
    if (!activeTasks) {
        activeTasks = [NSMutableDictionary new];
    }
    if (!activeRequests) {
        activeRequests = [NSMutableDictionary new];
    }
}

-(void) addVIPRequest:(ConnectionRequest *)contentReq{
    [downlaodRequests insertObject:contentReq atIndex:0];
    [self startDownloadRequests];
}

-(void) addRequest:(ConnectionRequest *)contentReq{
    [downlaodRequests addObject:contentReq];
    [self startDownloadRequests];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    ConnectionRequest* request = [activeRequests valueForKey:[NSString stringWithFormat:@"%d",(int)task]];
    if(request.showLoading){
        [[LoadingView sharedView] hide];
    }
    if(error != nil){
        [request connectionManagerDidRecieveError:error];
    }else{
        [request connectionManagerDidCompleteLoadingData];
    }
    
    [activeTasks removeObjectForKey:[NSString stringWithFormat:@"%d",(int)task]];
    [activeRequests removeObjectForKey:[NSString stringWithFormat:@"%d",(int)task]];
    
    [self startDownloadRequests];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    ConnectionRequest* request = [activeRequests valueForKey:[NSString stringWithFormat:@"%d",(int)dataTask]];
    [request.data appendData:data];
}

@end
