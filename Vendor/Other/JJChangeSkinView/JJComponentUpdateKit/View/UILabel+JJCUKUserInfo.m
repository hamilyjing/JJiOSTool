//
//  UILabel+JJCUKUserInfo.m
//  BaiduBrowser
//
//  Created by gongjian03 on 9/14/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "UILabel+JJCUKUserInfo.h"

#import "UIView+JJCUK.h"
#import "JJCUKComponentUpdateViewUserInfoDefine.h"
#import "JJCUKFunctionTypeChangeSkinViewDefine.h"

@implementation UILabel (JJCUKUserInfo)

- (void)jj_setLightTextColor:(UIColor *)lightTextColor_
               darkTextColor:(UIColor *)darkTextColor_
{
    if (lightTextColor_)
    {
        [self jjCUK_setUserInfoWithObject:lightTextColor_ forKey:JJChangeSkinNofiticationUserInfoLabelLightTextColorKey];
    }
    
    if (darkTextColor_)
    {
        [self jjCUK_setUserInfoWithObject:darkTextColor_ forKey:JJChangeSkinNofiticationUserInfoLabelDarkTextColorKey];
    }
    
    self.jjCUKFunctionType = JJCUKFunctionTypeChangeSkinViewColorChangedFollowBackground;
}

@end
