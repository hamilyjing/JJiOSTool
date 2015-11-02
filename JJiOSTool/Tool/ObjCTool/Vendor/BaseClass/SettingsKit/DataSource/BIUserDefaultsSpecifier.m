//
//  BIUserDefaultsSpecifier.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/23/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsSpecifier+Private.h"
#import "BIUserDefaultsSpecifierDataSource.h"
#import "BIUserDefaultsTableViewCell.h"
#import "BIUserDefaultsConfig.h"
#import <objc/runtime.h>


NSString *const BISpecifierActionKeyValue = @"Value";


@interface BIUserDefaultsSpecifier ()
@property (nonatomic, strong) NSMutableDictionary *properties;
@end

@implementation BIUserDefaultsSpecifier

+ (instancetype)specifierWithDictionary:(NSDictionary *)dict {
    NSString *type = [dict objectForKey:BISpecifierType];
    if ([type length] <= 0) {
        NSLog(@"specifierWithDictionary Invalid Parma : No Specifier Type!");
    }
    
    Class cls = [BIUserDefaultsSpecifier specifierClassForType:type];
    if (cls == [BIUserDefaultsSpecifier class] && ![BICustomSpecifier isEqualToString:type]) {
        NSLog(@"specifierWithDictionary Unknown Specifier Class : %@!", type);
    }
    return [[cls alloc] initWithDictionary:dict];
}

+ (instancetype)specifierWithSpecifier:(BIUserDefaultsSpecifier *)specifier; {
    NSString *type = [specifier.properties objectForKey:BISpecifierType];
    if ([type length] <= 0) {
        NSLog(@"specifierWithDictionary Invalid Parma : No Specifier Type!");
    }
    
    Class cls = [BIUserDefaultsSpecifier specifierClassForType:type];
    if (cls == [BIUserDefaultsSpecifier class] && ![BICustomSpecifier isEqualToString:type]) {
        NSLog(@"specifierWithDictionary Unknown Specifier Class : %@!", type);
    }
    return [[cls alloc] initWithSpecifier:specifier];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.properties = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.properties = [NSMutableDictionary dictionary];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self setProperty:obj forKey:key];
        }];
        
        if ([BIUserDefaultsConfig debugEnable]) {
            [self validate];
        }
        
        [self resetToDefault];
    }
    return self;
}

- (instancetype)initWithSpecifier:(BIUserDefaultsSpecifier *)specifier {
    self = [super init];
    if (self) {
        self.properties = [specifier.properties mutableCopy];
        self.dataSource = specifier.dataSource;
        self.detailControllerClass = specifier.detailControllerClass;
        self.cellClass = specifier.cellClass;
        self.action = specifier.action;
        self.getter = specifier.getter;
        self.setter = specifier.setter;
        self.target = specifier.target;
        
        [self resetToDefault];
    }
    return self;
}


- (NSString *)description {
    NSMutableString *desc = [NSMutableString stringWithCapacity:128];
    [desc appendString:@"Specifier = "];
    [desc appendString:[_properties description]];
    [desc appendString:@"\n"];
    return desc;
}

#pragma mark - Public

- (void)resetToDefault
{
    
}

- (NSString *)identifier {
    return [self propertyForKey:BISpecifierID];
}

- (NSString *)key {
    return [self propertyForKey:BISpecifierKey];
}

- (NSString *)type {
    return [self propertyForKey:BISpecifierType];
}

- (NSString *)title {
    return [self propertyForKey:BISpecifierTitle];
}

- (NSString *)detailText {
    return [self propertyForKey:BISpecifierDetailText];
}

- (NSArray *)titles {
    return [self propertyForKey:BISpecifierTitles];
}

- (NSArray *)values {
    return [self propertyForKey:BISpecifierValues];
}

- (UITableViewStyle)tableViewStyle
{
    id value = [self propertyForKey:BISpecifierTableViewStyle];
    if (value && [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    else
    {
        return UITableViewStyleGrouped;
    }
}

- (NSArray *)shortTitles {
    return [self propertyForKey:BISpecifierShortTitles];
}

- (NSString *)titleForValue:(id)value {
    if (value == nil) {
        return nil;
    }
    
    NSArray *values = [self values];
    NSArray *titles = [self shortTitles];
    if (!titles) {
        titles = [self titles];
    }
    
    if (values.count != titles.count) {
        NSLog(@"titleForValue : Titles Count Must Equal To Values Count");
        return nil;
    }

    NSInteger index = [values indexOfObject:value];
    if (index == NSNotFound) {
        NSLog(@"titleForValue : Can't Find The Value : %@", [value description]);
        return nil;
    }
    return [titles objectAtIndex:index];
}

- (id)defaultValue {
    return [self propertyForKey:BISpecifierDefaultValue];
}

- (Class)cellClass
{
    NSString *className = [self propertyForKey:BISpecifierCellClass];
    if ([className length] > 0 && NULL == _cellClass)
    {
        _cellClass = NSClassFromString(className);
    }
    return _cellClass ? _cellClass : self.defatulCellClass;
}

- (UITableViewCellStyle)cellStyle {
    NSString *style = [self propertyForKey:BISpecifierCellStyle];
    if ([style length] > 0) {
        if ([BISpecifierCellStyleDefault isEqualToString:style]) {
            return UITableViewCellStyleDefault;
        }
        else if ([BISpecifierCellStyleValue1 isEqualToString:style]) {
            return UITableViewCellStyleValue1;
        }
        else if ([BISpecifierCellStyleValue2 isEqualToString:style]) {
            return UITableViewCellStyleValue2;
        }
        else if ([BISpecifierCellStyleSubtitle isEqualToString:style]) {
            return UITableViewCellStyleSubtitle;
        }
    }
    return self.defatulCellStyle;
}

- (Class)detailControllerClass {
    if (_detailControllerClass == nil) {
        NSString *classText = [self propertyForKey:BISpecifierDetailControllerClass];
        if ([classText length] > 0) {
            _detailControllerClass = NSClassFromString(classText);
        }
    }
    return _detailControllerClass;
}

- (id)target {
    if (_target) {
        return _target;
    }
    
    return self.dataSource.target;
}

- (SEL)getter {
    if (_getter == nil) {
        NSString *selector = [self propertyForKey:BISpecifierGetter];
        if ([selector length] > 0) {
            _getter = NSSelectorFromString(selector);
        }
    }
    return _getter;
}

- (SEL)setter {
    if (_setter == nil) {
        NSString *selector = [self propertyForKey:BISpecifierSetter];
        if ([selector length] > 0) {
            _setter = NSSelectorFromString(selector);
        }
    }
    return _setter;
}

- (SEL)action {
    if (_action == nil) {
        NSString *selector = [self propertyForKey:BISpecifierAction];
        if ([selector length] > 0) {
            _action = NSSelectorFromString(selector);
        }
    }
    return _action;
}

- (void)setValues:(NSDictionary *)values titles:(NSDictionary *)titles {
    [self setProperty:values forKey:BISpecifierValues];
    [self setProperty:titles forKey:BISpecifierTitles];
}

- (void)setProperty:(id)property forKey:(NSString *)key {
    if ([self isValidKey:key]) {
        [_properties setObject:property forKey:key];
    } else {
        NSLog(@"setProperty Invalid Key : %@", key);
    }
}

- (void)removePropertyForKey:(NSString *)key {
    [_properties removeObjectForKey:key];
}

- (id)propertyForKey:(NSString *)key {
    return [_properties objectForKey:key];
}

- (NSIndexPath *)indexPath {
    if (self.dataSource) {
        return [self.dataSource indexPathForSpecifier:self];
    }
    return nil;
}

@end

@implementation BIUserDefaultsSpecifier (GroupSpecifier)

- (NSString *)footerTitle {
    return [self propertyForKey:BISpecifierFooterText];
}

@end

@implementation BIUserDefaultsSpecifier (ChildPaneSpecifier)

- (NSString *)file {
    return [self propertyForKey:BISpecifierFile];
}

- (NSString *)fileType {
    return [self propertyForKey:BISpecifierFileType];
}

@end

@implementation BIUserDefaultsSpecifier (SwitchSpecifier)

- (id)trueValue {
    return [self propertyForKey:BISpecifierTrueValue];
}

- (id)falseValue {
    return [self propertyForKey:BISpecifierFalseValue];
}

@end


@implementation BIUserDefaultsSpecifier (SliderSpecifier)

- (CGFloat)minimumValue {
    return [[self propertyForKey:BISpecifierMinimumValue] floatValue];
}

- (CGFloat)maximumValue {
    return [[self propertyForKey:BISpecifierMaximumValue] floatValue];
}

- (NSString *)minimumValueImage {
    return [self propertyForKey:BISpecifierMinimumValueImage];
}

- (NSString *)maximumValueImage {
    return [self propertyForKey:BISpecifierMaximumValueImage];
}

@end

@implementation BIUserDefaultsSpecifier (TextFieldSpecifier)

- (BOOL)secureTextEntry {
    return [[self propertyForKey:BISpecifierIsSecure] boolValue];
}

- (UIKeyboardType)keyboardType {
    NSString *type = [self propertyForKey:BISpecifierKeyboardType];
    if ([BISpecifierKeyboardTypeDefault isEqualToString:type]) {
        return UIKeyboardTypeDefault;
    }
    else if ([BISpecifierKeyboardTypeNumbersAndPunctuation isEqualToString:type]) {
        return UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([BISpecifierKeyboardTypeNumberPad isEqualToString:type]) {
        return UIKeyboardTypeNumberPad;
    }
    else if ([BISpecifierKeyboardTypePhonePad isEqualToString:type]) {
        return UIKeyboardTypePhonePad;
    }
    else if ([BISpecifierKeyboardTypeNamePhonePad isEqualToString:type]) {
        return UIKeyboardTypeNamePhonePad;
    }
    else if ([BISpecifierKeyboardTypeASCIICapable isEqualToString:type]) {
        return UIKeyboardTypeASCIICapable;
    }
    else if ([BISpecifierKeyboardTypeDecimalPad isEqualToString:type]) {
        return UIKeyboardTypeDecimalPad;
    }
    else if ([BISpecifierKeyboardTypeURL isEqualToString:type]) {
        return UIKeyboardTypeURL;
    }
    else if ([BISpecifierKeyboardTypeEmailAddress isEqualToString:type]) {
        return UIKeyboardTypeEmailAddress;
    }
    return UIKeyboardTypeDefault;
}

- (UITextAutocapitalizationType)autocapitalizationType {
    NSString *type = [self propertyForKey:BISpecifierAutoCapitalizationType];
    if ([BISpecifierAutoCapitalizationTypeNone isEqualToString:type]) {
        return UITextAutocapitalizationTypeNone;
    }
    else if ([BISpecifierAutoCapitalizationTypeSentences isEqualToString:type]) {
        return UITextAutocapitalizationTypeSentences;
    }
    else if ([BISpecifierAutoCapitalizationTypeWords isEqualToString:type]) {
        return UITextAutocapitalizationTypeWords;
    }
    else if ([BISpecifierAutoCapitalizationTypeAllCharacters isEqualToString:type]) {
        return UITextAutocapitalizationTypeAllCharacters;
    }
    return UITextAutocapitalizationTypeNone;
}

- (UITextAutocorrectionType)autoCorrectionType {
    NSString *type = [self propertyForKey:BISpecifierAutoCorrectionType];
    if ([BISpecifierAutoCorrectionTypeDefault isEqualToString:type]) {
        return UITextAutocorrectionTypeDefault;
    }
    else if ([BISpecifierAutoCorrectionTypeNo isEqualToString:type]) {
        return UITextAutocorrectionTypeNo;
    }
    else if ([BISpecifierAutoCorrectionTypeYes isEqualToString:type]) {
        return UITextAutocorrectionTypeYes;
    }
    return UITextAutocorrectionTypeDefault;
}

@end

@implementation BIUserDefaultsSpecifier (ButtonSpecifier)

- (NSDictionary *)alertControllerDictionary {
    return [self propertyForKey:BISpecifierAlertController];
}

- (NSTextAlignment)textAlignment {
    NSString *alignment = [self propertyForKey:BISpecifierTextAlignment];
    if ([BISpecifierTextAlignmentLeft isEqualToString:alignment]) {
        return NSTextAlignmentLeft;
    }
    
    if ([BISpecifierTextAlignmentCenter isEqualToString:alignment]) {
        return NSTextAlignmentCenter;
    }
    
    return NSTextAlignmentLeft;
}

- (UIAlertControllerStyle)alertStyle {
    NSString *text = [[self alertControllerDictionary] objectForKey:BISpecifierStyle];
    if ([BISpecifierAlertControllerStyleAlert isEqualToString:text]) {
        return UIAlertControllerStyleAlert;
    } else if ([BISpecifierAlertControllerStyleActionSheet isEqualToString:text]) {
        return UIAlertControllerStyleActionSheet;
    }
    
    NSLog(@"alertStyle Not Support Alert Style : %@!!", text);
    
    return UIAlertControllerStyleActionSheet;
}

- (NSString *)alertTitle {
    return [[self alertControllerDictionary] objectForKey:BISpecifierTitle];
}

- (NSString *)alertMessage {
    return [[self alertControllerDictionary] objectForKey:BISpecifierMessage];
}

- (NSString *)confirmActionTitle {
    return [[self alertControllerDictionary] objectForKey:BISpecifierConfirmActionTitle];
}

- (NSString *)cancelActionTitle {
    return [[self alertControllerDictionary] objectForKey:BISpecifierCancelActionTitle];
}

- (SEL)confirmAction {
    return NSSelectorFromString([[self alertControllerDictionary] objectForKey:BISpecifierConfirmAction]);
}

- (SEL)cancelAction {
    return NSSelectorFromString([[self alertControllerDictionary] objectForKey:BISpecifierCancelAction]);
}

@end

@implementation BIUserDefaultsSpecifier (DefaultAction)

- (id)runActionWithSelector:(SEL)selector {
    id target = self.target;
    if (target == nil || selector == nil) {
        NSLog(@"runActionWithSelector target & selector Can't Be nil!!");
        return nil;
    }
    
    if (![target respondsToSelector:selector]) {
        NSLog(@"runActionWithSelector target %@ has no selector %@:", NSStringFromClass([target class]), NSStringFromSelector(selector));
        return nil;
    }
    
    unsigned int count = method_getNumberOfArguments(class_getInstanceMethod([target class], selector));
    if (count == 2)
    {
        IMP imp = [target methodForSelector:selector];
        id (*func)(id, SEL) = (void *)imp;
        return func(target, selector);
    }
    else if (count == 3)
    {
        IMP imp = [target methodForSelector:selector];
        id (*func)(id, SEL, id) = (void *)imp;
        return func(target, selector, self);
    }
    return nil;
}

- (void)runDefaultActionWithController:(BIUserDefaultsTableViewController *)controller arguments:(NSDictionary *)dict {
    
}

@end

