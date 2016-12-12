//
//  BackEndConfigurationDataProvider.m
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import "BackEndConfigurationsDataCenter.h"

#define BackEndServerIntegration1BaseURL    @"https://api.myjson.com/bins"

static BackEndConfigurationsDataCenter* sharedCenter = nil;
static dispatch_once_t sharedCenterCreationOnceToken;

@implementation BackEndConfigurationsDataCenter

+(BackEndConfigurationsDataCenter *) sharedCenter{
    dispatch_once(&sharedCenterCreationOnceToken, ^{
        sharedCenter = [[BackEndConfigurationsDataCenter alloc] init];
        sharedCenter.backEndServer = BackEndServerIntegration1;
    });
    return sharedCenter;
}

-(NSString *)getServiceURL{
    if(_backEndServer == BackEndServerIntegration1){
        return BackEndServerIntegration1BaseURL;
    }
    
    return @"";
}

@end
