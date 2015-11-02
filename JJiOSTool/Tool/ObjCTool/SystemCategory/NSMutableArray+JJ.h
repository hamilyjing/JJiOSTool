//
//  NSMutableArray+JJ.h
//  JJObjCTool
//
//  Created by hamilyjing on 5/11/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableArray (JJ)

#pragma mark - Safe method

-(void)jj_addObj:(id)i;
-(void)jj_addString:(NSString*)i;
-(void)jj_addBool:(BOOL)i;
-(void)jj_addInt:(int)i;
-(void)jj_addInteger:(NSInteger)i;
-(void)jj_addUnsignedInteger:(NSUInteger)i;
-(void)jj_addCGFloat:(CGFloat)f;
-(void)jj_addChar:(char)c;
-(void)jj_addFloat:(float)i;
-(void)jj_addPoint:(CGPoint)o;
-(void)jj_addSize:(CGSize)o;
-(void)jj_addRect:(CGRect)o;

@end
