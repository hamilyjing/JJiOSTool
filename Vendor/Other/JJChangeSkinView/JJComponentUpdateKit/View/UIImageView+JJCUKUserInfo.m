//
//  UIImageView+JJCUKUserInfo.m
//  BaiduBrowser
//
//  Created by hamilyjing on 9/7/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "UIImageView+JJCUKUserInfo.h"

#import "UIView+JJCUK.h"
#import "JJCUKComponentUpdateViewUserInfoDefine.h"
#import "JJCUKFunctionTypeChangeSkinViewDefine.h"

@implementation UIImageView (JJCUKUserInfo)

- (void)jj_setLightImage:(UIImage *)lightImage_
               darkImage:(UIImage *)darkImage_
{
    if (lightImage_)
    {
        [self jjCUK_setUserInfoWithObject:lightImage_ forKey:JJChangeSkinNofiticationUserInfoLightImageKey];
    }
    
    if (darkImage_)
    {
        [self jjCUK_setUserInfoWithObject:darkImage_ forKey:JJChangeSkinNofiticationUserInfoDarkImageKey];
    }
    
    self.jjCUKFunctionType = JJCUKFunctionTypeChangeSkinViewColorChangedFollowBackground;
}

- (void)jj_setLightAnimationImages:(NSArray *)lightAnimationImages_
               darkAnimationImages:(NSArray *)darkAnimationImages_
{
    if (lightAnimationImages_)
    {
        [self jjCUK_setUserInfoWithObject:lightAnimationImages_ forKey:JJChangeSkinNofiticationUserInfoLightAnimationImagesKey];
    }
    
    if (darkAnimationImages_)
    {
        [self jjCUK_setUserInfoWithObject:darkAnimationImages_ forKey:JJChangeSkinNofiticationUserInfoDarkAnimationImagesKey];
    }
    
    self.jjCUKFunctionType = JJCUKFunctionTypeChangeSkinViewColorChangedFollowBackground;
}

@end
