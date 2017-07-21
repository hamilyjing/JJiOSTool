//
//  YZTRsa.h
//  PANewToapAPP
//
//  Created by 陈小强 on 14-11-17.
//  Copyright (c) 2014年 Gavin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YZTRsa : NSObject
#pragma mark - Instance Methods

- (void)loadPublicKeyFromFile:(NSString *)derFilePath;
- (void)loadPublicKeyFromData:(NSData *)derData;

- (void)loadPrivateKeyFromFile:(NSString *)p12FilePath password:(NSString *)p12Password;
- (void)loadPrivateKeyFromData:(NSData *)p12Data password:(NSString *)p12Password;

//利用pem格式公钥文件加密和私钥解密
- (void)loadPemPublicKeyFromPemFile:(NSString *)pemFilePath;
- (NSString *)rsaUsePemPublicKeyDecryptString:(NSString *)string;

- (void)loadPemPrivateKeyFromPemFile:(NSString *)pemFilePath;
- (NSString *)rsaUsePemPrivateKeyEncryptString:(NSString *)string;

- (NSString *)signTheDataSHA1WithRSA:(NSString *)plainText;
- (BOOL)verifySHA1Signature:(NSData *)plainData  signature:(NSData *)sigData;


// MD5 + RSA
- (BOOL)verifyMd5RsaWithPlainString:(NSString *)plainString signature:(NSString *)signature keyPath:(NSString *)path;

- (NSString *)rsaEncryptString:(NSString *)string;
- (NSString *)rsaEncryptString:(NSString *)string withSecPadding:(SecPadding)secPadding;

- (NSData *)rsaEncryptData:(NSData *)data ;
- (NSData *)rsaEncryptData:(NSData *)data withSecPadding:(SecPadding)secPadding;

- (NSString *)rsaDecryptString:(NSString *)string;
- (NSData *)rsaDecryptData:(NSData *)data;

#pragma mark - Class Methods

+ (void)setSharedInstance:(YZTRsa *)instance;
+ (YZTRsa *)sharedInstance;


@end
