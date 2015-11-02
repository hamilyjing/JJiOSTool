//
//  BIUserDefaultsTableViewCell.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/23/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsTableViewCell.h"
#import "BIUserDefaultsSpecifier.h"

@implementation BIUserDefaultsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setUp];
        [self layout];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUp
{
    
}

- (void)layout
{
    
}

- (void)refreshCellContentsWithSpecifier:(BIUserDefaultsSpecifier *)specifier {
    self.textLabel.text = specifier.title;
    self.detailTextLabel.text = specifier.detailText;
    
    SEL action = specifier.getter;
    if (action) {
        NSString *title = [specifier runActionWithSelector:action];
        if ([title isKindOfClass:[NSString class]]) {
            if (self.textLabel.text == nil) {
                self.textLabel.text = title;
            } else {
                self.detailTextLabel.text = title;
            }
        }
    }
}

@end
