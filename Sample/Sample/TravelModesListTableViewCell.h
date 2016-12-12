//
//  TravelModesListTableViewCell.h
//  Sample
//
//  Created by Ahmed AbdEl-Samie on 12/10/16.
//  Copyright © 2016 Ahmed AbdEl-Samie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelModesListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *vendorImage;
@property (nonatomic, weak) IBOutlet UIImageView *seperator;
@property (nonatomic, weak) IBOutlet UILabel *timeOfDepartureAndArrival;
@property (nonatomic, weak) IBOutlet UILabel *price;
@property (nonatomic, weak) IBOutlet UILabel *duration;
@property (nonatomic, weak) IBOutlet UILabel *stops;


@end
