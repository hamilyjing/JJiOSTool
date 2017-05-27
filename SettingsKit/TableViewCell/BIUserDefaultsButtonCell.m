//
//  BIUserDefaultsButtonCell.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/25/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsButtonCell.h"
#import "BIUserDefaultsSpecifier.h"

@implementation BIUserDefaultsButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        
    }
    return self;
}

- (void)refreshCellContentsWithSpecifier:(BIUserDefaultsSpecifier *)specifier {
    self.textLabel.text = specifier.title;
    self.detailTextLabel.text = specifier.detailText;
    self.textLabel.textAlignment = specifier.textAlignment;
    
    SEL action = specifier.getter;
    if (action) {
        NSString *title = [specifier runActionWithSelector:action];
        if ([title isKindOfClass:[NSString class]]) {
            self.textLabel.text = title;
        }
    }
}

@end
