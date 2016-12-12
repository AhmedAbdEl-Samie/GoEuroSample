//
//  NetworkManager.h
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2016 Ahmed AbdEl-Samie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetworkManager : NSObject

+(NetworkManager *) sharedManager;

-(BOOL) isConnectedToInternet;
-(void)showNetworkErrorWithRetryOption:(BOOL)isRetryOptionAvailable andCancelOption:(BOOL)isCancelOptionAvailable;

@end
