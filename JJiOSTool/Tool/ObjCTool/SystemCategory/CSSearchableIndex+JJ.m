//
//  CSSearchableIndex+JJ.m
//  BaiduBrowser
//
//  Created by gongjian03 on 7/18/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "CSSearchableIndex+JJ.h"

#if 90000 <= __IPHONE_OS_VERSION_MAX_ALLOWED

@implementation CSSearchableIndex (JJ)

+ (void)jj_addToSpotlightWithTitle:(NSString *)title_
                contentDescription:(NSString *)contentDescription_
                             image:(UIImage *)image_
                          imageURL:(NSURL *)imageURL_
                  uniqueIdentifier:(NSString *)uniqueIdentifier_
                  domainIdentifier:(NSString *)domainIdentifier_
                             error:(NSError **)error_
{
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"image"];
    attributeSet.title = title_;
    attributeSet.contentDescription = contentDescription_;
    if (image_) {
        NSData *imageData = UIImagePNGRepresentation(image_);
        if (!imageData)
        {
            imageData = UIImageJPEGRepresentation(image_, 1.0);
        }
        if (imageData) {
            attributeSet.thumbnailData = imageData;
        }
    }
    attributeSet.thumbnailURL = imageURL_;
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:uniqueIdentifier_ domainIdentifier:domainIdentifier_ attributeSet:attributeSet];
    
    [[self defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * __nullable error)
    {
        if (error_ != NULL)
        {
//            *error_ = error;
        }
    }];
}

@end

#endif
