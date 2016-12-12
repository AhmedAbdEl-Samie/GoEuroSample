//
//  LoadingView.m
//  Zoser
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import "LoadingView.h"
#import "ConstraintsUtility.h"

static LoadingView* sharedInstance = nil;
static dispatch_once_t sharedManagerCreationOnceToken;

@implementation LoadingView

+(LoadingView *)sharedView{
    dispatch_once(&sharedManagerCreationOnceToken, ^{
        sharedInstance = [[LoadingView alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [[[NSBundle mainBundle]
             loadNibNamed:@"LoadingView"
             owner:self options:nil]
            firstObject];
    if (self) {
        
    }
    return self;
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [ConstraintsUtility addSurroundingConstraintsToView:[UIApplication sharedApplication].keyWindow forView:self releatedToView:[UIApplication sharedApplication].keyWindow withConstant:0 withRelation:NSLayoutRelationEqual];
}

-(void)showInParentView:(UIView *)parentView{
    [parentView addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [ConstraintsUtility addSurroundingConstraintsToView:parentView forView:self releatedToView:parentView withConstant:0 withRelation:NSLayoutRelationEqual];
}

-(void)hide{
    [self removeFromSuperview];
}

@end
