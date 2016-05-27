//
//  UITableView+DataSource.m
//  clientUI
//
//  Created by Gong Jian on 14-5-29.
//
//

#import "UITableView+JJDataSource.h"

#import <objc/runtime.h>

#import "JJTableViewDataSource.h"

NSString *const UITableViewDataSourceObjectCreated = @"UITableViewDataSourceObjectCreated";

@implementation UITableView (DataSource)

- (JJTableViewDataSource *)dataSourceObject
{
    return (JJTableViewDataSource *)objc_getAssociatedObject(self, @selector(dataSourceObject));
}

- (void)setDataSourceObject:(JJTableViewDataSource *)dataSourceObject_
{
    if (self.dataSourceObject != dataSourceObject_)
    {
        objc_setAssociatedObject(self, @selector(dataSourceObject), dataSourceObject_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:UITableViewDataSourceObjectCreated object:self];
    }
}

- (void)bindDataSourceObject
{
    self.dataSource = self.dataSourceObject;
}

- (void)setItems:(NSArray *)items_ needReloadData:(BOOL)needReloadData_
{
    self.dataSourceObject.items = items_;
    if (needReloadData_)
    {
        [self reloadData];
    }
}

- (NSArray *)items
{
    return self.dataSourceObject.items;
}

- (NSUInteger)itemCount
{
    return [[self items] count];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSourceObject itemAtIndexPath:indexPath];
}

- (void)setIndexs:(NSArray *)indexs_ needReloadData:(BOOL)needReloadData_
{
    self.dataSourceObject.indexs = indexs_;
    if (needReloadData_)
    {
        [self reloadData];
    }
}

- (NSArray *)indexs
{
    return self.dataSourceObject.indexs;
}

- (NSUInteger)indexCount
{
    return [[self indexs] count];
}

- (id)indexItemAtIndex:(NSUInteger)index
{
    return [self.dataSourceObject indexItemAtIndex:index];
}

@end
