//
//  TravelModesDataCenter.h
//  Sample
//
//  Created by Ahmed AbdEl-Samie on 12/10/16.
//  Copyright © 2016 Ahmed AbdEl-Samie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralDelegates.h"
#import "ConnectionRequest.h"
#import "TravelDetails+CoreDataProperties.h"

typedef enum {
    BusTravelMode,
    TrainTravelMode,
    FlightTravelMode
}TravelMode;

@interface TravelModesDataCenter : NSObject <ConnectionRequestDelegate>

@property (nonatomic, assign) id<OperationDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *travelDetailsForBusMode;
@property (nonatomic, retain) NSMutableArray *travelDetailsForTrainMode;
@property (nonatomic, retain) NSMutableArray *travelDetailsForFlightMode;

+(TravelModesDataCenter *) sharedCenter;
-(void)loadFlightsWithMode:(TravelMode)travelMode andDelegate:(id<OperationDelegate>)aDelegate;
-(void)loadImageForTravelDetails:(TravelDetails *)travelDetails;

@end
