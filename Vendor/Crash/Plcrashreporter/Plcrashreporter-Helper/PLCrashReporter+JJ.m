//
//  PLCrashReporter+JJ.m
//  JJObjCTool
//
//  Created by gongjian03 on 7/30/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import "PLCrashReporter+JJ.h"

@implementation PLCrashReporter (JJ)

#pragma mark - public

- (void)jj_enableCrashReporterAndSetCallback:(PLCrashReporterPostCrashSignalCallback)callback_
{
    PLCrashReporterCallbacks cb = {
        .version = 0,
        .context = (void *) 0xABABABAB,
        .handleSignal = callback_,
    };
    
    [self setCrashCallbacks:&cb];
    
    NSError *error = nil;
    [self enableCrashReporterAndReturnError:&error];
    if (error)
    {
        NSAssert(NO, @"Enable crash reporter failed : %@", error);
    }
}

- (void)jj_saveCrashLogWithCrashLogFilePath:(NSString *)crashLogFilePath_
{
    if (![self hasPendingCrashReport])
    {
        return;
    }
    
    NSError *error;
    NSData *data = [self loadPendingCrashReportDataAndReturnError: &error];
    if (error)
    {
        NSAssert(NO, @"Load crash reporter data failed : %@", error);
        return;
    }
    
    PLCrashReport *crashReport = [[PLCrashReport alloc] initWithData:data error:&error];
    if (error)
    {
        NSAssert(NO, @"Create PLCrashReport object failed : %@", error);
        return;
    }
    
    NSString *crashLogString = [PLCrashReportTextFormatter stringValueForCrashReport:crashReport withTextFormat:PLCrashReportTextFormatiOS];
    if ([crashLogString length] <= 0)
    {
        return;
    }
    
    NSString *crashLogPath = [crashLogFilePath_ stringByAppendingPathComponent:[self jj_crashLogFileNameOfCrashReport:crashReport]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:crashLogFilePath_])
    {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:crashLogFilePath_ withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            NSAssert(NO, @"Create path: %@, error: %@", crashLogFilePath_, error);
        }
    }
    
    [crashLogString writeToFile:crashLogPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error)
    {
        NSAssert(NO, @"Save crash reporter failed, filePath: %@, error: %@", crashLogPath, error);
    }
}

#pragma mark - private

- (NSString *)jj_crashLogFileNameOfCrashReport:(PLCrashReport *)crashReport_
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = infoDictionary[@"CFBundleDisplayName"];
    NSString *bundleVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSDate* crashDate = crashReport_.systemInfo.timestamp;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HHmmss"];
    NSString *strCrashDate = [dateFormatter stringFromDate:crashDate];
    
    NSString *crashLogFileName = [NSString stringWithFormat:@"%@-%@-%@.crash", appName, bundleVersion, strCrashDate];
    return crashLogFileName;
}

@end
