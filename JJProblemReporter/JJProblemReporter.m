//
//  JJProblemReporter.m
//  JJObjCTool
//
//  Created by gongjian03 on 7/30/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import "JJProblemReporter.h"

#import <MessageUI/MessageUI.h>

#ifdef JJ_USE_PLCRASHREPORT
#import <CrashReporter/CrashReporter.h>

#import "PLCrashReporter+JJ.h"

static void post_crash_callback(siginfo_t *info, ucontext_t *uap, void *context);
#endif

#import "Main.h"
#import "NSDate+JJ.h"
#import "NSFileManager+JJ.h"
#import "UIAlertController+JJ.h"
#import "UIDevice+JJ.h"
#import "NSDictionary+JJ.h"

static NSString * const JJPRTDateFormatString = @"yyyy-MM-dd-HHmmss";

@interface JJProblemReporter () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *toRecipients;
@property (nonatomic, copy) void (^completionBlock)();

@end

@implementation JJProblemReporter

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JJProblemReporterConfig" ofType:@"plist"];
        NSDictionary *prtConfigDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        self.toRecipients = prtConfigDic[@"toRecipients"];
        
#ifdef JJ_USE_PLCRASHREPORT
        [[PLCrashReporter sharedReporter] jj_enableCrashReporterAndSetCallback:post_crash_callback];
#endif
    }
    
    return self;
}

#pragma mark - public

+ (instancetype)sharedInstance
{
    static JJProblemReporter *s_instance = nil;
    if (s_instance == nil)
    {
        s_instance = [[self alloc] init];
    }
    return s_instance;
}

- (void)sendProblemReporterWithCrashLog:(BOOL)needCrashLog_
                             completion:(void (^)(void))completion_
{
    if (![MFMailComposeViewController canSendMail])
    {
        [UIAlertController jj_showAlertInViewController:[UIApplication sharedApplication].delegate.window.rootViewController withTitle:NSLocalizedString(@"Unable to send mail", nil) message:NSLocalizedString(@"We can't find an email account, which we use to send your problem report. Make sure that there is an email account set up on your mobile device.",
                                                                                                                                                                                                                nil) cancelButtonTitle:NSLocalizedString(@"OK", nil) destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * __nonnull controller, UIAlertAction * __nonnull action, NSInteger buttonIndex) {
            
        }];
        
        return;
    }
    
    NSString *fileSizePath = [self.logFilePath stringByAppendingPathComponent:@"fileSize.log"];
    [NSFileManager jj_printAllFileSizeToFilePath:fileSizePath fromDirPathArray:@[[NSFileManager jj_documentsDirectory], [NSFileManager jj_libraryDirectory]]];
    
    // zip log
    NSString *zipFilePath = [self logZipFilePath];
    BOOL success = [Main createZipFileAtPath:zipFilePath withContentsOfDirectory:self.logFilePath];
    if (!success)
    {
        NSAssert(NO, @"Zip failed, from: %@, to: %@", self.logFilePath, zipFilePath);
        return;
    }
    
    MFMailComposeViewController *mailVC = nil;
    mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    
    [mailVC setToRecipients:self.toRecipients];
    [mailVC setMessageBody:NSLocalizedString(@"Enter your problem description below:", nil) isHTML:NO];
    
    NSString *appName = [UIDevice jj_appName];
    NSString *nowDateString = [[NSDate date] jj_currentLocaleStringWithDateFormatString:JJPRTDateFormatString];
    
    if (needCrashLog_)
    {
        [mailVC setSubject:[[NSString alloc] initWithFormat:NSLocalizedString(@"Crash Problem Report: %@ (%@) for %@ (%@)", @"Narrative: Problem report email subject line"), appName, [UIDevice jj_bundleVersion], [UIDevice jj_platformSimpleDescription], [UIDevice jj_systemVersion], nowDateString]];
    }
    else
    {
        [mailVC setSubject:[[NSString alloc] initWithFormat:NSLocalizedString(@"Problem Report: %@ (%@) for %@ (%@)", @"Narrative: Problem report email subject line"), appName, [UIDevice jj_bundleVersion], [UIDevice jj_platformSimpleDescription], [UIDevice jj_systemVersion], nowDateString]];
    }
    
    [mailVC addAttachmentData:[NSData dataWithContentsOfFile:zipFilePath] mimeType:@"application/zip" fileName:[zipFilePath lastPathComponent]];
    
    NSError *removeError;
    [[NSFileManager defaultManager] removeItemAtPath:zipFilePath error:&removeError];
    if (removeError)
    {
        NSAssert(NO, @"Remove zip log file falied, error: %@", removeError);
    }
    
    self.completionBlock = completion_;
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:mailVC animated:YES completion:nil];
}

- (void)alertOccuredCrashIfNeededWithCompletion:(void (^)(void))completion_
{
#ifdef JJ_USE_PLCRASHREPORT
    if (![[PLCrashReporter sharedReporter] hasPendingCrashReport])
    {
        if (completion_)
        {
            completion_();
        }
        return;
    }
    
    [[PLCrashReporter sharedReporter] purgePendingCrashReport];
    
    [UIAlertController jj_showAlertInViewController:[UIApplication sharedApplication].delegate.window.rootViewController withTitle:[UIDevice jj_appName] message:NSLocalizedString(@"Stopped unexpectedly. Do you want to send a problem report?", nil) cancelButtonTitle:NSLocalizedString(@"Do Not Send", nil) destructiveButtonTitle:NSLocalizedString(@"Send", nil) otherButtonTitles:nil tapBlock:^(UIAlertController * __nonnull controller, UIAlertAction * __nonnull action, NSInteger buttonIndex)
    {
        if (buttonIndex == controller.jj_cancelButtonIndex)
        {
            if (completion_)
            {
                completion_();
            }
        }
        else if (buttonIndex == controller.jj_destructiveButtonIndex)
        {
            [self sendProblemReporterWithCrashLog:YES completion:completion_];
        }
    }];
#else
    if (completion_)
    {
        completion_();
    }
#endif
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (MFMailComposeResultSent == result)
    {
        [self cleanCrashLog];
    }
    
    if (self.completionBlock)
    {
        self.completionBlock();
        self.completionBlock = nil;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private

- (NSString *)logZipFilePath
{
    NSString *appName = [UIDevice jj_appName];
    NSString *bundleVersion = [UIDevice jj_bundleVersion];
    NSString *nowDateString = [[NSDate date] jj_currentLocaleStringWithDateFormatString:JJPRTDateFormatString];
    NSString *platformSimpleDescription = [UIDevice jj_platformSimpleDescription];
    platformSimpleDescription = [platformSimpleDescription stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *systemVersion = [UIDevice jj_systemVersion];
    
    NSString *logZipFilePath = [NSFileManager jj_tempDirectory];
    logZipFilePath = [logZipFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@(%@)-%@(%@)-time(%@)-LOGS.zip", appName, bundleVersion, platformSimpleDescription, systemVersion, nowDateString]];
    
    return logZipFilePath;
}

- (void)cleanCrashLog
{
    NSString* logDir = self.logFilePath;
    if (![logDir length])
        return;
    
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum =[localFileManager enumeratorAtPath:logDir];
    
    NSString *file;
    while (file = [dirEnum nextObject])
    {
        if ([[file pathExtension] isEqualToString: @"crash"])
        {
            NSError* error = nil;
            NSString* path = [logDir stringByAppendingPathComponent:file];
            if (![localFileManager removeItemAtPath:path error:&error])
            {
                NSAssert(NO, @"remove file: %@ failed. error: %@", path, error);
            }
        }
    }
}

#pragma mark - getter and setter

- (void)setLogFilePath:(NSString *)logFilePath_
{
    if (_logFilePath == logFilePath_)
    {
        return;
    }
    
    _logFilePath = logFilePath_;
    
#ifdef JJ_USE_PLCRASHREPORT
    [[PLCrashReporter sharedReporter] jj_saveCrashLogWithCrashLogFilePath:_logFilePath];
#endif
}

@end

#ifdef JJ_USE_PLCRASHREPORT
static void post_crash_callback (siginfo_t *info, ucontext_t *uap, void *context)
{
}
#endif
