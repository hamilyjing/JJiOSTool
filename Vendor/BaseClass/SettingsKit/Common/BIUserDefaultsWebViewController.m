//
//  BIUserDefaultsWebViewController.m
//  SettingsKit
//
//  Created by HuGuanqin on 10/1/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsSpecifierDataSource.h"
#import "BIUserDefaultsWebViewController.h"

@interface BIUserDefaultsWebViewController ()
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *fileName;
@end

@implementation BIUserDefaultsWebViewController {
    UIWebView *_webView;
}

- (instancetype)initWithSpecifier:(BIUserDefaultsSpecifier *)specifier {
    self = [super init];
    if (self) {
        self.title = specifier.title;
        self.fileName = specifier.file;
        self.filePath = [specifier.dataSource.bundle resourcePath];
    }
    return self;
}


- (void)loadView {
    [super loadView];
    
    NSString *fullPath = [self.filePath stringByAppendingPathComponent:self.fileName];
    NSString *htmlText = [[NSString alloc] initWithContentsOfFile:fullPath
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [_webView setBackgroundColor:[UIColor whiteColor]];
    [_webView loadHTMLString:htmlText baseURL:[NSURL fileURLWithPath:self.filePath]];
    [self.view addSubview:_webView];
}

- (void)viewWillLayoutSubviews {
    _webView.frame = self.view.bounds;
}

@end
