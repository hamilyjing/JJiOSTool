//
//  NSArray+JJ.h
//  JJObjCTool
//
//  Created by hamilyjing on 5/11/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray (JJ)

#pragma mark - Safe method

-(id)jj_objectWithIndex:(NSUInteger)index;
- (NSString*)jj_stringWithIndex:(NSUInteger)index;
- (NSNumber*)jj_numberWithIndex:(NSUInteger)index;
- (NSArray*)jj_arrayWithIndex:(NSUInteger)index;
- (NSDictionary*)jj_dictionaryWithIndex:(NSUInteger)index;
- (NSInteger)jj_integerWithIndex:(NSUInteger)index;
- (NSUInteger)jj_unsignedIntegerWithIndex:(NSUInteger)index;
- (BOOL)jj_boolWithIndex:(NSUInteger)index;
- (int16_t)jj_int16WithIndex:(NSUInteger)index;
- (int32_t)jj_int32WithIndex:(NSUInteger)index;
- (int64_t)jj_int64WithIndex:(NSUInteger)index;
- (char)jj_charWithIndex:(NSUInteger)index;
- (short)jj_shortWithIndex:(NSUInteger)index;
- (float)jj_floatWithIndex:(NSUInteger)index;
- (double)jj_doubleWithIndex:(NSUInteger)index;

#pragma mark - Get CG object

- (CGFloat)jj_CGFloatWithIndex:(NSUInteger)index;
- (CGPoint)jj_pointWithIndex:(NSUInteger)index;
- (CGSize)jj_sizeWithIndex:(NSUInteger)index;
- (CGRect)jj_rectWithIndex:(NSUInteger)index;

#pragma mark - JSON

- (NSString *)jj_JSONString;
- (NSData *)jj_JSONSData;

@end
