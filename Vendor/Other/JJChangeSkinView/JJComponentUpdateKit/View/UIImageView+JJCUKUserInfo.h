//
//  UIImageView+JJCUKUserInfo.h
//  BaiduBrowser
//
//  Created by hamilyjing on 9/7/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JJCUKUserInfo)

- (void)jj_setLightImage:(UIImage *)lightImage
               darkImage:(UIImage *)darkImage;

- (void)jj_setLightAnimationImages:(NSArray *)lightAnimationImages
               darkAnimationImages:(NSArray *)darkAnimationImages;

@end
