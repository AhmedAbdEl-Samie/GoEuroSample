//
//  TravelModesDataCenter.m
//  Sample
//
//  Created by Ahmed AbdEl-Samie on 12/10/16.
//  Copyright © 2016 Ahmed AbdEl-Samie. All rights reserved.
//

#import "TravelModesDataCenter.h"
#import "ConnectionRequest.h"
#import "ParsingUtility.h"
#import "AppDelegate.h"
#import "ParsingUtility.h"
#import "ValidationsUtility.h"
#import "NetworkManager.h"

#define by_bus @"/37yzm"
#define by_train @"/3zmcy"
#define by_flight @"/w60i"

static TravelModesDataCenter* sharedCenter = nil;
static dispatch_once_t sharedCenterCreationOnceToken;

@implementation TravelModesDataCenter

+(TravelModesDataCenter *) sharedCenter{
    dispatch_once(&sharedCenterCreationOnceToken, ^{
        sharedCenter = [[TravelModesDataCenter alloc] init];
        sharedCenter.travelDetailsForBusMode = [NSMutableArray new];
        sharedCenter.travelDetailsForTrainMode = [NSMutableArray new];
        sharedCenter.travelDetailsForFlightMode = [NSMutableArray new];
    });
    
    return sharedCenter;
}

-(void)loadFlightsWithMode:(TravelMode)travelMode andDelegate:(id<OperationDelegate>)aDelegate{
    NSString *requestURL = @"";
    OperationID operationID;
    NSString *fetchMode = @"";
    NSMutableArray *currentModeArray = [NSMutableArray new];
    BOOL isOnline = [[NetworkManager sharedManager] isConnectedToInternet];
    
    self.delegate = aDelegate;
    switch (travelMode) {
        case TrainTravelMode:
            requestURL = by_train;
            operationID = LoadTravelDetailsByTrainModeOperationID;
            fetchMode = @"train";
            currentModeArray = self.travelDetailsForTrainMode;
            break;
        case BusTravelMode:
            requestURL = by_bus;
            operationID = LoadTravelDetailsByBusModeOperationID;
            fetchMode = @"bus";
            currentModeArray = self.travelDetailsForBusMode;
            break;
        case FlightTravelMode:
            requestURL = by_flight;
            operationID = LoadTravelDetailsByFlightModeOperationID;
            fetchMode = @"flight";
            currentModeArray = self.travelDetailsForFlightMode;
            break;
        default:
            break;
    }
    
    if(isOnline){
        [self fetchDataWithDeletion:YES andFetchMode:fetchMode andOperationID:operationID andCurrentModeArray:nil];
        
        NSMutableDictionary *travelInfoParameters = [NSMutableDictionary new];
        
        ConnectionRequest *cr = [[ConnectionRequest alloc] initWithDelegate:self andrequestURL:requestURL andHTTPMethod:ConnectionRequestHTTPMethodGET andParameters:travelInfoParameters andIncluedAuthenticationToken:NO andShowLoading:YES andRequestID:operationID andIsCoreRequest:NO];
        [cr initiateRequest];
    }else{
        [self fetchDataWithDeletion:NO andFetchMode:fetchMode andOperationID:operationID andCurrentModeArray:currentModeArray];
    }
}

-(void)fetchDataWithDeletion:(BOOL)isDelete andFetchMode:(NSString *)fetchMode andOperationID:(OperationID)operationID andCurrentModeArray:(NSMutableArray *)currentModeArray{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TravelDetails" inManagedObjectContext:[((AppDelegate *)[UIApplication sharedApplication].delegate) persistentContainer].viewContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"travelModel == %@",fetchMode]];
    
    NSError *aError = nil;
    NSArray *fetchedObjects = [[((AppDelegate *)[UIApplication sharedApplication].delegate) persistentContainer].viewContext executeFetchRequest:fetchRequest error:&aError];
    if (aError == nil) {
        NSLog(@"%lu",(unsigned long)fetchedObjects.count);
        if(isDelete){
            for (NSManagedObject *object in fetchedObjects) {
                [[((AppDelegate *)[UIApplication sharedApplication].delegate) persistentContainer].viewContext deleteObject:object];
            }
            [self saveContext];
        }else{
            [currentModeArray addObjectsFromArray:fetchedObjects];
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didFinishOperationWithID:)]){
                [self.delegate didFinishOperationWithID:operationID];
            }
            
        }
    }
}

-(void)request:(ConnectionRequest *)request didCompleteLoadingData:(NSMutableData *)data{
    
    if(request.requestID == LoadTravelDetailsByTrainModeOperationID ||
       request.requestID == LoadTravelDetailsByBusModeOperationID ||
       request.requestID == LoadTravelDetailsByFlightModeOperationID){
    
        NSArray *travelDetailsInfo = [ParsingUtility parseDataAsArray:data];
        NSString *travelMode = @"";
        NSMutableArray *travelDetails;
        switch (request.requestID) {
            case TrainTravelMode:
                travelMode = @"train";
                travelDetails = self.travelDetailsForTrainMode;
                break;
            case LoadTravelDetailsByBusModeOperationID:
                travelMode = @"bus";
                travelDetails = self.travelDetailsForBusMode;
                break;
            case LoadTravelDetailsByFlightModeOperationID:
                travelMode = @"flight";
                travelDetails = self.travelDetailsForFlightMode;
                break;
            default:
                break;
        }
        
        for (NSDictionary *aTravelDetails in travelDetailsInfo) {
            [travelDetails addObject:[self insertNewTravelDetails:aTravelDetails andWithTravelMode:travelMode]];
        }

    }else if(request.requestID == LoadImageOperationID){
        ((TravelDetails *)(request.object)).logoData = data;
    }
    
    [self saveContext];
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didFinishOperationWithID:)]){
        [self.delegate didFinishOperationWithID:request.requestID];
    }
}

-(TravelDetails *)insertNewTravelDetails:(NSDictionary *)aTravelDetails andWithTravelMode:(NSString *) travelMode{
    TravelDetails *travelDetails = [NSEntityDescription insertNewObjectForEntityForName:@"TravelDetails" inManagedObjectContext:[((AppDelegate *)[UIApplication sharedApplication].delegate) persistentContainer].viewContext];
    
    travelDetails.arrivalTime = [ValidationsUtility forceObjectToBeString:[aTravelDetails objectForKey:@"arrival_time"]];
    travelDetails.departureTime = [ValidationsUtility forceObjectToBeString:[aTravelDetails objectForKey:@"departure_time"]];
    
    NSArray *departureTimeSeperated = [travelDetails.departureTime componentsSeparatedByString:@":"];
    NSArray *arrivalTimeSeperated = [travelDetails.arrivalTime componentsSeparatedByString:@":"];
    int mins = [arrivalTimeSeperated[1] intValue]-[departureTimeSeperated[1] intValue];
    int hours = [arrivalTimeSeperated[0] intValue]-[departureTimeSeperated[0] intValue];
    if(hours < 0){
        hours += 12;
        if(hours < 0){
            hours += 12;
        }
    }
    if(mins < 0){
        mins += 60;
        hours--;
    }
    
    travelDetails.duration = [NSString stringWithFormat:@"%02d:%02dh",hours,mins];
    
    
    travelDetails.logoURL = [ValidationsUtility forceObjectToBeString:[aTravelDetails objectForKey:@"provider_logo"]];
    travelDetails.logoURL = [travelDetails.logoURL stringByReplacingOccurrencesOfString:@"{size}" withString:@"63"];
    
    travelDetails.numberOfChanges = [ValidationsUtility forceObjectToBeString:[aTravelDetails objectForKey:@"number_of_stops"]];
    if ([travelDetails.numberOfChanges intValue] == 0) {
        travelDetails.numberOfChanges = @"Direct";
    }else{
        if([travelDetails.numberOfChanges intValue] == 1){
            travelDetails.numberOfChanges = [NSString stringWithFormat:@"%@ Change",travelDetails.numberOfChanges];
        }else{
            travelDetails.numberOfChanges = [NSString stringWithFormat:@"%@ Changes",travelDetails.numberOfChanges];
        }
    }
    travelDetails.price = [NSString stringWithFormat:@"%0.2f",[[ValidationsUtility forceObjectToBeString:[aTravelDetails objectForKey:@"price_in_euros"]] floatValue]];
    travelDetails.travelDetailsID = [ValidationsUtility forceObjectToBeString:[aTravelDetails objectForKey:@"id"]];
    travelDetails.travelModel = travelMode;
    
    return travelDetails;
}

-(void)saveContext{
    NSError *error;
    if (![[((AppDelegate *)[UIApplication sharedApplication].delegate) persistentContainer].viewContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
}

-(void)loadImageForTravelDetails:(TravelDetails *)travelDetails{
    ConnectionRequest *cr = [[ConnectionRequest alloc] initWithDelegate:self andrequestURL:travelDetails.logoURL andHTTPMethod:ConnectionRequestHTTPMethodGET andParameters:nil andIncluedAuthenticationToken:NO andShowLoading:NO andRequestID:LoadImageOperationID andIsCoreRequest:NO];
    cr.isCompleteURL = YES;
    cr.object = travelDetails;
    [cr initiateRequest];
}


@end
