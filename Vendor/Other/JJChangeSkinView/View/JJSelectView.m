//
//  JJSelectView.m
//  BaiduBrowser
//
//  Created by gongjian03 on 8/24/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "JJSelectView.h"

#import "JJCUKFunctionTypeChangeSkinViewDefine.h"
#import "UIView+JJCUK.h"
#import "UIView+JJ.h"
#import "UIColor+JJ.h"

extern NSString *JJChangeSkinNofiticationUserInfoPureColorStringKey;

@implementation JJSelectView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUp];
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.jj_backgroundView];
    
    [self addSubview:self.selectMark];
    
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.jj_backgroundView.frame = self.bounds;
    
    self.selectMark.center = CGPointMake(self.bounds.size.width, 0);
    
    NSInteger titleLabelBottom = 5;
    self.titleLabel.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - titleLabelBottom - self.titleLabel.bounds.size.height * 0.5);
}

#pragma mark - public

- (void)setColorString:(NSString *)colorString_
{
    [self.selectMark jjCUK_setUserInfoWithObject:colorString_ forKey:JJChangeSkinNofiticationUserInfoPureColorStringKey];
    
    self.selectMark.jjCUKFunctionType = JJCUKFunctionTypeChangeSkinViewImageViewSelectedMark;
}

#pragma mark - event

- (void)touchDownBackgroundView:(UIButton *)sender
{
    if (!self.selectMark.hidden)
    {
        return;
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        [self jj_scaleWithSX:0.9 sy:0.9];
    }];
}

- (void)touchUpOutsideBackgroundView:(UIButton *)sender
{
    if (!self.selectMark.hidden)
    {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self jj_scaleWithSX:1 sy:1];
    }];
}

- (void)pressBackgroundView:(UIButton *)sender
{
    if (!self.selectMark.hidden)
    {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self jj_scaleWithSX:1 sy:1];
    }];
    
    if (self.jj_selectBlock)
    {
        self.jj_selectBlock();
    }
}

#pragma mark - getter and setter

- (UIButton *)jj_backgroundView
{
    if (_jj_backgroundView)
    {
        return _jj_backgroundView;
    }
    
    _jj_backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
    _jj_backgroundView.backgroundColor = [UIColor clearColor];
    [_jj_backgroundView addTarget:self action:@selector(pressBackgroundView:) forControlEvents:UIControlEventTouchUpInside];
    [_jj_backgroundView addTarget:self action:@selector(touchDownBackgroundView:) forControlEvents:UIControlEventTouchDown];
    [_jj_backgroundView addTarget:self action:@selector(touchUpOutsideBackgroundView:) forControlEvents:UIControlEventTouchUpOutside];
    [_jj_backgroundView addTarget:self action:@selector(touchUpOutsideBackgroundView:) forControlEvents:UIControlEventTouchCancel];
    
    _jj_backgroundView.layer.cornerRadius = 2;
    _jj_backgroundView.layer.borderWidth = 0.5;
    _jj_backgroundView.layer.borderColor = [UIColor jj_colorWithRGBA:209 green:209 blue:209].CGColor;
    _jj_backgroundView.layer.masksToBounds = YES;
    
    return _jj_backgroundView;
}

- (UIImageView *)selectMark
{
    if (_selectMark)
    {
        return _selectMark;
    }
    
    UIImage *image = [UIImage imageNamed:@"JJChangeSkinView_rss_select"];
    
    _selectMark = [[UIImageView alloc] init];
    _selectMark.hidden = YES;
    _selectMark.image = image;
    _selectMark.jjSize = image.size;
    
    return _selectMark;
}

- (UILabel *)titleLabel
{
    if (_titleLabel)
    {
        return _titleLabel;
    }
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.jjSize = CGSizeMake(48, 16);
    
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:9.0f];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _titleLabel.layer.cornerRadius = 8;
    _titleLabel.layer.borderWidth = [UIView jj_singleLineWidth];
    _titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _titleLabel.layer.masksToBounds = YES;
    
    return _titleLabel;
}

@end
