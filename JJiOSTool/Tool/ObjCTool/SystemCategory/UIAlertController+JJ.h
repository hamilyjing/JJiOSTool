//
//  UIAlertController+JJ.h
//  JJObjCTool
//
//  Created by gongjian03 on 7/30/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JJUIAlertControllerPopoverPresentationControllerBlock) (UIPopoverPresentationController * __nonnull popover);
typedef void (^JJUIAlertControllerCompletionBlock) (UIAlertController * __nonnull controller, UIAlertAction * __nonnull action, NSInteger buttonIndex);

@interface UIAlertController (JJ)

#pragma mark - show alert and action sheet

+ (nonnull instancetype)jj_showInViewController:(nonnull UIViewController *)viewController
                                      withTitle:(nullable NSString *)title
                                        message:(nullable NSString *)message
                                 preferredStyle:(UIAlertControllerStyle)preferredStyle
                              cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                         destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                              otherButtonTitles:(nullable NSArray *)otherButtonTitles
             popoverPresentationControllerBlock:(nullable JJUIAlertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
                                       tapBlock:(nullable JJUIAlertControllerCompletionBlock)tapBlock;

+ (nonnull instancetype)jj_showAlertInViewController:(nonnull UIViewController *)viewController
                                           withTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                   otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                            tapBlock:(nullable JJUIAlertControllerCompletionBlock)tapBlock;

+ (nonnull instancetype)jj_showActionSheetInViewController:(nonnull UIViewController *)viewController
                                                 withTitle:(nullable NSString *)title
                                                   message:(nullable NSString *)message
                                         cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                         otherButtonTitles:(nullable NSArray *)otherButtonTitles
                        popoverPresentationControllerBlock:(nullable JJUIAlertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
                                                  tapBlock:(nullable JJUIAlertControllerCompletionBlock)tapBlock;

@property (readonly, nonatomic) BOOL jj_visible;
@property (readonly, nonatomic) NSInteger jj_cancelButtonIndex;
@property (readonly, nonatomic) NSInteger jj_firstOtherButtonIndex;
@property (readonly, nonatomic) NSInteger jj_destructiveButtonIndex;

@end
