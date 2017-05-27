//
//  BIUserDefaultsValuesViewController.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/29/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsValuesViewController.h"
#import "BIUserDefaultsBackingStore.h"
#import "BIUserDefaultsSpecifier.h"

static NSString *const kCheckmarkCellReusableIdentifier = @"CheckmarkCellReusableIdentifier";

@interface BIUserDefaultsValuesViewController ()
@property (nonatomic, strong) NSIndexPath *selectedItem;
@property (nonatomic, strong) BIUserDefaultsSpecifier *specifier;
@end

@implementation BIUserDefaultsValuesViewController

- (instancetype)initWithSpecifier:(BIUserDefaultsSpecifier *)specifier {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.specifier = specifier;
        self.title = specifier.title;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadData];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateSelectedItem {
    NSString *value = [[BIUserDefaultsBackingStore sharedInstance] objectForKey:self.specifier.key];
    if (value == nil) {
        value = [self.specifier defaultValue];
    }
    
    NSInteger row = [[self.specifier values] indexOfObject:value];
    self.selectedItem = [NSIndexPath indexPathForRow:row inSection:0];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.specifier values] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCheckmarkCellReusableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCheckmarkCellReusableIdentifier];
    }

    if ([indexPath isEqual:self.selectedItem]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    NSArray *titles = [self.specifier shortTitles];
    if ([titles count] <= 0) {
        titles = [self.specifier titles];
    }
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![indexPath isEqual:self.selectedItem]) {
        id value = [[self.specifier values] objectAtIndex:indexPath.row];
        
        [tableView cellForRowAtIndexPath:self.selectedItem].accessoryType = UITableViewCellAccessoryNone;
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
       
        self.selectedItem = indexPath;
        
        [[BIUserDefaultsBackingStore sharedInstance] setObject:value forKey:self.specifier.key];
        [[BIUserDefaultsBackingStore sharedInstance] synchronize];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Sync & Reload

- (void)reloadData {
    [self updateSelectedItem];
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:self.selectedItem
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:NO];
    
}

- (void)handleNotification:(NSNotification *)nofitication {
    if ([UIApplicationWillEnterForegroundNotification isEqualToString:nofitication.name]) {
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    }
}


@end
