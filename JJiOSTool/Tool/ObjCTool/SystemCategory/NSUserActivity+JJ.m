//
//  NSUserActivity+JJ.m
//  BaiduBrowser
//
//  Created by gongjian03 on 8/10/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "NSUserActivity+JJ.h"

#if 90000 <= __IPHONE_OS_VERSION_MAX_ALLOWED

#import <CoreSpotlight/CoreSpotlight.h>

@implementation NSUserActivity (JJ)

+ (void)jj_searchWithActivityType:(NSString *)activityType_
                            title:(NSString *)title_
               contentDescription:(NSString *)contentDescription_
                   thumbnailImage:(UIImage *)thumbnailImage_
                     thumbnailURL:(NSURL *)thumbnailURL_
                         keyWords:(NSSet<NSString *> *)keyWords_
                         userInfo:(NSDictionary *)userInfo_
                 isPublicIndexing:(BOOL)isPublicIndexing_
{
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:activityType_];
    userActivity.eligibleForSearch = YES;
    
    userActivity.title = title_;
    userActivity.contentAttributeSet.contentDescription = contentDescription_;
    if (thumbnailImage_) {
        NSData *imageData = UIImagePNGRepresentation(thumbnailImage_);
        if (!imageData)
        {
            imageData = UIImageJPEGRepresentation(thumbnailImage_, 1.0);
        }
        if (imageData) {
            userActivity.contentAttributeSet.thumbnailData = imageData;
        }
    }
    userActivity.contentAttributeSet.thumbnailURL = thumbnailURL_;
    userActivity.keywords = keyWords_;
    
    userActivity.userInfo = userInfo_;
    
    if (isPublicIndexing_)
    {
        userActivity.eligibleForPublicIndexing = isPublicIndexing_;
    }
    
    [userActivity becomeCurrent];
}

@end

#endif
