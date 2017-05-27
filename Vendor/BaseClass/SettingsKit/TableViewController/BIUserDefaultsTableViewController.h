//
//  BIUserDefaultsTableViewController.h
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BIUserDefaultsSpecifier;
@class BIUserDefaultsSpecifierDataSource;

@interface BIUserDefaultsTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong, readonly) BIUserDefaultsSpecifierDataSource *dataSource;

- (instancetype)initWithDataSource:(BIUserDefaultsSpecifierDataSource *)dataSource;

- (void)setSpecifierDataSource:(BIUserDefaultsSpecifierDataSource *)dataSource;

- (UITableViewCell *)tableView:(UITableView*)tableView willBeginConfiguringTableCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath specifier:(BIUserDefaultsSpecifier *)specifier;
- (UITableViewCell *)tableView:(UITableView*)tableView didEndConfiguringTableCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath specifier:(BIUserDefaultsSpecifier *)specifier;

- (BOOL)tableView:(UITableView*)tableView willBeginSelectingRowAtIndexPath:(NSIndexPath *)indexPath specifier:(BIUserDefaultsSpecifier *)specifier;
- (void)tableView:(UITableView*)tableView didEndSelectingRowAtIndexPath:(NSIndexPath *)indexPath specifier:(BIUserDefaultsSpecifier *)specifier;

@end
