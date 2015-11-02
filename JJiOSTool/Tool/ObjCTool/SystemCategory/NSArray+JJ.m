//
//  NSArray+JJ.m
//  JJObjCTool
//
//  Created by hamilyjing on 5/11/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "NSArray+JJ.h"

@implementation NSArray (JJ)

#pragma mark - Safe method

-(id)jj_objectWithIndex:(NSUInteger)index{
    if (index <self.count) {
        return self[index];
    }else{
        NSAssert(NO, @"index(%ld) is beyond the bounds of the array(%ld).", (long)index, (long)self.count);
        return nil;
    }
}

- (NSString*)jj_stringWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return @"";
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    NSAssert(NO, @"Value(%@) is not NSString class.", value);
    
    return nil;
}


- (NSNumber*)jj_numberWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    
    NSAssert(NO, @"Value(%@) is not NSNumber class.", value);
    
    return nil;
}

- (NSArray*)jj_arrayWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    
    NSAssert(NO, @"Value(%@) is not NSArray class.", value);
    
    return nil;
}


- (NSDictionary*)jj_dictionaryWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    
    NSAssert(NO, @"Value(%@) is not NSDictionary class.", value);
    
    return nil;
}

- (NSInteger)jj_integerWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    
    NSAssert(NO, @"Value(%@) can not convert to NSInteger.", value);
    
    return 0;
}
- (NSUInteger)jj_unsignedIntegerWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value unsignedIntegerValue];
    }
    
    NSAssert(NO, @"Value(%@) can not convert to NSUInteger.", value);
    
    return 0;
}
- (BOOL)jj_boolWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value boolValue];
    }
    
    NSAssert(NO, @"Value(%@) can not convert to BOOL.", value);
    
    return NO;
}
- (int16_t)jj_int16WithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    
    NSAssert(NO, @"Value(%@) can not convert to int16_t.", value);
    
    return 0;
}
- (int32_t)jj_int32WithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    
    NSAssert(NO, @"Value(%@) can not convert to int32_t.", value);
    
    return 0;
}
- (int64_t)jj_int64WithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value longLongValue];
    }
    
    NSAssert(NO, @"Value(%@) can not convert to int64_t.", value);
    
    return 0;
}

- (char)jj_charWithIndex:(NSUInteger)index{
    
    id value = [self jj_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value charValue];
    }
    
    NSAssert(NO, @"Value(%@) can not convert to char.", value);
    
    return 0;
}

- (short)jj_shortWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    
    NSAssert(NO, @"Value(%@) can not convert to short.", value);
    
    return 0;
}
- (float)jj_floatWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value floatValue];
    }
    
    NSAssert(NO, @"Value(%@) can not convert to float.", value);
    
    return 0;
}
- (double)jj_doubleWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value doubleValue];
    }
    
    NSAssert(NO, @"Value(%@) can not convert to double.", value);
    
    return 0;
}

#pragma mark - Get CG object

- (CGFloat)jj_CGFloatWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    
    CGFloat f = [value doubleValue];
    
    return f;
}

- (CGPoint)jj_pointWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    
    CGPoint point = CGPointFromString(value);
    
    return point;
}
- (CGSize)jj_sizeWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    
    CGSize size = CGSizeFromString(value);
    
    return size;
}
- (CGRect)jj_rectWithIndex:(NSUInteger)index
{
    id value = [self jj_objectWithIndex:index];
    
    CGRect rect = CGRectFromString(value);
    
    return rect;
}

@end
