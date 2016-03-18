//
//  BIUserDefaultsSpecifier+Private.h
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIUserDefaultsSpecifier.h"

@class BIUserDefaultsTableViewController;

@interface NSDictionary (Specifier)
- (BOOL)isReloadDependence;
- (BOOL)isVisibilityDependence;
- (NSString *)dependenceKey;
- (NSString *)dependenceType;
- (NSObject *)dependenceTrueValue;
- (NSObject *)dependenceDefaultValue;
@end

@interface BIUserDefaultsSpecifier (Private)

@property (nonatomic, readonly) Class defatulCellClass;

@property (nonatomic, readonly) UITableViewCellStyle defatulCellStyle;

+ (Class)specifierClassForType:(NSString *)type;

- (NSDictionary *)validKeys;

- (NSArray *)dependences;

- (NSArray *)reloadDependences;

- (NSDictionary *)visibilityDependence;

- (BOOL)isVisible;

- (BOOL)isGroupSpecifier;

- (BOOL)isRadioGroupSpecifier;

- (BOOL)isValidKey:(NSString *)key;

- (BOOL)isGeneralKey:(NSString *)key;

- (void)validate;

- (void)pushViewController:(UIViewController *)viewController
  navigationViewController:(UINavigationController *)navigationViewController
                  animated:(BOOL)animated;

@end

@interface BIUserDefaultsGroupSpecifier : BIUserDefaultsSpecifier

@end

@interface BIUserDefaultsRadioGroupSpecifier : BIUserDefaultsSpecifier

@end

@interface BIUserDefaultsSliderSpecifier : BIUserDefaultsSpecifier

@end

@interface BIUserDefaultsChildPaneSpecifier : BIUserDefaultsSpecifier

@end

@interface BIUserDefaultsTextFieldSpecifier : BIUserDefaultsSpecifier

@end

@interface BIUserDefaultsTitleValueSpecifier : BIUserDefaultsSpecifier

@end

@interface BIUserDefaultsMultiValueSpecifier : BIUserDefaultsSpecifier

@end

@interface BIUserDefaultsToggleSwitchSpecifier : BIUserDefaultsSpecifier

@end

@interface BIUserDefaultsButtonSpecifier : BIUserDefaultsSpecifier

@end

