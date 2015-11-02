//
//  UIApplication+JJ.h
//  JJObjCTool
//
//  Created by hamilyjing on 5/13/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (JJ)

#pragma mark - Root view controller

+ (UIViewController *)jj_rootViewController;

#pragma mark - Open URL

+ (void)jj_openUrlWithString:(NSString *)urlString;

@end
