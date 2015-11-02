//
//  CAAnimation+JJ.h
//  JJObjCTool
//
//  Created by gongjian03 on 10/1/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CAAnimation (JJ)

#pragma mark - Custom Animation

+ (CATransition *)jj_showAnimationType:(NSString *)type
                 withSubType:(NSString *)subType
                    duration:(CFTimeInterval)duration
         timingFunctionnName:(NSString *)timingFunctionnName
                        view:(UIView *)theView;

#pragma mark - rotate

+ (void)jj_rotateWithView:(UIView *)view duration:(NSTimeInterval)duration angle:(CGFloat)angle;
+ (void)jj_xRotateWithView:(UIView *)view;
+ (void)jj_yRotateWithView:(UIView *)view;

#pragma mark - shake

+ (void)jj_shakeLeftAndRight:(UIView *)view;

@end
