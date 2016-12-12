//
//  ValidationsManager.m
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import "ValidationsUtility.h"

@implementation ValidationsUtility


+(NSString *)forceObjectToBeString:(id)object {
    if ([self isObjectNotNull:object]) {
        return [NSString stringWithFormat:@"%@",object];
    }
    return @"";
}

+(BOOL)isObjectNotNull:(id)object {
    if([object class] == [NSNull class] || object == NULL || object == nil){
        return NO;
    }
    return YES;
}

+(BOOL)isStringNotEmpty:(NSString *)string {
    if([self isStringNotNull:string]){
        if([string caseInsensitiveCompare:@""] == NSOrderedSame){
            return NO;
        }
        return YES;
    }
    
    return NO;
}

+(BOOL)isString:(NSString *)string charachtersCountBetweenLowestBoundry:(int)lowestBoundary andHightestBoundary:(int)hightestBoundary {
    if(string.length >= lowestBoundary && string.length <= hightestBoundary){
        return YES;
    }
    
    return NO;
}

+(BOOL)isEmailIsValid:(NSString *)email withIsStrict:(BOOL)isStrict{
    
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = isStrict ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isStringNotNull:(NSString *)string {
    if([string class] == [NSNull class] || string == NULL || string == nil || [string caseInsensitiveCompare:@"null"] == NSOrderedSame || [string caseInsensitiveCompare:@"<null>"] == NSOrderedSame){
        return NO;
    }
    return YES;
}

+(BOOL)isString:(NSString *)string containsString:(NSString *)stringToBeFound{
    if ([string rangeOfString:stringToBeFound].location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

@end
