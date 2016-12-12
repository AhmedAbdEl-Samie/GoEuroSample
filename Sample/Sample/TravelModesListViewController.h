//
//  TravelModesListViewController.h
//  Sample
//
//  Created by Ahmed AbdEl-Samie on 12/10/16.
//  Copyright © 2016 Ahmed AbdEl-Samie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralDelegates.h"

typedef enum{
    SortingByDepartureMode,
    SortingByArrivalMode,
    SortingByDurationMode
}SortingMode;

@interface TravelModesListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, OperationDelegate>

@property (weak, nonatomic) IBOutlet UITableView *travelDetailsTableView;

@property (weak, nonatomic) IBOutlet UIButton *trainButton;
@property (weak, nonatomic) IBOutlet UIButton *busButton;
@property (weak, nonatomic) IBOutlet UIButton *flightButton;

@property (weak, nonatomic) IBOutlet UIImageView *selectedModeIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedModeIndicatorCenterConstraintToBus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedModeIndicatorCenterConstraintToFlight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedModeIndicatorCenterConstraintToTrain;

@property (weak, nonatomic) IBOutlet UIView *sortContainerView;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UIButton *sortByDepartureButton;
@property (weak, nonatomic) IBOutlet UIButton *sortByArrivalButton;
@property (weak, nonatomic) IBOutlet UIButton *sortByDurationButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departureSortButtonLeadingConstraintToSortButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrivalSortButtonLeadingConstraintToSortButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *durationSortButtonLeadingConstraintToSortButton;

- (IBAction)changeSelectedMode:(id)sender;
- (IBAction)changeSortingMethod:(id)sender;

@end
