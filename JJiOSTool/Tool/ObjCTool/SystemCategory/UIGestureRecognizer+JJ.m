//
//  UIGestureRecognizer+JJ.m
//  JJObjCTool
//
//  Created by JJ on 5/13/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "UIGestureRecognizer+JJ.h"

#import <objc/runtime.h>

static const void *jjGestureRecognizerBlockKey = &jjGestureRecognizerBlockKey;
static const void *jjGestureRecognizerDelayKey = &jjGestureRecognizerDelayKey;
static const void *jjGestureRecognizerShouldHandleActionKey = &jjGestureRecognizerShouldHandleActionKey;

@interface UIGestureRecognizer (BlocksKitInternal)

@property (nonatomic, copy, setter = jj_setHandler:) void (^jj_handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location);
@property (nonatomic, setter = jj_setHandlerDelay:) NSTimeInterval jj_handlerDelay;

@property (nonatomic, setter = jj_setShouldHandleAction:) BOOL jj_shouldHandleAction;

@end

@implementation UIGestureRecognizer (JJ)

#pragma mark - Init

+ (id)jj_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay
{
    return [[[self class] alloc] initWithJJHandler:block delay:delay];
}

- (id)initWithJJHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay
{
    self = [self initWithTarget:self action:@selector(jj_handleAction:)];
    if (!self) return nil;
    
    self.jj_handler = block;
    self.jj_handlerDelay = delay;
    
    return self;
}

+ (id)jj_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block
{
    return [self jj_recognizerWithHandler:block delay:0.0];
}

- (id)initWithJJHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block
{
    return (self = [self initWithJJHandler:block delay:0.0]);
}

#pragma mark - Cancel

- (void)jj_cancel
{
    self.jj_shouldHandleAction = NO;
}

#pragma mark - Event response

- (void)jj_handleAction:(UIGestureRecognizer *)recognizer
{
    void (^handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) = recognizer.jj_handler;
    if (!handler) return;
    
    NSTimeInterval delay = self.jj_handlerDelay;
    CGPoint location = [self locationInView:self.view];
    void (^block)(void) = ^{
        if (!self.jj_shouldHandleAction) return;
        handler(self, self.state, location);
    };
    
    self.jj_shouldHandleAction = YES;
    
    if (!delay) {
        block();
        return;
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

#pragma mark - Getter and setter

- (void)jj_setHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))handler
{
    objc_setAssociatedObject(self, jjGestureRecognizerBlockKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))jj_handler
{
    return objc_getAssociatedObject(self, jjGestureRecognizerBlockKey);
}

- (void)jj_setHandlerDelay:(NSTimeInterval)delay
{
    NSNumber *delayValue = delay ? @(delay) : nil;
    objc_setAssociatedObject(self, jjGestureRecognizerDelayKey, delayValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)jj_handlerDelay
{
    return [objc_getAssociatedObject(self, jjGestureRecognizerDelayKey) doubleValue];
}

- (void)jj_setShouldHandleAction:(BOOL)flag
{
    objc_setAssociatedObject(self, jjGestureRecognizerShouldHandleActionKey, @(flag), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)jj_shouldHandleAction
{
    return [objc_getAssociatedObject(self, jjGestureRecognizerShouldHandleActionKey) boolValue];
}

@end
