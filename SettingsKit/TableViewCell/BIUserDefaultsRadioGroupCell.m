//
//  BIUserDefaultsRadioGroupCell.m
//  SettingsKit
//
//  Created by HuGuanqin on 10/22/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsRadioGroupCell.h"
#import "BIUserDefaultsBackingStore.h"
#import "BIUserDefaultsSpecifier.h"

@implementation BIUserDefaultsRadioGroupCell

- (void)refreshCellContentsWithSpecifier:(BIUserDefaultsSpecifier *)specifier {
    NSIndexPath *indexPath = [specifier indexPath];
    
    if (indexPath != nil && indexPath.row < [[specifier values] count]) {
        self.textLabel.text = [[specifier titles] objectAtIndex:indexPath.row];
        
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
        
        if ([value isEqual:[[specifier values] objectAtIndex:indexPath.row]]) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            self.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
