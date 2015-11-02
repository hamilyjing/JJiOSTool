//
//  UIView+JJ.h
//  JJObjCTool
//
//  Created by JJ on 5/13/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JJ)

#pragma mark - Frame

@property (nonatomic) CGFloat jjLeft;
@property (nonatomic) CGFloat jjTop;
@property (nonatomic) CGFloat jjWidth;
@property (nonatomic) CGFloat jjHeight;

@property (nonatomic) CGPoint jjOrigin;
@property (nonatomic) CGSize jjSize;

@property (nonatomic) CGFloat jjRight;
@property (nonatomic) CGFloat jjBottom;

@property (nonatomic) CGFloat jjCenterX;
@property (nonatomic) CGFloat jjCenterY;

// 相对屏幕
@property (nonatomic, readonly) CGFloat jjScreenX;
@property (nonatomic, readonly) CGFloat jjScreenY;
@property (nonatomic, readonly) CGRect jjScreenFrame;

#pragma mark - Subview

+ (UIView *)jj_topView;
+ (UIView *)jj_firstView;

- (void)jj_addSubViews:(NSArray *)subViews;
- (void)jj_addSubViews:(NSArray *)subViews target:(id)target action:(SEL)action;
- (void)jj_addSubViews:(NSArray *)subViews pressBlock:(void (^)(id sender))pressBlock;

- (void)jj_eachSubview:(void (^)(UIView *subview))block;

#pragma mark - Screenshot

- (UIImage *)jj_screenCapture:(BOOL)isOpaque;
- (UIImage *)jj_screenCapture:(BOOL)isOpaque margin:(UIEdgeInsets)margin;

#pragma mark - Touch and tap

- (void)jj_whenTouches:(NSUInteger)numberOfTouches tapped:(NSUInteger)numberOfTaps handler:(void (^)(void))block;

- (void)jj_whenTapped:(void (^)(void))block;
- (void)jj_whenDoubleTapped:(void (^)(void))block;

#pragma mark - visible

- (BOOL)jj_isVisible;

#pragma mark - view controller

- (UIViewController *)jj_viewController;

#pragma mark - transform

- (void)jj_scaleWithSX:(CGFloat)sx sy:(CGFloat)sy;

#pragma mark - line

+ (CGFloat)jj_singleLineWidth;
+ (CGFloat)jj_singleLineAdjustOffset;

+ (CGFloat)jj_lineWidthWithPixelNumber:(NSInteger)pixelNumber;
+ (CGFloat)jj_lineAdjustOffsetWithPixelNumber:(NSInteger)pixelNumber;

@end
