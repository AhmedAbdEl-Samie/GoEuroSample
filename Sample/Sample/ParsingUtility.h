//
//  ParsingManager.h
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParsingUtility : NSObject

+(NSArray *) parseDataAsArray:(NSData *)rawData;
+(NSDictionary *) parseDataAsDictionary:(NSData *)rawData;
+(NSString *) parseDataAsString:(NSData *)rawData;

@end
