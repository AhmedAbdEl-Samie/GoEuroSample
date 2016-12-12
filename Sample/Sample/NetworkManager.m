//
//  NetworkManager.m
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2016 Ahmed AbdEl-Samie. All rights reserved.
//

#import "NetworkManager.h"
#import "Reachability.h"
#import "ConnectionManager.h"

static NetworkManager* sharedInstance = nil;
static dispatch_once_t sharedManagerCreationOnceToken;

@interface NetworkManager (){
    Reachability *internetReachability;
}

@end

@implementation NetworkManager


+(NetworkManager *) sharedManager{
    dispatch_once(&sharedManagerCreationOnceToken, ^{
        sharedInstance = [[NetworkManager alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        internetReachability = [Reachability reachabilityForInternetConnection];
        [internetReachability startNotifier];        
        
    }
    return self;
}

-(BOOL) isConnectedToInternet {
    
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    
    switch (internetStatus) {
            
        case NotReachable: {
            return NO;
        }
            
        case ReachableViaWiFi:
        {
            return YES;
        }
            
        case ReachableViaWWAN:
        {
            return YES;
        }
    }
    
    return NO;
    
}

-(void)showNetworkErrorWithRetryOption:(BOOL)isRetryOptionAvailable andCancelOption:(BOOL)isCancelOptionAvailable{
    
    UIAlertView *alert;
    
    if(isCancelOptionAvailable && isRetryOptionAvailable){
        alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                           message:@"Please Check Your Connection"
                                          delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 otherButtonTitles:@"Retry",nil];
    }else if(isRetryOptionAvailable){
        alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                           message:@"Please Check Your Connection"
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"Retry",nil];
    }else if (!isRetryOptionAvailable && !isCancelOptionAvailable){
        alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                           message:@"Please Check Your Connection"
                                          delegate:self
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    }
    
//    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        [[ConnectionManager sharedManager] retryDownloadRequests];
    }else if(buttonIndex == 0){
        [[ConnectionManager sharedManager] cancelRequestsOtherThanCore];
    }
}


@end
