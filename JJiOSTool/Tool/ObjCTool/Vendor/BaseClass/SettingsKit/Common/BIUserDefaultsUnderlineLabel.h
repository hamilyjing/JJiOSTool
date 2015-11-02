//
//  BIUserDefaultsUnderlineLabel.h
//  SettingsKit
//
//  Created by HuGuanqin on 10/23/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIUserDefaultsUnderlineLabel : UILabel   {
    UIControl *_actionView;
}

- (void)addTarget:(id)target action:(SEL)action;

@end
