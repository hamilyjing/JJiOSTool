//
//  JJToolBar.h
//  BaiduBrowser
//
//  Created by gongjian03 on 8/24/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJToolBar : UIView

@property (nonatomic, strong) NSArray<UIView *> *items;

@property (nonatomic, strong) NSArray<UIView *> *leftItems;
@property (nonatomic, strong) NSArray<UIView *> *rightItems;

@property (nonatomic, assign) UIEdgeInsets margin;

- (void)setItems:(NSArray<UIView *> *)items animated:(BOOL)animated;

- (void)setLeftItems:(NSArray<UIView *> *)leftItems rightItems:(NSArray<UIView *> *)rightItems animated:(BOOL)animated;

@end
