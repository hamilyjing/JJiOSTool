//
//  JJTableViewDataSource.h
//  clientUI
//
//  Created by Gong Jian on 14-5-16.
//
//

#import <Foundation/Foundation.h>

#import "JJTableViewCellProtocol.h"

// you will judge if cell is nil, if yes, you will create a new one and return it. if no, return cell directly.
typedef UITableViewCell* (^TableViewCellConfigureBlock)(id reusedCell, id item, NSIndexPath *indexPath, BOOL *useDefaultAction);

@interface JJTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSArray *indexs;

@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *cellMap;

// optional
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock; // default return nil.
@property (nonatomic, copy) NSString* (^titleForHeaderInSection)(NSInteger section); // default return nil.
@property (nonatomic, copy) NSString* (^titleForFooterInSection)(NSInteger section); // default return nil.
@property (nonatomic, copy) BOOL (^canEditRowAtIndexPath)(NSIndexPath *indexPath); // default return YES.
@property (nonatomic, copy) BOOL (^canMoveRowAtIndexPath)(NSIndexPath *indexPath); // default return NO.
@property (nonatomic, copy) void (^edit)(UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath); // default nothing.
@property (nonatomic, copy) void (^move)(NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath); // default nothing.

// if using xib to create cell or create by yourself, set cellClass nil. cellIdentifier and tableView can be nil.
- (id)initWithItems:(NSArray *)anItems
          tableView:(UITableView *)tableView
     viewController:(UIViewController *)viewController;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (id)indexItemAtIndex:(NSUInteger)index;

- (CGFloat)cellHeight:(NSIndexPath *)indexPath;

- (void)willDisplayCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)didEndDisplayingCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

- (NSString *)titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

- (NSIndexPath *)willDeselectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void)didDeselectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

- (NSIndexPath *)willSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

- (NSArray<UITableViewRowAction *> *)editActionsForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

- (void)willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void)didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

- (BOOL)shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (BOOL)canPerformAction:(SEL)action tableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;
- (void)performAction:(SEL)action tableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;

- (BOOL)shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void)didHighlightRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void)didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

- (BOOL)shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

- (NSInteger)indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

- (BOOL)canFocusRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

- (void)accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

@end
