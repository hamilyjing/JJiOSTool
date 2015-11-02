//
//  BIUserDefaultsSpecifierGroup.m
//  SettingsKit
//
//  Created by HuGuanqin on 10/14/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsSpecifierGroup.h"
#import "BIUserDefaultsSpecifier+Private.h"
#import "BIUserDefaultsBackingStore.h"

@interface BIUserDefaultsSpecifierGroup ()

@property (nonatomic, strong) NSArray *originalRowSpecifiers; // for PSRadioGroupSpecifier, user can decide which item will be shown.

@property (nonatomic, strong) NSMutableArray *rowSpecifierArray;
@property (nonatomic, strong) NSIndexSet *lastHideSpecifierIndexs;

@end

@implementation BIUserDefaultsSpecifierGroup

- (instancetype)initWithSpecifierGroup:(BIUserDefaultsSpecifierGroup *)group {
    self = [super init];
    if (self) {
        _sectionSpecifier = [group sectionSpecifier];
        _rowSpecifierArray = [[NSMutableArray alloc] initWithArray:[group rowSpecifiers]];
        self.originalRowSpecifiers = _rowSpecifierArray;
    }
    return self;
}

- (instancetype)initWithSectionSpecifier:(BIUserDefaultsSpecifier *)specifier {
    self = [super init];
    if (self) {
        _sectionSpecifier = specifier;
        _rowSpecifierArray = [[NSMutableArray alloc] initWithCapacity:4];
        
        // RadioGroup类型，把Section Speicifer作为Row Specifier
        if ([_sectionSpecifier isRadioGroupSpecifier]) {
            for (NSInteger i = 0; i < [[_sectionSpecifier values] count]; i++) {
                BIUserDefaultsSpecifier *specifier = [BIUserDefaultsSpecifier specifierWithSpecifier:_sectionSpecifier];
                [_rowSpecifierArray addObject:specifier];
            }
            
            self.originalRowSpecifiers = _rowSpecifierArray;
        }
    }
    return self;
}


- (NSString *)description {
    NSMutableString *desc = [NSMutableString stringWithCapacity:128];
    [desc appendString:@"Specifier Group = "];
    [desc appendString:_sectionSpecifier.title];
    [desc appendString:@"\n"];
    [desc appendString:[_rowSpecifierArray description]];
    [desc appendString:@"\n"];
    return desc;
}

- (void)appendRowSpecifier:(BIUserDefaultsSpecifier *)specifier {
    [_rowSpecifierArray addObject:specifier];
}

- (void)removeRowSpecifier:(BIUserDefaultsSpecifier *)specifier {
    [_rowSpecifierArray removeObject:specifier];
}

- (void)removeRowSpecifierAtIndex:(NSUInteger)index {
    if (index < [_rowSpecifierArray count]) {
        [_rowSpecifierArray removeObjectAtIndex:index];
    }
}

- (void)insertRowSpecifier:(BIUserDefaultsSpecifier *)specifier atIndex:(NSUInteger)index {
    if (index <= [_rowSpecifierArray count]) {
        [_rowSpecifierArray insertObject:specifier atIndex:index];
    }
}

- (BIUserDefaultsSpecifier *)sectionSpecifier {
    return _sectionSpecifier;
}

- (BIUserDefaultsSpecifier *)rowSpecifierAtIndex:(NSUInteger)index {
    if (index < [_rowSpecifierArray count]) {
        return [_rowSpecifierArray objectAtIndex:index];
    }
    return nil;
}

- (NSArray *)rowSpecifiers {
    return _rowSpecifierArray;
}

- (NSUInteger)numberOfRows
{
    if ([_sectionSpecifier isRadioGroupSpecifier])
    {
        [self collectShownSpecifiersForRadioGroup];
    }
    
    return [_rowSpecifierArray count];
}

- (void)collectShownSpecifiersForRadioGroup
{
    BIUserDefaultsSpecifier *firstSpecifier = [self.originalRowSpecifiers firstObject];
    SEL hideIndexsAction = NSSelectorFromString([firstSpecifier propertyForKey:BISpecifierHideIndexsAction]);
    
    id hideSpecifierIndexs = [firstSpecifier runActionWithSelector:hideIndexsAction];
    
    if (![hideSpecifierIndexs isKindOfClass:[NSIndexSet class]])
    {
        return;
    }
    
    if (![hideSpecifierIndexs isEqualToIndexSet:self.lastHideSpecifierIndexs])
    {
        self.rowSpecifierArray = [self deapCopyOriginalRowSpecifiers];
        
        [self.rowSpecifierArray removeObjectsAtIndexes:hideSpecifierIndexs];
        
        for (BIUserDefaultsSpecifier *specifier in self.rowSpecifierArray)
        {
            [self resetValuesByKey:BISpecifierTitles hideIndexs:hideSpecifierIndexs specifier:specifier];
            [self resetValuesByKey:BISpecifierValues hideIndexs:hideSpecifierIndexs specifier:specifier];
        }
        
        self.lastHideSpecifierIndexs = hideSpecifierIndexs;
        
        [self resetStoreValueIfNeed];
    }
}

- (void)resetStoreValueIfNeed
{
    BIUserDefaultsSpecifier *oneSpecifier = [self.rowSpecifierArray firstObject];
    NSNumber *value = [[BIUserDefaultsBackingStore sharedInstance] objectForKey:oneSpecifier.key];
    if (![oneSpecifier.values containsObject:value])
    {
        [[BIUserDefaultsBackingStore sharedInstance] setObject:[oneSpecifier.values firstObject] forKey:oneSpecifier.key];
    }
}

- (NSMutableArray *)deapCopyOriginalRowSpecifiers
{
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (BIUserDefaultsSpecifier *specifier in self.originalRowSpecifiers)
    {
        BIUserDefaultsSpecifier *oneSpecifier = [BIUserDefaultsSpecifier specifierWithSpecifier:specifier];
        
        [mArray addObject:oneSpecifier];
    }
    
    return mArray;
}

- (void)resetValuesByKey:(NSString *)key hideIndexs:(NSIndexSet *)hideIndexs specifier:(BIUserDefaultsSpecifier *)specifier
{
    NSMutableArray *values = [[specifier propertyForKey:key] mutableCopy];
    [values removeObjectsAtIndexes:hideIndexs];
    [specifier setProperty:values forKey:key];
}

@end
