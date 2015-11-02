//
//  JJMantle+Test.m
//  JJObjCTool
//
//  Created by JJ on 5/23/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JJMantle+Test.h"

#import "JJMantleHeader.h"
#import "NSString+JJ.h"
#import "NSData+JJ.h"

NSString *MTLDataValueTransformerName = @"MTLDataValueTransformerName";

@interface AAMantle : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) NSString *str1;

@end

@implementation AAMantle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"str": @"str",
             @"str1": @"str1",};
}

@end

@interface XYUser : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, assign) CGFloat floatValue;
@property (readonly, nonatomic, assign) NSInteger integerValue;
@property (readonly, nonatomic, assign) BOOL boolValue;

@property (readonly, nonatomic, copy) NSString *stringValue;
@property (readonly, nonatomic, strong) NSData *dataValue;

@property (nonatomic, strong) NSURL *urlValue;

@property (readonly, nonatomic, copy) NSString *level1Name;

@property (readonly, nonatomic, strong) NSDictionary *dicValue;

@property (nonatomic, strong) AAMantle *aa;
@property (nonatomic, strong) NSMutableArray *aaArray;

@end

@implementation XYUser

+ (void)load
{
    MTLValueTransformer *dataValueTransformer = nil;
    dataValueTransformer = [MTLValueTransformer transformerUsingForwardBlock:^ id (NSString *str, BOOL *success, NSError **error)
    {
        if (str == nil) return nil;
        
        if (![str isKindOfClass:NSString.class]) {
            if (error != NULL) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedString(@"Could not convert string to URL", @""),
                                           NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"Expected an NSString, got: %@.", @""), str],
                                           MTLTransformerErrorHandlingInputValueErrorKey : str
                                           };
                
                *error = [NSError errorWithDomain:MTLTransformerErrorHandlingErrorDomain code:MTLTransformerErrorHandlingErrorInvalidInput userInfo:userInfo];
            }
            *success = NO;
            return nil;
        }
        
        NSData *result = [str jj_data];
        
        if (result == nil) {
            if (error != NULL) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedString(@"Could not convert string to URL", @""),
                                           NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"Input URL string %@ was malformed", @""), str],
                                           MTLTransformerErrorHandlingInputValueErrorKey : str
                                           };
                
                *error = [NSError errorWithDomain:MTLTransformerErrorHandlingErrorDomain code:MTLTransformerErrorHandlingErrorInvalidInput userInfo:userInfo];
            }
            *success = NO;
            return nil;
        }
        
        return result;
    }
                            
                                                                reverseBlock:^ id (NSData *data, BOOL *success, NSError **error)
    {
        if (data == nil) return nil;
        
        if (![data isKindOfClass:[NSData class]]) {
            if (error != NULL) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedString(@"Could not convert URL to string", @""),
                                           NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"Expected an NSURL, got: %@.", @""), data],
                                           MTLTransformerErrorHandlingInputValueErrorKey : data
                                           };
                
                *error = [NSError errorWithDomain:MTLTransformerErrorHandlingErrorDomain code:MTLTransformerErrorHandlingErrorInvalidInput userInfo:userInfo];
            }
            *success = NO;
            return nil;
        }
        return [data jj_UFT8String];
    }];
    
    [NSValueTransformer setValueTransformer:dataValueTransformer forName:MTLDataValueTransformerName];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"dataValue": @"dataValue", //这里代表createdAt属性映射JSON中的created_at关键字
             @"urlValue": @"urlValue",
             @"floatValue": @"floatValue",
             @"integerValue": @"integerValue",
             @"boolValue": @"boolValue",
             @"stringValue": @"stringValue",
             
             @"level1Name": @"level1.name",
             
             @"dicValue": @[@"latitude", @"longitude"],
             };
}

//+ (NSValueTransformer *)urlJSONTransformer {
//    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
//}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"urlValue"])
    {
        return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
    }
    else if ([key isEqualToString:@"dataValue"])
    {
        return [NSValueTransformer valueTransformerForName:MTLDataValueTransformerName];
    }
    return nil;
}

@end

extern void jjMantleTest()
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JJMantleTest" ofType:@"json"];
    
    NSDictionary *JSONDictionary = @{
                                     @"name": @"john",
                                     @"dataValue": @"1234567",
                                     @"plan": @"1",
                                     @"urlValue": @"http://www.baidu.com",
                                     @"floatValue": @"1.2",
                                     @"integerValue": @"54",
                                     @"boolValue": @"1",
                                     @"stringValue": @"12345",
                                     
                                     @"level1": @{
                                             @"name": @"level1",
                                         },
                                     
                                     @"latitude": @"latitude11",
                                     @"longitude": @"longitude11",
                                     };
    
    JSONDictionary = [NSData jj_dictionaryWithJSONByFilePath:filePath];
    JSONDictionary = JSONDictionary[@"mantle"];
    
    NSError *error;
    XYUser *user = [MTLJSONAdapter modelOfClass:XYUser.class fromJSONDictionary:JSONDictionary error:&error];
    user.aa = [MTLJSONAdapter modelOfClass:AAMantle.class fromJSONDictionary:JSONDictionary[@"aa"] error:&error];
    user.aaArray = [NSMutableArray array];
    [user.aaArray addObject:[MTLJSONAdapter modelOfClass:AAMantle.class fromJSONDictionary:JSONDictionary[@"aaArray"][0] error:&error]];
    [user.aaArray addObject:[MTLJSONAdapter modelOfClass:AAMantle.class fromJSONDictionary:JSONDictionary[@"aaArray"][1] error:&error]];
    
    __unused id obj22 = [user copy];
    
    NSString *homeDictionary = NSHomeDirectory();//获取根目录
    NSString *homePath  = [homeDictionary stringByAppendingPathComponent:@"atany.archiver"];//添加储存的文件名
    __unused BOOL flag = [NSKeyedArchiver archiveRootObject:user toFile:homePath];//归档一个字符串
    
    
    __unused id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:homePath];
}
