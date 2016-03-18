//
//  BIUserDefaultsUnderlineLabel.m
//  SettingsKit
//
//  Created by HuGuanqin on 10/23/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsUnderlineLabel.h"

@implementation BIUserDefaultsUnderlineLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        _actionView = [[UIControl alloc] initWithFrame:self.bounds];
        _actionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_actionView];
        [self sendSubviewToBack:_actionView];
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _actionView.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    
    CGSize fontSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName: self.font,
                                                        NSParagraphStyleAttributeName: style}
                                              context:nil].size;
    
    CGContextSetStrokeColorWithColor(ctx, self.textColor.CGColor);
    CGContextSetLineWidth(ctx, 1.0f);
    CGPoint leftPoint = CGPointMake(self.frame.size.width - fontSize.width,self.frame.size.height);
    CGPoint rightPoint = CGPointMake(self.frame.size.width,self.frame.size.height);
    
    CGContextMoveToPoint(ctx, leftPoint.x, leftPoint.y);
    CGContextAddLineToPoint(ctx, rightPoint.x, rightPoint.y);
    CGContextStrokePath(ctx);
}

- (void)addTarget:(id)target action:(SEL)action {
    [_actionView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
