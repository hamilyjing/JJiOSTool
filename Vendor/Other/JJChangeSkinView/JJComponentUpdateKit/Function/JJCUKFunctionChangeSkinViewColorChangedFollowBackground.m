//
//  JJCUKFunctionChangeSkinViewColorChangedFollowBackground.m
//  BaiduBrowser
//
//  Created by gongjian03 on 9/7/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "JJCUKFunctionChangeSkinViewColorChangedFollowBackground.h"

#import "UIView+JJCUK.h"
#import "JJCUKComponentUpdateViewUserInfoDefine.h"
#import "JJChangeSkinManager.h"

@implementation JJCUKFunctionChangeSkinViewColorChangedFollowBackground

#pragma mark - public

- (void)updateComponent:(id<JJCUKFunctionTypeDelegate>)component_ withObject:(id)object_
{
    UIView *view = (UIView *)component_;
    
    UIStatusBarStyle statusBarStyle;
    
    NSString *backgroundType = view.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoBackgroundTypeKey];
    if ([backgroundType isEqualToString:JJChangeSkinNofiticationUserInfoBackgroundTypePureColor])
    {
        statusBarStyle = [[JJChangeSkinManager sharedInstance] pureColorStatusBarStyle];
    }
    else
    {
        statusBarStyle = [[JJChangeSkinManager sharedInstance] photoImageStatusBarStyle];
    }
    
    if ([view isKindOfClass:[UILabel class]])
    {
        [self setLabel:(UILabel *)view statusBarStyle:statusBarStyle];
    }
    else if ([view isKindOfClass:[UIImageView class]])
    {
        [self setImageView:(UIImageView *)view statusBarStyle:statusBarStyle];
    }
    else if ([view isKindOfClass:[UIButton class]])
    {
        [self setButton:(UIButton *)view statusBarStyle:statusBarStyle];
    }
    else
    {
        [self setView:view statusBarStyle:statusBarStyle];
    }
}

#pragma mark - private

- (void)setLabel:(UILabel *)label_ statusBarStyle:(UIStatusBarStyle)statusBarStyle_
{
    UIColor *textColor;
    
    if (UIStatusBarStyleLightContent == statusBarStyle_)
    {
        textColor = label_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoLabelLightTextColorKey];
    }
    else
    {
        textColor = label_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoLabelDarkTextColorKey];
    }
    
    label_.textColor = textColor;
}

- (void)setImageView:(UIImageView *)imageView_ statusBarStyle:(UIStatusBarStyle)statusBarStyle_
{
    UIImage *image;
    NSArray *animationImages;
    
    if (UIStatusBarStyleLightContent == statusBarStyle_)
    {
        image = imageView_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoLightImageKey];
        animationImages = imageView_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoLightAnimationImagesKey];
    }
    else
    {
        image = imageView_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoDarkImageKey];
        animationImages = imageView_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoDarkAnimationImagesKey];
    }
    
    if (image)
    {
        imageView_.image = image;
    }
    
    if (animationImages)
    {
        imageView_.animationImages = animationImages;
    }
    
    if (!image && !animationImages)
    {
        [self setView:imageView_ statusBarStyle:statusBarStyle_];
    }
}

- (void)setButton:(UIButton *)button_ statusBarStyle:(UIStatusBarStyle)statusBarStyle_
{
    UIColor *normalTitleColor;
    UIColor *highlightedTitleColor;
    UIColor *disableTitleColor;
    
    UIImage *normalImage;
    UIImage *highlightedImage;
    UIImage *disableImage;
    
    if (UIStatusBarStyleLightContent == statusBarStyle_)
    {
        normalTitleColor = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonLightNormalTitleColorKey];
        highlightedTitleColor = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonLightHighlightedTitleColorKey];
        disableTitleColor = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonLightDisableTitleColorKey];
        
        normalImage = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonLightNormalImageKey];
        highlightedImage = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonLightHighlightedImageKey];
        disableImage = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonLightDisableImageKey];
    }
    else
    {
        normalTitleColor = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonDarkNormalTitleColorKey];
        highlightedTitleColor = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonDarkHighlightedTitleColorKey];
        disableTitleColor = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonDarkDisableTitleColorKey];
        
        normalImage = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonDarkNormalImageKey];
        highlightedImage = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonDarkHighlightedImageKey];
        disableImage = button_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoButtonDarkDisableImageKey];
    }
    
    if (normalTitleColor)
    {
        [button_ setTitleColor:normalTitleColor forState:UIControlStateNormal];
    }
    if (highlightedTitleColor)
    {
        [button_ setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    }
    if (disableTitleColor)
    {
        [button_ setTitleColor:disableTitleColor forState:UIControlStateDisabled];
    }
    
    if (normalImage)
    {
        [button_ setImage:normalImage forState:UIControlStateNormal];
    }
    if (highlightedImage)
    {
        [button_ setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    if (disableImage)
    {
        [button_ setImage:disableImage forState:UIControlStateDisabled];
    }
}

- (void)setView:(UIView *)view_ statusBarStyle:(UIStatusBarStyle)statusBarStyle_
{
    UIColor *color;
    UIColor *borderColor;
    
    if (UIStatusBarStyleLightContent == statusBarStyle_)
    {
        color = view_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoViewLightBackgroundColorKey];
        borderColor = view_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoViewLightBorderColorKey];
    }
    else
    {
        color = view_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoViewDarkBackgroundColorKey];
        borderColor = view_.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoViewDarkBorderColorKey];
    }
    
    if (color)
    {
        view_.backgroundColor = color;
    }
    
    if (borderColor)
    {
        view_.layer.borderColor = borderColor.CGColor;
    }
}

@end
