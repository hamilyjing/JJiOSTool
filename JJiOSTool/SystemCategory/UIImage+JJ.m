//
//  UIImage+JJ.m
//  JJObjCTool
//
//  Created by JJ on 5/12/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "UIImage+JJ.h"

#import <objc/runtime.h>

@implementation UIImage (JJ)

#pragma mark - Image name

- (NSString *)jj_imageName
{
    return objc_getAssociatedObject(self, &@selector(jj_imageName));
}

- (void)setJj_imageName:(NSString *)imageName
{
    objc_setAssociatedObject(self, &@selector(jj_imageName), imageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Init

+ (UIImage *)jj_initResizebleWidth:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width * 0.5, 0, image.size.width * 0.5) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)jj_initResizebleHeight:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.5, 0, image.size.height * 0.5, 0) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)jj_imageNamed:(NSString *)imageName_
{
    NSString *scaleName = [UIImage jj_scaleName:imageName_];
    
    UIImage *image = [UIImage imageNamed:scaleName];
    if (!image)
    {
        image = [UIImage imageNamed:imageName_];
    }
    
    return image;
}

+ (UIImage *)jj_imageNamed:(NSString *)imageName_ filePath:(NSString *)filePath_
{
    if (!filePath_)
    {
        return [UIImage jj_imageNamed:imageName_];
    }
    
    NSString *scaleName = [UIImage jj_scaleName:imageName_];
    
    NSBundle *pathBundle = [[NSBundle alloc] initWithPath:filePath_];
    UIImage *image;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        image = [UIImage imageWithContentsOfFile:[filePath_ stringByAppendingPathComponent:scaleName]];
        if (!image)
        {
            image = [UIImage imageWithContentsOfFile:[filePath_ stringByAppendingPathComponent:imageName_]];
        }
    }
    else
    {
        image = [UIImage imageNamed:scaleName inBundle:pathBundle compatibleWithTraitCollection:nil];
        if (!image)
        {
            image = [UIImage imageNamed:imageName_ inBundle:pathBundle compatibleWithTraitCollection:nil];
        }
    }
    
    return image;
}

+ (NSString *)jj_scaleName:(NSString *)imageName_
{
    NSString *suffix = [imageName_ pathExtension];
    if (0 == suffix.length || [[suffix lowercaseString] isEqualToString:@"png"])
    {
        return imageName_;
    }
    
    NSString *nameNoSuffix = [imageName_ stringByDeletingPathExtension];
    NSInteger scale = ceil([UIScreen mainScreen].scale);
    
    NSString *scaleName = [NSString stringWithFormat:@"%@@%ldx.%@", nameNoSuffix, (long)scale, suffix];
    
    return scaleName;
}

#pragma mark - NSData

- (NSData *)jj_dataWithCompressionQuality:(CGFloat)compressionQuality
{
    NSData *imageData = UIImagePNGRepresentation(self);
    if (!imageData)
    {
        imageData = UIImageJPEGRepresentation(self, compressionQuality);
    }
    
    return imageData;
}

- (NSData *)jj_data
{
    return [self jj_dataWithCompressionQuality:1.0];
}

#pragma mark - save

- (BOOL)jj_saveToFile:(NSString *)filePath_
{
    NSData *data = [self jj_data];
    if (!data)
    {
        return NO;
    }
    
    BOOL success = [data writeToFile:filePath_ atomically:YES];
    return success;
}

#pragma mark - sub image

- (UIImage *)jj_subImage:(CGRect)rect_
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect_);
    
    CGSize size;
    size.width = rect_.size.width;
    size.height = rect_.size.height;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect_, subImageRef);
    UIImage *subImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return subImage;
}

#pragma mark - orientation

- (UIImage *)jj_fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
