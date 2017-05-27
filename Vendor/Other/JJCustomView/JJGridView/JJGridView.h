//
//  JJGridView.h
//  JJObjCTool
//
//  Created by hamilyjing on 9/3/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJGridView : UIView

/**
 * @brief 网格间距，默认30
 */
@property (nonatomic, assign) CGFloat gridSpacing;

/**
 * @brief 网格线宽度，默认为1 pixel (1.0f / [UIScreen mainScreen].scale)
 */
@property (nonatomic, assign) CGFloat gridLineWidth;

/**
 * @brief 网格颜色，默认蓝色
 */
@property (nonatomic, strong) UIColor *gridColor;

@end
