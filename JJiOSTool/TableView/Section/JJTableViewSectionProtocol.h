//
//  JJTableViewSectionProtocol.h
//  PANewToapAPP
//
//  Created by JJ on 5/18/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JJTableViewSectionProtocol <NSObject>

@optional

+ (CGFloat)heightForHeader:(UITableView *)tableView section:(NSInteger)section viewController:(UIViewController *)viewController;

+ (CGFloat)heightForFooter:(UITableView *)tableView section:(NSInteger)section viewController:(UIViewController *)viewController;

+ (UIView *)viewForHeader:(UITableView *)tableView section:(NSInteger)section viewController:(UIViewController *)viewController;

+ (UIView *)viewForFooter:(UITableView *)tableView section:(NSInteger)section viewController:(UIViewController *)viewController;

+ (NSString *)titleForHeaderInSection:(UITableView *)tableView section:(NSInteger)section viewController:(UIViewController *)viewController;

+ (NSString *)titleForFooterInSection:(UITableView *)tableView section:(NSInteger)section viewController:(UIViewController *)viewController;

+ (void)willDisplayHeaderView:(UITableView *)tableView headerView:(UIView *)headerView section:(NSInteger)section viewController:(UIViewController *)viewController;

+ (void)willDisplayFooterView:(UITableView *)tableView footerView:(UIView *)footerView section:(NSInteger)section viewController:(UIViewController *)viewController;

+ (void)didEndDisplayingHeaderView:(UITableView *)tableView headerView:(UIView *)headerView section:(NSInteger)section viewController:(UIViewController *)viewController;

+ (void)didEndDisplayingFooterView:(UITableView *)tableView footerView:(UIView *)footerView section:(NSInteger)section viewController:(UIViewController *)viewController;

@end
