//
//  JJGridView.m
//  JJObjCTool
//
//  Created by hamilyjing on 9/3/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import "JJGridView.h"

#import "UIView+JJ.h"

@implementation JJGridView

#pragma mark - life cycle

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)awakeFromNib
{
    [self __setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self __setUp];
    }
    
    return self;
}

#pragma mark - public

- (void)setGridColor:(UIColor *)gridColor
{
    _gridColor = gridColor;
    
    [self setNeedsDisplay];
}

- (void)setGridSpacing:(CGFloat)gridSpacing
{
    _gridSpacing = gridSpacing;
    
    [self setNeedsDisplay];
}

- (void)setGridLineWidth:(CGFloat)gridLineWidth
{
    _gridLineWidth = gridLineWidth;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGFloat lineMargin = self.gridSpacing;
    
    /**
     *  https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GraphicsDrawingOverview/GraphicsDrawingOverview.html
     * 仅当要绘制的线宽为奇数像素时，绘制位置需要调整
     */
    CGFloat pixelAdjustOffset = 0;
    if (((int)(self.gridLineWidth * [UIScreen mainScreen].scale) + 1) % 2 == 0)
    {
        pixelAdjustOffset = [UIView jj_singleLineAdjustOffset];
    }
    
    CGFloat xPos = lineMargin - pixelAdjustOffset;
    CGFloat yPos = lineMargin - pixelAdjustOffset;
    while (xPos < self.bounds.size.width)
    {
        CGContextMoveToPoint(context, xPos, 0);
        CGContextAddLineToPoint(context, xPos, self.bounds.size.height);
        xPos += lineMargin;
    }
    
    while (yPos < self.bounds.size.height)
    {
        CGContextMoveToPoint(context, 0, yPos);
        CGContextAddLineToPoint(context, self.bounds.size.width, yPos);
        yPos += lineMargin;
    }
    
    CGContextSetLineWidth(context, self.gridLineWidth);
    CGContextSetStrokeColorWithColor(context, self.gridColor.CGColor);
    CGContextStrokePath(context);
}

#pragma mark - private

- (void)__setUp
{
    self.backgroundColor = [UIColor clearColor];
    
    _gridColor = [UIColor blueColor];
    _gridLineWidth = [UIView jj_singleLineWidth];
    _gridSpacing = 30;
}

@end
