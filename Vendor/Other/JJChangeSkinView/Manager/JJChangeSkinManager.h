//
//  JJChangeSkinManager.h
//  BaiduBrowser
//
//  Created by hamilyjing on 8/27/15.
//  Copyright © 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JJChangeSkinPhotoItemList;

@interface JJChangeSkinManager : NSObject

@property (nonatomic, copy) NSString *defaultPureColorString;

@property (nonatomic, strong) NSDictionary *pureColorItemDic;
@property (nonatomic, strong) JJChangeSkinPhotoItemList *photoItemList;

@property (nonatomic, strong) NSString *changeSkinPhotoDirectory;

+ (instancetype)sharedInstance;

- (UIStatusBarStyle)pureColorStatusBarStyle;
- (UIStatusBarStyle)photoImageStatusBarStyle;

- (UIColor *)pureColor;
- (UIImage *)photoImage;

- (NSString *)pureColorString;
- (NSString *)photoNameString;

- (NSString *)pureColorTitleString;
- (NSString *)photoTitleString;

- (void)changePureColor:(NSString *)colorString;
- (void)changePhotoName:(NSString *)photoName;

- (void)saveSystemPhotoWithName:(NSString *)name image:(UIImage *)image;

@end
