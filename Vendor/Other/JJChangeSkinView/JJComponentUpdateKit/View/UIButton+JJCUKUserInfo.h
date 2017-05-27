//
//  UIButton+JJCUKUserInfo.h
//  BaiduBrowser
//
//  Created by gongjian03 on 9/7/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JJCUKUserInfo)

- (void)jj_setLightNormalImage:(UIImage *)lightNormalImage
   lightHighlightedNormalImage:(UIImage *)lightHighlightedNormalImage
             lightDisableImage:(UIImage *)lightDisableImage
               darkNormalImage:(UIImage *)darkNormalImage
    darkHighlightedNormalImage:(UIImage *)darkHighlightedNormalImage
              darkDisableImage:(UIImage *)darkDisableImage;

- (void)jj_setLightNormalTitleColor:(UIColor *)lightNormalTitleColor
   lightHighlightedNormalTitleColor:(UIColor *)lightHighlightedNormalTitleColor
             lightDisableTitleColor:(UIColor *)lightDisableTitleColor
               darkNormalTitleColor:(UIColor *)darkNormalTitleColor
    darkHighlightedNormalTitleColor:(UIColor *)darkHighlightedNormalTitleColor
              darkDisableTitleColor:(UIColor *)darkDisableTitleColor;

- (void)jj_setLightNormalImage:(UIImage *)lightNormalImage
   lightHighlightedNormalImage:(UIImage *)lightHighlightedNormalImage
               darkNormalImage:(UIImage *)darkNormalImage
    darkHighlightedNormalImage:(UIImage *)darkHighlightedNormalImage;

- (void)jj_setLightNormalTitleColor:(UIColor *)lightNormalTitleColor
   lightHighlightedNormalTitleColor:(UIColor *)lightHighlightedNormalTitleColor
               darkNormalTitleColor:(UIColor *)darkNormalTitleColor
    darkHighlightedNormalTitleColor:(UIColor *)darkHighlightedNormalTitleColor;

@end
