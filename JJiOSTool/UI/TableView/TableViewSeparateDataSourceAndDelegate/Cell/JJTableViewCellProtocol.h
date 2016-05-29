//
//  JJTableViewCellProtocol.h
//  PANewToapAPP
//
//  Created by JJ on 5/13/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JJTableViewCellProtocol <NSObject>

+ (NSString *)jj_cellIdentifier:(id)object viewController:(UIViewController *)viewController;

+ (UITableViewCell *)jj_cell:(id)object resuedCell:(UITableViewCell *)resuedCell viewController:(UIViewController *)viewController;

+ (CGFloat)jj_height:(id)object viewController:(UIViewController *)viewController;

- (void)jj_setModel:(id)object viewController:(UIViewController *)viewController;

@optional

- (UITableViewCellEditingStyle)jj_editingStyleForRow:(id)object viewController:(UIViewController *)viewController;

- (NSString *)jj_titleForDeleteConfirmationButtonForRow:(id)object viewController:(UIViewController *)viewController;

+ (BOOL)jj_canEditRowAtIndexPath:(id)object viewController:(UIViewController *)viewController;
+ (BOOL)jj_canMoveRowAtIndexPath:(id)object viewController:(UIViewController *)viewController;
- (void)jj_commitEditingStyle:(UITableViewCellEditingStyle)editingStyle object:(id)object viewController:(UIViewController *)viewController indexPath:(NSIndexPath *)indexPath;

- (void)jj_willDisplayCell:(id)object viewController:(UIViewController *)viewController;
- (void)jj_didEndDisplayingCell:(id)object viewController:(UIViewController *)viewController;

- (NSIndexPath *)jj_willDeselectRow:(id)object viewController:(UIViewController *)viewController;
- (void)jj_didDeselectRow:(id)object viewController:(UIViewController *)viewController;

- (NSIndexPath *)jj_willSelectRow:(id)object viewController:(UIViewController *)viewController;
- (void)jj_didSelectRow:(id)object viewController:(UIViewController *)viewController;

- (NSArray<UITableViewRowAction *> *)jj_editActionsForRow:(id)object viewController:(UIViewController *)viewController;

- (void)jj_willBeginEditingRow:(id)object viewController:(UIViewController *)viewController;
- (void)jj_didEndEditingRow:(id)object viewController:(UIViewController *)viewController;

- (BOOL)jj_shouldShowMenuForRow:(id)object viewController:(UIViewController *)viewController;
- (BOOL)jj_canPerformAction:(id)object action:(SEL)action sender:(id)sender viewController:(UIViewController *)viewController;
- (void)jj_performAction:(id)object action:(SEL)action sender:(id)sender viewController:(UIViewController *)viewController;

- (BOOL)jj_shouldHighlightRow:(id)object viewController:(UIViewController *)viewController;
- (void)jj_didHighlightRow:(id)object viewController:(UIViewController *)viewController;
- (void)jj_didUnhighlightRow:(id)object viewController:(UIViewController *)viewController;

- (BOOL)jj_shouldIndentWhileEditingRow:(id)object viewController:(UIViewController *)viewController;

- (NSInteger)jj_indentationLevelForRow:(id)object viewController:(UIViewController *)viewController;

- (BOOL)jj_canFocusRow:(id)object viewController:(UIViewController *)viewController;

- (void)jj_accessoryButtonTappedForRow:(id)object viewController:(UIViewController *)viewController;

@end
