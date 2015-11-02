//
//  NSDate+JJ.m
//  JJObjCTool
//
//  Created by gongjian03 on 7/31/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "NSDate+JJ.h"

#import <objc/runtime.h>

static NSMutableDictionary *jj_g_s_dateformatDic;

@implementation NSDate (JJ)

#pragma mark - date formatter

- (NSString *)jj_stringWithDateFormatString:(NSString *)dateFormatString_ currentLocale:(BOOL)currentLocale_
{
    if (!jj_g_s_dateformatDic)
    {
        jj_g_s_dateformatDic = [NSMutableDictionary dictionary];
    }
    
    NSDateFormatter *dateFormat = jj_g_s_dateformatDic[dateFormatString_];
    if (!dateFormat)
    {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:dateFormatString_];
        if (currentLocale_)
        {
            dateFormat.locale = [NSLocale currentLocale];
        }
        
        jj_g_s_dateformatDic[dateFormatString_] = dateFormat;
    }
    
    NSString *dateString = [dateFormat stringFromDate:self];
    return dateString;
}

- (NSString *)jj_currentLocaleStringWithDateFormatString:(NSString *)dateFormatString_
{
    return [self jj_stringWithDateFormatString:dateFormatString_ currentLocale:YES];
}

- (NSString *)jj_stringWithDateFormatString:(NSString *)dateFormatString_
{
    return [self jj_stringWithDateFormatString:dateFormatString_ currentLocale:NO];
}

@end
