//
//  UITableViewCell+JJTableViewDataSource.m
//  PANewToapAPP
//
//  Created by JJ on 5/16/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import "UITableViewCell+JJTableViewDataSource.h"

@implementation UITableViewCell (JJTableViewDataSource)

- (void)jj_setModel:(id)object viewController:(UIViewController *)viewController
{
}

+ (NSString *)jj_cellIdentifier:(id)object viewController:(UIViewController *)viewController
{
    NSString *identifier = NSStringFromClass([object class]);
    return identifier;
}

+ (UITableViewCell *)jj_cell:(id)object resuedCell:(UITableViewCell *)resuedCell viewController:(UIViewController *)viewController
{
    if (resuedCell)
    {
        return resuedCell;
    }
    
    UITableViewCell *cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self jj_cellIdentifier:object viewController:viewController]];
    return cell;
}

+ (CGFloat)jj_height:(id)object viewController:(UIViewController *)viewController
{
    return 60;
}

- (UITableViewCellEditingStyle)jj_editingStyleForRow:(id)object viewController:(UIViewController *)viewController;
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)jj_titleForDeleteConfirmationButtonForRow:(id)object viewController:(UIViewController *)viewController
{
    return @"删除";
}

+ (BOOL)jj_canEditRowAtIndexPath:(id)object viewController:(UIViewController *)viewController
{
    return NO;
}

+ (BOOL)jj_canMoveRowAtIndexPath:(id)object viewController:(UIViewController *)viewController
{
    return NO;
}

- (void)jj_commitEditingStyle:(UITableViewCellEditingStyle)editingStyle object:(id)object viewController:(UIViewController *)viewController indexPath:(NSIndexPath *)indexPath
{
    
}

@end
