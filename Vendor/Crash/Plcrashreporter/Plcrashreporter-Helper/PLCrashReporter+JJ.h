//
//  PLCrashReporter+JJ.h
//  JJObjCTool
//
//  Created by gongjian03 on 7/30/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import <CrashReporter/CrashReporter.h>

@interface PLCrashReporter (JJ)

- (void)jj_enableCrashReporterAndSetCallback:(PLCrashReporterPostCrashSignalCallback)callback;

- (void)jj_saveCrashLogWithCrashLogFilePath:(NSString *)crashLogFilePath;

@end
