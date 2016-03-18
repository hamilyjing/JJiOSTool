//
//  BIUserDefaultsSpecifier+Private.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsTableViewController.h"
#import "BIUserDefaultsValuesViewController.h"
#import "BIUserDefaultsWebViewController.h"
#import "BIUserDefaultsSpecifierDataSource.h"
#import "BIUserDefaultsSpecifier+Private.h"
#import "BIUserDefaultsBackingStore.h"
#import "BIUserDefaultsRadioGroupCell.h"
#import "BIUserDefaultsTitleValueCell.h"
#import "BIUserDefaultsChildPaneCell.h"
#import "BIUserDefaultsTextFieldCell.h"
#import "BIUserDefaultsSliderCell.h"
#import "BIUserDefaultsSwitchCell.h"
#import "BIUserDefaultsButtonCell.h"
#import "UIViewController+SK.h"


#define REQUIRED [NSNumber numberWithBool:YES]
#define OPTIONAL [NSNumber numberWithBool:NO]

@implementation NSDictionary (Specifier)

- (BOOL)isReloadDependence {
    return [BISpecifierDependenceTypeReload isEqualToString:[self dependenceType]];
}

- (BOOL)isVisibilityDependence {
    return [BISpecifierDependenceTypeVisibility isEqualToString:[self dependenceType]];
}

- (NSString *)dependenceKey {
    return [self objectForKey:BISpecifierDependenceKey];
}

- (NSString *)dependenceType {
    return [self objectForKey:BISpecifierDependenceType];
}

- (NSObject *)dependenceTrueValue {
    return [self objectForKey:BISpecifierDependenceTrueValue];
}

- (NSObject *)dependenceDefaultValue {
    return [self objectForKey:BISpecifierDependenceDefaultValue];
}

@end

@interface BIUserDefaultsTableViewController ()
@property (nonatomic, strong) BIUserDefaultsSpecifierDataSource *dataSource;
@end

@interface BIUserDefaultsSpecifierDataSource ()
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSString *stringsTable;
@property (nonatomic, strong) NSArray *specifiers;
@property (nonatomic, strong) NSMutableArray *specifiersSections;
@property (nonatomic, strong) NSMutableArray *specifiersRows;
@end

@implementation BIUserDefaultsSpecifier (Private)

static NSMutableDictionary *registerClasses = nil;

+ (void)load {
    registerClasses = [[NSMutableDictionary alloc] initWithCapacity:8];
    
    [registerClasses setObject:[BIUserDefaultsGroupSpecifier class] forKey:BIGroupSpecifier];
    [registerClasses setObject:[BIUserDefaultsRadioGroupSpecifier class] forKey:BIRadioGroupSpecifier];
    [registerClasses setObject:[BIUserDefaultsSliderSpecifier class] forKey:BISliderSpecifier];
    [registerClasses setObject:[BIUserDefaultsChildPaneSpecifier class] forKey:BIChildPaneSpecifier];
    [registerClasses setObject:[BIUserDefaultsTextFieldSpecifier class] forKey:BITextFieldSpecifier];
    [registerClasses setObject:[BIUserDefaultsTitleValueSpecifier class] forKey:BITitleValueSpecifier];
    [registerClasses setObject:[BIUserDefaultsMultiValueSpecifier class] forKey:BIMultiValueSpecifier];
    [registerClasses setObject:[BIUserDefaultsToggleSwitchSpecifier class] forKey:BIToggleSwitchSpecifier];
    [registerClasses setObject:[BIUserDefaultsButtonSpecifier class] forKey:BIButtonSpecifier];
}

+ (Class)specifierClassForType:(NSString *)type {
    Class cls = [registerClasses objectForKey:type];
    if (cls == nil) {
        cls = [BIUserDefaultsSpecifier class];
    }
    return cls;
}

- (Class)defatulCellClass {
    return [BIUserDefaultsTableViewCell class];
}

- (UITableViewCellStyle)defatulCellStyle {
    return UITableViewCellStyleDefault;
}

- (NSDictionary *)validKeys {
    return nil;
}

- (NSDictionary *)visibilityDependence {
    NSArray *dependences = [self dependences];
    for (NSDictionary *dict in dependences) {
        if ([dict isVisibilityDependence]) {
            return dict;
        }
    }
    return nil;
}

- (NSArray *)reloadDependences {
    NSMutableArray *reloadDependences = [NSMutableArray arrayWithCapacity:4];
    NSArray *dependences = [self dependences];
    for (NSDictionary *dict in dependences) {
        if ([dict isReloadDependence]) {
            [reloadDependences addObject:dict];
        }
    }
    return reloadDependences;
}

- (NSArray *)dependences {
    return [self propertyForKey:BISpecifierDependences];
}

- (BOOL)isVisible {
    NSDictionary *dict = [self visibilityDependence];
    if (dict != nil) {
        NSString *key = [dict objectForKey:BISpecifierDependenceKey];
        NSObject *value = [[BIUserDefaultsBackingStore sharedInstance] objectForKey:key];
        if (value == nil) {
            value = [dict objectForKey:BISpecifierDependenceDefaultValue];
        }
        if (value == nil) {
            value = [NSNumber numberWithBool:NO];
        }
        
        NSObject *trueValue = [dict objectForKey:BISpecifierDependenceTrueValue];
        if (trueValue == nil) {
            trueValue = [NSNumber numberWithBool:YES];
        }
        if (![value isEqual:trueValue]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isGeneralKey:(NSString *)key {
    static NSSet *generalKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generalKeys = [[NSSet alloc] initWithObjects:BISpecifierID, BISpecifierCellClass, BISpecifierCellStyle, BISpecifierDependences, nil];
    });
    
    return [generalKeys containsObject:key];
}

- (BOOL)isGroupSpecifier {
    NSString *type = self.type;
    if ([BIGroupSpecifier isEqualToString:type] || [BIRadioGroupSpecifier isEqualToString:type]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isRadioGroupSpecifier {
    return NO;
}

- (BOOL)isValidKey:(NSString *)key {
    if ([self isGeneralKey:key]) {
        return YES;
    }
    
    //未指定有效Key集合的，默认有效
    NSDictionary *validKeys = [self validKeys];
    if (validKeys) {
        return [validKeys objectForKey:key] != nil;
    }
    return YES;
}

- (void)validate {
    __block BOOL valid = YES;
    
    NSDictionary *validKeys = [self validKeys];
    [validKeys enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *value, BOOL *stop) {
        if ([value boolValue]) {
            id property = [self propertyForKey:key];
            if (property == nil) {
                NSLog(@"%@ must contain key : %@", NSStringFromClass([self class]), key);
                
                valid = NO;
            }
        }
    }];
    
    assert(valid);
}

- (void)pushViewController:(UIViewController *)viewController_
  navigationViewController:(UINavigationController *)navigationViewController_
                  animated:(BOOL)animated_
{
    [viewController_ willBePushed];
    
    [navigationViewController_ pushViewController:viewController_ animated:animated_];
    
    [viewController_ didBePushed];
}

@end

@implementation BIUserDefaultsGroupSpecifier 

- (NSDictionary *)validKeys {
    static NSDictionary *validKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validKeys = [[NSDictionary alloc] initWithObjectsAndKeys:
                     REQUIRED, BISpecifierType,
                     OPTIONAL, BISpecifierTitle,
                     OPTIONAL, BISpecifierFooterText,
                     nil];
    });
    return validKeys;
}

@end

@implementation BIUserDefaultsRadioGroupSpecifier

- (Class)defatulCellClass {
    return [BIUserDefaultsRadioGroupCell class];
}

- (NSDictionary *)validKeys {
    static NSDictionary *validKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validKeys = [[NSDictionary alloc] initWithObjectsAndKeys:
                     REQUIRED, BISpecifierType,
                     REQUIRED, BISpecifierKey,
                     REQUIRED, BISpecifierDefaultValue,
                     REQUIRED, BISpecifierTitles,
                     REQUIRED, BISpecifierValues,
                     OPTIONAL, BISpecifierTitle,
                     OPTIONAL, BISpecifierFooterText,
                     OPTIONAL, BISpecifierGetter,
                     OPTIONAL, BISpecifierSetter,
                     OPTIONAL, BISpecifierHideIndexsAction,
                     nil];
    });
    return validKeys;
}

- (BOOL)isRadioGroupSpecifier {
    return YES;
}

- (void)runDefaultActionWithController:(BIUserDefaultsTableViewController *)controller arguments:(NSDictionary *)dict {
    NSIndexPath *indexPath = [self indexPath];
    if (indexPath != nil && indexPath.row < [[self values] count]) {
        id value = [[self values] objectAtIndex:indexPath.row];
        [[BIUserDefaultsBackingStore sharedInstance] setObject:value forKey:self.key];
        [[BIUserDefaultsBackingStore sharedInstance] synchronize];
        
        [controller.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                            withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end

@implementation BIUserDefaultsChildPaneSpecifier

- (Class)defatulCellClass {
    return [BIUserDefaultsChildPaneCell class];
}

- (UITableViewCellStyle)defatulCellStyle {
    return UITableViewCellStyleValue1;
}

- (NSDictionary *)validKeys {
    static NSDictionary *validKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validKeys = [[NSDictionary alloc] initWithObjectsAndKeys:
                     REQUIRED, BISpecifierType,
                     REQUIRED, BISpecifierTitle,
                     OPTIONAL, BISpecifierFile,
                     OPTIONAL, BISpecifierFileType,
                     OPTIONAL, BISpecifierGetter,
                     OPTIONAL, BISpecifierDetailText,
                     OPTIONAL, BISpecifierDetailControllerClass,
                     OPTIONAL, BISpecifierKeyStoryboardName,
                     OPTIONAL, BISpecifierKeyViewControllerIdentifier,
                     OPTIONAL, BISpecifierTableViewStyle,
                     nil];
    });
    return validKeys;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)runDefaultActionWithController:(BIUserDefaultsTableViewController *)controller arguments:(NSDictionary *)dict {
    NSString *fileType = [self fileType];
    NSString *fileName = [self file];
    // 如果未指定类型、名称，必须指定具体的ViewController
    if (([fileType length] <= 0 || [fileName length] <= 0) && self.detailControllerClass == nil) {
        NSLog(@"runDefaultActionWithController Child Pane Must Contain FileType and FileName (Or Custom ViewController)!");
        return;
    }
    
    Class childControllerClass = self.detailControllerClass;
    if ([fileType length] <= 0 || [fileName length] <= 0) {
        UIViewController *childController = nil;
        if ([childControllerClass instancesRespondToSelector:@selector(initWithSpecifier:)])
        {
            SEL selector = NSSelectorFromString(@"initWithSpecifier:");
            NSObject *object = [childControllerClass alloc];
            IMP imp = [object methodForSelector:selector];
            id (*func)(id, SEL, id) = (void *)imp;
            childController = func(object, selector, self);
        }
        else
        {
            //childController = [[childControllerClass alloc] init];
            
            if ([childControllerClass isSubclassOfClass:[UITableViewController class]])
            {
                childController = [[childControllerClass alloc] initWithStyle:[self tableViewStyle]];
            }
            else
            {
                childController = [[childControllerClass alloc] init];
            }
        }
        
        if ([childController isKindOfClass:[UIViewController class]])
        {
            [self pushViewController:childController navigationViewController:controller.navigationController animated:YES];
        }
        return;
    }
    
    // URI-网页，AppStore等
    if ([BISpecifierFileTypeURI isEqualToString:fileType]) {
        if ([self.file hasSuffix:@".html"]) {
            if (childControllerClass == nil) {
                childControllerClass = [BIUserDefaultsWebViewController class];
            }
            
            UIViewController *childController = nil;
            if ([childControllerClass instancesRespondToSelector:@selector(initWithSpecifier:)])
            {
                SEL selector = NSSelectorFromString(@"initWithSpecifier:");
                NSObject *object = [childControllerClass alloc];
                IMP imp = [object methodForSelector:selector];
                id (*func)(id, SEL, id) = (void *)imp;
                childController = func(object, selector, self);
            }
            else
            {
                //childController = [[childControllerClass alloc] init];
                
                ///* 应该加一个key：TableViewStyle
                if ([childControllerClass isSubclassOfClass:[UITableViewController class]])
                {
                    childController = [[childControllerClass alloc] initWithStyle:[self tableViewStyle]];
                }
                else
                {
                    childController = [[childControllerClass alloc] init];
                }
                 //*/
            }
            
            if ([childController isKindOfClass:[UIViewController class]])
            {
                [self pushViewController:childController navigationViewController:controller.navigationController animated:YES];
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.file]];
        }
        return;
    }
    
    BIUserDefaultsSpecifierDataSource *dataSource = nil;
    if ([BISpecifierFileTypePlist isEqualToString:fileType]) {              // 同一Bundle下的plist文件
        dataSource = [[BIUserDefaultsSpecifierDataSource alloc] initWithPlist:fileName
                                                                     inBundle:controller.dataSource.bundle
                                                                 stringsTable:controller.dataSource.stringsTable];
    } else if ([BISpecifierFileTypeBundle isEqualToString:fileType]) {      // Bundle
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:filePath];
        dataSource = [[BIUserDefaultsSpecifierDataSource alloc] initWithBundle:bundle];
    }
    
    BIUserDefaultsTableViewController *childController = nil;
    NSString *storyboardName = self.properties[BISpecifierKeyStoryboardName];
    NSString *viewControllerIdentifier = self.properties[BISpecifierKeyViewControllerIdentifier];
    if ([storyboardName length] > 0
        && [viewControllerIdentifier length] > 0)
    {
        UIStoryboard *inputSettingStoryBoard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        childController = [inputSettingStoryBoard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    }
    
    if (dataSource != nil)
    {
        if ([childController isKindOfClass:[BIUserDefaultsTableViewController class]])
        {
            [(BIUserDefaultsTableViewController *)childController setDataSource:dataSource];
        }
        else
        {
            if (childControllerClass == nil)
            {
                childControllerClass = [BIUserDefaultsTableViewController class];
            }
            
            childController = [[childControllerClass alloc] initWithDataSource:dataSource];
        }
    }
    
    [self pushViewController:childController navigationViewController:controller.navigationController animated:YES];
}

#pragma clang diagnostic pop

@end


@implementation BIUserDefaultsToggleSwitchSpecifier

- (Class)defatulCellClass {
    return [BIUserDefaultsSwitchCell class];
}

- (UITableViewCellStyle)defatulCellStyle {
    return UITableViewCellStyleValue1;
}

- (void)resetToDefault
{
    
}

- (NSDictionary *)validKeys {
    static NSDictionary *validKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validKeys = [[NSDictionary alloc] initWithObjectsAndKeys:
                     REQUIRED, BISpecifierType,
                     REQUIRED, BISpecifierTitle,
                     REQUIRED, BISpecifierKey,
                     REQUIRED, BISpecifierDefaultValue,
                     OPTIONAL, BISpecifierTrueValue,
                     OPTIONAL, BISpecifierFalseValue,
                     OPTIONAL, BISpecifierGetter,
                     OPTIONAL, BISpecifierSetter,
                     nil];
    });
    return validKeys;
}

- (void)runDefaultActionWithController:(BIUserDefaultsTableViewController *)controller arguments:(NSDictionary *)dict {
    BOOL state = [[dict objectForKey:BISpecifierActionKeyValue] boolValue];
    
    id value = state ? [self trueValue] : [self falseValue];
    if (value != nil) {
        [[BIUserDefaultsBackingStore sharedInstance] setObject:value forKey:[self key]];
    } else {
        [[BIUserDefaultsBackingStore sharedInstance] setBool:state forKey:[self key]];
    }
    [[BIUserDefaultsBackingStore sharedInstance] synchronize];
}

@end

@implementation BIUserDefaultsSliderSpecifier

- (Class)defatulCellClass {
    return [BIUserDefaultsSliderCell class];
}

- (UITableViewCellStyle)defatulCellStyle {
    return UITableViewCellStyleDefault;
}

- (NSDictionary *)validKeys {
    static NSDictionary *validKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validKeys = [[NSDictionary alloc] initWithObjectsAndKeys:
                     REQUIRED, BISpecifierType,
                     REQUIRED, BISpecifierKey,
                     REQUIRED, BISpecifierDefaultValue,
                     REQUIRED, BISpecifierMinimumValue,
                     REQUIRED, BISpecifierMaximumValue,
                     OPTIONAL, BISpecifierMinimumValueImage,
                     OPTIONAL, BISpecifierMaximumValueImage,
                     OPTIONAL, BISpecifierGetter,
                     OPTIONAL, BISpecifierSetter,
                     OPTIONAL, BISpecifierMinimumTextValue,
                     OPTIONAL, BISpecifierMaximumTextValue,
                     nil];
    });
    return validKeys;
}

- (void)runDefaultActionWithController:(BIUserDefaultsTableViewController *)controller arguments:(NSDictionary *)dict
{
    id value = [dict objectForKey:BISpecifierActionKeyValue];
    [[BIUserDefaultsBackingStore sharedInstance] setObject:value forKey:[self key]];
    [[BIUserDefaultsBackingStore sharedInstance] synchronize];
    
    if (self.setter)
    {
        [self runActionWithSelector:self.setter];
    }
}

@end


@implementation BIUserDefaultsTitleValueSpecifier

- (Class)defatulCellClass {
    return [BIUserDefaultsTitleValueCell class];
}

- (UITableViewCellStyle)defatulCellStyle {
    return UITableViewCellStyleValue1;
}

- (NSDictionary *)validKeys {
    static NSDictionary *validKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validKeys = [[NSDictionary alloc] initWithObjectsAndKeys:
                     REQUIRED, BISpecifierType,
                     REQUIRED, BISpecifierTitle,
                     REQUIRED, BISpecifierKey,
                     REQUIRED, BISpecifierDefaultValue,
                     OPTIONAL, BISpecifierTitles,
                     OPTIONAL, BISpecifierValues,
                     OPTIONAL, BISpecifierGetter,
                     OPTIONAL, BISpecifierAction,
                     nil];
    });
    return validKeys;
}

- (NSString *)titleForValue:(id)value {
    NSString *title = [super titleForValue:value];
    if (title == nil) {
        title = value;
    }
    return title;
}

@end

@implementation BIUserDefaultsTextFieldSpecifier

- (Class)defatulCellClass {
    return [BIUserDefaultsTextFieldCell class];
}

- (NSDictionary *)validKeys {
    static NSDictionary *validKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validKeys = [[NSDictionary alloc] initWithObjectsAndKeys:
                     REQUIRED, BISpecifierType,
                     REQUIRED, BISpecifierTitle,
                     REQUIRED, BISpecifierKey,
                     OPTIONAL, BISpecifierDefaultValue,
                     OPTIONAL, BISpecifierIsSecure,
                     OPTIONAL, BISpecifierKeyboardType,
                     OPTIONAL, BISpecifierAutoCapitalizationType,
                     OPTIONAL, BISpecifierAutoCorrectionType,
                     nil];
    });
    return validKeys;
}

- (void)runDefaultActionWithController:(BIUserDefaultsTableViewController *)controller arguments:(NSDictionary *)dict {
    id value = [dict objectForKey:BISpecifierActionKeyValue];
    [[BIUserDefaultsBackingStore sharedInstance] setObject:value forKey:[self key]];
    [[BIUserDefaultsBackingStore sharedInstance] synchronize];
}

@end


@implementation BIUserDefaultsMultiValueSpecifier

- (Class)defatulCellClass {
    return [BIUserDefaultsTitleValueCell class];
}

- (UITableViewCellStyle)defatulCellStyle {
    return UITableViewCellStyleValue1;
}

- (NSDictionary *)validKeys {
    static NSDictionary *validKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validKeys = [[NSDictionary alloc] initWithObjectsAndKeys:
                     REQUIRED, BISpecifierType,
                     REQUIRED, BISpecifierTitle,
                     REQUIRED, BISpecifierKey,
                     REQUIRED, BISpecifierDefaultValue,
                     REQUIRED, BISpecifierTitles,
                     REQUIRED, BISpecifierValues,
                     OPTIONAL, BISpecifierShortTitles,
                     OPTIONAL, BISpecifierDetailControllerClass,
                     OPTIONAL, BISpecifierTableViewStyle,
                     nil];
    });
    return validKeys;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)runDefaultActionWithController:(BIUserDefaultsTableViewController *)controller arguments:(NSDictionary *)dict {
    Class childControllerClass = self.detailControllerClass;
    if (childControllerClass == nil) {
        childControllerClass = [BIUserDefaultsValuesViewController class];
    }
    
    UIViewController *childController = nil;
    if ([childControllerClass instancesRespondToSelector:@selector(initWithSpecifier:)])
    {
        SEL selector = NSSelectorFromString(@"initWithSpecifier:");
        NSObject *object = [childControllerClass alloc];
        IMP imp = [object methodForSelector:selector];
        id (*func)(id, SEL, id) = (void *)imp;
        childController = func(object, selector, self);
    }
    else
    {
        //childController = [[childControllerClass alloc] init];
        
        if ([childControllerClass isSubclassOfClass:[UITableViewController class]])
        {
            childController = [[childControllerClass alloc] initWithStyle:[self tableViewStyle]];
        }
        else
        {
            childController = [[childControllerClass alloc] init];
        }
    }
    
    if ([childController isKindOfClass:[UIViewController class]])
    {
        [self pushViewController:childController navigationViewController:controller.navigationController animated:YES];
    }
}

#pragma clang diagnostic pop

@end

@implementation BIUserDefaultsButtonSpecifier

- (Class)defatulCellClass {
    return [BIUserDefaultsButtonCell class];
}

- (NSDictionary *)validKeys {
    static NSDictionary *validKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validKeys = [[NSDictionary alloc] initWithObjectsAndKeys:
                     REQUIRED, BISpecifierType,
                     REQUIRED, BISpecifierTitle,
                     OPTIONAL, BISpecifierTextAlignment,
                     OPTIONAL, BISpecifierAlertController,
                     OPTIONAL, BISpecifierAction,
                     OPTIONAL, BISpecifierStyle,
                     OPTIONAL, BISpecifierMessage,
                     OPTIONAL, BISpecifierTitle,
                     OPTIONAL, BISpecifierConfirmAction,
                     OPTIONAL, BISpecifierConfirmActionTitle,
                     OPTIONAL, BISpecifierCancelAction,
                     OPTIONAL, BISpecifierCancelActionTitle,
                     OPTIONAL, BISpecifierDetailText,
                     nil];
    });
    return validKeys;
}

- (void)setProperty:(id)property forKey:(NSString *)key {
    if ([BISpecifierAlertController isEqualToString:key]) {
        NSDictionary *dictionary = property;
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *alertDictionary = [NSMutableDictionary dictionaryWithCapacity:[property count]];
            [dictionary enumerateKeysAndObjectsUsingBlock:^(id alertKey, id obj, BOOL *stop) {
                if ([self isValidKey:alertKey]) {
                    [alertDictionary setObject:obj forKey:alertKey];
                }
            }];
            
            if ([alertDictionary count] > 0) {
                [super setProperty:alertDictionary forKey:key];
            }
        }
        
    } else {
        return [super setProperty:property forKey:key];
    }
}

- (void)runDefaultActionWithController:(BIUserDefaultsTableViewController *)controller arguments:(NSDictionary *)dict {
    if ([self propertyForKey:BISpecifierAlertController]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[self alertTitle]
                                                                                 message:[self alertMessage]
                                                                          preferredStyle:[self alertStyle]];
        
        NSString *cancelTitle = [self cancelActionTitle];
        if ([cancelTitle length] > 0) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                SEL cancelSelector = [self cancelAction];
                if (cancelSelector) {
                    [self runActionWithSelector:cancelSelector];
                }
            }];
            [alertController addAction:action];
        }
        
        NSString *confirmTitle = [self confirmActionTitle];
        if ([confirmTitle length] > 0) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                SEL confirmSelector = [self confirmAction];
                if (confirmSelector) {
                    [self runActionWithSelector:confirmSelector];
                }
            }];
            [alertController addAction:action];
        }
        
        [controller presentViewController:alertController animated:YES completion:nil];
    }
}

@end



