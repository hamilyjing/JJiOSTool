//
//  CAAnimation+JJ.m
//  JJObjCTool
//
//  Created by gongjian03 on 10/1/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import "CAAnimation+JJ.h"

@implementation CAAnimation (JJ)

#pragma mark - Custom Animation

+ (CATransition *)jj_showAnimationType:(NSString *)type_
                           withSubType:(NSString *)subType_
                              duration:(CFTimeInterval)duration_
                   timingFunctionnName:(NSString *)timingFunctionnName_
                                  view:(UIView *)theView_
{
    CATransition *transition = [CATransition animation];
    transition.type = type_ ? type_ : kCATransitionFade;
    transition.subtype = subType_ ? subType_ : kCATransitionFromBottom;
    transition.duration = duration_;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionnName_ ? timingFunctionnName_ : kCAMediaTimingFunctionEaseInEaseOut];
    
    [theView_.layer addAnimation:transition forKey:nil];
    
    return transition;
}

#pragma mark - rotate

+ (void)jj_rotateWithView:(UIView *)view_ duration:(NSTimeInterval)duration_ angle:(CGFloat)angle_
{
    [UIView animateWithDuration:duration_ animations:^
    {
        view_.transform = CGAffineTransformRotate(view_.transform, angle_); // M_PI: 180
    } completion:^(BOOL finished)
    {
        
    }];
    
    /* use CA
     
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    rotation.fromValue = @(0); 
    rotation.toValue = @(M_PI);
    rotation.duration = 1.f; 
    rotation.repeatCount = 1; // INFINITY
    
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // rotation.fillMode = kCAFillModeForwards;
    // rotation.removedOnCompletion = NO;
    
    self.demoImgView.transform = CGAffineTransformMakeRotation(M_PI);
    
    [self.demoImgView.layer addAnimation:rotation forKey:@"an_roate"];
     */
}

+ (void)jj_xRotateWithView:(UIView *)view_
{
    CABasicAnimation *TransformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    TransformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    TransformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 0, 0)];
    
    TransformAnim.cumulative = YES;
    TransformAnim.duration = 3;
    TransformAnim.repeatCount = 2;
    
    [view_.layer addAnimation:TransformAnim forKey:nil];
}

+ (void)jj_yRotateWithView:(UIView *)view_
{
    CABasicAnimation *TransformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    TransformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    TransformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 1, 0)];
    
    TransformAnim.cumulative = YES;
    TransformAnim.duration = 3;
    TransformAnim.repeatCount = 2;
    
    [view_.layer addAnimation:TransformAnim forKey:nil];
}

#pragma mark - shake

+ (void)jj_shakeLeftAndRight:(UIView *)view_
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @10, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.4;
    
    animation.additive = YES;
    
    [view_.layer addAnimation:animation forKey:@"shakeLeftAndRight"];
}

@end
