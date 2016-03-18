//
//  UIView+JJ.m
//  JJObjCTool
//
//  Created by JJ on 5/13/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "UIView+JJ.h"

#import <objc/runtime.h>

#import "UIGestureRecognizer+JJ.h"

@interface UIView (JJAddSubViews)

@property (nonatomic, copy) void (^jj_addSubViewsPressBlock)(id sender);

@end

@implementation UIView (JJAddSubViews)

#pragma mark - getter and setter

- (void (^)(id))jj_addSubViewsPressBlock
{
    return objc_getAssociatedObject(self, @selector(jj_addSubViewsPressBlock));
}

- (void)setJj_addSubViewsPressBlock:(void (^)(id))jj_addSubViewsPressBlock_
{
    objc_setAssociatedObject(self, @selector(jj_addSubViewsPressBlock), jj_addSubViewsPressBlock_, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UIView (JJ)

#pragma mark - Frame

- (CGFloat)jjLeft {
    return self.frame.origin.x;
}

- (void)setJjLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)jjTop {
    return self.frame.origin.y;
}

- (void)setJjTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)jjRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setJjRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)jjBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setJjBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)jjCenterX {
    return self.center.x;
}

- (void)setJjCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)jjCenterY {
    return self.center.y;
}

- (void)setJjCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)jjWidth {
    return self.frame.size.width;
}

- (void)setJjWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)jjHeight {
    return self.frame.size.height;
}

- (void)setJjHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)jjOrigin {
    return self.frame.origin;
}

- (void)setJjOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)jjSize {
    return self.frame.size;
}

- (void)setJjSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)jjScreenX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.jjLeft;
    }
    return x;
}

- (CGFloat)jjScreenY {
    CGFloat y = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        y += view.jjTop;
    }
    return y;
}

- (CGRect)jjScreenFrame {
    return CGRectMake(self.jjScreenX, self.jjScreenY, self.jjWidth, self.jjHeight);
}

#pragma mark - Subview

+ (UIView *)jj_topView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.subviews.count > 0)
    {
        return [window.subviews lastObject];
    }
    else
    {
        return window;
    }
}

+ (UIView *)jj_firstView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.subviews.count > 0)
    {
        return [window.subviews objectAtIndex:0];
    }
    else
    {
        return window;
    }
}

- (void)jj_addSubViews:(NSArray *)subViews_
{
    [subViews_ enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [self addSubview:obj];
     }];
}

- (void)jj_addSubViews:(NSArray *)subViews_ target:(id)target_ action:(SEL)action_
{
    [subViews_ enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj isKindOfClass:[UIButton class]])
         {
             [(UIButton *)obj addTarget:target_ action:action_ forControlEvents:UIControlEventTouchUpInside];
         }
         [self addSubview:obj];
     }];
}

- (void)jj_addSubViews:(NSArray *)subViews_ pressBlock:(void (^)(id sender))pressBlock_
{
    self.jj_addSubViewsPressBlock = pressBlock_;
    
    [self jj_addSubViews:subViews_ target:self action:@selector(jj_addSubViewsHandlePress:)];
}

- (void)jj_addSubViewsHandlePress:(id)sender_
{
    if (self.jj_addSubViewsPressBlock)
    {
        self.jj_addSubViewsPressBlock(sender_);
    }
}

- (void)jj_eachSubview:(void (^)(UIView *subview))block
{
    NSParameterAssert(block != nil);
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        block(subview);
    }];
}

#pragma mark - Screenshot

- (UIImage *)jj_screenCapture:(BOOL)isOpaque
{
    return [self jj_screenCapture:isOpaque margin:UIEdgeInsetsZero];
}

- (UIImage *)jj_screenCapture:(BOOL)isOpaque margin:(UIEdgeInsets)margin
{
    CGRect rect = self.bounds;
    rect.origin.x += margin.left;
    rect.origin.y += margin.top;
    rect.size.width = rect.size.width - margin.left - margin.right;
    rect.size.height = rect.size.height - margin.top - margin.bottom;
    
    UIImage *image = nil;
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, isOpaque, [UIScreen mainScreen].scale);
        [self drawViewHierarchyInRect:rect afterScreenUpdates:NO];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, isOpaque, [UIScreen mainScreen].scale);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

#pragma mark - Touch and tap

- (void)jj_whenTouches:(NSUInteger)numberOfTouches tapped:(NSUInteger)numberOfTaps handler:(void (^)(void))block
{
    if (!block) return;
    
    UITapGestureRecognizer *gesture = [UITapGestureRecognizer jj_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if (state == UIGestureRecognizerStateRecognized) block();
    }];
    
    gesture.numberOfTouchesRequired = numberOfTouches; // 手指数
    gesture.numberOfTapsRequired = numberOfTaps; // 点击次数
    
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[UITapGestureRecognizer class]]) return;
        
        UITapGestureRecognizer *tap = obj;
        BOOL rightTouches = (tap.numberOfTouchesRequired == numberOfTouches);
        BOOL rightTaps = (tap.numberOfTapsRequired == numberOfTaps);
        if (rightTouches && rightTaps) {
            [gesture requireGestureRecognizerToFail:tap];
        }
    }];
    
    [self addGestureRecognizer:gesture];
}

- (void)jj_whenTapped:(void (^)(void))block
{
    [self jj_whenTouches:1 tapped:1 handler:block];
}

- (void)jj_whenDoubleTapped:(void (^)(void))block
{
    [self jj_whenTouches:2 tapped:1 handler:block];
}

#pragma mark - visible

- (BOOL)jj_isVisible
{
    UIViewController *vc = [self jj_viewController];
    if (!vc)
    {
        return NO;
    }
    
    BOOL isVCLoad = [vc isViewLoaded];
    BOOL haveWindow = (vc.view.window != nil);
    
    return (isVCLoad && haveWindow);
}

#pragma mark - view controller

- (UIViewController *)jj_viewController
{
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - transform

- (void)jj_scaleWithSX:(CGFloat)sx_ sy:(CGFloat)sy_
{
    self.transform = CGAffineTransformIdentity;
    self.transform = CGAffineTransformScale(self.transform, sx_, sy_);
}

#pragma mark - line

+ (CGFloat)jj_singleLineWidth
{
    return (1 / [UIScreen mainScreen].scale);
}

+ (CGFloat)jj_singleLineAdjustOffset
{
    return ((1 / [UIScreen mainScreen].scale) / 2);
}

+ (CGFloat)jj_lineWidthWithPixelNumber:(NSInteger)pixelNumber_
{
    return (pixelNumber_ * [self jj_singleLineWidth]);
}

+ (CGFloat)jj_lineAdjustOffsetWithPixelNumber:(NSInteger)pixelNumber_
{
    if (0 == (pixelNumber_ % 2))
    {
        return 0;
    }
    else
    {
        return [self jj_singleLineAdjustOffset];
    }
}

@end
