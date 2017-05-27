//
//  JJNeedChangeSkinView.m
//  BaiduBrowser
//
//  Created by gongjian03 on 8/28/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "JJNeedChangeSkinView.h"

#import "JJCUKFunctionTypeChangeSkinViewDefine.h"
#import "UIGestureRecognizer+JJ.h"
#import "UIView+JJ.h"
#import "UIView+JJCUK.h"
#import "FXBlurView.h"

extern NSString *JJChangeSkinViewBeScreenCapturedViewChangedNotificationName;

extern NSString *JJChangeSkinNofiticationUserInfoImageBlurRadiusKey;

@interface JJNeedChangeSkinView () <JJCUKViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) FXBlurView *blurView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation JJNeedChangeSkinView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUp];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    //self.blurView.frame = self.bounds;
}

#pragma mark - public

- (void)setEnableLongPress:(BOOL)enableLongPress_
{
    if (_enableLongPress == enableLongPress_)
    {
        return;
    }
    
    _enableLongPress = enableLongPress_;
    
    if (_enableLongPress)
    {
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        //self.longPressGestureRecognizer.minimumPressDuration = 1;
        [self.backgroundImageView addGestureRecognizer:self.longPressGestureRecognizer];
        self.backgroundImageView.userInteractionEnabled = YES;
    }
    else
    {
        self.backgroundImageView.userInteractionEnabled = YES;
        [self.backgroundImageView removeGestureRecognizer:self.longPressGestureRecognizer];
        self.longPressGestureRecognizer = nil;
    }
}

- (void)setCUKFunctionType:(JJCUKFunctionType *)cukFunctionType_
{
    self.backgroundImageView.jjCUKFunctionType = cukFunctionType_;
}

- (void)showChangeSkinView
{
}

- (void)setUp
{
    //[self addSubview:self.blurView];
    //[self sendSubviewToBack:self.blurView];
    
    [self addSubview:self.backgroundImageView];
    [self sendSubviewToBack:self.backgroundImageView];
    
    self.enableLongPress = NO;
}

#pragma mark - event

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    [self showChangeSkinView];
}

#pragma mark - JJCUKViewDelegate

- (void)jjCUK_didUpdateView:(UIView *)view_
{
//    if (view_ == self.backgroundImageView)
//    {
//        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//        [nc postNotificationName:JJChangeSkinViewBeScreenCapturedViewChangedNotificationName object:nil];
//    }
}

#pragma mark - getter and setter

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView)
    {
        return _backgroundImageView;
    }
    
    _backgroundImageView = [[UIImageView alloc] init];
    //_backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    //_backgroundImageView.layer.masksToBounds = YES;
    _backgroundImageView.jjCUKFunctionType = JJCUKFunctionTypeChangeSkinViewImageViewColorAndPhoto;
    //[_backgroundImageView jjCUK_setUserInfoWithObject:@(30.0) forKey:JJChangeSkinNofiticationUserInfoImageBlurRadiusKey];
    _backgroundImageView.jjCUKViewDelegate = self;
    
    return _backgroundImageView;
}

- (FXBlurView *)blurView
{
    if (_blurView)
    {
        return _blurView;
    }
    
    _blurView = [[FXBlurView alloc] init];
    _blurView.blurRadius = 2.0;
    _blurView.dynamic = NO;
    _blurView.userInteractionEnabled = NO;
    
    return _blurView;
}

@end
