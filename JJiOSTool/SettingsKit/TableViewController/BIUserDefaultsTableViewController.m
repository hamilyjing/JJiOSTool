//
//  BIUserDefaultsTableViewController.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsTableViewController.h"
#import "BIUserDefaultsSpecifierDataSource.h"
#import "BIUserDefaultsUpdateOperation.h"
#import "BIUserDefaultsBackingStore.h"
#import "BIUserDefaultsTextFieldCell.h"
#import "BIUserDefaultsSwitchCell.h"
#import "BIUserDefaultsSliderCell.h"
#import "BIUserDefaultsSpecifier.h"
#import "BIUserDefaultsUpdates.h"

@interface BIUserDefaultsSpecifierDataSource ()
- (NSSet *)allKeys;
@end

@interface BIUserDefaultsTableViewController ()
@property (nonatomic, assign) BOOL   specifierChanged;
@property (nonatomic, strong) NSSet *specifierKeys;
@property (nonatomic, strong) NSMutableDictionary *specifierValues;
@property (nonatomic, strong) BIUserDefaultsSpecifierDataSource *dataSource;
@property (nonatomic, strong) id activeTextField;
@end

@interface UIView (TableViewCell)
- (UITableViewCell *)superCell;
@end

@implementation BIUserDefaultsTableViewController

- (instancetype)initWithDataSource:(BIUserDefaultsSpecifierDataSource *)dataSource {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        assert(dataSource != nil);
        
        self.dataSource = dataSource;
        self.dataSource.target = self;
        self.specifierKeys = [dataSource allKeys];
        self.specifierValues = [NSMutableDictionary dictionaryWithCapacity:8];
        
        self.title = dataSource.title;
        
        self.tableView.estimatedRowHeight = 89;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    _dataSource.target = nil;
    
    
    [_activeTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadDataIfNeeded];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.specifierValues removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(synchronize)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:BIUserDefaultsDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSUserDefaultsDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.activeTextField resignFirstResponder];
    self.activeTextField = nil;
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    if ([self.specifierValues count] == 0 && [self.specifierKeys count] > 0) {
        [self.specifierKeys enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
            id value = [[BIUserDefaultsBackingStore sharedInstance] objectForKey:key];
            if (value == nil) {
                value = [NSNull null];
            }
            [self.specifierValues setValue:value forKey:key];
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:BIUserDefaultsDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public

- (void)setSpecifierDataSource:(BIUserDefaultsSpecifierDataSource *)dataSource_
{
    self.dataSource = dataSource_;
    
    self.dataSource.target = self;
    self.specifierKeys = [self.dataSource allKeys];
    self.specifierValues = [NSMutableDictionary dictionaryWithCapacity:8];
    
    self.title = self.dataSource.title;
    
    self.tableView.estimatedRowHeight = 89;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView*)tableView willBeginConfiguringTableCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath specifier:(BIUserDefaultsSpecifier *)specifier
{
    return cell;
}

- (UITableViewCell *)tableView:(UITableView*)tableView didEndConfiguringTableCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath specifier:(BIUserDefaultsSpecifier *)specifier
{
    return cell;
}

- (BOOL)tableView:(UITableView*)tableView willBeginSelectingRowAtIndexPath:(NSIndexPath *)indexPath specifier:(BIUserDefaultsSpecifier *)specifier
{
    return YES;
}

- (void)tableView:(UITableView*)tableView didEndSelectingRowAtIndexPath:(NSIndexPath *)indexPath specifier:(BIUserDefaultsSpecifier *)specifier
{
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataSource numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BIUserDefaultsSpecifier *specifier = [_dataSource specifierForSection:section];
    return [specifier propertyForKey:BISpecifierTitle];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    BIUserDefaultsSpecifier *specifier = [_dataSource specifierForSection:section];
    return [specifier propertyForKey:BISpecifierFooterText];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BIUserDefaultsSpecifier *specifier = [_dataSource specifierForRowAtIndexPath:indexPath];
    
    NSString *cellClassStr = NSStringFromClass(specifier.cellClass);
    NSString *identifier = [NSString stringWithFormat:@"%@-%ld", cellClassStr, (long)specifier.cellStyle];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[specifier.cellClass alloc] initWithStyle:specifier.cellStyle reuseIdentifier:identifier];
        
        [self addActionToControlInCell:cell];
    }
    
    cell = [self tableView:tableView willBeginConfiguringTableCell:cell indexPath:indexPath specifier:specifier];
    
    if ([cell respondsToSelector:@selector(refreshCellContentsWithSpecifier:)]) {
        [cell performSelector:@selector(refreshCellContentsWithSpecifier:) withObject:specifier];
    }
    
    cell = [self tableView:tableView didEndConfiguringTableCell:cell indexPath:indexPath specifier:specifier];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIUserDefaultsSpecifier *specifier = [_dataSource specifierForRowAtIndexPath:indexPath];
    
    if (![self tableView:tableView willBeginSelectingRowAtIndexPath:indexPath specifier:specifier])
    {
        return;
    }
    
    if (specifier.action)
    {
        [specifier runActionWithSelector:specifier.action];
    }
    else
    {
        [specifier runDefaultActionWithController:self arguments:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self tableView:tableView didEndSelectingRowAtIndexPath:indexPath specifier:specifier];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    self.activeTextField = nil;
    return YES;
}

#pragma mark - Private

- (void)updateWithSpecifier:(BIUserDefaultsSpecifier *)specifier {
    BIUserDefaultsUpdates *updates = [self.dataSource updatesWithChangedKeys:[NSArray arrayWithObject:specifier.key]];
    
    BOOL ignore = NO;
    if ([updates.updates count] == 1) {
        BIUserDefaultsUpdateOperation *operation = [updates.updates objectAtIndex:0];
        if (operation.specifier == specifier) {
            ignore = YES;
        }
    }
    
    if (!ignore) {
        [updates applyToDataSource:self.dataSource];
        
        [self.tableView reloadData];
        
        //[updates applyToTableView:self.tableView];
    }
}

- (void)toggleSwitch:(UISwitch *)toggleSwitch event:(UIEvent *)event {
    NSIndexPath  *indexPath = [self.tableView indexPathForCell:[toggleSwitch superCell]];
    NSDictionary *arguments = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:toggleSwitch.on]
                                                          forKey:BISpecifierActionKeyValue];
    BIUserDefaultsSpecifier *specifier = [_dataSource specifierForRowAtIndexPath:indexPath];
    [specifier runDefaultActionWithController:self arguments:arguments];
    
    [self updateWithSpecifier:specifier];
}

- (void)sliderValueChanged:(UISlider *)slider event:(UIEvent *)event {
    NSIndexPath  *indexPath = [self.tableView indexPathForCell:[slider superCell]];
    NSDictionary *arguments = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:slider.value]
                                                          forKey:BISpecifierActionKeyValue];
    BIUserDefaultsSpecifier *specifier = [_dataSource specifierForRowAtIndexPath:indexPath];
    [specifier runDefaultActionWithController:self arguments:arguments];
    
    [self updateWithSpecifier:specifier];
}

- (void)textValueChanged:(UITextField *)textField event:(UIEvent *)event {
    NSIndexPath  *indexPath = [self.tableView indexPathForCell:[textField superCell]];
    NSDictionary *arguments = [NSDictionary dictionaryWithObject:(textField.text ? textField.text : @"")
                                                          forKey:BISpecifierActionKeyValue];
    BIUserDefaultsSpecifier *specifier = [_dataSource specifierForRowAtIndexPath:indexPath];
    [specifier runDefaultActionWithController:self arguments:arguments];
    
    [self updateWithSpecifier:specifier];
}

- (void)addActionToControlInCell:(UITableViewCell *)cell
{
    if ([cell isKindOfClass:[BIUserDefaultsSwitchCell class]])
    {
        UISwitch *toggler = ((BIUserDefaultsSwitchCell *)cell).toggleSwitch;
        [toggler removeTarget:self action:@selector(toggleSwitch:event:) forControlEvents:UIControlEventValueChanged];
        [toggler addTarget:self action:@selector(toggleSwitch:event:) forControlEvents:UIControlEventValueChanged];
    }
    else if ([cell isKindOfClass:[BIUserDefaultsSliderCell class]])
    {
        UISlider *slider = ((BIUserDefaultsSliderCell *)cell).slider;
        [slider removeTarget:self action:@selector(sliderValueChanged:event:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(sliderValueChanged:event:) forControlEvents:UIControlEventValueChanged];
    }
    else if ([cell isKindOfClass:[BIUserDefaultsTextFieldCell class]])
    {
        UITextField *textField = ((BIUserDefaultsTextFieldCell *)cell).textField;
        textField.delegate = self;
        [textField removeTarget:self action:@selector(textValueChanged:event:) forControlEvents:UIControlEventValueChanged];
        [textField addTarget:self action:@selector(textValueChanged:event:) forControlEvents:UIControlEventEditingChanged];
    }
}

#pragma mark - Sync & Reload

- (void)synchronize {
    [[BIUserDefaultsBackingStore sharedInstance] synchronize];
}

- (void)reloadData {
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

- (void)reloadDataIfNeeded {
    if (self.specifierChanged) {
        NSMutableSet *invalidKeys = [NSMutableSet setWithCapacity:32];
        [self.specifierValues enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            id currentValue = [[BIUserDefaultsBackingStore sharedInstance] objectForKey:key];
            if (currentValue == nil) {
                currentValue = [NSNull null];
            }
            if (![value isEqual:currentValue]) {
                [invalidKeys addObject:key];
            }
        }];
        
        [self.specifierValues removeAllObjects];
        
        if ([invalidKeys count] > 0) {
            BIUserDefaultsUpdates *updates = [self.dataSource updatesWithChangedKeys:invalidKeys.allObjects];
            [updates applyToDataSource:self.dataSource];
            [updates applyToTableView:self.tableView];
        }
    }
    
    self.specifierChanged = NO;
}

- (void)handleNotification:(NSNotification *)nofitication {
    if ([NSUserDefaultsDidChangeNotification isEqualToString:nofitication.name]
        || [BIUserDefaultsDidChangeNotification isEqualToString:nofitication.name]) {
        self.specifierChanged = YES;
    } else if ([UIApplicationDidEnterBackgroundNotification isEqualToString:nofitication.name]) {
        if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

@end


@implementation UIView (TableViewCell)

- (UITableViewCell *)superCell {
    UIView *superView = self.superview;
    while (superView) {
        if ([superView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)superView;
        }
        superView = superView.superview;
    }
    return nil;
}

@end
