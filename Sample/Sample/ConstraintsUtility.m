//
//  ConstraintsManager.m
//  Zoser
//
//  Created by Ahmed Abd El-Samie on 10/4/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import "ConstraintsUtility.h"

@implementation ConstraintsUtility

+(NSLayoutConstraint *) addTopConstraintToView:(UIView *)superView forView:(UIView *)view releatedToView:(UIView *)relatedView withConstant:(double)constant withRelation:(NSLayoutRelation)relation{
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint
                               constraintWithItem:view
                               attribute:NSLayoutAttributeTop
                               relatedBy:relation
                               toItem:relatedView
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:constant];
    [superView addConstraint:topConstraint];
    
    return topConstraint;
    
}

+(NSLayoutConstraint *) addBottomConstraintToView:(UIView *)superView forView:(UIView *)view releatedToView:(UIView *)relatedView withConstant:(double)constant withRelation:(NSLayoutRelation)relation{
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint
                                  constraintWithItem:view
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:relation
                                  toItem:relatedView
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1.0f
                                  constant:constant];
    [superView addConstraint:bottomConstraint];
    
    return bottomConstraint;
}

+(NSLayoutConstraint *) addLeadingConstraintToView:(UIView *)superView forView:(UIView *)view releatedToView:(UIView *)relatedView withConstant:(double)constant withRelation:(NSLayoutRelation)relation{
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint
                                   constraintWithItem:view
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:relation
                                   toItem:relatedView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:constant];
    [superView addConstraint:leadingConstraint];
    
    return leadingConstraint;
}

+(NSLayoutConstraint *) addTrailingConstraintToView:(UIView *)superView forView:(UIView *)view releatedToView:(UIView *)relatedView withConstant:(double)constant withRelation:(NSLayoutRelation)relation{
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint
                                    constraintWithItem:view
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:relation
                                    toItem:relatedView
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0f
                                    constant:constant];
    [superView addConstraint:trailingConstraint];
    
    return trailingConstraint;
}

+(NSLayoutConstraint *) addWidthConstraintToView:(UIView *)view withWidth:(double)width withRelation:(NSLayoutRelation)relation{
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:relation
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:width];
    [view addConstraint:widthConstraint];
    
    return widthConstraint;
    
}

+(NSLayoutConstraint *) addHeightConstraintToView:(UIView *)view withHeigh:(double)heigh withRelation:(NSLayoutRelation)relation{
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:relation
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:heigh];
    [view addConstraint:heightConstraint];
    
    return heightConstraint;
    
}

+(void) addSurroundingConstraintsToView:(UIView *)superView forView:(UIView *)view releatedToView:(UIView *)relatedView withConstant:(double)constant withRelation:(NSLayoutRelation)relation{
    [self addTopConstraintToView:superView forView:view releatedToView:relatedView withConstant:constant withRelation:relation];
    [self addBottomConstraintToView:superView forView:view releatedToView:relatedView withConstant:constant withRelation:relation];
    [self addLeadingConstraintToView:superView forView:view releatedToView:relatedView withConstant:constant withRelation:relation];
    [self addTrailingConstraintToView:superView forView:view releatedToView:relatedView withConstant:constant withRelation:relation];
}

@end
