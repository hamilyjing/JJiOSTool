//
//  JJProblemReporter.h
//  JJObjCTool
//
//  Created by gongjian03 on 7/30/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import <Foundation/Foundation.h>

/* you should add locatized string, default is English
 "Unable to send mail" = "无法发送邮件";
 "We can't find an email account, which we use to send your problem report. Make sure that there is an email account set up on your mobile device." = "我们无法找到用于发送问题报告的电子邮件地址。请确保移动设备上已设置电子邮件帐户。";
 "OK" = "确认";
 "Enter your problem description below:" = "在下方输入您的问题描述：";
 "Crash Problem Report: %@ (%@) for %@ (%@)" = "崩溃问题报告: %@ (%@) for %@ (%@)";
 "Problem Report: %@ (%@) for %@ (%@)" = "问题报告: %@ (%@) for %@ (%@)";
 "Stopped unexpectedly. Do you want to send a problem report?" = "意外停止。是否要发送问题报告?";
 "Do Not Send" = "不要发送";
 "Send" = "发送";
 */

//#define JJ_USE_PLCRASHREPORT

@interface JJProblemReporter : NSObject

@property (nonatomic, copy) NSString *logFilePath;

+ (instancetype)sharedInstance;

- (void)sendProblemReporterWithCrashLog:(BOOL)needCrashLog completion:(void (^)(void))completion;

- (void)alertOccuredCrashIfNeededWithCompletion:(void (^)(void))completion;

@end
