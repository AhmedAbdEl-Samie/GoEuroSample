//
//  ConnectionManager.h
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2016 Ahmed AbdEl-Samie. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConnectionRequest.h"

@interface ConnectionManager : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>{
    int noOfAllowedDownloadThreads;
    NSMutableArray* downlaodRequests;
    NSMutableDictionary* activeTasks;
    NSMutableDictionary* activeRequests;
    NSURLSession* session;
}

+(ConnectionManager *) sharedManager;

-(void) deleteAllConnections;
-(void) setMaxDownloadThreads:(int)noOfThread;
-(void) addVIPRequest:(ConnectionRequest *)contentReq;
-(void) addRequest:(ConnectionRequest *)contentReq;
-(void) retryDownloadRequests;
-(void) cancelRequestsOtherThanCore;

@end
