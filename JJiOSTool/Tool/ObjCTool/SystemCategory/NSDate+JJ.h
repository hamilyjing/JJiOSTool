//
//  NSDate+JJ.h
//  JJObjCTool
//
//  Created by gongjian03 on 7/31/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JJ)

#pragma mark - date formatter

- (NSString *)jj_stringWithDateFormatString:(NSString *)dateFormatString currentLocale:(BOOL)currentLocale;

- (NSString *)jj_currentLocaleStringWithDateFormatString:(NSString *)dateFormatString;

- (NSString *)jj_stringWithDateFormatString:(NSString *)dateFormatString;

@end
