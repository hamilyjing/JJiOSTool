//
//  JJSpotlightManager.m
//  
//
//  Created by gongjian03 on 7/22/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "JJSpotlightManager.h"

#import "CSSearchableIndex+JJ.h"
#import "NSUserActivity+JJ.h"

@implementation JJSpotlightManager

#pragma mark - life cycle

/*
+ (void)load
{
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.baidu.BDPhoneBrowser11"];
    userActivity.title = @"12345678";
    userActivity.keywords = [NSSet setWithArray:@[@"gongjian", @"jing"]];
    userActivity.userInfo = @{@"ff": @"gg"};
    userActivity.eligibleForSearch = YES;
    //userActivity.eligibleForPublicIndexing = NO;
    //userActivity.webpageURL = [NSURL URLWithString:@"www.baidu.com"];
    //userActivity.requiredUserInfoKeys = [NSSet setWithArray:@[@"ff"]];
    [userActivity becomeCurrent];
    
    //return;
    
    NSError *error;
    
    NSInteger i = 0;
    for (; i < 100; ++i)
    {
        NSString *str = [NSString stringWithFormat:@"趣星球%ld", (long)i];
        NSString *key = [NSString stringWithFormat:@"tucao%ld", (long)i];
        [CSSearchableIndex jj_addToSpotlightWithTitle:@"百度浏览器"
                                contentDescription:str
                                             image:[UIImage imageNamed:@"tucao_icon@2x.png"]
                                  uniqueIdentifier:key
                                  domainIdentifier:@"com.baidu.BDPhoneBrowser.tucao"
                                             error:&error];
    }
    
    [CSSearchableIndex jj_addToSpotlightWithTitle:@"百度浏览器"
                            contentDescription:@"趣星球"
                                         image:[UIImage imageNamed:@"tucao_icon@2x.png"]
                              uniqueIdentifier:@"tucao"
                              domainIdentifier:@"com.baidu.BDPhoneBrowser.tucao"
                                         error:&error];
}
 
 */

#pragma mark - public

+ (instancetype)sharedInstance
{
    static dispatch_once_t token;
    static JJSpotlightManager *s_instance;
    dispatch_once(&token, ^{
        s_instance = [[self alloc] init];
    });
    return s_instance;
}

- (void)addWithUniqueIdentifier:(NSString *)uniqueIdentifier_
               domainIdentifier:(NSString *)domainIdentifier_
                          title:(NSString *)title_
             contentDescription:(NSString *)contentDescription_
                 thumbnailImage:(UIImage *)thumbnailImage_
                   thumbnailURL:(NSURL *)thumbnailURL_
                          error:(NSError **)error_
{
#if 90000 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0)
    {
        return;
    }
    
    // for core spotlight
    [CSSearchableIndex jj_addToSpotlightWithTitle:title_
                               contentDescription:contentDescription_
                                            image:thumbnailImage_
                                         imageURL:thumbnailURL_
                                 uniqueIdentifier:uniqueIdentifier_
                                 domainIdentifier:domainIdentifier_
                                            error:error_];
    
    // for NSUserActivity
    //[NSUserActivity jj_searchWithActivityType:domainIdentifier_ title:title_ contentDescription:contentDescription_ thumbnailImage:thumbnailImage_ thumbnailURL:thumbnailURL_ keyWords:[NSSet setWithArray:@[title_, contentDescription_]] userInfo:@{@"kCSSearchableItemActivityIdentifier": uniqueIdentifier_} isPublicIndexing:self.eligibleForPublicIndexing];
    
#endif
}

- (void)deleteSearchableItemsWithDomainIdentifiers:(NSArray<NSString *> *)domainIdentifiers_ completionHandler:(void (^)(NSError *error))completionHandler_
{
#if 90000 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0)
    {
        return;
    }
    
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:domainIdentifiers_ completionHandler:completionHandler_];
    
#endif
}

- (void)deleteSearchableItemsWithDomainIdentifier:(NSString *)domainIdentifier_ completionHandler:(void (^)(NSError *error))completionHandler_
{
    return [self deleteSearchableItemsWithDomainIdentifiers:[NSArray arrayWithObject:domainIdentifier_] completionHandler:completionHandler_];
}

@end
