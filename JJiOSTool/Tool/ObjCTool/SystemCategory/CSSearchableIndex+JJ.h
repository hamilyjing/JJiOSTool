//
//  CSSearchableIndex+JJ.h
//  BaiduBrowser
//
//  Created by gongjian03 on 7/18/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if 90000 <= __IPHONE_OS_VERSION_MAX_ALLOWED

#import <CoreSpotlight/CoreSpotlight.h>

@interface CSSearchableIndex (JJ)

+ (void)jj_addToSpotlightWithTitle:(NSString *)title
                contentDescription:(NSString *)contentDescription
                             image:(UIImage *)image
                          imageURL:(NSURL *)imageURL
                  uniqueIdentifier:(NSString *)uniqueIdentifier
                  domainIdentifier:(NSString *)domainIdentifier
                             error:(NSError **)error;

@end

#endif
