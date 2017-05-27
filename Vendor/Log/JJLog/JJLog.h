//
//  JJLog.h
//  JJObjCTool
//
//  Created by hamilyjing on 5/11/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JJLogBug(moduleName, logMsgFormat, ...) JJLogMessage(JJLogLevelBug, moduleName, __FILE__, __func__, __LINE__, self, logMsgFormat, ## __VA_ARGS__);
#define JJLogError(moduleName, logMsgFormat, ...) JJLogMessage(JJLogLevelError, moduleName, __FILE__, __func__, __LINE__, nil, logMsgFormat, ## __VA_ARGS__);
#define JJLogWarning(moduleName, logMsgFormat, ...) JJLogMessage(JJLogLevelWarning, moduleName, __FILE__, __func__, __LINE__, self, logMsgFormat, ## __VA_ARGS__);
#define JJLogInfo(moduleName, logMsgFormat, ...) JJLogMessage(JJLogLevelInfo, moduleName, __FILE__, __func__, __LINE__, self, logMsgFormat, ## __VA_ARGS__);
#define JJLogTrace(moduleName, logMsgFormat, ...) JJLogMessage(JJLogLevelTrace, moduleName, __FILE__, __func__, __LINE__, self, logMsgFormat, ## __VA_ARGS__);

// use below if no object
#define JJLoger(logLevel, moduleName, logMsgFormat, ...) JJLogMessage(logLevel, moduleName, __FILE__, __func__, __LINE__, nil, logMsgFormat, ## __VA_ARGS__);

#define JJLogErrorNil(moduleName, object) JJLogError(moduleName, @"The object(%@) is nil.", object);
#define JJLogWarningNil(moduleName, object) JJLogWarning(moduleName, @"The object(%@) is nil.", object);

typedef NS_ENUM(NSInteger, JJLogLevel)
{
    JJLogLevelBug = 0,
    JJLogLevelError,
    JJLogLevelWarning,
    JJLogLevelInfo,
    JJLogLevelTrace
};

extern void JJLogMessage(JJLogLevel logLevel
                         , NSString *moduleName
                         , const char *filePath
                         , const char *functionName
                         , int codeLine
                         , id object
                         , NSString *logMsgFormat
                         , ...);

extern NSString * JJLogMaximumLogSizeExceededNotification;

@interface JJLog : NSObject

// These are intentionally atomic to remind you that these are accessed on multiple threads.
// Atomicy doesn't actually matter for non-objects.
@property (readwrite, assign) JJLogLevel logLevel;
@property (readwrite, assign) BOOL isStarted;
@property (readwrite, assign) NSTimeInterval maximumLogAge;
@property (readwrite, assign) NSUInteger maximumLogSize; //bytes
@property (readwrite, strong) NSThread *thread;
@property (readwrite, strong) NSDateFormatter *dateFormatter;
@property (readonly, copy) NSString *logDirectory;

@property (nonatomic, assign) BOOL haveLogCapability;

// Shared instance
+ (instancetype)sharedLog;
+ (void)setSharedLog:(JJLog *)log;

/*!
 Designated initializer. Generally +sharedLog can be used instead of this.
 \param directory : Path to the directory to place logs in. This directory heirarchy will be created if needed
 \param logName : Base name of the log. The dateTime will be appended to this, along with an extension.
 "-Console" will be appended for the console log.
 */
- (id)initWithDirectory:(NSString *)directory logName:(NSString *)logName;

/*!
 Begins logging, including console logging in Release mode. We may want to make
 console logging an option, but so far everyone wants it and it's easy to add later.
 */
- (void)startLogging;

/*!
 Stops logging. Doesn't stop console logging. Nothing can stop console logging.
 http://c-faq.com/stdio/undofreopen.html
 */
- (void)stopLogging;

/*!
 Stops logging, and then starts logging again using a new log file.
 This method uses the startLogging and stopLogging methods.
 */
- (void)restartLogging;

/*!
 Log a message at a level. Generally it is easier to use the JJLog...() macros.
 */

- (void)logMessage:(NSString *)message level:(JJLogLevel)level;

/*!
 Removes old logs in the background based on maximimumLogAge. Log aging is based on
 modification date, not the filename.
 Also removes old logs until the total size of the log directory is below the maximum
 allowed value (currently 10 times the maximum individual log file size).
 */
- (void)removeOldLogs;

/*!
 Logging will be stopped (if it is not already stopped), and all existing log files in the 
 currently logging directory will be removed. This should be called as a part of resetting/removing the app, right before the app quits.
 */
- (void)removeAllLogs;

/*!
 Checks if the maximum log size in bytes was reached.
 */
- (BOOL)didReachMaxLogSize;

@end
