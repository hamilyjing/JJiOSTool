//
//  JJSelectView.h
//  BaiduBrowser
//
//  Created by gongjian03 on 8/24/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJSelectView : UIView

@property (nonatomic, strong) UIButton *jj_backgroundView;

@property (nonatomic, strong) UIImageView *selectMark;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setColorString:(NSString *)colorString;

@property (nonatomic, copy) void (^jj_selectBlock)();

@end
