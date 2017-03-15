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

- (NSArray<NSString *> *)jjSectionClassNameArray
{
    return (NSArray<NSString *> *)objc_getAssociatedObject(self, @selector(jjSectionClassNameArray));
}

- (void)setJjSectionClassNameArray:(NSArray<NSString *> *)jjSectionClassNameArray_
{
    if (self.jjSectionClassNameArray != jjSectionClassNameArray_)
    {
        objc_setAssociatedObject(self, @selector(jjSectionClassNameArray), jjSectionClassNameArray_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (NSArray<id> *)jjSectionDataArray
{
    return (NSArray<id> *)objc_getAssociatedObject(self, @selector(jjSectionDataArray));
}

- (void)setJjSectionDataArray:(NSArray<id> *)jjSectionDataArray_
{
    if (self.jjSectionDataArray != jjSectionDataArray_)
    {
        objc_setAssociatedObject(self, @selector(jjSectionDataArray), jjSectionDataArray_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
