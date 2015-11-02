//
//  UIGestureRecognizer+JJ.h
//  JJObjCTool
//
//  Created by JJ on 5/13/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (JJ)

#pragma mark - Init

+ (id)jj_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay;
- (id)initWithJJHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay NS_REPLACES_RECEIVER;

+ (id)jj_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block;
- (id)initWithJJHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block NS_REPLACES_RECEIVER;

#pragma mark - Cancel

- (void)jj_cancel;

@end
