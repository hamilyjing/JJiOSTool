//
//  JJWeakDictionary.m
//  JJObjCTool
//
//  Created by gongjian03 on 8/7/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import "JJWeakDictionary.h"

@interface JJWeakDictionary ()

@property (nonatomic, strong) NSMapTable *mapTable;

@end

@implementation JJWeakDictionary

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.mapTable = [NSMapTable strongToWeakObjectsMapTable];
    }
    
    return self;
}

#pragma mark - public

- (void)setObject:(id)object_ forKey:(id)key_
{
    [self.mapTable setObject:object_ forKey:key_];
}

- (id)objectForKey:(id)key_
{
    return [self.mapTable objectForKey:key_];
}

@end
