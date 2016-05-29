//
//  UITableView+JJTableViewSection.m
//  PANewToapAPP
//
//  Created by JJ on 5/23/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import "UITableView+JJTableViewSection.h"

#import <objc/runtime.h>

@implementation UITableView (JJTableViewSection)

- (NSArray<NSString *> *)jjSectionObjectArray
{
    return (NSArray<NSString *> *)objc_getAssociatedObject(self, @selector(jjSectionObjectArray));
}

- (void)setJjSectionObjectArray:(NSArray<NSString *> *)jjSectionObjectArray_
{
    if (self.jjSectionObjectArray != jjSectionObjectArray_)
    {
        objc_setAssociatedObject(self, @selector(jjSectionObjectArray), jjSectionObjectArray_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
