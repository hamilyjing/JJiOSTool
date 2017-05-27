//
//  JJLog.m
//  JJObjCTool
//
//  Created by hamilyjing on 5/11/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "JJLog.h"

#import <execinfo.h>
#import <pthread.h>
#import <stdio.h>
#import <unistd.h>

#define MX_IOS

static JJLog *theSharedLog = nil;

static NSString * const JJLogModuleNameLog = @"[log]";

const size_t LOG_BUFF_MAX_SIZE = 1;//1024;

NSString *JJLogMaximumLogSizeExceededNotification = @"JJLogMaximumLogSizeExceededNotification";

static NSArray *theLevelStrings;

static NSArray *kLogCleanFileExtensionArray;
static NSString *kLogFileExtension = @"log";
static NSString *kLogFilesDirectory = @"JJLog";
static NSTimeInterval kDefaultMaximumLogAge = 60 * 60 * 24;	// One day
#ifdef MX_IOS
static NSUInteger kDefaultMaximumLogSize = 8 * 1024 * 1024; // 8 MB
static NSUInteger kDefaultLogSizeMultiplier = 4; // Allow 'n' times the maximum log size for the size of the entire logs directory.
#else
static NSUInteger kDefaultMaximumLogSize = 16 * 1024 * 1024; // 16 MB
static NSUInteger kDefaultLogSizeMultiplier = 8; // Allow 'n' times the maximum log size for the size of the entire logs directory.
#endif

void JJLogMessage(JJLogLevel logLevel
                  , NSString *moduleName
                  , const char *filePath
                  , const char *functionName
                  , int codeLine
                  , id object
                  , NSString *logMsgFormat
                  , ...)
{
    if (![[JJLog sharedLog] haveLogCapability]
        ||  logLevel > [[JJLog sharedLog] logLevel])
    {
        return;
    }
    
    NSString *argsMsg = @"";
    
    if ([logMsgFormat length] != 0)
    {
        va_list args;
        va_start(args, logMsgFormat);
        argsMsg = [[NSString alloc] initWithFormat:logMsgFormat arguments:args];
        va_end(args);
    }
    
    NSString *logMsg = nil;
    
    if (object)
    {
        logMsg = [NSString stringWithFormat:@"{client_:%@ %s:%d %p} %@"
                  , moduleName
                  , functionName
                  , codeLine
                  , object
                  , argsMsg];
    }
    else
    {
        logMsg = [NSString stringWithFormat:@"{client_:%@ %s:%d} %@"
                  , moduleName
                  , functionName
                  , codeLine
                  , argsMsg];
    }
    
    [theSharedLog logMessage:logMsg level:logLevel];
}

//////////////////
// Private Methods
//////////////////
@interface JJLog ()
{
    char *     _logBuff;
    size_t     _currentBuffSize;
}

@property (readwrite, copy) NSString *logDirectory;
@property (readwrite, strong) NSFileHandle *fileHandle;
@property (readwrite, copy) NSString *logName;
@property (readwrite, strong) NSString *logBasename;
@property (readwrite, assign) BOOL clearLogs;
@property (nonatomic, readwrite, assign) BOOL loggingRestarted;

@end

/////////
// JJLog
/////////
@implementation JJLog

//////////////////////////
#pragma mark Class methods
//////////////////////////

+ (void)initialize
{
	if (self == [JJLog class])
	{
        kLogCleanFileExtensionArray = @[kLogFileExtension, @"crash"];
        
		theLevelStrings = [[NSArray alloc] initWithObjects:@"INTERNAL", @"ERROR", @"WARNING", @"INFO", @"DEBUG", @"TRACE", nil];

		// Create shared logger
		
		NSString *logName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
		
	#if TARGET_OS_IPHONE
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSString *docDirectory = [paths objectAtIndex:0];
		NSString *directory = [docDirectory stringByAppendingPathComponent:kLogFilesDirectory];
	#else
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString *directory = [[[paths objectAtIndex:0] stringByAppendingPathComponent:kLogFilesDirectory]
							   stringByAppendingPathComponent:logName];
	#endif
		
		theSharedLog = [[self alloc] initWithDirectory:directory logName:logName];
	}
}	

+ (id)sharedLog
{
	// Already set up in +initialize
	return theSharedLog;
}

+ (void)setSharedLog:(JJLog *)aLog
{
	if (theSharedLog != aLog)
	{
		[theSharedLog stopLogging];
		theSharedLog = aLog;
	}
}

/////////////////////////////////////
#pragma mark Constructors/Destructors
/////////////////////////////////////

//
// Designated initializer
//
- (id)initWithDirectory:(NSString *)directory logName:(NSString *)logName
{
	self = [super init];
	if (self != nil)
	{
		self.logLevel = JJLogLevelInfo;
		self.dateFormatter = [[NSDateFormatter alloc] init];
		[self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        [self.dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
		self.maximumLogAge = kDefaultMaximumLogAge;
		self.maximumLogSize = kDefaultMaximumLogSize;
		self.isStarted = NO;
		self.clearLogs = NO;
		
		self.logDirectory = directory;
		self.logName = logName;
        
        self.fileHandle = nil;
        
        _logBuff = (char *)malloc(LOG_BUFF_MAX_SIZE);
        _currentBuffSize = 0;
	}
	
	return self;
}

- (void)dealloc
{
    free(_logBuff);
}

////////////////////
#pragma mark Actions
////////////////////

- (void)startLogging
{
	if (self.fileHandle == nil)
	{
		self.isStarted = YES;
		
		NSFileManager *fm = [NSFileManager defaultManager];
		BOOL canCreateFile = YES;
		BOOL isDirectory;
		NSString *logDirectory = self.logDirectory;
		if ( ! [fm fileExistsAtPath:logDirectory isDirectory:&isDirectory] )
		{
			NSError *error;
			if ( ! [fm createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:&error] )
			{
				// FIXME: Make look like regular log message
				NSLog(@"ERROR: Could not create log file. Logging to console: %@", error);
				canCreateFile = NO;
			}
		}
		
		if (canCreateFile)
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"yyyy-MM-dd-HHmmssSS"];
            [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
			self.logBasename = [NSString stringWithFormat:@"%@-%@", self.logName, [dateFormat stringFromDate:[NSDate date]]];
			NSString *logPath = [[logDirectory stringByAppendingPathComponent:self.logBasename] stringByAppendingPathExtension:kLogFileExtension];
			
			if ([fm createFileAtPath:logPath contents:nil attributes:nil])
			{
				self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
				if (self.fileHandle == nil)
				{
					NSLog(@"ERROR: Could not open file for writing. Logging to console: %@", logPath);
				}
#if JJLOG_CONSOLE
				NSString *consoleBasename = [self.logBasename stringByAppendingString:@"-Console"];
				NSString *consolePath = [[logDirectory stringByAppendingPathComponent:consoleBasename] stringByAppendingPathExtension:kLogFileExtension];
				
				FILE *fp;
				fp = freopen ([consolePath UTF8String], "a+", stderr);
				if (fp != NULL)
				{
					NSLog(@"Stderr redirected to: %@", consolePath);
					fp = freopen ([consolePath UTF8String], "a+", stdout);
					if (fp != NULL)
					{
						printf("Stdout also redirected.\n");
					}
				}
				else
				{
					NSLog(@"ERROR: Could not reopen console. Console will not be redirected to %@", consolePath);
				}
#endif
			}
			else
			{
				NSLog(@"ERROR: Could not create file. Logging to console: %@", logPath);
			}
		}
	}
	
	if (self.thread == nil)
	{
		// Log on a background thread.
		self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(startRunLoop:) object:nil];
		[self.thread start];
		
		// Log on the main thread.
		//self.thread = [NSThread mainThread];
	}
	
	[self writeLogMessage:@"**************************************************************\n"];
	if (self.loggingRestarted)
	{
		self.loggingRestarted = NO;
		[self writeLogMessage:@"** Restarting Logging: THIS IS A CONTINUATION OF PREVIOUS LOGGING\n"];
	}
	else
	{
		[self writeLogMessage:@"** Started Logging\n"];
	}
	[self writeLogMessage:[NSString stringWithFormat:@"** Date: %@\n", [NSDate date]]];
	[self writeLogMessage:@"**************************************************************\n"];

	[self writeLogMessage:[NSString stringWithFormat:@"** Application Identifier: %@\n", (__bridge NSString *)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleIdentifierKey)]];
	[self writeLogMessage:[NSString stringWithFormat:@"** Application Version:    %@\n", (__bridge NSString *)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey)]];

    // TODO find a way on 10.8 to determine the OS version and write it to the log
    
	[self writeLogMessage:@"**************************************************************\n\n"];
	
	// Remove old logs:
	[self removeOldLogs];
}

- (void)stopLogging
{
	self.isStarted = NO;
	// It's not easy to stop console logging here. http://c-faq.com/stdio/undofreopen.html
	// There may be a way, but it's probably not worth the trouble.
}

- (void)restartLogging
{
	[self stopLogging];
    
	[self.fileHandle closeFile];
	self.fileHandle = nil;

	self.loggingRestarted = YES;
    
	[self startLogging];
}

- (void)logMessage:(NSString *)message level:(JJLogLevel)level
{
	NSString *levelString = [theLevelStrings objectAtIndex:level];
	NSString *logMessage = nil;
	
    if (self.isStarted == YES)
    {
        if ( [[[NSThread currentThread] name] length] == 0 )
        {
            pthread_t t = pthread_self();			
            [[NSThread currentThread] setName:[NSString stringWithFormat:@"%x", (int)t]];
        }
        
        NSString *formattedDate = [self.dateFormatter stringFromDate:[NSDate date]];
        logMessage = [NSString stringWithFormat:@"-- %@ %@ [%@] - %@\n",
                                            formattedDate,
                                            levelString,
                                            [[NSThread currentThread] name],
                                            message];
        

        [self performSelector:@selector(writeLogMessage:) onThread:self.thread withObject:logMessage waitUntilDone:NO];
    }
    else
    {
#if JJLOG_DEBUG
        logMessage = [NSString stringWithFormat:@"%@ - %@", levelString, message];
        NSLog(@"(WARNING: JJLog is not running) %@", logMessage);
#endif
    }
}

- (void)removeOldLogs
{
	[self performSelectorInBackground:@selector(removeOldLogsStartingWithDate:) withObject:[NSDate dateWithTimeIntervalSinceNow:-self.maximumLogAge]];
}

- (BOOL)didReachMaxLogSize
{
	//JJLogDebugTrace();
	BOOL reachedMaxSize = NO;
    
	if (self.isStarted)
	{
        NSError *error = nil;
        NSDictionary *logFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[[self.logDirectory stringByAppendingPathComponent:self.logBasename] stringByAppendingPathExtension:kLogFileExtension] error:&error];
        if (error != nil)
        {
            JJLogError(JJLogModuleNameLog, @"[JJLog didReachMaxLogSize] Could not get the log file attributes. Got error: %@.", error);
        }
        else if ([logFileAttributes fileSize] >= kDefaultMaximumLogSize)
        {
            reachedMaxSize = YES;
        }
		//JJLogTrace(JJLogModuleNameLog, @"[JJLog didReachMaxLogSize] The log file %@ reach the maximum log size.",
					//(reachedMaxSize ? @"did" : @"did not"));
	}
	else
	{
		JJLogTrace(JJLogModuleNameLog, @"[JJLog didReachMaxLogSize] Logging is not started.");
	}
    
	return reachedMaxSize;
}

- (void)removeAllLogs
{
	if (self.isStarted)
	{
		self.clearLogs = YES;
		[self stopLogging];
	}
	else
	{
		[self deleteLogDirectory];
	}
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark Threaded methods
///////////////////////////////////////////////////////////////////////////////

//
// (Logging Thread) startRunLoop:
//
- (void)startRunLoop:(id)sender
{
	@autoreleasepool {

		[[NSThread currentThread] setName:@"JJLog"];
		
		do
		{
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
		} while (self.isStarted);
		
		
		[self.fileHandle closeFile];
		self.fileHandle = nil;
		
		if (self.clearLogs)
		{
			[self deleteLogDirectory];
		}
	
	}
}

//
// (Logging Thread) writeLogMessage:
//
- (void)writeLogMessage:(NSString *)message
{
    const char *cmessage = [message UTF8String];
	size_t cmessage_len = strlen(cmessage);
    size_t message_writed_len = 0;
    
    if (cmessage_len >= LOG_BUFF_MAX_SIZE-1 )
    {
        if (_currentBuffSize > 0 )
        {
            [self writeLogBuffToFile:_logBuff buffSize:_currentBuffSize];
            message_writed_len += _currentBuffSize;
            _currentBuffSize = 0;
        }
        
        [self writeLogBuffToFile:cmessage buffSize:cmessage_len];
         message_writed_len += cmessage_len;
    }
    else if (_currentBuffSize + cmessage_len > LOG_BUFF_MAX_SIZE-1)
    {
        [self writeLogBuffToFile:_logBuff buffSize:_currentBuffSize];
         message_writed_len += _currentBuffSize;
        
        memcpy(_logBuff, cmessage, cmessage_len);
        _currentBuffSize = cmessage_len;
    }
    else
    {
        memcpy(_logBuff+_currentBuffSize, cmessage, cmessage_len);
        _currentBuffSize += cmessage_len;
    }
    
    if (message_writed_len>0)
    {
        [self rotateLogFilesIfNeeded:message_writed_len];
    }
}

- (void)writeLogBuffToFile:(const char *)cmessage buffSize:(size_t)cmessage_len
{	
	
		
#if JJLOG_DEBUG
	write(STDOUT_FILENO, cmessage, cmessage_len);
#endif
	
	if (self.fileHandle != nil)
	{
		@try
		{
			write([self.fileHandle fileDescriptor], cmessage, cmessage_len);
		}
		@catch (id e)
		{
			NSLog(@"ERROR: Could not write to log file. Switching to console: %@", e);
#if JJLOG_CONSOLE
			write(STDOUT_FILENO, cmessage, cmessage_len);
#endif
			self.fileHandle = nil;
		}
	}
	else
	{
#if JJLOG_CONSOLE
		write(STDOUT_FILENO, cmessage, cmessage_len);
#endif
	}

}

- (void)rotateLogFilesIfNeeded:(size_t)cmessage_len
{
    static unsigned long long total_written_logsize = 0;
    
    if (self.fileHandle != nil)
	{
		total_written_logsize += cmessage_len;
		if (total_written_logsize > self.maximumLogSize)
		{
			// Send a message to the application to roll the logs
			NSString *rollMessage = [NSString stringWithFormat:@"JJLog maximum log file size exceeded, restarting logging"];
			NSNotification *notification = [NSNotification notificationWithName:JJLogMaximumLogSizeExceededNotification object:nil];
			[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
            
            const char *maxSizeMessage = [rollMessage UTF8String];
            size_t maxSizeMessage_len = strlen(maxSizeMessage);

			@try
			{
				write([self.fileHandle fileDescriptor], maxSizeMessage, maxSizeMessage_len);
			}
			@catch (id e)
			{
				NSLog(@"ERROR: Could not write to log file. Switching to console: %@", e);
#if JJLOG_CONSOLE
				write(STDOUT_FILENO, maxSizeMessage, maxSizeMessage_len);
#endif
				self.fileHandle = nil;
			}

			total_written_logsize = 0;
			[self restartLogging];
		}
	}
}

//
// (Background Thread) removeOldLogsStartingWithDate:
// Removes expired log files (logs from before the specified date), then uses the removeOldLogsUpToSizeLimit: method
// to remove old log files (starting with the oldest) until the logs directory's total size no longer exceeds the max size.
//
- (void)removeOldLogsStartingWithDate:(NSDate *)aDate
{
	@autoreleasepool {
		[NSThread sleepForTimeInterval:30.0];	// Don't even try to do this unless it's a "long run"
		JJLogInfo(JJLogModuleNameLog, @"Cleaning logs older than %@", aDate);

		NSFileManager *fm = [[NSFileManager alloc] init];
		NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:self.logDirectory];
		[dirEnum skipDescendents];
		
		for (NSString *file in dirEnum)
		{
            if ([kLogCleanFileExtensionArray containsObject:[file pathExtension]])
			{
				NSDate *fileModDate = [[fm attributesOfItemAtPath:[self.logDirectory stringByAppendingPathComponent:file] error:NULL] objectForKey:NSFileModificationDate];
				if ([fileModDate compare:aDate] == NSOrderedAscending)
				{
					JJLogTrace(JJLogModuleNameLog, @"Removing log file: %@", file);
					NSError *error;
					if (![fm removeItemAtPath:[self.logDirectory stringByAppendingPathComponent:file] error:&error])
					{
						JJLogError(JJLogModuleNameLog, @"Could not remove file (%@): %@", file, [error localizedDescription]);
					}
				}

				[NSThread sleepForTimeInterval:1.0]; // No need to hurry
			}
		}

		// Remove old log files (starting with the oldest) until the logs directory's total size no longer exceeds the max size.
		[self removeOldLogsUpToSizeLimit:[NSNumber numberWithUnsignedLongLong:(unsigned long long)(self.maximumLogSize * kDefaultLogSizeMultiplier)]];

	}
}

//
// (Background Thread) removeOldLogsUpToSizeLimit:
//
- (void)removeOldLogsUpToSizeLimit:(NSNumber *)maxLogDirectorySize
{
    const NSTimeInterval kMinimumLogTime = -600.0; // Minimum time to keep a log file is ten minutes - the '-' sign means "in the past"

	@autoreleasepool {
		JJLogInfo(JJLogModuleNameLog, @"[JJLog removeOldLogsUpToSizeLimit:] Cleaning logs such that the total log directory size will be below %@ bytes.", maxLogDirectorySize);

		NSFileManager *fm = [[NSFileManager alloc] init];
		NSString *file = nil;
		NSString *filePath = nil;
		NSError *error = nil;
		unsigned long long currentDirectorySize = 0;
		unsigned long long deletedFileSize = 0;

		// Get the log directory total size
		NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:self.logDirectory];
		[dirEnum skipDescendents];
		//Note: This assumes the logs directory is a simple, flat directory containing nothing but the application's log files.
		for (file in dirEnum)
		{
			currentDirectorySize += [[fm attributesOfItemAtPath:[self.logDirectory stringByAppendingPathComponent:file] error:NULL] fileSize];
		}

		// If the total size is greater than the allotted size, need to delete some logs
		if (currentDirectorySize > [maxLogDirectorySize unsignedLongLongValue])
		{
			NSArray *dirContents = [fm contentsOfDirectoryAtPath:self.logDirectory error:nil]; // Shallow search
			// Sort the array in ascending order by file name (which is the date and time of the log).
			dirContents = [dirContents sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES]]];

			file = nil;
			for (NSUInteger i = 0; (currentDirectorySize > [maxLogDirectorySize unsignedLongLongValue]) && (i < [dirContents count]); i++)
			{
				file = [dirContents objectAtIndex:i];
                if ([kLogCleanFileExtensionArray containsObject:[file pathExtension]])
				{
					filePath = [self.logDirectory stringByAppendingPathComponent:file];

                // Only remove the file if it's not too recent
                if ([[[fm attributesOfItemAtPath:filePath error:NULL] fileModificationDate] timeIntervalSinceNow] <= kMinimumLogTime)
                {
                    JJLogTrace(JJLogModuleNameLog, @"[JJLog removeOldLogsUpToSizeLimit:] Removing log file: %@", file);
                    filePath = [self.logDirectory stringByAppendingPathComponent:file];
                    deletedFileSize = [[fm attributesOfItemAtPath:filePath error:NULL] fileSize];
                    error = nil;
                    if ([fm removeItemAtPath:filePath error:&error] == YES)
                    {
                        currentDirectorySize -= deletedFileSize;
                    }
                    else
                    {
                        JJLogError(JJLogModuleNameLog, @"JJLog removeOldLogsUpToSizeLimit: Could not remove file (%@): %@", file, [error localizedDescription]);
                    }
                }
                else
                {
                   JJLogTrace(JJLogModuleNameLog, @"[JJLog removeOldLogsUpToSizeLimit:] Avoided removing log file %@ because it's too recent", file);
                }

					[NSThread sleepForTimeInterval:1.0]; // No need to hurry
				}
			}
		}

	}
}

- (void)deleteLogDirectory
{
	if (self.fileHandle)
	{
		// the logs appear to still active... don't delete yet
		JJLogError(JJLogModuleNameLog, @"[JJLog deleteLogDirectory] - called before logging is shut down");
		return;
	}
	
	NSString *logDirectory = self.logDirectory;
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:logDirectory error:NULL];
}

@end
