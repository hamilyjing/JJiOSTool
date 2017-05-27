//
//  JJNeedChangeSkinView.h
//  BaiduBrowser
//
//  Created by gongjian03 on 8/28/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JJCUKFunctionTypeCustomDefine.h"

@interface JJNeedChangeSkinView : UIView

@property (nonatomic, assign) BOOL enableLongPress;

- (void)setCUKFunctionType:(JJCUKFunctionType *)cukFunctionType;

- (void)showChangeSkinView;

// subclass overwrite
- (void)setUp;

@end
