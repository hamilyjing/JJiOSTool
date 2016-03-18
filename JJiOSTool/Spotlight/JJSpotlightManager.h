//
//  JJSpotlightManager.h
//
//
//  Created by gongjian03 on 7/22/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JJSpotlightManager : NSObject

@property (nonatomic, assign) BOOL eligibleForPublicIndexing;

+ (instancetype)sharedInstance;

- (void)addWithUniqueIdentifier:(NSString *)uniqueIdentifier
               domainIdentifier:(NSString *)domainIdentifier
                          title:(NSString *)title
             contentDescription:(NSString *)contentDescription
                 thumbnailImage:(UIImage *)thumbnailImage
                   thumbnailURL:(NSURL *)thumbnailURL
                          error:(NSError **)error;

- (void)deleteSearchableItemsWithDomainIdentifiers:(NSArray<NSString *> *)domainIdentifiers completionHandler:(void (^)(NSError *error))completionHandler;

- (void)deleteSearchableItemsWithDomainIdentifier:(NSString *)domainIdentifier completionHandler:(void (^)(NSError *error))completionHandler;

@end
