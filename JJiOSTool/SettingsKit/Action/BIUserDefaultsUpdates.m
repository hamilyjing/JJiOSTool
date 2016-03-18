//
//  BIUserDefaultsUpdates.m
//  SettingsKit
//
//  Created by HuGuanqin on 10/14/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsSpecifierDataSource.h"
#import "BIUserDefaultsSpecifier+Private.h"
#import "BIUserDefaultsUpdateOperation.h"
#import "BIUserDefaultsUpdates.h"

@interface BIUserDefaultsSpecifierDataSource ()
@property (nonatomic, strong) NSMutableArray *specifierGroups;
@end

@interface BIUserDefaultsSpecifierGroup (Compare)
- (BOOL)isSame:(BIUserDefaultsSpecifierGroup *)group;
@end

@implementation BIUserDefaultsSpecifierGroup (Compare)

- (BOOL)isSame:(BIUserDefaultsSpecifierGroup *)group {
    if ([self sectionSpecifier] == [group sectionSpecifier]) {
        return YES;
    }
    return NO;
}

@end

@interface BIUserDefaultsUpdates ()
@property (nonatomic, strong, readwrite) NSMutableArray *updateOperations;
@property (nonatomic, strong, readwrite) NSMutableArray *currentGroupArray;
@property (nonatomic, strong, readwrite) NSArray *originalGroups;
@end

@implementation BIUserDefaultsUpdates

- (instancetype)initWithOriginalGroups:(NSArray *)groups {
    self = [super init];
    if (self) {
        self.originalGroups = groups;
        self.updateOperations = [NSMutableArray arrayWithCapacity:4];
        self.currentGroupArray  = [NSMutableArray arrayWithCapacity:4];
        for (BIUserDefaultsSpecifierGroup *group in groups) {
            BIUserDefaultsSpecifierGroup *item = [[BIUserDefaultsSpecifierGroup alloc] initWithSpecifierGroup:group];
            [self.currentGroupArray addObject:item];
        }
    }
    return self;
}



- (NSArray *)updates {
    return _updateOperations;
}

- (NSArray *)currentGroups {
    return _currentGroupArray;
}

- (void)removeSection:(BIUserDefaultsSpecifier *)specifier {
    [self.originalGroups enumerateObjectsUsingBlock:^(BIUserDefaultsSpecifierGroup *item, NSUInteger idx, BOOL *stop) {
        if (item.sectionSpecifier == specifier) {
            [self removeSectionAtIndex:idx];
            
            *stop = YES;
        }
    }];
}

- (void)removeSectionAtIndex:(NSUInteger)index {
    if (index < [self.originalGroups count]) {
        BIUserDefaultsSpecifierGroup *group = [self.originalGroups objectAtIndex:index];

        [self.currentGroupArray enumerateObjectsUsingBlock:^(BIUserDefaultsSpecifierGroup *item, NSUInteger idx, BOOL *stop) {
            if ([item isSame:group]) {
                BIUserDefaultsUpdateOperation *operation = [BIUserDefaultsUpdateOperation removeOperationWithSpecifier:group.sectionSpecifier
                                                                                                           atIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
                [self.updateOperations addObject:operation];
                [self.currentGroupArray removeObjectAtIndex:idx];
                
                *stop = YES;
            }
        }];
    }
}

- (void)insertSection:(BIUserDefaultsSpecifierGroup *)group atIndex:(NSUInteger)index {
    if (index <= [self.currentGroups count]) {
        BIUserDefaultsUpdateOperation *operation = [BIUserDefaultsUpdateOperation insertOperationWithSpecifier:group.sectionSpecifier
                                                                                                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
        [self.updateOperations addObject:operation];
        [self.currentGroupArray insertObject:group atIndex:index];
    }
}

- (void)reloadSectionAtIndex:(NSUInteger)index {
    if (index < [self.originalGroups count]) {
        BIUserDefaultsSpecifierGroup *group = [self.originalGroups objectAtIndex:index];
        BIUserDefaultsUpdateOperation *operation = [BIUserDefaultsUpdateOperation reloadOperationWithSpecifier:group.sectionSpecifier
                                                                                                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
        [self.updateOperations addObject:operation];
    }
}

- (void)removeSpecifierAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) {
        return;
    }
    
    if (indexPath.section < [self.originalGroups count]) {
        BIUserDefaultsSpecifierGroup *group = [self.originalGroups objectAtIndex:indexPath.section];
        if (indexPath.row < [group.rowSpecifiers count]) {
            [self.currentGroupArray enumerateObjectsUsingBlock:^(BIUserDefaultsSpecifierGroup *item, NSUInteger idx, BOOL *stop) {
                if ([item isSame:group]) {
                    BIUserDefaultsSpecifier *specifier = [group.rowSpecifiers objectAtIndex:indexPath.row];
                    BIUserDefaultsUpdateOperation *operation = [BIUserDefaultsUpdateOperation removeOperationWithSpecifier:specifier
                                                                                                               atIndexPath:indexPath];
                    [item removeRowSpecifier:specifier];
                    [self.updateOperations addObject:operation];
                    
                    *stop = YES;
                }
            }];
        }
    }
}

- (void)insertSpecifier:(BIUserDefaultsSpecifier *)specifier atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) {
        return;
    }
    
    if (indexPath.section < [self.currentGroupArray count]) {
        BIUserDefaultsSpecifierGroup *group = [self.currentGroupArray objectAtIndex:indexPath.section];
        if (indexPath.row <= [group.rowSpecifiers count]) {
            BIUserDefaultsUpdateOperation *operation = [BIUserDefaultsUpdateOperation insertOperationWithSpecifier:specifier
                                                                                                       atIndexPath:indexPath];
            [self.updateOperations addObject:operation];
            [group insertRowSpecifier:specifier atIndex:indexPath.row];
        }
    }
}

- (void)reloadSpecifier:(BIUserDefaultsSpecifier *)specifier atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) {
        return;
    }
    
    if (indexPath.section < [self.originalGroups count]) {
        BIUserDefaultsSpecifierGroup *group = [self.originalGroups objectAtIndex:indexPath.section];
        if (indexPath.row < [group.rowSpecifiers count]) {
            BIUserDefaultsUpdateOperation *operation = [BIUserDefaultsUpdateOperation reloadOperationWithSpecifier:specifier
                                                                                                       atIndexPath:indexPath];
            [self.updateOperations addObject:operation];
        }
    }
}

- (void)applyToDataSource:(BIUserDefaultsSpecifierDataSource *)dataSource {
    [dataSource.specifierGroups removeAllObjects];
    [dataSource.specifierGroups addObjectsFromArray:self.currentGroups];
}

- (void)applyToTableView:(UITableView *)tableView {
    NSMutableIndexSet *removeSections = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *reloadSections = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *insertSections = [NSMutableIndexSet indexSet];
    NSMutableArray *removeIndexPaths = [NSMutableArray arrayWithCapacity:4];
    NSMutableArray *reloadIndexPaths = [NSMutableArray arrayWithCapacity:4];
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:4];
    
    [self.updates enumerateObjectsUsingBlock:^(BIUserDefaultsUpdateOperation *operation, NSUInteger idx, BOOL *stop) {
        switch (operation.type) {
            case BIUserDefaultsUpdateOperationTypeReload:
                if (operation.specifier.isGroupSpecifier) {
                    [reloadSections addIndex:operation.indexPath.section];
                } else {
                    [reloadIndexPaths addObject:operation.indexPath];
                }
                break;
                
            case BIUserDefaultsUpdateOperationTypeRemove:
                if (operation.specifier.isGroupSpecifier) {
                    [removeSections addIndex:operation.indexPath.section];
                } else {
                    [removeIndexPaths addObject:operation.indexPath];
                }
                break;
                
            case BIUserDefaultsUpdateOperationTypeInsert:
                if (operation.specifier.isGroupSpecifier) {
                    [insertSections addIndex:operation.indexPath.section];
                } else {
                    [insertIndexPaths addObject:operation.indexPath];
                }
                break;
                
            default:
                break;
        }
    }];
    
    [tableView beginUpdates];
    
    [tableView deleteSections:removeSections withRowAnimation:UITableViewRowAnimationFade];
    [tableView deleteRowsAtIndexPaths:removeIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadSections:reloadSections withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView insertSections:insertSections withRowAnimation:UITableViewRowAnimationFade];
    [tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    [tableView endUpdates];
}

@end
