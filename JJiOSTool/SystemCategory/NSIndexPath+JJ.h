//
//  NSIndexPath+JJ.h
//  JJObjCTool
//
//  Created by hamilyjing on 5/12/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSIndexPath (JJ)

#pragma mark - Offset

- (NSIndexPath *)previousRow;
- (NSIndexPath *)nextRow;
- (NSIndexPath *)previousItem;
- (NSIndexPath *)nextItem;
- (NSIndexPath *)nextSection;
- (NSIndexPath *)previousSection;

@end
