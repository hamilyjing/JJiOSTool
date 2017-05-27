//
//  BIUserDefaultsSwitchCell.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsSwitchCell.h"
#import "BIUserDefaultsSpecifier.h"
#import "BIUserDefaultsBackingStore.h"

@implementation BIUserDefaultsSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView  = [[UISwitch alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)refreshCellContentsWithSpecifier:(BIUserDefaultsSpecifier *)specifier {
    self.textLabel.text = specifier.title;
    
    // 更新状态
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
    
    if ([value isEqual:specifier.trueValue]) {
        self.toggleSwitch.on = YES;
    } else if ([value isEqual:specifier.falseValue]) {
        self.toggleSwitch.on = NO;
    } else {
        self.toggleSwitch.on = [value boolValue];
    }
}

- (void)setAccessoryView:(UIView *)accessoryView {
    // 只允许设置Switch
    if ([accessoryView isKindOfClass:[UISwitch class]]) {
        [super setAccessoryView:accessoryView];
    }
}

- (UISwitch *)toggleSwitch {
    return (UISwitch *)self.accessoryView;
}

@end
