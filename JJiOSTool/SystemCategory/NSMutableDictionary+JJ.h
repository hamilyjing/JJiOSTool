//
//  NSMutableDictionary+JJ.h
//  JJObjCTool
//
//  Created by hamilyjing on 5/12/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableDictionary (JJ)

#pragma mark - Safe method

-(void)jj_setObj:(id)i forKey:(NSString*)key;
-(void)jj_setString:(NSString*)i forKey:(NSString*)key;
-(void)jj_setBool:(BOOL)i forKey:(NSString*)key;
-(void)jj_setInt:(int)i forKey:(NSString*)key;
-(void)jj_setInteger:(NSInteger)i forKey:(NSString*)key;
-(void)jj_setUnsignedInteger:(NSUInteger)i forKey:(NSString*)key;
-(void)jj_setCGFloat:(CGFloat)f forKey:(NSString*)key;
-(void)jj_setChar:(char)c forKey:(NSString*)key;
-(void)jj_setFloat:(float)i forKey:(NSString*)key;
-(void)jj_setDouble:(double)i forKey:(NSString*)key;
-(void)jj_setLongLong:(long long)i forKey:(NSString*)key;
-(void)jj_setPoint:(CGPoint)o forKey:(NSString*)key;
-(void)jj_setSize:(CGSize)o forKey:(NSString*)key;
-(void)jj_setRect:(CGRect)o forKey:(NSString*)key;

@end
