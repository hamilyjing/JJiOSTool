//
//  UITableView+DataSource.h
//  clientUI
//
//  Created by Gong Jian on 14-5-29.
//
//

#import <UIKit/UIKit.h>

@class JJTableViewDataSource;

@interface UITableView (JJDataSource)

@property (nonatomic, strong) JJTableViewDataSource *dataSourceObject;

- (void)bindDataSourceObject;

- (void)setItems:(NSArray *)items needReloadData:(BOOL)needReloadData;
- (NSArray *)items;
- (NSUInteger)itemCount;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)setIndexs:(NSArray *)indexs needReloadData:(BOOL)needReloadData;
- (NSArray *)indexs;
- (NSUInteger)indexCount;
- (id)indexItemAtIndex:(NSUInteger)index;

@end
