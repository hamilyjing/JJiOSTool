//
//  JJCUKFunctionChangeSkinViewImageViewColorAndPhoto.m
//  BaiduBrowser
//
//  Created by gongjian03 on 8/14/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "JJCUKFunctionChangeSkinViewImageViewColorAndPhoto.h"

#import "JJChangeSkinManager.h"
#import "UIView+JJCUK.h"
#import "UIImageView+LBBlurredImage.h"

NSString *JJChangeSkinNofiticationUserInfoImageBlurRadiusKey = @"JJChangeSkinNofiticationUserInfoImageBlurRadiusKey";

@implementation JJCUKFunctionChangeSkinViewImageViewColorAndPhoto

#pragma mark - public

- (void)updateComponent:(id<JJCUKFunctionTypeDelegate>)component_ withObject:(id)object_
{
    UIImage *photoImage = [[JJChangeSkinManager sharedInstance] photoImage];
    UIColor *pureColor = [[JJChangeSkinManager sharedInstance] pureColor];
    
    UIImageView *imageView = (UIImageView *)component_;
    imageView.image = nil;
    imageView.backgroundColor = nil;
    
    if (photoImage)
    {
        NSNumber *blurRadius = imageView.jjCUKUserInfo[JJChangeSkinNofiticationUserInfoImageBlurRadiusKey];
        if (blurRadius)
        {
            [imageView setImageToBlur:photoImage blurRadius:[blurRadius floatValue] completionBlock:nil];
        }
        else
        {
            imageView.image = photoImage;
        }
    }
    else
    {
        imageView.backgroundColor = pureColor;
    }
}

@end
