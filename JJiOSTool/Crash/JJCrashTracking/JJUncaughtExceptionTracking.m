//
//  JJUncaughtExceptionTracking.m
//  JJObjCTool
//
//  Created by gong jian on 12-7-12.
//  Copyright (c) 2012年 Gong jian. All rights reserved.
//

#import "JJUncaughtExceptionTracking.h"

void handleUncaughtException(NSException* exception)
{	
	NSArray* callstacks = [exception callStackSymbols];
	for(__unused NSString* stack in callstacks)
	{
		// add log below
	}
}

void trackUncaughtExceptionCrash()
{
    NSSetUncaughtExceptionHandler(&handleUncaughtException);
}
