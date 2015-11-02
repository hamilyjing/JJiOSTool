//
//  NSTimer+JJ.m
//  JJObjCTool
//
//  Created by gongjian03 on 6/2/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "NSTimer+JJ.h"

@implementation NSTimer (JJ)

#pragma mark - execute time

+ (double)jj_measureExecutionTime:(void (^)())block
{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    
    block();
    
    double executionTime = CFAbsoluteTimeGetCurrent() - startTime;
    return executionTime;
}

static CFAbsoluteTime g_s_jj_startTime;

+ (void)jj_startTiming
{
    g_s_jj_startTime = CFAbsoluteTimeGetCurrent();
}

+ (double)jj_timeInterval
{
    double startTime = g_s_jj_startTime;
    g_s_jj_startTime = CFAbsoluteTimeGetCurrent();
    double timeInterval = g_s_jj_startTime - startTime;
    
    return timeInterval;
}

@end
