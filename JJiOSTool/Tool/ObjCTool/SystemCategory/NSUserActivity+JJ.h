//
//  NSUserActivity+JJ.h
//  BaiduBrowser
//
//  Created by gongjian03 on 8/10/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if 90000 <= __IPHONE_OS_VERSION_MAX_ALLOWED

@interface NSUserActivity (JJ)

+ (void)jj_searchWithActivityType:(NSString *)activityType
                            title:(NSString *)title
               contentDescription:(NSString *)contentDescription
                   thumbnailImage:(UIImage *)thumbnailImage
                     thumbnailURL:(NSURL *)thumbnailURL
                         keyWords:(NSSet<NSString *> *)keyWords
                         userInfo:(NSDictionary *)userInfo
                 isPublicIndexing:(BOOL)isPublicIndexing;

@end

#endif
