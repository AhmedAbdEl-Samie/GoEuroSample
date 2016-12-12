//
//  ConnectionRequest.h
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackEndConfigurationsDataCenter.h"
#import "OperationIDs.h"

@class ConnectionRequest;

typedef enum {
    ConnectionRequestHTTPMethodGET,
    ConnectionRequestHTTPMethodPOST,
    ConnectionRequestHTTPMethodDELETE,
    ConnectionRequestHTTPMethodPUT
}ConnectionRequestHTTPMethod;

@protocol ConnectionRequestDelegate <NSObject>

-(void) request:(ConnectionRequest *)request didCompleteLoadingData:(NSMutableData *)data;

@optional
-(void) request:(ConnectionRequest *)request didRecieveError:(NSError *)error;

@end

@interface ConnectionRequest : NSObject

@property BOOL isCompleteURL;
@property BOOL showLoading;
@property BOOL isRequestCanceled;
@property BOOL incluedAuthenticationToken;
@property BOOL isCoreRequest;
@property (nonatomic, assign) id object;
@property (nonatomic, weak) id<ConnectionRequestDelegate> delegate;
@property (nonatomic, assign) ConnectionRequestHTTPMethod requestMethod;
@property (nonatomic, retain) NSString* requestURL;
@property (nonatomic, retain) NSMutableURLRequest* request;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSMutableDictionary* parameters;
@property (readonly, assign) OperationID requestID;

-(instancetype)initWithDelegate:(id<ConnectionRequestDelegate>)delegate andrequestURL:(NSString *)requestURL andHTTPMethod:(ConnectionRequestHTTPMethod)requestMethod andParameters:(NSMutableDictionary *)parameters andIncluedAuthenticationToken:(BOOL) incluedAuthenticationToken andShowLoading:(BOOL)showLoading andRequestID:(OperationID)aRequestID andIsCoreRequest:(BOOL)isACoreRequest;
-(void)initiateRequest;
-(void)uploadImage:(id)image withKey:(NSString *)key;

-(void) connectionManagerDidRecieveError:(NSError *)error;
-(void) connectionManagerDidCompleteLoadingData;

@end
