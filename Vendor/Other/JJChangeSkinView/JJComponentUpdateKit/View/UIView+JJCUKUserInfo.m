//
//  UIView+JJCUKUserInfo.m
//  BaiduBrowser
//
//  Created by gongjian03 on 9/8/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "UIView+JJCUKUserInfo.h"

#import "UIView+JJCUK.h"
#import "JJCUKComponentUpdateViewUserInfoDefine.h"
#import "JJCUKFunctionTypeChangeSkinViewDefine.h"

@implementation UIView (JJCUKUserInfo)

- (void)jj_setLightBackgroundColor:(UIColor *)lightColor_
               darkBackgroundColor:(UIColor *)darkColor_
{
    if (lightColor_)
    {
        [self jjCUK_setUserInfoWithObject:lightColor_ forKey:JJChangeSkinNofiticationUserInfoViewLightBackgroundColorKey];
    }
    
    if (darkColor_)
    {
        [self jjCUK_setUserInfoWithObject:darkColor_ forKey:JJChangeSkinNofiticationUserInfoViewDarkBackgroundColorKey];
    }
    
    self.jjCUKFunctionType = JJCUKFunctionTypeChangeSkinViewColorChangedFollowBackground;
}

- (void)jj_setLightBorderColor:(UIColor *)lightBorderColor_
               darkBorderColor:(UIColor *)darkBorderColor_
{
    if (lightBorderColor_)
    {
        [self jjCUK_setUserInfoWithObject:lightBorderColor_ forKey:JJChangeSkinNofiticationUserInfoViewLightBorderColorKey];
    }
    
    if (darkBorderColor_)
    {
        [self jjCUK_setUserInfoWithObject:darkBorderColor_ forKey:JJChangeSkinNofiticationUserInfoViewDarkBorderColorKey];
    }
    
    self.jjCUKFunctionType = JJCUKFunctionTypeChangeSkinViewColorChangedFollowBackground;
}

@end
