//
//  NSObject+JJTableViewCellMapKey.m
//  PANewToapAPP
//
//  Created by JJ on 5/13/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import "NSObject+JJTableViewCellMapKey.h"

#import <objc/runtime.h>

@implementation NSObject (JJTableViewCellMapKey)

- (NSString *)jjCellMapKey
{
    return (NSString *)objc_getAssociatedObject(self, @selector(jjCellMapKey));
}

- (void)setJjCellMapKey:(NSString *)jjCellMapKey_
{
    if (![self.jjCellMapKey isEqualToString:jjCellMapKey_])
    {
        objc_setAssociatedObject(self, @selector(jjCellMapKey), jjCellMapKey_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id)jjCellOtherInfo
{
    return (id)objc_getAssociatedObject(self, @selector(jjCellOtherInfo));
}

- (void)setJjCellOtherInfo:(id)jjCellOtherInfo_
{
    if (self.jjCellOtherInfo != jjCellOtherInfo_)
    {
        objc_setAssociatedObject(self, @selector(jjCellOtherInfo), jjCellOtherInfo_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
