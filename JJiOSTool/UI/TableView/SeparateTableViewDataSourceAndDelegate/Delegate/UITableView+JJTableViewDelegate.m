//
//  UITableView+JJTableViewDelegate.m
//  aaa
//
//  Created by hamilyjing on 5/22/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import "UITableView+JJTableViewDelegate.h"

#import <objc/runtime.h>

@implementation UITableView (JJTableViewDelegate)

- (JJTableViewDelegate *)jjDelegate
{
    return (JJTableViewDelegate *)objc_getAssociatedObject(self, @selector(jjDelegate));
}

- (void)setJjDelegate:(JJTableViewDelegate *)jjDelegate_
{
    if (self.jjDelegate != jjDelegate_)
    {
        objc_setAssociatedObject(self, @selector(jjDelegate), jjDelegate_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.delegate = (id<UITableViewDelegate>)self.jjDelegate;
    }
}

@end
