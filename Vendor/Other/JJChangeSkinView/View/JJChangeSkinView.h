//
//  JJChangeSkinView.h
//  BaiduBrowser
//
//  Created by hamilyjing on 8/27/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *JJChangeSkinViewWillShow;
extern NSString *JJChangeSkinViewDidShow;
extern NSString *JJChangeSkinViewWillHide;
extern NSString *JJChangeSkinViewDidhide;

@interface JJChangeSkinView : UIView

+ (void)showWithBeScreenCapturedView:(UIView *)beScreenCapturedView animation:(BOOL)animation;
+ (void)hide:(BOOL)animation;

+ (BOOL)isShowing;

@end
