//
//  JJImportContactsManager.m
//
//
//  Created by JJ on 1/30/15.
//  All rights reserved.
//

#import "JJImportContactsManager.h"

NSString * const BaiduInputMethodContactAccessGranted = @"BaiduInputMethodContactAccessGranted";
NSString * const BaiduInputMethodContactAccessDenied = @"BaiduInputMethodContactAccessDenied";

@interface BIImportContactsManager ()

@property (nonatomic, copy) void (^resultBlock)(BOOL, NSArray *);

@end

static BIImportContactsManager *s_shareInstance = nil;

@implementation BIImportContactsManager

- (void)dealloc
{
    [self cleanUp];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^()
    {
        s_shareInstance = [[self alloc] init];
    });
    return s_shareInstance;
}

#pragma mark - Private

- (void)cleanUp
{
    self.resultBlock = nil;
}

- (void)importResult:(BOOL)success resultValue:(id)value
{
    if (self.resultBlock)
    {
        self.resultBlock(success, value);
    }
    
    [self cleanUp];
}

+ (ABAddressBookRef)addressBook
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (addressBook)
    {
        addressBook = CFAutorelease(addressBook);
    }
    
    return addressBook;
}

+ (ABAddressBookRef)addressBookAuthorized:(ABAddressBookRef)addressBook
{
    __block BOOL accessGranted = NO;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
    {
        accessGranted = granted;
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSString *notificationName = accessGranted ? BaiduInputMethodContactAccessGranted : BaiduInputMethodContactAccessDenied;
    [center postNotificationName:notificationName
                          object:nil];
    
    return accessGranted ? addressBook : NULL;
}

+ (NSString *)completeContactAddress:(CFTypeRef)dict
{
    NSString *value = nil;
    CFTypeID typeId = CFGetTypeID(dict);
    if (typeId == CFStringGetTypeID())
    {
        value = [(__bridge NSString *)dict copy];
    }
    else if (typeId == CFDictionaryGetTypeID())
    {
        NSString* homeStreet  = (NSString*)CFDictionaryGetValue(dict, kABPersonAddressStreetKey);
        NSString* homeCity    = (NSString*)CFDictionaryGetValue(dict, kABPersonAddressCityKey);
        NSString* homeCountry = (NSString*)CFDictionaryGetValue(dict, kABPersonAddressCountryKey);
        homeStreet  = (nil == homeStreet || [homeStreet isEqualToString:@"null"] || [homeStreet isEqualToString:@"(null)"] ) ? @"" : [NSString stringWithFormat:@"%@,", homeStreet];
        homeCity    = (nil == homeCity || [homeCity isEqualToString:@"null"] || [homeCity isEqualToString:@"(null)"] ) ? @"" : [NSString stringWithFormat:@"%@,", homeCity];
        homeCountry = (nil == homeCountry || [homeCountry isEqualToString:@"null"] || [homeCountry isEqualToString:@"(null)"] ) ? @"" : [NSString stringWithFormat:@"%@", homeCountry];
        value = [NSString stringWithFormat:@"%@%@%@" ,homeStreet, homeCity, homeCountry];
    }
    
    return value;
    
}

+ (NSDictionary*)contactLabelDictionay
{
    static NSDictionary*  contactLabelDictionay = nil;
    
    if (contactLabelDictionay == nil)
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:10];
        
        NSMutableDictionary* phoneAttributeDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        [phoneAttributeDict setObject:@"移动电话" forKey:(NSString*)kABPersonPhoneMobileLabel];
        [phoneAttributeDict setObject:@"iPhone" forKey:(NSString*)kABPersonPhoneIPhoneLabel];
        [phoneAttributeDict setObject:@"主要电话" forKey:(NSString*)kABPersonPhoneMainLabel];
        [phoneAttributeDict setObject:@"住宅传真" forKey:(NSString*)kABPersonPhoneHomeFAXLabel];
        [phoneAttributeDict setObject:@"工作传真" forKey:(NSString*)kABPersonPhoneWorkFAXLabel];
        [phoneAttributeDict setObject:@"其他传真" forKey:@"_$!<OtherFAX>!$_"];   //__IPHONE_5_0
        
        //    [phoneAttributeDict setObject:@"其他传真" forKey:(NSString*)kABPersonPhoneOtherFAXLabel];   //__IPHONE_5_0
        [phoneAttributeDict setObject:@"传呼" forKey:(NSString*)kABPersonPhonePagerLabel];
        [phoneAttributeDict setObject:@"工作电话" forKey:(NSString*)kABWorkLabel];
        [phoneAttributeDict setObject:@"住宅电话" forKey:(NSString*)kABHomeLabel];
        [phoneAttributeDict setObject:@"其他电话" forKey:(NSString*)kABOtherLabel];
        
        [dict setObject:phoneAttributeDict forKey:[NSNumber numberWithInt:kABPersonPhoneProperty ]];
        
        NSMutableDictionary* emailAttributeDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        [emailAttributeDict setObject:@"工作邮箱" forKey:(NSString*)kABWorkLabel];
        [emailAttributeDict setObject:@"住宅邮箱" forKey:(NSString*)kABHomeLabel];
        [emailAttributeDict setObject:@"其他邮箱" forKey:(NSString*)kABOtherLabel];
        
        [dict setObject:emailAttributeDict forKey:[NSNumber numberWithInt:kABPersonEmailProperty ]];
        
        NSMutableDictionary* addressAttributeDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        [addressAttributeDict setObject:@"工作地址" forKey:(NSString*)kABWorkLabel];
        [addressAttributeDict setObject:@"家庭地址" forKey:(NSString*)kABHomeLabel];
        [addressAttributeDict setObject:@"其他地址" forKey:(NSString*)kABOtherLabel];
        
        [dict setObject:addressAttributeDict forKey:[NSNumber numberWithInt:kABPersonAddressProperty ]];
        
        contactLabelDictionay  = dict;
    }
    
    return contactLabelDictionay;
}

+ (NSArray *)readContactsFromAddressBook:(ABAddressBookRef)addressBook
{
    NSMutableArray* allContacts = [NSMutableArray array];
    
    @autoreleasepool
    {
        NSArray *array= (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        for (id persion in array)
        {
            NSMutableDictionary* contactDict = [NSMutableDictionary dictionaryWithCapacity:10];
            
            ABRecordRef record = (__bridge ABRecordRef)persion;
            
            //NAME
            NSString* firstName=(__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
            NSString* lastName=(__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
            
            NSString* tmp  =  [NSString stringWithFormat:@"%@%@",
                               nil == lastName ? @""  : (NSString *)lastName,
                               nil == firstName ? @""  :(NSString *)firstName];
            if( [tmp length] == 0)
            {
                continue;
            }
            
            NSMutableString* name = [NSMutableString string];  //去掉空格
            
            NSArray* array   = [tmp componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            
            for (NSString* str  in array)
            {
                [name appendString:str];
            }
            if (name.length > 0) {
                [contactDict setObject:name forKey:@"name"];
            }
            
            //COMPANY
            NSString* company  = (__bridge NSString*)ABRecordCopyValue(record, kABPersonOrganizationProperty);
            if (company.length > 0)
            {
                [contactDict setObject:company forKey:@"company"];
            }
            
            //PHONE, ADDRESS, EMAIL
            ABPropertyID propertyArray[3] = {kABPersonPhoneProperty,kABPersonEmailProperty,kABPersonAddressProperty};
            
            NSString* defaultLabelArray[3] ={ @"电话",  @"邮箱", @"地址"};
            
            NSString* keyArray[3] ={ @"phones", @"emails",@"addresses"};
            
            
            int count = sizeof(propertyArray)/sizeof(ABPropertyID);
            
            for ( int i = 0; i < count; ++i )
            {
                
                NSDictionary* labelDict = [[self contactLabelDictionay] objectForKey:[NSNumber numberWithInt:propertyArray[i]]];
                ABMultiValueRef mulValue = (ABMultiValueRef) ABRecordCopyValue(record, propertyArray[i]);
                if (!mulValue)
                {
                    continue;
                }
                
                CFIndex valueCount = ABMultiValueGetCount(mulValue);
                NSMutableArray* tmpArr = [NSMutableArray arrayWithCapacity:count];
                for(CFIndex j=0 ; j < valueCount ; j++)
                {
                    NSString* labelRef = (__bridge NSString*) ABMultiValueCopyLabelAtIndex(mulValue, j) ;
                    NSString* valueRef = nil;
                    if (propertyArray[i] == kABPersonAddressProperty )
                    {
                        CFDictionaryRef dict = (CFDictionaryRef)ABMultiValueCopyValueAtIndex(mulValue, j);
                        valueRef = [self completeContactAddress:dict];
                        if (dict) {
                            CFRelease(dict);
                            dict = nil;
                        }
                    }
                    else
                    {
                        CFTypeRef valueCFString = ABMultiValueCopyValueAtIndex(mulValue, j);
                        if (CFGetTypeID(valueCFString) == CFStringGetTypeID())
                        {
                            valueRef = (__bridge NSString*)valueCFString;
                        }
                    }
                    NSString* readableLabel = [labelDict objectForKey:labelRef]; //convert to human readable strings
                    NSString* label = readableLabel ? readableLabel : labelRef;
                    if (nil == label)
                    {
                        label = defaultLabelArray[i];
                    }
                    
                    if (valueRef.length > 0 && label.length > 0)
                    {
                        [tmpArr addObject:valueRef];
                        [tmpArr addObject:label];
                    }
                }
                CFRelease(mulValue);
                
                if ([tmpArr count] > 0)
                {
                    [contactDict setObject:tmpArr forKey:keyArray[i]];
                }
                
            }
            
            [allContacts addObject:contactDict];
            
        }
        
        CFRelease((CFArrayRef)array);
    }
    
    return allContacts;
}

#pragma mark - Public

+ (BOOL)privacyOn
{
    return kABAuthorizationStatusAuthorized == ABAddressBookGetAuthorizationStatus();
}

+ (BOOL)privacyOff
{
    return kABAuthorizationStatusDenied == ABAddressBookGetAuthorizationStatus();
}

+ (BOOL)haveNotAuthorized
{
    return kABAuthorizationStatusNotDetermined == ABAddressBookGetAuthorizationStatus();
}

+ (BOOL)haveRestricted
{
    return kABAuthorizationStatusRestricted == ABAddressBookGetAuthorizationStatus();
}

- (void)importContacts:(void (^)(BOOL, NSArray *))result_ needAuthorized:(BOOL)needAuthorized_
{
    self.resultBlock = result_;
    
    ABAddressBookRef addressBook = [BIImportContactsManager addressBook];
    
    if (needAuthorized_ && addressBook)
    {
        addressBook = [BIImportContactsManager addressBookAuthorized:addressBook];
    }
    
    if (!addressBook)
    {
        [self importResult:NO resultValue:nil];
        return;
    }
    
    NSArray *contacts = [BIImportContactsManager readContactsFromAddressBook:addressBook];
    
    [self importResult:YES resultValue:contacts];
}

@end
