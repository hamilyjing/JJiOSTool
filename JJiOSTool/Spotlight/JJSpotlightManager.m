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
