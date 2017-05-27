//
//  JJChangeSkinManager.m
//  BaiduBrowser
//
//  Created by hamilyjing on 8/27/15.
//  Copyright © 2015. All rights reserved.
//

#import "JJChangeSkinManager.h"

#import "JJChangeSkinPureColorItem.h"
#import "JJChangeSkinPhotoItem.h"
#import "NSData+JJ.h"
#import "UIColor+JJ.h"
#import "NSFileManager+JJ.h"
#import "UIImage+JJ.h"

NSString *JJChangeSkinNofiticationName = @"JJChangeSkinNofiticationName";
NSString *JJChangeSkinNofiticationUserInfoPureColorStringKey = @"JJChangeSkinNofiticationUserInfoPureColorStringKey";
NSString *JJChangeSkinNofiticationUserInfoPhotoNameStringKey = @"JJChangeSkinNofiticationUserInfoPhotoNameStringKey";

static NSString *JJChangeSkinPureColorStringKey = @"JJChangeSkinPureColorStringKey";
static NSString *JJChangeSkinPhotoNameKey = @"JJChangeSkinPhotoNameKey";

@implementation JJChangeSkinManager

#pragma mark - life cycle

- (instancetype)init
{
    //换肤界面预览，调用方法
//    [[BDPhoneFavoritesDataManager sharedInstance] resetContentOffsetForSkin:^(BOOL completion) {
//        if (completion) {//重设成功
//            ;
//        } else {//重设失败
//        
//        }
//    }];
    
    self = [super init];
    if (self)
    {
        [self __setUp];
    }
    
    return self;
}

#pragma mark - public

+ (instancetype)sharedInstance
{
    static JJChangeSkinManager *s_instance = nil;
    if (s_instance == nil)
    {
        s_instance = [[self alloc] init];
    }
    return s_instance;
}

- (UIStatusBarStyle)pureColorStatusBarStyle
{
    NSString *colorString = [self pureColorString];
    JJChangeSkinPureColorItem *item = self.pureColorItemDic[colorString];
    if ([item.statusBarStyle isEqualToString:@"dark"])
    {
        return UIStatusBarStyleDefault;
    }
    else
    {
        return UIStatusBarStyleLightContent;
    }
}

- (UIStatusBarStyle)photoImageStatusBarStyle
{
    NSString *photoName = [self photoNameString];
    if (!photoName)
    {
        return [self pureColorStatusBarStyle];
    }
    
    JJChangeSkinPhotoItem *item = [self.photoItemList photoItemWithName:photoName];
    if ([item.statusBarStyle isEqualToString:@"dark"])
    {
        return UIStatusBarStyleDefault;
    }
    else
    {
        return UIStatusBarStyleLightContent;
    }
}

- (UIColor *)pureColor
{
    NSString *colorString = [self pureColorString];
    return [UIColor jj_colorWithHexString:colorString];
}

- (UIImage *)photoImage
{
    NSString *photoName = [self photoNameString];
    if (!photoName)
    {
        return nil;
    }
    
    JJChangeSkinPhotoItem *item = [self.photoItemList photoItemWithName:photoName];
    UIImage *image = [item photoImage];
    return image;
}

- (NSString *)pureColorString
{
    if ([self photoNameString])
    {
        return self.defaultPureColorString;
    }
    
    NSString *colorStr = [[NSUserDefaults standardUserDefaults] objectForKey:JJChangeSkinPureColorStringKey];
    if (colorStr)
    {
        JJChangeSkinPureColorItem *item = self.pureColorItemDic[colorStr];
        if (item)
        {
            return item.colorString;
        }
        else
        {
            return self.defaultPureColorString;
        }
    }
    else
    {
        return self.defaultPureColorString;
    }
}

- (NSString *)photoNameString
{
    NSString *photoName = [[NSUserDefaults standardUserDefaults] objectForKey:JJChangeSkinPhotoNameKey];
    return photoName;
}

- (NSString *)pureColorTitleString
{
    NSString *name = [self pureColorString];
    JJChangeSkinPureColorItem *item = self.pureColorItemDic[name];
    return item.title;
}

- (NSString *)photoTitleString
{
    NSString *photoName = [self photoNameString];
    if (photoName)
    {
        JJChangeSkinPhotoItem *item = [self.photoItemList photoItemWithName:photoName];
        return item.title;
    }
    else
    {
        return [self pureColorTitleString];
    }
}

- (void)changePureColor:(NSString *)colorString_
{
    if (!colorString_)
    {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:JJChangeSkinPhotoNameKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:colorString_ forKey:JJChangeSkinPureColorStringKey];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:JJChangeSkinNofiticationName object:nil userInfo:@{JJChangeSkinNofiticationUserInfoPureColorStringKey: colorString_}];
}

- (void)changePhotoName:(NSString *)photoName_
{
    if (!photoName_)
    {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:JJChangeSkinPureColorStringKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:photoName_ forKey:JJChangeSkinPhotoNameKey];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:JJChangeSkinNofiticationName object:nil userInfo:@{JJChangeSkinNofiticationUserInfoPhotoNameStringKey: photoName_}];
}

- (void)saveSystemPhotoWithName:(NSString *)name_ image:(UIImage *)image_
{
    JJChangeSkinPhotoItem *photoItem = [[JJChangeSkinPhotoItem alloc] init];
    photoItem.name = name_;
    photoItem.source = JJChangeSkinPhotoItemSourceSystemPhotoAlbum;
    
    CGSize imageSize = image_.size;
    CGRect rect = CGRectMake((imageSize.width - imageSize.height) * 0.5, 0, imageSize.height, imageSize.height);
    UIImage *thumbnailImage = [image_ jj_subImage:rect];
    NSString *thumbnailName = [@"thumbnail-" stringByAppendingString:name_];
    NSString *thumbnailFilePath = [self.changeSkinPhotoDirectory stringByAppendingPathComponent:thumbnailName];
    if ([thumbnailImage jj_saveToFile:thumbnailFilePath])
    {
        photoItem.thumbnailName = thumbnailName;
    }
    
    if ([self.photoItemList.items count] >= 2)
    {// only show two user picture
        JJChangeSkinPhotoItem *secondPhotoItem = self.photoItemList.items[1];
        if ([secondPhotoItem.source isEqualToString:JJChangeSkinPhotoItemSourceSystemPhotoAlbum])
        {
            JJChangeSkinPhotoItem *removedPhotoItem;
            if ([[self photoNameString] isEqualToString:secondPhotoItem.name])
            {
                removedPhotoItem = self.photoItemList.items[0];
                [self.photoItemList.items removeObjectAtIndex:0];
            }
            else
            {
                removedPhotoItem = self.photoItemList.items[1];
                [self.photoItemList.items removeObjectAtIndex:1];
            }
            
            [self __removePhotoCache:removedPhotoItem];
        }
    }
    
    [self.photoItemList.items insertObject:photoItem atIndex:0];
    
    [self __savePhotoItemList];
}

#pragma mark - private

- (void)__setUp
{
    [self __readPureColorConfig];
    
    [self __readPhotoConfig];
}

- (void)__readPureColorConfig
{
    NSString *pureColorConfigFilePath = [[NSBundle mainBundle] pathForResource:@"JJChangeSkinPureColorConfig" ofType:@"json"];
    NSDictionary *fileContent = [NSData jj_dictionaryWithJSONByFilePath:pureColorConfigFilePath];
    
    NSMutableDictionary *mPureColorItemArray = [NSMutableDictionary dictionary];
    
    NSArray *items = fileContent[@"items"];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         JJChangeSkinPureColorItem *item = [[JJChangeSkinPureColorItem alloc] init];
         item.index = [obj[@"index"] integerValue];
         item.colorString = obj[@"color"];
         item.statusBarStyle = obj[@"statusBarStyle"];
         item.title = obj[@"title"];
         item.titleColorString = obj[@"titleColor"];
         
         mPureColorItemArray[item.colorString] = item;
         
         NSString *defaultColor = obj[@"default"];
         if (defaultColor && [defaultColor boolValue])
         {
             self.defaultPureColorString = item.colorString;
         }
     }];
    
    self.pureColorItemDic = mPureColorItemArray;
}

- (NSMutableArray *)__readPhotoConfigWithFilePath:(NSString *)filePath_
{
    NSDictionary *fileContent = [NSData jj_dictionaryWithJSONByFilePath:filePath_];
    
    NSMutableArray *mPhotoItemArray = [NSMutableArray arrayWithCapacity:4];
    
    NSArray *items = fileContent[@"items"];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         JJChangeSkinPhotoItem *item = [[JJChangeSkinPhotoItem alloc] init];
         item.thumbnailName = obj[@"thumbnailName"];
         item.name = obj[@"name"];
         item.statusBarStyle = obj[@"statusBarStyle"];
         item.title = obj[@"title"];
         item.titleColorString = obj[@"titleColor"];
         
         [mPhotoItemArray addObject:item];
     }];
    
    return mPhotoItemArray;
}

- (void)__readPhotoConfig
{
    NSString *photoConfigFilePath = [[NSBundle mainBundle] pathForResource:@"JJChangeSkinPhotoConfig" ofType:@"json"];
    
    NSString *cachePhotoConfigFilePath = [[BDFileManager changeSkinPhotoPath] stringByAppendingPathComponent:@"JJChangeSkinPhotoConfig.archiver"];
    JJChangeSkinPhotoItemList *photoItemList = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePhotoConfigFilePath];
    if (!photoItemList)
    {
        NSDictionary *fileContent = [NSData jj_dictionaryWithJSONByFilePath:photoConfigFilePath];
        NSError *error;
        photoItemList = [[JJChangeSkinPhotoItemList alloc] initWithDictionary:fileContent error:&error];
        
        self.photoItemList = photoItemList;
    }
    else
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [photoItemList.items enumerateObjectsUsingBlock:^(JJChangeSkinPhotoItem *obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            dic[obj.name] = @"";
        }];
        
        NSMutableArray *mPhotoItemArray = [self __readPhotoConfigWithFilePath:photoConfigFilePath];
        [mPhotoItemArray enumerateObjectsUsingBlock:^(JJChangeSkinPhotoItem *obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if (![dic objectForKey:obj.name])
            {
                [photoItemList.items addObject:obj];
            }
        }];
        
        self.photoItemList = photoItemList;
    }
}

- (void)__savePhotoItemList
{
    NSString *cachePhotoConfigFilePath = [[BDFileManager changeSkinPhotoPath] stringByAppendingPathComponent:@"JJChangeSkinPhotoConfig.archiver"];
    BOOL success = [NSKeyedArchiver archiveRootObject:_photoItemList toFile:cachePhotoConfigFilePath];
    if (!success)
    {
        NSAssert(NO, @"Archiver object() to file() failed!", _photoItemList, cachePhotoConfigFilePath);
    }
}

- (void)__removePhotoCache:(JJChangeSkinPhotoItem *)photoItem_
{
    if (photoItem_.name.length > 0)
    {
        NSString *nameFilePath = [self.changeSkinPhotoDirectory stringByAppendingPathComponent:photoItem_.name];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:nameFilePath error:&error];
    }
    
    if (photoItem_.thumbnailName.length > 0)
    {
        NSString *thumbnailNameFilePath = [self.changeSkinPhotoDirectory stringByAppendingPathComponent:photoItem_.thumbnailName];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:thumbnailNameFilePath error:&error];
    }
}

#pragma mark - getter and setter

- (void)setPhotoItemList:(JJChangeSkinPhotoItemList *)photoItemList_
{
    if (_photoItemList == photoItemList_)
    {
        return;
    }
    
    _photoItemList = photoItemList_;
    
    [self __savePhotoItemList];
}

- (NSString *)changeSkinPhotoDirectory
{
    if (_changeSkinPhotoDirectory)
    {
        return _changeSkinPhotoDirectory;
    }
    
    NSString *directory = [NSFileManager jj_cachesDirectory];
    directory = [directory stringByAppendingPathComponent:@"changeSkin/photo"];
    [NSFileManager jj_createDirectoryAtPath:directory];
    _changeSkinPhotoDirectory = directory;
    return _changeSkinPhotoDirectory;
}

@end
