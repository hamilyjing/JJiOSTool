//
//  BIUserDefaultsWebViewController.h
//  SettingsKit
//
//  Created by HuGuanqin on 10/1/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIUserDefaultsSpecifier.h"

@interface BIUserDefaultsWebViewController : UIViewController <UIWebViewDelegate>

- (instancetype)initWithSpecifier:(BIUserDefaultsSpecifier *)specifier;

@end
