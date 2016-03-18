//
//  JJImportContactsManager.h
//
//
//  Created by JJ on 1/30/15.
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

extern NSString * const BaiduInputMethodContactAccessGranted;
extern NSString * const BaiduInputMethodContactAccessDenied;

@interface BIImportContactsManager : NSObject

+ (instancetype)sharedInstance;

+ (BOOL)privacyOn;
+ (BOOL)privacyOff;
+ (BOOL)haveNotAuthorized;
+ (BOOL)haveRestricted;

- (void)importContacts:(void (^)(BOOL, NSArray *))result needAuthorized:(BOOL)needAuthorized;

@end
