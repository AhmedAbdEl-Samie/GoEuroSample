//
//  TravelModesListTableViewCell.m
//  Sample
//
//  Created by Ahmed AbdEl-Samie on 12/10/16.
//  Copyright © 2016 Ahmed AbdEl-Samie. All rights reserved.
//

#import "TravelModesListTableViewCell.h"

@implementation TravelModesListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self bringSubviewToFront:self.seperator];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    self.vendorImage.image = nil;
    
}

@end
