//
//  UtilMacro.h
//  JJObjCTool
//
//  Created by Gongjian on 8/30/14.
//  Copyright (c) 2014 JianJing. All rights reserved.
//

CFAbsoluteTime g_jj_startTime;
#define JJ_StartTime (g_jj_startTime = CFAbsoluteTimeGetCurrent());
#define JJ_TimeInterval (CFAbsoluteTimeGetCurrent() - g_jj_startTime) // NSLog(@"%f", JJ_TimeInterval);

/**
 iOS version
 */
#define JJ_IS_IOS_BETWEEN(v0, v1) ([[UIDevice currentDevice].systemVersion floatValue] >= v0 && [[UIDevice currentDevice].systemVersion floatValue] < v1)

#define JJ_IS_IOS_BEFORE(v) ([[UIDevice currentDevice].systemVersion floatValue] < v)
#define JJ_IS_IOS_AFTER(v) ([[UIDevice currentDevice].systemVersion floatValue] > v)

#define JJ_IS_IOS_BEFORE_AND_INCLUDE(v) ([[UIDevice currentDevice].systemVersion floatValue] <= v)
#define JJ_IS_IOS_AFTER_AND_INCLUDE(v) ([[UIDevice currentDevice].systemVersion floatValue] >= v)


/**
 Frame
 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SAFE_RELEASE(x) [x release];x=nil
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif
