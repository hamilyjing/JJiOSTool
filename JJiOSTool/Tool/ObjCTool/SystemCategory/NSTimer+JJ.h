//
//  NSTimer+JJ.h
//  JJObjCTool
//
//  Created by gongjian03 on 6/2/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSTimer (JJ)

#pragma mark - execute time

+ (double)jj_measureExecutionTime:(void (^)())block;

+ (void)jj_startTiming;
+ (double)jj_timeInterval;

@end
