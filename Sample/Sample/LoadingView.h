//
//  LoadingView.h
//  Zoser
//
//  Created by Ahmed Abd El-Samie on 10/10/15.
//  Copyright © 2015 Ahmed Abd El-Samie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+(LoadingView *) sharedView;

-(void)show;
-(void)showInParentView:(UIView *)parentView;

-(void)hide;

@end
