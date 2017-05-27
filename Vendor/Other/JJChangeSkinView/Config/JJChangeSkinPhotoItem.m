//
//  JJChangeSkinPhotoItem.m
//  BaiduBrowser
//
//  Created by gongjian03 on 8/31/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "JJChangeSkinPhotoItem.h"

#import "JJChangeSkinManager.h"
#import "UIImage+JJ.h"

NSString *JJChangeSkinPhotoItemSourceSystemPhotoAlbum = @"JJChangeSkinPhotoItemSourceSystemPhotoAlbum";

@implementation JJChangeSkinPhotoItemList

- (JJChangeSkinPhotoItem *)photoItemWithName:(NSString *)name_
{
    for (JJChangeSkinPhotoItem *obj in self.items)
    {
        if ([obj.name isEqualToString:name_])
        {
            return obj;
        }
    }
    
    return nil;
}

@end

@implementation JJChangeSkinPhotoItem

- (UIImage *)thumbnailPhotoImage
{
    if (!self.thumbnailName)
    {
        return [self photoImage];
    }
    
    NSString *path;
    if (self.source)
    {
        path = [[JJChangeSkinManager sharedInstance] changeSkinPhotoDirectory];
    }
    
    UIImage *image = [UIImage jj_imageNamed:self.thumbnailName filePath:path];
    return image;
}

- (UIImage *)photoImage
{
    NSString *path;
    if (self.source)
    {
        path = [[JJChangeSkinManager sharedInstance] changeSkinPhotoDirectory];
    }
    
    UIImage *image = [UIImage jj_imageNamed:self.name filePath:path];
    return image;
}

@end
