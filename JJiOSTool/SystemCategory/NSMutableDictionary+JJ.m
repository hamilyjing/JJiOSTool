//
//  NSMutableDictionary+JJ.m
//  JJObjCTool
//
//  Created by hamilyjing on 5/12/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "NSMutableDictionary+JJ.h"

@implementation NSMutableDictionary (JJ)

-(void)jj_setObj:(id)i forKey:(NSString*)key{
    if (i!=nil) {
        self[key] = i;
    }
}
-(void)jj_setString:(NSString*)i forKey:(NSString*)key;
{
    [self setValue:i forKey:key];
}
-(void)jj_setBool:(BOOL)i forKey:(NSString *)key
{
    self[key] = @(i);
}
-(void)jj_setInt:(int)i forKey:(NSString *)key
{
    self[key] = @(i);
}
-(void)jj_setInteger:(NSInteger)i forKey:(NSString *)key
{
    self[key] = @(i);
}
-(void)jj_setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key
{
    self[key] = @(i);
}
-(void)jj_setCGFloat:(CGFloat)f forKey:(NSString *)key
{
    self[key] = @(f);
}
-(void)jj_setChar:(char)c forKey:(NSString *)key
{
    self[key] = @(c);
}
-(void)jj_setFloat:(float)i forKey:(NSString *)key
{
    self[key] = @(i);
}
-(void)jj_setDouble:(double)i forKey:(NSString*)key{
    self[key] = @(i);
}
-(void)jj_setLongLong:(long long)i forKey:(NSString*)key{
    self[key] = @(i);
}
-(void)jj_setPoint:(CGPoint)o forKey:(NSString *)key
{
    self[key] = NSStringFromCGPoint(o);
}
-(void)jj_setSize:(CGSize)o forKey:(NSString *)key
{
    self[key] = NSStringFromCGSize(o);
}
-(void)jj_setRect:(CGRect)o forKey:(NSString *)key
{
    self[key] = NSStringFromCGRect(o);
}

@end
