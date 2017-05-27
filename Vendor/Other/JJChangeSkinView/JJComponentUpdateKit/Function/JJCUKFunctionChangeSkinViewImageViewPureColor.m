//
//  JJCUKFunctionChangeSkinViewImageViewPureColor.m
//  BaiduBrowser
//
//  Created by hamilyjing on 8/20/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "JJCUKFunctionChangeSkinViewImageViewPureColor.h"

#import "JJChangeSkinManager.h"

extern NSString *JJChangeSkinNofiticationName;

@implementation JJCUKFunctionChangeSkinViewImageViewPureColor

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(changeSkinNofitication:) name:JJChangeSkinNofiticationName object:nil];
    }
    
    return self;
}

#pragma mark - public

- (void)updateComponent:(id<JJCUKFunctionTypeDelegate>)component_ withObject:(id)object_
{
    UIImageView *imageView = (UIImageView *)component_;
    imageView.image = nil;
    imageView.backgroundColor = nil;
    
    imageView.backgroundColor = [[JJChangeSkinManager sharedInstance] pureColor];
}

#pragma mark - notification

- (void)changeSkinNofitication:(NSNotification *)notification_
{
    [self updateAllComponentWithObject:notification_.userInfo];
}

@end
