//
//  JJChangeSkinPhotoItem.h
//  BaiduBrowser
//
//  Created by gongjian03 on 8/31/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "JSONModel.h"

@class JJChangeSkinPhotoItem;

extern NSString *JJChangeSkinPhotoItemSourceSystemPhotoAlbum;

@protocol JJChangeSkinPhotoItem <NSObject>

@end

@interface JJChangeSkinPhotoItemList : JSONModel

@property (nonatomic, strong) NSMutableArray<JJChangeSkinPhotoItem> *items;

- (JJChangeSkinPhotoItem *)photoItemWithName:(NSString *)name;

@end

@interface JJChangeSkinPhotoItem : JSONModel

@property (nonatomic, copy) NSString<Optional> *thumbnailName;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *statusBarStyle;
@property (nonatomic, copy) NSString<Optional> *haveDeletedMark;
@property (nonatomic, copy) NSString<Optional> *source;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *titleColorString;

- (UIImage *)thumbnailPhotoImage;

- (UIImage *)photoImage;

@end
