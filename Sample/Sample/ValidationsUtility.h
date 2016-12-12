//
//  ValidationsManager.h
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidationsUtility : NSObject

+(BOOL)isObjectNotNull:(id)object;
+(NSString *)forceObjectToBeString:(id)object;
+(BOOL)isStringNotNull:(NSString *)string;
+(BOOL)isStringNotEmpty:(NSString *)string;
+(BOOL)isString:(NSString *)string charachtersCountBetweenLowestBoundry:(int)lowestBoundary andHightestBoundary:(int)hightestBoundary;
+(BOOL)isString:(NSString *)string containsString:(NSString *)stringToBeFound;
+(BOOL) isEmailIsValid:(NSString *)email withIsStrict:(BOOL)isStrict;

@end
