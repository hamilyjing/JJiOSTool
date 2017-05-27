//
//  BIUserDefaultsSpecifier.h
//  SettingsKit
//
//  Created by HuGuanqin on 9/23/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIUserDefaultsDefines.h"

extern NSString *const BISpecifierActionKeyValue;

@class BIUserDefaultsSpecifierDataSource;
@class BIUserDefaultsTableViewController;

@interface BIUserDefaultsSpecifier : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary *properties;

@property (nonatomic, weak) BIUserDefaultsSpecifierDataSource *dataSource;

@property (nonatomic, weak) Class detailControllerClass;
@property (nonatomic, weak) Class cellClass;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) SEL getter;
@property (nonatomic, assign) SEL setter;
@property (nonatomic, weak) id  target;

+ (instancetype)specifierWithDictionary:(NSDictionary *)dict;
+ (instancetype)specifierWithSpecifier:(BIUserDefaultsSpecifier *)specifier;

- (void)resetToDefault;

- (void)setValues:(NSDictionary *)values titles:(NSDictionary *)titles;
- (void)setProperty:(id)property forKey:(NSString *)key;
- (void)removePropertyForKey:(NSString *)key;
- (id)propertyForKey:(NSString *)key;

- (NSString *)identifier;
- (NSString *)key;
- (NSString *)type;
- (NSString *)title;
- (NSString *)detailText;
- (NSString *)titleForValue:(id)value;
- (NSArray *)shortTitles;
- (NSArray *)titles;
- (NSArray *)values;
- (id)defaultValue;
- (UITableViewStyle)tableViewStyle;

- (NSIndexPath *)indexPath;
- (UITableViewCellStyle)cellStyle;

@end

@interface BIUserDefaultsSpecifier (GroupSpecifier)
- (NSString *)footerTitle;
@end


@interface BIUserDefaultsSpecifier (ChildPaneSpecifier)
- (NSString *)file;
- (NSString *)fileType;
@end


@interface BIUserDefaultsSpecifier (SwitchSpecifier)
- (id)trueValue;
- (id)falseValue;
@end


@interface BIUserDefaultsSpecifier (SliderSpecifier)
- (CGFloat)minimumValue;
- (CGFloat)maximumValue;
- (NSString *)minimumValueImage;
- (NSString *)maximumValueImage;
@end


@interface BIUserDefaultsSpecifier (TextFieldSpecifier)
- (BOOL)secureTextEntry;
- (UIKeyboardType)keyboardType;
- (UITextAutocapitalizationType)autocapitalizationType;
- (UITextAutocorrectionType)autoCorrectionType;
@end


@interface BIUserDefaultsSpecifier (ButtonSpecifier)
- (NSTextAlignment)textAlignment;
- (UIAlertControllerStyle)alertStyle;
- (NSString *)alertTitle;
- (NSString *)alertMessage;
- (NSString *)confirmActionTitle;
- (NSString *)cancelActionTitle;
- (SEL)confirmAction;
- (SEL)cancelAction;
@end

@interface BIUserDefaultsSpecifier (CustomAction)
- (id)runActionWithSelector:(SEL)selector;
- (void)runDefaultActionWithController:(BIUserDefaultsTableViewController *)controller arguments:(NSDictionary *)dict;
@end
