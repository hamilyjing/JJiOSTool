//
//  BIUserDefaultsSliderCell.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsSpecifierDataSource.h"
#import "BIUserDefaultsBackingStore.h"
#import "BIUserDefaultsSliderCell.h"
#import "BIUserDefaultsSpecifier.h"

@interface BIUserDefaultsSliderCell ()

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *maxLabel;

@end

@implementation BIUserDefaultsSliderCell

- (void)setUp
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // UISlider的frame不能设置为CGRectZero，否则不能滑动
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(30, 0, 100, 20)];
    self.slider.continuous = YES;
    
    self.minLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    self.minLabel.numberOfLines = 0;
    self.maxLabel.numberOfLines = 0;
    
    CGFloat labelFontSize = 15;
    CGFloat margin = 10;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        labelFontSize = 24;
        margin = 20;
    }
    
    self.minLabelEdgeInsets = UIEdgeInsetsMake(0, margin, 0, margin);
    self.maxLabelEdgeInsets = UIEdgeInsetsMake(0, margin, 0, margin);
    
    self.minLabel.font = [UIFont systemFontOfSize:labelFontSize];
    self.maxLabel.font = [UIFont systemFontOfSize:labelFontSize];
    
    self.minLabel.textAlignment = NSTextAlignmentCenter;
    self.maxLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_slider];
    [self.contentView addSubview:_minLabel];
    [self.contentView addSubview:_maxLabel];
}

- (void)layout
{
    // 禁止autoresizing，否则constraint不起作用
    _slider.translatesAutoresizingMaskIntoConstraints = NO;
    _minLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _maxLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *c = nil;
    
    // mini label
    c = [NSLayoutConstraint constraintWithItem:_minLabel
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1
                                      constant:_minLabelEdgeInsets.left];
    [self.contentView addConstraint:c];
    
    c = [NSLayoutConstraint constraintWithItem:_minLabel
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1
                                      constant:0];
    [self.contentView addConstraint:c];
    
    // slider
    c = [NSLayoutConstraint constraintWithItem:_slider
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_minLabel
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1
                                      constant:_minLabelEdgeInsets.right];
    [self.contentView addConstraint:c];
    
    c = [NSLayoutConstraint constraintWithItem:_slider
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1
                                      constant:0];
    [self.contentView addConstraint:c];
    
    c = [NSLayoutConstraint constraintWithItem:_slider
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_maxLabel
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1
                                      constant:-_maxLabelEdgeInsets.left];
    [self.contentView addConstraint:c];
    
    // max label
    c = [NSLayoutConstraint constraintWithItem:_maxLabel
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1
                                      constant:-_maxLabelEdgeInsets.right];
    
    [self.contentView addConstraint:c];
    
    c = [NSLayoutConstraint constraintWithItem:_maxLabel
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1
                                      constant:0];
    
    [self.contentView addConstraint:c];
}

- (void)refreshCellContentsWithSpecifier:(BIUserDefaultsSpecifier *)specifier {
    _slider.minimumValue = [specifier minimumValue];
    _slider.maximumValue = [specifier maximumValue];
    
    id  value = nil;
    SEL action = specifier.getter;
    if (action) {
        value = [specifier runActionWithSelector:action];
    }
    
    if (value == nil) {
        value = [[BIUserDefaultsBackingStore sharedInstance] objectForKey:specifier.key];
    }
    
    if (value == nil) {
        value = [specifier defaultValue];
    }
    
    if ([value respondsToSelector:@selector(floatValue)]) {
        _slider.value = [value floatValue];
    }
    
    NSString *minImage = [specifier minimumValueImage];
    if (minImage != nil) {
        NSString *path = [[specifier.dataSource.bundle bundlePath] stringByAppendingPathComponent:minImage];
        _slider.minimumValueImage = [UIImage imageWithContentsOfFile:path];
    }
    
    NSString *maxImage = [specifier maximumValueImage];
    if (maxImage != nil) {
        NSString *path = [[specifier.dataSource.bundle bundlePath] stringByAppendingPathComponent:maxImage];
        _slider.maximumValueImage = [UIImage imageWithContentsOfFile:path];
    }
    
    self.minLabel.text = specifier.properties[BISpecifierMinimumTextValue];
    self.maxLabel.text = specifier.properties[BISpecifierMaximumTextValue];
}

@end
