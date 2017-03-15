//
//  JJTableViewDelegate.m
//  aaa
//
//  Created by hamilyjing on 5/22/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "JJTableViewDelegate.h"

#import "UITableView+JJDataSource.h"
#import "UITableViewCell+JJTableViewDataSource.h"
#import "JJTableViewDataSource.h"
#import "UITableView+JJTableViewSection.h"

@interface JJTableViewDelegate ()

@property (nonatomic, weak) id<UITableViewDelegate> delegate;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation JJTableViewDelegate

#pragma mark - life cycle

- (id)initWithDelegate:(id<UITableViewDelegate>)delegate
             tableView:(UITableView *)tableView
        viewController:(UIViewController *)viewController
{
    self = [super init];
    if (self)
    {
        self.tableView = tableView;
        self.viewController = viewController;
        self.delegate = delegate;
    }
    
    return self;
}

- (id)init
{
    NSAssert(NO, @"init discarded");
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
        return;
    }
    
    [tableView.dataSourceObject willDisplayCell:cell indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)])
    {
        [self.delegate tableView:tableView willDisplayHeaderView:view forSection:section];
        return;
    }
    
    NSString *sectionClassName = [self __objectFromArray:tableView.jjSectionClassNameArray index:section];
    if ([NSClassFromString(sectionClassName) respondsToSelector:@selector(willDisplayHeaderView:headerView:section:viewController:)])
    {
        [NSClassFromString(sectionClassName) willDisplayHeaderView:tableView headerView:view section:section viewController:self.viewController];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)])
    {
        [self.delegate tableView:tableView willDisplayFooterView:view forSection:section];
        return;
    }
    
    NSString *sectionClassName = [self __objectFromArray:tableView.jjSectionClassNameArray index:section];
    if ([NSClassFromString(sectionClassName) respondsToSelector:@selector(willDisplayFooterView:footerView:section:viewController:)])
    {
        [NSClassFromString(sectionClassName) willDisplayFooterView:tableView footerView:view section:section viewController:self.viewController];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
        return;
    }
    
    [tableView.dataSourceObject didEndDisplayingCell:cell indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)])
    {
        [self.delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
        return;
    }
    
    NSString *sectionClassName = [self __objectFromArray:tableView.jjSectionClassNameArray index:section];
    if ([NSClassFromString(sectionClassName) respondsToSelector:@selector(didEndDisplayingHeaderView:headerView:section:viewController:)])
    {
        [NSClassFromString(sectionClassName) didEndDisplayingHeaderView:tableView headerView:view section:section viewController:self.viewController];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)])
    {
        [self.delegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
        return;
    }
    
    NSString *sectionClassName = [self __objectFromArray:tableView.jjSectionClassNameArray index:section];
    if ([NSClassFromString(sectionClassName) respondsToSelector:@selector(didEndDisplayingFooterView:footerView:section:viewController:)])
    {
        [NSClassFromString(sectionClassName) didEndDisplayingFooterView:tableView footerView:view section:section viewController:self.viewController];
    }
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        CGFloat height = [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
        return height;
    }
    
    CGFloat height = [tableView.dataSourceObject cellHeight:indexPath];
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
    {
        CGFloat height = [self.delegate tableView:tableView heightForHeaderInSection:section];
        return height;
    }
    
    NSString *sectionClassName = [self __objectFromArray:tableView.jjSectionClassNameArray index:section];
    if ([NSClassFromString(sectionClassName) respondsToSelector:@selector(heightForHeader:section:viewController:)])
    {
        CGFloat headerHeight = [NSClassFromString(sectionClassName) heightForHeader:tableView section:section viewController:self.viewController];
        return headerHeight;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
    {
        CGFloat height = [self.delegate tableView:tableView heightForFooterInSection:section];
        return height;
    }
    
    NSString *sectionClassName = [self __objectFromArray:tableView.jjSectionClassNameArray index:section];
    if ([NSClassFromString(sectionClassName) respondsToSelector:@selector(heightForFooter:section:viewController:)])
    {
        CGFloat footerHeight = [NSClassFromString(sectionClassName) heightForFooter:tableView section:section viewController:self.viewController];
        return footerHeight;
    }
    
    return 0.01;
}

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.

/*
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)])
    {
        CGFloat height = [self.delegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
        return height;
    }
    
    return -1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:estimatedHeightForHeaderInSection:)])
    {
        CGFloat height = [self.delegate tableView:tableView estimatedHeightForHeaderInSection:section];
        return height;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:estimatedHeightForFooterInSection:)])
    {
        CGFloat height = [self.delegate tableView:tableView estimatedHeightForFooterInSection:section];
        return height;
    }
    
    return 10;
}
*/
// Section header & footer information. Views are preferred over title should you decide to provide both

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // custom view for header. will be adjusted to default or specified header height
{
    if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
    {
        UIView *view = [self.delegate tableView:tableView viewForHeaderInSection:section];
        return view;
    }
    
    NSString *sectionClassName = [self __objectFromArray:tableView.jjSectionClassNameArray index:section];
    if ([NSClassFromString(sectionClassName) respondsToSelector:@selector(viewForHeader:section:viewController:)])
    {
        UIView *view = [NSClassFromString(sectionClassName) viewForHeader:tableView section:section viewController:self.viewController];
        return view;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    if ([self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
    {
        UIView *view = [self.delegate tableView:tableView viewForFooterInSection:section];
        return view;
    }
    
    NSString *sectionClassName = [self __objectFromArray:tableView.jjSectionClassNameArray index:section];
    if ([NSClassFromString(sectionClassName) respondsToSelector:@selector(viewForFooter:section:viewController:)])
    {
        UIView *view = [NSClassFromString(sectionClassName) viewForFooter:tableView section:section viewController:self.viewController];
        return view;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

// Accessories (disclosures).

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
    {
        [self.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        return;
    }
    
    [tableView.dataSourceObject accessoryButtonTappedForRowWithIndexPath:indexPath tableView:tableView];
}

// Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)])
    {
        BOOL shouldHighlight = [self.delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
        return shouldHighlight;
    }
    
    return [tableView.dataSourceObject shouldHighlightRowAtIndexPath:indexPath tableView:tableView];;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
        return;
    }
    
    [tableView.dataSourceObject didHighlightRowAtIndexPath:indexPath tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
        return;
    }
    
    [tableView.dataSourceObject didUnhighlightRowAtIndexPath:indexPath tableView:tableView];
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
    {
        NSIndexPath *indexPath1 = [self.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
        return indexPath1;
    }
    
    return [tableView.dataSourceObject willSelectRowAtIndexPath:indexPath tableView:tableView];
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
    {
        NSIndexPath *indexPath1 = [self.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
        return indexPath1;
    }
    
    return [tableView.dataSourceObject willDeselectRowAtIndexPath:indexPath tableView:tableView];
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
    
    [tableView.dataSourceObject didSelectRowAtIndexPath:indexPath tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
        return;
    }
    
    [tableView.dataSourceObject didDeselectRowAtIndexPath:indexPath tableView:tableView];
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
    {
        UITableViewCellEditingStyle cellEditingStyle = [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
        return cellEditingStyle;
    }
    
    return [tableView.dataSourceObject editingStyleForRowAtIndexPath:indexPath tableView:tableView];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED
{
    if ([self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)])
    {
        NSString *deleteString = [self.delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
        return deleteString;
    }
    
    return [tableView.dataSourceObject titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath tableView:tableView];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED // supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
{
    if ([self.delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)])
    {
        NSArray<UITableViewRowAction *> *actionArray = [self.delegate tableView:tableView editActionsForRowAtIndexPath:indexPath];
        return actionArray;
    }
    
    return [tableView.dataSourceObject editActionsForRowAtIndexPath:indexPath tableView:tableView];
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    
    return [tableView.dataSourceObject shouldIndentWhileEditingRowAtIndexPath:indexPath tableView:tableView];
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath __TVOS_PROHIBITED
{
    if ([self.delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
        return;
    }
    
    [tableView.dataSourceObject willBeginEditingRowAtIndexPath:indexPath tableView:tableView];
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath __TVOS_PROHIBITED
{
    if ([self.delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
        return;
    }
    
    [tableView.dataSourceObject didEndEditingRowAtIndexPath:indexPath tableView:tableView];
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
    {
        NSIndexPath *indexPath = [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
        return indexPath;
    }
    
    return proposedDestinationIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath // return 'depth' of row for hierarchies
{
    if ([self.delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
    {
        NSInteger indentationLevel = [self.delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
        return indentationLevel;
    }
    
    return [tableView.dataSourceObject indentationLevelForRowAtIndexPath:indexPath tableView:tableView];
}

// Copy/Paste.  All three methods must be implemented by the delegate.
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)])
    {
        BOOL shouldShowMenu = [self.delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
        return shouldShowMenu;
    }
    
    return [tableView.dataSourceObject shouldShowMenuForRowAtIndexPath:indexPath tableView:tableView];
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)])
    {
        BOOL canPerform = [self.delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
        return canPerform;
    }
    
    return [tableView.dataSourceObject canPerformAction:action tableView:tableView forRowAtIndexPath:indexPath withSender:sender];
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)])
    {
        [self.delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
        return;
    }
    
    [tableView.dataSourceObject performAction:action tableView:tableView forRowAtIndexPath:indexPath withSender:sender];
}

// Focus

- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:canFocusRowAtIndexPath:)])
    {
        BOOL canFocus = [self.delegate tableView:tableView canFocusRowAtIndexPath:indexPath];
        return canFocus;
    }
    
    return [tableView.dataSourceObject canFocusRowAtIndexPath:indexPath tableView:tableView];
}

- (BOOL)tableView:(UITableView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:shouldUpdateFocusInContext:)])
    {
        BOOL shouldUpdateFocus = [self.delegate tableView:tableView shouldUpdateFocusInContext:context];
        return shouldUpdateFocus;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0)
{
    if ([self.delegate respondsToSelector:@selector(tableView:didUpdateFocusInContext:withAnimationCoordinator:)])
    {
        [self.delegate tableView:tableView didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
        return;
    }
}

- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInTableView:(UITableView *)tableView NS_AVAILABLE_IOS(9_0)
{
    if ([self.delegate respondsToSelector:@selector(indexPathForPreferredFocusedViewInTableView:)])
    {
        NSIndexPath *indexPath = [self.delegate indexPathForPreferredFocusedViewInTableView:tableView];
        return indexPath;
    }
    
    return nil;
}

#pragma mark - private

- (id)__objectFromArray:(NSArray *)array index:(NSUInteger)index
{
    if ([array count] <= index)
    {
        return nil;
    }
    
    return array[index];
}

@end
