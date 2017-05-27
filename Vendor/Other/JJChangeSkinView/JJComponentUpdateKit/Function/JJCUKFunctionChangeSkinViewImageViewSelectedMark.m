//
//  JJCUKFunctionChangeSkinViewImageViewSelectedMark.m
//  BaiduBrowser
//
//  Created by gongjian03 on 8/27/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "JJCUKFunctionChangeSkinViewImageViewSelectedMark.h"

#import "JJChangeSkinManager.h"
#import "UIView+JJCUK.h"

extern NSString *JJChangeSkinNofiticationUserInfoPureColorStringKey;
extern NSString *JJChangeSkinNofiticationUserInfoPhotoNameStringKey;

@implementation JJCUKFunctionChangeSkinViewImageViewSelectedMark

#pragma mark - public

- (void)updateComponent:(id<JJCUKFunctionTypeDelegate>)component_ withObject:(id)object_
{
    NSString *titleBarPhotoNameString = [[JJChangeSkinManager sharedInstance] photoNameString];
    NSString *titleBarPureColorString = [[JJChangeSkinManager sharedInstance] pureColorString];
    
    UIImageView *imageView = (UIImageView *)component_;
    NSString *componentPhotoNameString = imageView.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoPhotoNameStringKey];
    NSString *componentColorString = imageView.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoPureColorStringKey];
    
    BOOL hidden = YES;
    
    if (componentPhotoNameString)
    {
        if (titleBarPhotoNameString && [titleBarPhotoNameString isEqualToString:componentPhotoNameString])
        {
            hidden = NO;
        }
    }
    else if (componentColorString)
    {
        if (!titleBarPhotoNameString && [titleBarPureColorString isEqualToString:componentColorString])
        {
            hidden = NO;
        }
    }
    
    imageView.hidden = hidden;
}

@end
