//
//  UIImage+JJ.h
//  JJObjCTool
//
//  Created by JJ on 5/12/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JJ)

#pragma mark - Image name

@property (nonatomic, copy) NSString *jj_imageName;

#pragma mark - Init

+ (UIImage *)jj_initResizebleWidth:(NSString *)imageName;
+ (UIImage *)jj_initResizebleHeight:(NSString *)imageName;

+ (UIImage *)jj_imageNamed:(NSString *)imageName;
+ (UIImage *)jj_imageNamed:(NSString *)imageName filePath:(NSString *)filePath;

+ (NSString *)jj_scaleName:(NSString *)imageName;

#pragma mark - NSData

- (NSData *)jj_dataWithCompressionQuality:(CGFloat)compressionQuality;
- (NSData *)jj_data;

#pragma mark - save

- (BOOL)jj_saveToFile:(NSString *)filePath;

#pragma mark - sub image

- (UIImage *)jj_subImage:(CGRect)rect;

#pragma mark - orientation

- (UIImage *)jj_fixOrientation;

@end
