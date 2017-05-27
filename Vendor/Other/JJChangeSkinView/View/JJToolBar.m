//
//  JJToolBar.m
//  BaiduBrowser
//
//  Created by gongjian03 on 8/24/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "JJToolBar.h"

#import "UIView+JJ.h"

@implementation JJToolBar

#pragma mark - life cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - public

- (void)setItems:(nullable NSArray<UIView *> *)items animated:(BOOL)animated
{
    self.items = items;
    
    [items enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [self addSubview:obj];
    }];
}

- (void)setLeftItems:(NSArray<UIView *> *)leftItems_
          rightItems:(NSArray<UIView *> *)rightItems_
            animated:(BOOL)animated_
{
    self.leftItems = leftItems_;
    self.rightItems = rightItems_;
    
    [self jj_addSubViews:leftItems_];
    [self jj_addSubViews:rightItems_];
}

@end
