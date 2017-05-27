//
//  UIButton+JJCUKUserInfo.m
//  BaiduBrowser
//
//  Created by gongjian03 on 9/7/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "UIButton+JJCUKUserInfo.h"

#import "UIView+JJCUK.h"
#import "JJCUKComponentUpdateViewUserInfoDefine.h"
#import "JJCUKFunctionTypeChangeSkinViewDefine.h"

@implementation UIButton (JJCUKUserInfo)

- (void)jj_setLightNormalImage:(UIImage *)lightNormalImage_
   lightHighlightedNormalImage:(UIImage *)lightHighlightedNormalImage_
             lightDisableImage:(UIImage *)lightDisableImage_
               darkNormalImage:(UIImage *)darkNormalImage_
    darkHighlightedNormalImage:(UIImage *)darkHighlightedNormalImage_
              darkDisableImage:(UIImage *)darkDisableImage_
{
    if (lightNormalImage_)
    {
        [self jjCUK_setUserInfoWithObject:lightNormalImage_ forKey:JJChangeSkinNofiticationUserInfoButtonLightNormalImageKey];
    }
    
    if (lightHighlightedNormalImage_)
    {
        [self jjCUK_setUserInfoWithObject:lightHighlightedNormalImage_ forKey:JJChangeSkinNofiticationUserInfoButtonLightHighlightedImageKey];
    }
    
    if (lightDisableImage_)
    {
        [self jjCUK_setUserInfoWithObject:lightDisableImage_ forKey:JJChangeSkinNofiticationUserInfoButtonLightDisableImageKey];
    }
    
    if (darkNormalImage_)
    {
        [self jjCUK_setUserInfoWithObject:darkNormalImage_ forKey:JJChangeSkinNofiticationUserInfoButtonDarkNormalImageKey];
    }
    
    if (darkHighlightedNormalImage_)
    {
        [self jjCUK_setUserInfoWithObject:darkHighlightedNormalImage_ forKey:JJChangeSkinNofiticationUserInfoButtonDarkHighlightedImageKey];
    }
    
    if (darkDisableImage_)
    {
        [self jjCUK_setUserInfoWithObject:darkDisableImage_ forKey:JJChangeSkinNofiticationUserInfoButtonDarkDisableImageKey];
    }
    
    self.jjCUKFunctionType = JJCUKFunctionTypeChangeSkinViewColorChangedFollowBackground;
}

- (void)jj_setLightNormalTitleColor:(UIColor *)lightNormalTitleColor_
   lightHighlightedNormalTitleColor:(UIColor *)lightHighlightedNormalTitleColor_
             lightDisableTitleColor:(UIColor *)lightDisableTitleColor_
               darkNormalTitleColor:(UIColor *)darkNormalTitleColor_
    darkHighlightedNormalTitleColor:(UIColor *)darkHighlightedNormalTitleColor_
              darkDisableTitleColor:(UIColor *)darkDisableTitleColor_
{
    if (lightNormalTitleColor_)
    {
        [self jjCUK_setUserInfoWithObject:lightNormalTitleColor_ forKey:JJChangeSkinNofiticationUserInfoButtonLightNormalTitleColorKey];
    }
    
    if (lightHighlightedNormalTitleColor_)
    {
        [self jjCUK_setUserInfoWithObject:lightHighlightedNormalTitleColor_ forKey:JJChangeSkinNofiticationUserInfoButtonLightHighlightedTitleColorKey];
    }
    
    if (lightDisableTitleColor_)
    {
        [self jjCUK_setUserInfoWithObject:lightDisableTitleColor_ forKey:JJChangeSkinNofiticationUserInfoButtonLightDisableTitleColorKey];
    }
    
    if (darkNormalTitleColor_)
    {
        [self jjCUK_setUserInfoWithObject:darkNormalTitleColor_ forKey:JJChangeSkinNofiticationUserInfoButtonDarkNormalTitleColorKey];
    }
    
    if (darkHighlightedNormalTitleColor_)
    {
        [self jjCUK_setUserInfoWithObject:darkHighlightedNormalTitleColor_ forKey:JJChangeSkinNofiticationUserInfoButtonDarkHighlightedTitleColorKey];
    }
    
    if (darkDisableTitleColor_)
    {
        [self jjCUK_setUserInfoWithObject:darkDisableTitleColor_ forKey:JJChangeSkinNofiticationUserInfoButtonDarkDisableTitleColorKey];
    }
    
    self.jjCUKFunctionType = JJCUKFunctionTypeChangeSkinViewColorChangedFollowBackground;
}

- (void)jj_setLightNormalImage:(UIImage *)lightNormalImage_
   lightHighlightedNormalImage:(UIImage *)lightHighlightedNormalImage_
               darkNormalImage:(UIImage *)darkNormalImage_
    darkHighlightedNormalImage:(UIImage *)darkHighlightedNormalImage_
{
    [self jj_setLightNormalImage:lightNormalImage_
     lightHighlightedNormalImage:lightHighlightedNormalImage_
               lightDisableImage:nil
                 darkNormalImage:darkNormalImage_
      darkHighlightedNormalImage:darkHighlightedNormalImage_
                darkDisableImage:nil];
}

- (void)jj_setLightNormalTitleColor:(UIColor *)lightNormalTitleColor_
   lightHighlightedNormalTitleColor:(UIColor *)lightHighlightedNormalTitleColor_
               darkNormalTitleColor:(UIColor *)darkNormalTitleColor_
    darkHighlightedNormalTitleColor:(UIColor *)darkHighlightedNormalTitleColor_
{
    [self jj_setLightNormalTitleColor:lightNormalTitleColor_
     lightHighlightedNormalTitleColor:lightHighlightedNormalTitleColor_
               lightDisableTitleColor:nil
                 darkNormalTitleColor:darkNormalTitleColor_
      darkHighlightedNormalTitleColor:darkHighlightedNormalTitleColor_
                darkDisableTitleColor:nil];
}

@end
