//
//  BIUserDefaultsTableViewCell.h
//  SettingsKit
//
//  Created by HuGuanqin on 9/23/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BIUserDefaultsSpecifier;

@interface BIUserDefaultsTableViewCell : UITableViewCell

- (void)setUp;
- (void)layout;

- (void)refreshCellContentsWithSpecifier:(BIUserDefaultsSpecifier *)specifier;

@end
