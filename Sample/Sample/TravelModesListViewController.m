//
//  TravelModesListViewController.m
//  Sample
//
//  Created by Ahmed AbdEl-Samie on 12/10/16.
//  Copyright © 2016 Ahmed AbdEl-Samie. All rights reserved.
//

#import "TravelModesListViewController.h"
#import "TravelModesDataCenter.h"
#import "TravelModesListTableViewCell.h"
#import "TravelDetails+CoreDataClass.h"

@interface TravelModesListViewController () {
    NSMutableArray *currentTravelDetailsList;
    NSMutableArray *alreadyAnimatedPaths;
    SortingMode sortingMode;
}

@end

@implementation TravelModesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    currentTravelDetailsList = [NSMutableArray new];
    alreadyAnimatedPaths = [NSMutableArray new];
    sortingMode = SortingByDepartureMode;
    
    //Setup page title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 3;
    titleLabel.font = [UIFont boldSystemFontOfSize: 20.0f];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"\nBerlin - Munich \n Jan 07";
    
    self.navigationItem.titleView = titleLabel;
    
    
    self.sortContainerView.layer.borderColor = [UIColor grayColor].CGColor;
    self.sortContainerView.layer.borderWidth = 3;
    
    [[TravelModesDataCenter sharedCenter] loadFlightsWithMode:TrainTravelMode andDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return currentTravelDetailsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *travelModesListTableViewCellIdentifier = @"TravelModesListTableViewCellIdentifier";
    
    TravelModesListTableViewCell *cell = (TravelModesListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:travelModesListTableViewCellIdentifier];

    if (cell == nil){
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"TravelModesListTableViewCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    TravelDetails *travelDetails = [currentTravelDetailsList objectAtIndex:indexPath.row];
    
    if(travelDetails.logoData != nil){
        cell.vendorImage.image = [UIImage imageWithData:travelDetails.logoData];
    }else{
        [[TravelModesDataCenter sharedCenter] loadImageForTravelDetails:travelDetails];
    }
    
    cell.duration.text = travelDetails.duration;
    cell.price.text = [NSString stringWithFormat:@"€%@",travelDetails.price];
    cell.timeOfDepartureAndArrival.text = [NSString stringWithFormat:@"%@ - %@",travelDetails.departureTime,travelDetails.arrivalTime];
    cell.stops.text = travelDetails.numberOfChanges;

    if(![alreadyAnimatedPaths containsObject:indexPath]){
        [self animateWithBounceEffectForView:cell.vendorImage withCompletion:nil];
        [self animateWithBounceEffectForView:cell.price withCompletion:nil];
        [alreadyAnimatedPaths addObject:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon"
                                                    message:@"Offer details are not yet implemented!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)didFinishOperationWithID:(OperationID)operationID{
    if(operationID == LoadImageOperationID){
        [self.travelDetailsTableView reloadData];
        return;
    }
    switch (operationID) {
        case LoadTravelDetailsByBusModeOperationID:
            currentTravelDetailsList = [TravelModesDataCenter sharedCenter].travelDetailsForBusMode;
            break;
        case LoadTravelDetailsByTrainModeOperationID:
            currentTravelDetailsList = [TravelModesDataCenter sharedCenter].travelDetailsForTrainMode;
            break;
        case LoadTravelDetailsByFlightModeOperationID:
            currentTravelDetailsList = [TravelModesDataCenter sharedCenter].travelDetailsForFlightMode;
            break;
        default:
            break;
    }

    [self applySorting];
}

- (IBAction)changeSelectedMode:(id)sender {
    currentTravelDetailsList = [NSMutableArray new];
    if(sender == self.busButton){
        if([TravelModesDataCenter sharedCenter].travelDetailsForBusMode.count == 0){
            [[TravelModesDataCenter sharedCenter] loadFlightsWithMode:BusTravelMode andDelegate:self];
        }else{
            currentTravelDetailsList = [TravelModesDataCenter sharedCenter].travelDetailsForBusMode;
        }
        self.selectedModeIndicatorCenterConstraintToFlight.priority = 250;
        self.selectedModeIndicatorCenterConstraintToBus.priority = 750;
        self.selectedModeIndicatorCenterConstraintToTrain.priority = 250;
    }else if(sender == self.trainButton){
        if([TravelModesDataCenter sharedCenter].travelDetailsForTrainMode.count == 0){
            [[TravelModesDataCenter sharedCenter] loadFlightsWithMode:TrainTravelMode andDelegate:self];
        }else{
            currentTravelDetailsList = [TravelModesDataCenter sharedCenter].travelDetailsForTrainMode;
        }
        self.selectedModeIndicatorCenterConstraintToFlight.priority = 250;
        self.selectedModeIndicatorCenterConstraintToBus.priority = 250;
        self.selectedModeIndicatorCenterConstraintToTrain.priority = 750;
    }else if(sender == self.flightButton){
        if([TravelModesDataCenter sharedCenter].travelDetailsForFlightMode.count == 0){
            [[TravelModesDataCenter sharedCenter] loadFlightsWithMode:FlightTravelMode andDelegate:self];
        }else{
            currentTravelDetailsList = [TravelModesDataCenter sharedCenter].travelDetailsForFlightMode;
        }
        self.selectedModeIndicatorCenterConstraintToFlight.priority = 750;
        self.selectedModeIndicatorCenterConstraintToBus.priority = 250;
        self.selectedModeIndicatorCenterConstraintToTrain.priority = 250;
    }
    
    [self animateWithBounceEffectForView:self.selectedModeIndicator withCompletion:nil];
    
    [self applySorting];
}

-(void)animateWithBounceEffectForView:(UIView *)view withCompletion:(void (^)())completion{
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                view.transform = CGAffineTransformIdentity;
                if(completion != nil){
                    completion();
                }
            }];
        }];
    }];
}

-(void)changeSortingMethod:(id)sender{
    if(sender == self.sortButton){
        if(self.sortButton.tag == 0){
            self.sortByDepartureButton.alpha = 1;
            self.departureSortButtonLeadingConstraintToSortButton.constant = 50;
            [self animateWithBounceEffectForView:self.sortByDepartureButton withCompletion:^{
                self.sortByArrivalButton.alpha = 1;
                self.arrivalSortButtonLeadingConstraintToSortButton.constant = 118;
                [self animateWithBounceEffectForView:self.sortByArrivalButton withCompletion:^{
                    self.sortByDurationButton.alpha = 1;
                    self.durationSortButtonLeadingConstraintToSortButton.constant = 186;
                    [self animateWithBounceEffectForView:self.sortByDurationButton withCompletion:nil];
                }];
            }];
            self.sortButton.tag = 1;
        }else if (self.sortButton.tag == 1){
            self.departureSortButtonLeadingConstraintToSortButton.constant = -40;
            [self animateWithBounceEffectForView:self.sortByDepartureButton withCompletion:^{
                self.sortByDepartureButton.alpha = 0;
                self.arrivalSortButtonLeadingConstraintToSortButton.constant = -40;
                [self animateWithBounceEffectForView:self.sortByArrivalButton withCompletion:^{
                    self.sortByArrivalButton.alpha = 0;
                    self.durationSortButtonLeadingConstraintToSortButton.constant = -40;
                    [self animateWithBounceEffectForView:self.sortByDurationButton withCompletion:^{
                        self.sortByDurationButton.alpha = 0;
                    }];
                }];
            }];
            self.sortButton.tag = 0;
        }
    }else if(sender == self.sortByDepartureButton){
        [self changeSortingMethod:self.sortButton];
        sortingMode = SortingByDepartureMode;
        [self applySorting];
    }else if(sender == self.sortByArrivalButton){
        [self changeSortingMethod:self.sortButton];
        sortingMode = SortingByArrivalMode;
        [self applySorting];
    }else if(sender == self.sortByDurationButton){
        [self changeSortingMethod:self.sortButton];
        sortingMode = SortingByDurationMode;
        [self applySorting];
    }

}

-(void)applySorting{
    [self.travelDetailsTableView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:NO];    
    [alreadyAnimatedPaths removeAllObjects];
    NSSortDescriptor *sortDescriptor;
    switch (sortingMode) {
        case SortingByDepartureMode:{
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"departureTime" ascending:YES];
            break;
        }
        case SortingByArrivalMode:{
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"arrivalTime" ascending:YES];
            break;
        }
        case SortingByDurationMode:{
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"duration" ascending:YES];
            break;
        }
        default:
            break;
    }
    
    NSArray *array = [currentTravelDetailsList sortedArrayUsingDescriptors:@[sortDescriptor]];
    currentTravelDetailsList = [NSMutableArray new];
    [currentTravelDetailsList addObjectsFromArray:array];
    [self.travelDetailsTableView reloadData];
}

@end
