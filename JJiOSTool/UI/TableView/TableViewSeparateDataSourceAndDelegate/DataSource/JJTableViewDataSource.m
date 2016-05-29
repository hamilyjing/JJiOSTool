//
//  JJTableViewDataSource.m
//  clientUI
//
//  Created by Gong Jian on 14-5-16.
//
//

#import "JJTableViewDataSource.h"

#import "NSObject+JJTableViewCellMapKey.h"
#import "UIView+JJ.h"
#import "UITableView+JJTableViewSection.h"

@interface JJTableViewDataSource ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation JJTableViewDataSource

- (id)init
{
    NSAssert(NO, @"init discarded");
    return nil;
}

- (id)initWithItems:(NSArray *)anItems
          tableView:(UITableView *)tableView
     viewController:(UIViewController *)viewController
{
    self = [super init];
    if (self)
    {
        self.items = anItems;
        self.tableView = tableView;
        self.viewController = viewController;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [(NSArray *)[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (id)indexItemAtIndex:(NSUInteger)index
{
    return self.indexs[index];
}

- (CGFloat)cellHeight:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    NSString *cellName = [self __cellName:item];
    if (!cellName || ![NSClassFromString(cellName) conformsToProtocol:NSProtocolFromString(@"JJTableViewCellProtocol")])
    {
        return 0;
    }
    
    CGFloat height = [NSClassFromString(cellName) jj_height:item viewController:self.viewController];
    return height;
}

- (void)willDisplayCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (![cell respondsToSelector:@selector(jj_willDisplayCell:viewController:)])
    {
        return;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    
    [(id<JJTableViewCellProtocol>)cell jj_willDisplayCell:item viewController:self.viewController];
}

- (void)didEndDisplayingCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (![cell respondsToSelector:@selector(jj_didEndDisplayingCell:viewController:)])
    {
        return;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    
    [(id<JJTableViewCellProtocol>)cell jj_didEndDisplayingCell:item viewController:self.viewController];
}

- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_editingStyleForRow:viewController:)])
    {
        return UITableViewCellEditingStyleNone;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    
    UITableViewCellEditingStyle style = [(id<JJTableViewCellProtocol>)cell jj_editingStyleForRow:item viewController:self.viewController];
    return style;
}

- (NSString *)titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_titleForDeleteConfirmationButtonForRow:viewController:)])
    {
        return @"删除";
    }
    
    id item = [self itemAtIndexPath:indexPath];
    
    NSString *title = [(id<JJTableViewCellProtocol>)cell jj_titleForDeleteConfirmationButtonForRow:item viewController:self.viewController];
    return title;
}

- (NSIndexPath *)willDeselectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_willDeselectRow:viewController:)])
    {
        return indexPath;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    return [(id<JJTableViewCellProtocol>)cell jj_willDeselectRow:item viewController:self.viewController];
}

- (void)didDeselectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_didDeselectRow:viewController:)])
    {
        return;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    [(id<JJTableViewCellProtocol>)cell jj_didDeselectRow:item viewController:self.viewController];
}

- (NSIndexPath *)willSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_willSelectRow:viewController:)])
    {
        return indexPath;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    return [(id<JJTableViewCellProtocol>)cell jj_willSelectRow:item viewController:self.viewController];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_didSelectRow:viewController:)])
    {
        return;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    [(id<JJTableViewCellProtocol>)cell jj_didSelectRow:item viewController:self.viewController];
}

- (NSArray<UITableViewRowAction *> *)editActionsForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_editActionsForRow:viewController:)])
    {
        return nil;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    return [(id<JJTableViewCellProtocol>)cell jj_editActionsForRow:item viewController:self.viewController];
}

- (void)willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_willBeginEditingRow:viewController:)])
    {
        return;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    [(id<JJTableViewCellProtocol>)cell jj_willBeginEditingRow:item viewController:self.viewController];
}

- (void)didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_didEndEditingRow:viewController:)])
    {
        return;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    [(id<JJTableViewCellProtocol>)cell jj_didEndEditingRow:item viewController:self.viewController];
}

- (BOOL)shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_shouldShowMenuForRow:viewController:)])
    {
        return NO;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    BOOL isShow = [(id<JJTableViewCellProtocol>)cell jj_shouldShowMenuForRow:item viewController:self.viewController];
    return isShow;
}

- (BOOL)canPerformAction:(SEL)action tableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_canPerformAction:action:sender:viewController:)])
    {
        return NO;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    BOOL canPerform = [(id<JJTableViewCellProtocol>)cell jj_canPerformAction:item action:action sender:sender viewController:self.viewController];
    return canPerform;
}

- (void)performAction:(SEL)action tableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_performAction:action:sender:viewController:)])
    {
        return;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    [(id<JJTableViewCellProtocol>)cell jj_performAction:item action:action sender:sender viewController:self.viewController];
}

- (BOOL)shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_shouldHighlightRow:viewController:)])
    {
        return YES;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    BOOL shouldHighlight = [(id<JJTableViewCellProtocol>)cell jj_shouldHighlightRow:item viewController:self.viewController];
    return shouldHighlight;
}

- (void)didHighlightRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_didHighlightRow:viewController:)])
    {
        return;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    [(id<JJTableViewCellProtocol>)cell jj_didHighlightRow:item viewController:self.viewController];
}

- (void)didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_didUnhighlightRow:viewController:)])
    {
        return;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    [(id<JJTableViewCellProtocol>)cell jj_didUnhighlightRow:item viewController:self.viewController];
}

- (BOOL)shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_shouldIndentWhileEditingRow:viewController:)])
    {
        return NO;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    BOOL shouldIndent = [(id<JJTableViewCellProtocol>)cell jj_shouldIndentWhileEditingRow:item viewController:self.viewController];
    return shouldIndent;
}

- (NSInteger)indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_indentationLevelForRow:viewController:)])
    {
        return 0;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    NSInteger indentationLevel = [(id<JJTableViewCellProtocol>)cell jj_indentationLevelForRow:item viewController:self.viewController];
    return indentationLevel;
}

- (BOOL)canFocusRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_canFocusRow:viewController:)])
    {
        return NO;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    BOOL canFocus = [(id<JJTableViewCellProtocol>)cell jj_canFocusRow:item viewController:self.viewController];
    return canFocus;
}

- (void)accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_accessoryButtonTappedForRow:viewController:)])
    {
        return;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    [(id<JJTableViewCellProtocol>)cell jj_accessoryButtonTappedForRow:item viewController:self.viewController];
}

#pragma mark - Delegate
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger number = [self.items count];
    if (number <= 0)
    {
        number = 1;
    }
    
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[self.items objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    
    NSString *cellName = [self __cellName:item];
    if (!cellName || ![NSClassFromString(cellName) conformsToProtocol:NSProtocolFromString(@"JJTableViewCellProtocol")])
    {
        BOOL useDefaultAction = YES;
        UITableViewCell *cell;
        if (self.configureCellBlock)
        {
            cell = self.configureCellBlock(nil, item, indexPath, &useDefaultAction);
        }
        return cell;
    }
    
    NSString *cellIdentifier = [NSClassFromString(cellName) jj_cellIdentifier:item viewController:self.viewController];
    UITableViewCell *reusedCell;
    if (cellIdentifier)
    {
        reusedCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    BOOL useDefaultAction = YES;
    UITableViewCell *cell;
    if (self.configureCellBlock)
    {
        cell = self.configureCellBlock(reusedCell, item, indexPath, &useDefaultAction);
    }
    if (!useDefaultAction)
    {
        return cell;
    }
    
    cell = [NSClassFromString(cellName) jj_cell:item resuedCell:reusedCell viewController:self.viewController];
    
    [(id<JJTableViewCellProtocol>)cell jj_setModel:item viewController:self.viewController];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.titleForHeaderInSection)
    {
        return self.titleForHeaderInSection(section);
    }
    
    NSString *sectionClassName = tableView.jjSectionObjectArray[section];
    if ([NSClassFromString(sectionClassName) respondsToSelector:@selector(titleForHeaderInSection:section:viewController:)])
    {
        NSString *headerTitle = [NSClassFromString(sectionClassName) titleForHeaderInSection:tableView section:section viewController:self.viewController];
        return headerTitle;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.titleForFooterInSection)
    {
        return self.titleForFooterInSection(section);
    }
    
    NSString *sectionClassName = tableView.jjSectionObjectArray[section];
    if ([NSClassFromString(sectionClassName) respondsToSelector:@selector(titleForFooterInSection:section:viewController:)])
    {
        NSString *footerTitle = [NSClassFromString(sectionClassName) titleForFooterInSection:tableView section:section viewController:self.viewController];
        return footerTitle;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.canEditRowAtIndexPath)
    {
        return self.canEditRowAtIndexPath(indexPath);
    }
    
    id item = [self itemAtIndexPath:indexPath];
    NSString *cellName = [self __cellName:item];
    if (!cellName || ![NSClassFromString(cellName) respondsToSelector:@selector(jj_canEditRowAtIndexPath:viewController:)])
    {
        return NO;
    }
    
    BOOL canEdit = [NSClassFromString(cellName) jj_canEditRowAtIndexPath:item viewController:self.viewController];
    return canEdit;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.canMoveRowAtIndexPath)
    {
        return self.canMoveRowAtIndexPath(indexPath);
    }
    
    id item = [self itemAtIndexPath:indexPath];
    NSString *cellName = [self __cellName:item];
    if (!cellName || ![NSClassFromString(cellName) respondsToSelector:@selector(jj_canMoveRowAtIndexPath:viewController:)])
    {
        return NO;
    }
    
    BOOL canMove = [NSClassFromString(cellName) jj_canMoveRowAtIndexPath:item viewController:self.viewController];
    return canMove;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.edit)
    {
        self.edit(editingStyle, indexPath);
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell respondsToSelector:@selector(jj_commitEditingStyle:object:viewController:indexPath:)])
    {
        return;
    }
    
    id item = [self itemAtIndexPath:indexPath];
    
    [(id<JJTableViewCellProtocol>)cell jj_commitEditingStyle:editingStyle object:item viewController:self.viewController indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (self.move)
    {
        self.move(sourceIndexPath, destinationIndexPath);
        return;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexs;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSString *indexTitle = [self.indexs objectAtIndex:index];
    if (UITableViewIndexSearch == indexTitle)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    
    return index;
}

#pragma mark - private

- (NSString *)__cellMapKey:(id)object
{
    NSString *key = [object jjCellMapKey];
    if (!key)
    {
        key = NSStringFromClass(object);
    }
    
    return key;
}

- (NSString *)__cellName:(id)object
{
    NSString *key = [self __cellMapKey:object];
    if (!key)
    {
        return nil;
    }
    
    NSString *cellName = self.cellMap[key];
    return cellName;
}

- (UIViewController *)__viewController
{
    for (UIView *next = [self.tableView superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - getter and setter

- (UIViewController *)viewController
{
    if (_viewController)
    {
        return _viewController;
    }
    
    _viewController = [self __viewController];
    return _viewController;
}

@end
