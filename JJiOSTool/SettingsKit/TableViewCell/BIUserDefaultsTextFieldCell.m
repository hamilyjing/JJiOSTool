//
//  BIUserDefaultsTextFieldCell.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/27/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsTextFieldCell.h"
#import "BIUserDefaultsBackingStore.h"
#import "BIUserDefaultsSpecifier.h"

CGFloat const kMinLabelWidth = 64;
CGFloat const kMaxLabelWidth = 128;
CGFloat const kControlSpacing = 8;

@implementation BIUserDefaultsTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];

        [self.contentView addSubview:_textField];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize labelSize = [self.textLabel sizeThatFits:CGSizeZero];
    labelSize.width = MAX(labelSize.width, kMinLabelWidth);
    self.textLabel.frame = (CGRect){self.textLabel.frame.origin, {MIN(kMaxLabelWidth, labelSize.width), self.textLabel.frame.size.height}} ;

    CGRect bounds = [self.contentView bounds];
    CGRect frame  = bounds;
    if (self.textLabel.text.length == 0) {
        frame.origin.x = self.imageView.image ? CGRectGetMaxX(self.imageView.frame) +  kControlSpacing : kControlLeftPadding;
    } else {
        frame.origin.x = CGRectGetMaxX(self.textLabel.frame) +  kControlSpacing;
    }
    frame.size.width = bounds.size.width - frame.origin.x - kControlLeftPadding;
    _textField.frame = frame;
}

- (void)refreshCellContentsWithSpecifier:(BIUserDefaultsSpecifier *)specifier {
    self.textLabel.text = specifier.title;
    
    NSString *text = [[BIUserDefaultsBackingStore sharedInstance] objectForKey:specifier.key];
    if (text == nil) {
        text = [specifier defaultValue];
    }
    
    if (text && ![text isMemberOfClass:[NSString class]]) {
        text = [NSString stringWithFormat:@"%@", text];
    }

    _textField.text = text;
    _textField.textAlignment = [specifier textAlignment];
    _textField.keyboardType = [specifier keyboardType];
    _textField.secureTextEntry = [specifier secureTextEntry];
    _textField.autocapitalizationType = [specifier autocapitalizationType];
    if([specifier secureTextEntry]){
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    } else {
        _textField.autocorrectionType = specifier.autoCorrectionType;
    }
}

@end
