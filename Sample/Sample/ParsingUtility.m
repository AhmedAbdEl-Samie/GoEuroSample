//
//  ParsingManager.m
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import "ParsingUtility.h"

@implementation ParsingUtility

+(NSArray *) parseDataAsArray:(NSData *)rawData{
    
    NSString *dataString = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"NULL" withString:@"null"];
    rawData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData: rawData
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
    return dataArray;
}

+(NSDictionary *) parseDataAsDictionary:(NSData *)rawData{
    
    NSString *dataString = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"NULL" withString:@"null"];
    rawData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData: rawData
                                                              options: NSJSONReadingMutableContainers
                                                                error: nil];
    return dataDictionary;
}

+(NSString *) parseDataAsString:(NSData *)rawData{
    
    NSString *dataString = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"NULL" withString:@"null"];
    
    return dataString;
}


@end
