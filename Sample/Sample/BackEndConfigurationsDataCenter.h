//
//  BackEndConfigurationDataProvider.h
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BackEndServerIntegration1
}BackEndServer;

@interface BackEndConfigurationsDataCenter : NSObject

@property (nonatomic, assign) BackEndServer backEndServer;

+(BackEndConfigurationsDataCenter *) sharedCenter;
-(NSString *)getServiceURL;


@end
