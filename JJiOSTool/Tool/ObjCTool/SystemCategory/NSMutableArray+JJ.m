//
//  NSMutableArray+JJ.m
//  JJObjCTool
//
//  Created by hamilyjing on 5/11/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "NSMutableArray+JJ.h"

@implementation NSMutableArray (JJ)

#pragma mark - Safe method

-(void)jj_addObj:(id)i{
    if (i!=nil) {
        [self addObject:i];
    }
}
-(void)jj_addString:(NSString*)i
{
    if (i!=nil) {
        [self addObject:i];
    }
}
-(void)jj_addBool:(BOOL)i
{
    [self addObject:@(i)];
}
-(void)jj_addInt:(int)i
{
    [self addObject:@(i)];
}
-(void)jj_addInteger:(NSInteger)i
{
    [self addObject:@(i)];
}
-(void)jj_addUnsignedInteger:(NSUInteger)i
{
    [self addObject:@(i)];
}
-(void)jj_addCGFloat:(CGFloat)f
{
    [self addObject:@(f)];
}
-(void)jj_addChar:(char)c
{
    [self addObject:@(c)];
}
-(void)jj_addFloat:(float)i
{
    [self addObject:@(i)];
}
-(void)jj_addPoint:(CGPoint)o
{
    [self addObject:NSStringFromCGPoint(o)];
}
-(void)jj_addSize:(CGSize)o
{
    [self addObject:NSStringFromCGSize(o)];
}
-(void)jj_addRect:(CGRect)o
{
    [self addObject:NSStringFromCGRect(o)];
}

@end
