//
//  JJWeakDictionary.h
//  JJObjCTool
//
//  Created by gongjian03 on 8/7/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJWeakDictionary : NSObject

- (void)setObject:(id)object forKey:(id)key;
- (id)objectForKey:(id)key;

@end
