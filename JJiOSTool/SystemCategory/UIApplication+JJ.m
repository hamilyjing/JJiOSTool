//
//  UIApplication+JJ.m
//  JJObjCTool
//
//  Created by hamilyjing on 5/13/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "UIApplication+JJ.h"

@implementation UIApplication (JJ)

#pragma mark - Root view controller

+ (UIViewController *)jj_rootViewController
{
    UIApplication *app = [UIApplication sharedApplication];
    return app.keyWindow.rootViewController;
}

#pragma mark - Open URL

+ (void)jj_openUrlWithString:(NSString *)urlString
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

@end
