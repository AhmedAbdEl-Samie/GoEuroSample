//
//  GeneralDelegates.h
//  Zoser
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OperationIDs.h"

@class ZImage;

@protocol OperationDelegate <NSObject>

@optional
-(void)didCancelOperationWithID:(OperationID)operationID;
-(void)didFinishOperationWithID:(OperationID)operationID;
-(void)didRecieveErrorForOperationWithID:(OperationID)operationID andWithError:(NSError *)error;
-(void)didFinishOperationWithID:(OperationID)operationID andWithObject:(id)object;

@end

@interface GeneralDelegates : NSObject

@end
