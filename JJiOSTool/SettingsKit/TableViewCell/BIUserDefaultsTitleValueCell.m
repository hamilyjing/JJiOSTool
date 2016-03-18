//
//  BIUserDefaultsTitleValueCell.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/29/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsUnderlineLabel.h"
#import "BIUserDefaultsTitleValueCell.h"
#import "BIUserDefaultsBackingStore.h"
#import "BIUserDefaultsSpecifier.h"

@implementation BIUserDefaultsTitleValueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    
    NSString *title = [specifier titleForValue:value];
    
    self.accessoryView = nil;
    self.detailTextLabel.text = nil;
    if ([BITitleValueSpecifier isEqualToString:specifier.type]) {
        if ([title hasPrefix:@"http://"] || [title hasPrefix:@"https://"]) {
            BIUserDefaultsUnderlineLabel *label =  [[BIUserDefaultsUnderlineLabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = self.detailTextLabel.font;
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = self.detailTextLabel.textColor;
            label.text = title;
            [label sizeToFit];
            [label addTarget:self action:@selector(labelClicked:)];
            self.accessoryView = label;
            self.userInteractionEnabled = YES;
        } else {
            self.userInteractionEnabled = YES;
            self.detailTextLabel.text = title;
        }
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.detailTextLabel.text = title;
        
        self.userInteractionEnabled = YES;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (void)labelClicked:(id)sender {
    UIView *view = sender;
    while (view.superview) {
        if ([view isKindOfClass:[UILabel class]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:((UILabel *)view).text]];
            break;
        }
        view = view.superview;
    }
}

@end
