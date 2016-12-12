//
//  OperationIDs.h
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LoadTravelDetailsByFlightModeOperationID,
    LoadTravelDetailsByTrainModeOperationID,
    LoadTravelDetailsByBusModeOperationID,
    LoadImageOperationID
}OperationID;

@interface OperationIDs : NSObject

@end
