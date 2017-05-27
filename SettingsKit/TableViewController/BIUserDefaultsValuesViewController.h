//
//  BIUserDefaultsValuesViewController.h
//  SettingsKit
//
//  Created by HuGuanqin on 9/29/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BIUserDefaultsSpecifier;

@interface BIUserDefaultsValuesViewController : UITableViewController

- (instancetype)initWithSpecifier:(BIUserDefaultsSpecifier *)specifier;

@end
