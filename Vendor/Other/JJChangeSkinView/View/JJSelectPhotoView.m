//
//  JJSelectPhotoView.m
//  BaiduBrowser
//
//  Created by gongjian03 on 8/31/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "JJSelectPhotoView.h"

#import "JJCUKFunctionTypeChangeSkinViewDefine.h"
#import "UIView+JJCUK.h"

extern NSString *JJChangeSkinNofiticationUserInfoPhotoNameStringKey;

@implementation JJSelectPhotoView

- (void)setPhotoName:(NSString *)photoName_
{
    [self.selectMark jjCUK_setUserInfoWithObject:photoName_ forKey:JJChangeSkinNofiticationUserInfoPhotoNameStringKey];
    
    self.selectMark.jjCUKFunctionType = JJCUKFunctionTypeChangeSkinViewImageViewSelectedMark;
}

@end
