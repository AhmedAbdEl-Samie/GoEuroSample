//
//  ConstraintsManager.h
//
//  Created by Ahmed Abd El-Samie on 10/4/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ConstraintsUtility : NSObject

+(NSLayoutConstraint *) addWidthConstraintToView:(UIView *)view withWidth:(double)width withRelation:(NSLayoutRelation)relation;
+(NSLayoutConstraint *) addHeightConstraintToView:(UIView *)view withHeigh:(double)heigh withRelation:(NSLayoutRelation)relation;
+(NSLayoutConstraint *) addTopConstraintToView:(UIView *)superView forView:(UIView *)view releatedToView:(UIView *)relatedView withConstant:(double)constant withRelation:(NSLayoutRelation)relation;
+(NSLayoutConstraint *) addBottomConstraintToView:(UIView *)superView forView:(UIView *)view releatedToView:(UIView *)relatedView withConstant:(double)constant withRelation:(NSLayoutRelation)relation;
+(NSLayoutConstraint *) addLeadingConstraintToView:(UIView *)superView forView:(UIView *)view releatedToView:(UIView *)relatedView withConstant:(double)constant withRelation:(NSLayoutRelation)relation;
+(NSLayoutConstraint *) addTrailingConstraintToView:(UIView *)superView forView:(UIView *)view releatedToView:(UIView *)relatedView withConstant:(double)constant withRelation:(NSLayoutRelation)relation;
+(void) addSurroundingConstraintsToView:(UIView *)superView forView:(UIView *)view releatedToView:(UIView *)relatedView withConstant:(double)constant withRelation:(NSLayoutRelation)relation;

@end
