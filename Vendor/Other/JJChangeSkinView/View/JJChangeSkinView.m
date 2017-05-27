//
//  JJChangeSkinView.m
//  BaiduBrowser
//
//  Created by hamilyjing on 8/27/15.
//  Copyright © 2015 Baidu Inc. All rights reserved.
//

#import "JJChangeSkinView.h"

#import "JJChangeSkinManager.h"
#import "JJChangeSkinPureColorItem.h"
#import "JJChangeSkinPhotoItem.h"
#import "JJCUKFunctionTypeChangeSkinViewDefine.h"
#import "JJFakeStatusBar.h"
#import "JJSelectView.h"
//#import "JJSkinManager.h"
#import "JJToolBar.h"
//#import "NSObject+JJSkin.h"
#import "UIColor+JJ.h"
#import "UIDevice+JJ.h"
#import "UIView+JJ.h"
#import "UIView+JJCUK.h"
#import "NSObject+JJ.h"
#import "JJSelectPhotoView.h"
#import "VPImageCropperViewController.h"
#import "NSDate+JJ.h"
#import "UIImage+JJ.h"
#import "FXBlurView.h"

NSString *JJChangeSkinViewWillShow = @"JJChangeSkinViewWillShow";
NSString *JJChangeSkinViewDidShow = @"JJChangeSkinViewDidShow";
NSString *JJChangeSkinViewWillHide = @"JJChangeSkinViewWillHide";
NSString *JJChangeSkinViewDidhide = @"JJChangeSkinViewDidhide";

static const NSInteger JJChangeSkinViewTag = 1239876;

extern NSString *JJFavoritesChangeSkinViewBeScreenCapturedViewChangedNotificationName;

extern NSString *JJChangeSkinNofiticationUserInfoImageBlurRadiusKey;

@interface JJChangeSkinView () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate, JJCUKViewDelegate>

@property (nonatomic, copy) NSString *pureColorStringBeforChangeSkin;
@property (nonatomic, copy) NSString *photoNameStringBeforChangeSkin;

@property (nonatomic, strong) UIView *beScreenCapturedView;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *pureColorBackgroundMaskView;
@property (nonatomic, strong) FXBlurView *blurView;

@property (nonatomic, strong) JJFakeStatusBar *statusBar;
@property (nonatomic, strong) UIImageView *screenCaptureImageView;

@property (nonatomic, strong) CAGradientLayer *foregroundLayer;

@property (nonatomic, strong) UIScrollView *selectPureColorView;
@property (nonatomic, strong) UIScrollView *selectPhotoView;
@property (nonatomic, strong) JJToolBar *toolBar;

@end

@implementation JJChangeSkinView

#pragma mark - life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithBeScreenCapturedView:(UIView *)beScreenCapturedView_
{
    self = [super init];
    if (self)
    {
        [self __setUpWithBeScreenCapturedView:(UIView *)beScreenCapturedView_];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    self.pureColorBackgroundMaskView.frame = self.bounds;
    self.blurView.frame = self.bounds;
    
    self.statusBar.frame = CGRectMake(0, 0, [UIDevice jj_screenWidth], 20);
}

#pragma mark - public

+ (void)showWithBeScreenCapturedView:(UIView *)beScreenCapturedView_ animation:(BOOL)animation_
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *rootView = keyWindow.rootViewController.view;
    
    JJChangeSkinView *changeSkinView = [[JJChangeSkinView alloc] initWithBeScreenCapturedView:beScreenCapturedView_];
    changeSkinView.tag = JJChangeSkinViewTag;
    changeSkinView.frame = keyWindow.bounds;
    [rootView addSubview:changeSkinView];
    
    NSTimeInterval duration = 0;
    if (animation_)
    {
        duration = 0.5;
    }
    
    changeSkinView.screenCaptureImageView.frame = changeSkinView.bounds;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:JJChangeSkinViewWillShow object:changeSkinView];
    
    [changeSkinView __addPureColorAndPhotoAndToolBar];
    
    [changeSkinView __pureColorAndPhotoAndToolBarBeginFrame];
    
    [UIView animateWithDuration:duration animations:^{
        [changeSkinView.screenCaptureImageView jj_scaleWithSX:0.75 sy:0.75];
        changeSkinView.screenCaptureImageView.center = CGPointMake(keyWindow.center.x, keyWindow.center.y - 40);
        [changeSkinView __pureColorAndPhotoAndToolBarAfterFrame];
    } completion:^(BOOL finished) {
        [changeSkinView __addForegroundLayer];
        
        [nc postNotificationName:JJChangeSkinViewDidShow object:changeSkinView];
    }];
}

+ (void)hide:(BOOL)animation_
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *rootView = keyWindow.rootViewController.view;
    JJChangeSkinView *changeSkinView = (JJChangeSkinView *)[rootView viewWithTag:JJChangeSkinViewTag];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:JJChangeSkinViewWillHide object:changeSkinView];
    
    [changeSkinView.foregroundLayer removeFromSuperlayer];
//    [changeSkinView.toolBar removeFromSuperview];
//    [changeSkinView.selectPhotoView removeFromSuperview];
//    [changeSkinView.selectPureColorView removeFromSuperview];
    
    NSTimeInterval duration = 0;
    if (animation_)
    {
        duration = 0.5;
    }
    
    [UIView animateWithDuration:duration animations:^{
        [changeSkinView.screenCaptureImageView jj_scaleWithSX:1 sy:1];
        changeSkinView.screenCaptureImageView.center = changeSkinView.center;
        
        [changeSkinView __pureColorAndPhotoAndToolBarBeginFrame];
    } completion:^(BOOL finished) {
        [changeSkinView removeFromSuperview];
        
        [nc postNotificationName:JJChangeSkinViewDidhide object:changeSkinView];
    }];
}

+ (BOOL)isShowing
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *rootView = keyWindow.rootViewController.view;
    JJChangeSkinView *changeSkinView = (JJChangeSkinView *)[rootView viewWithTag:JJChangeSkinViewTag];
    return (changeSkinView != nil);
}

#pragma mark - JJCUKViewDelegate

- (void)jjCUK_didUpdateView:(UIView *)view_
{
    if (view_ == self.backgroundImageView)
    {
        if (self.backgroundImageView.image)
        {
            //self.pureColorBackgroundMaskView.hidden = YES;
            //self.foregroundLayer.hidden = YES;
            self.blurView.hidden = NO;
            
            _blurView.dynamic = YES;
            _blurView.dynamic = NO;
        }
        else
        {
            self.pureColorBackgroundMaskView.hidden = NO;
            //self.foregroundLayer.hidden = NO;
            self.blurView.hidden = YES;
        }
        
        [NSObject jj_performBlock:^{
            [self __setScreenCaptureImage];
        } afterDelay:0.01];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //portraitImg = [self imageByScalingToMaxSize:portraitImg];
    // 裁剪
    
    NSInteger height = 167;
    NSInteger y = ([UIDevice jj_screenHeight] - height) * 0.5;
    
    VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, y, picker.view.frame.size.width, height) limitScaleRatio:3.0];
    imgEditorVC.delegate = self;
    [picker pushViewController:imgEditorVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VPImageCropperDelegate

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    NSDate *nowDate = [NSDate date];
    NSString *dateFormatter = [nowDate jj_stringWithDateFormatString:@"yyyy-MM-dd-HHmmss"];
    NSString *fileName = @"localPhoto-";
    fileName = [fileName stringByAppendingString:dateFormatter];
    NSString *photoFilePath = [[JJChangeSkinManager sharedInstance].changeSkinPhotoDirectory stringByAppendingPathComponent:fileName];
    
    BOOL success = [editedImage jj_saveToFile:photoFilePath];
    if (success)
    {
        [[JJChangeSkinManager sharedInstance] saveSystemPhotoWithName:fileName image:editedImage];
        [self __resetSelectPhotoView];
        
        [NSObject jj_performBlock:^{
            [[JJChangeSkinManager sharedInstance] changePhotoName:fileName];
        } afterDelay:0.001];
    }
    
    [cropperViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - event

- (void)pressBackButton:(UIButton *)sender_
{
    self.backgroundImageView.jjCUKViewDelegate = nil;
    
    [[JJChangeSkinManager sharedInstance] changePureColor:self.pureColorStringBeforChangeSkin];
    [[JJChangeSkinManager sharedInstance] changePhotoName:self.photoNameStringBeforChangeSkin];
    
    [NSObject jj_performBlock:^{
        [JJChangeSkinView hide:YES];
    } afterDelay:0.001];
}

- (void)pressSelectButton:(UIButton *)sender_
{
    NSString *title = [[JJChangeSkinManager sharedInstance] photoTitleString];
    NSArray *values;
    if (title)
    {
        values = @[title];
    }
    BDRecordUserAction(kPhoneInterfaceIDTheme, kActionId00, values);
    
    [JJChangeSkinView hide:YES];
}

#pragma mark - notification

- (void)beScreenCapturedViewChangedNotification:(NSNotification *)notificaton_
{
//    [NSObject jj_performBlock:^{
//        [self __setScreenCaptureImage];
//    } afterDelay:0.001];
}

#pragma mark - private

- (void)__statisticsForPreview
{
    NSString *title = [[JJChangeSkinManager sharedInstance] photoTitleString];
    NSArray *values;
    if (title)
    {
        values = @[title];
    }
    BDRecordUserAction(kPhoneInterfaceIDTheme, kActionId01, values);
}

- (void)__setUpWithBeScreenCapturedView:(UIView *)beScreenCapturedView_
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beScreenCapturedViewChangedNotification:) name:JJFavoritesChangeSkinViewBeScreenCapturedViewChangedNotificationName object:nil];
    
    self.pureColorStringBeforChangeSkin = [[JJChangeSkinManager sharedInstance] pureColorString];
    self.photoNameStringBeforChangeSkin = [[JJChangeSkinManager sharedInstance] photoNameString];
    
    self.beScreenCapturedView = beScreenCapturedView_;
    
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.pureColorBackgroundMaskView];
    [self addSubview:self.blurView];
    
    if ([[JJChangeSkinManager sharedInstance] photoNameString])
    {
        //self.pureColorBackgroundMaskView.hidden = YES;
    }
    else
    {
        self.blurView.hidden = YES;
    }
    
    [self.screenCaptureImageView addSubview:self.statusBar];
    [self.screenCaptureImageView bringSubviewToFront:self.statusBar];
    
    [self addSubview:self.screenCaptureImageView];
    
    [self __setScreenCaptureImage];
}

- (void)__setScreenCaptureImage
{
    UIImage *screenCaptureImage = [self.beScreenCapturedView jj_screenCapture:YES margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.screenCaptureImageView.image = nil;
    self.screenCaptureImageView.image = screenCaptureImage;
}

- (void)__pureColorAndPhotoAndToolBarBeginFrame
{
    self.selectPureColorView.frame = CGRectMake(0, [UIDevice jj_screenHeight], [UIDevice jj_screenWidth], self.selectPureColorView.jjHeight);
    
    self.selectPhotoView.frame = CGRectMake(0, self.selectPureColorView.frame.origin.y + self.selectPureColorView.jjHeight, [UIDevice jj_screenWidth], self.selectPhotoView.jjHeight);
    
    self.toolBar.frame = CGRectMake(0, self.selectPhotoView.frame.origin.y + self.selectPhotoView.jjHeight, [UIDevice jj_screenWidth], self.toolBar.jjHeight);
}

- (void)__pureColorAndPhotoAndToolBarAfterFrame
{
    self.toolBar.frame = CGRectMake(0, [UIDevice jj_screenHeight] - self.toolBar.jjHeight, [UIDevice jj_screenWidth], self.toolBar.jjHeight);
    
    self.selectPhotoView.frame = CGRectMake(0, self.toolBar.frame.origin.y - self.selectPhotoView.jjHeight, [UIDevice jj_screenWidth], self.selectPhotoView.jjHeight);
    
    self.selectPureColorView.frame = CGRectMake(0, self.selectPhotoView.frame.origin.y - self.selectPureColorView.jjHeight, [UIDevice jj_screenWidth], self.selectPureColorView.jjHeight);
}

- (void)__addPureColorAndPhotoAndToolBar
{
    [self addSubview:self.toolBar];
    [self addSubview:self.selectPhotoView];
    [self addSubview:self.selectPureColorView];
}

- (void)__addForegroundLayer
{
    CGFloat foregroundLayerY = self.selectPureColorView.frame.origin.y - self.foregroundLayer.frame.size.height;
    self.foregroundLayer.frame = CGRectMake(0, foregroundLayerY, self.foregroundLayer.frame.size.width, self.foregroundLayer.frame.size.height);
    
    [self.layer addSublayer:self.foregroundLayer];
}

- (void)__resetSelectPhotoView
{
    [self.selectPhotoView removeFromSuperview];
    self.selectPhotoView = nil;
    
    self.selectPhotoView.frame = CGRectMake(0, self.toolBar.frame.origin.y - self.selectPhotoView.jjHeight, [UIDevice jj_screenWidth], self.selectPhotoView.jjHeight);
    [self addSubview:self.selectPhotoView];
}

#pragma mark - getter and setter

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView)
    {
        return _backgroundImageView;
    }
    
    _backgroundImageView = [[UIImageView alloc] init];
    //[_backgroundImageView jjCUK_setUserInfoWithObject:@(20.0) forKey:JJChangeSkinNofiticationUserInfoImageBlurRadiusKey];
    _backgroundImageView.jjCUKFunctionType = JJCUKFunctionTypeChangeSkinViewImageViewColorAndPhoto;
    _backgroundImageView.jjCUKViewDelegate = self;
    
    return _backgroundImageView;
}

- (FXBlurView *)blurView
{
    if (_blurView)
    {
        return _blurView;
    }
    
    _blurView = [[FXBlurView alloc] init];
    _blurView.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    _blurView.dynamic = NO;
    _blurView.blurRadius = 5.0;
    
    return _blurView;
}

- (JJFakeStatusBar *)statusBar
{
    return nil;
    
    if (_statusBar)
    {
        return _statusBar;
    }
    
    _statusBar = [[JJFakeStatusBar alloc] init];
    _statusBar.backgroundColor = [UIColor greenColor];
    
    return _statusBar;
}

- (UIImageView *)screenCaptureImageView
{
    if (_screenCaptureImageView)
    {
        return _screenCaptureImageView;
    }
    
    _screenCaptureImageView = [[UIImageView alloc] init];
    
    return _screenCaptureImageView;
}

- (CAGradientLayer *)foregroundLayer
{
    if (_foregroundLayer)
    {
        return _foregroundLayer;
    }
    
    UIColor *colorOne = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIColor *colorTwo = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    NSArray *colors = @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
    
    NSNumber *stopOne = @0;
    NSNumber *stopTwo = @1;
    NSArray *locations = @[stopOne, stopTwo];
    
    _foregroundLayer = [CAGradientLayer layer];
    
    _foregroundLayer.opacity = 0.3;
    _foregroundLayer.colors = colors;
    _foregroundLayer.locations = locations;
    _foregroundLayer.frame = CGRectMake(0, 0, self.bounds.size.width, 147);
    
    return _foregroundLayer;
}

- (UIScrollView *)selectPureColorView
{
    if (_selectPureColorView)
    {
        return _selectPureColorView;
    }
    
    if ([[JJChangeSkinManager sharedInstance].pureColorItemDic count] <= 0)
    {
        return nil;
    }
    
    _selectPureColorView = [[UIScrollView alloc] init];
    _selectPureColorView.showsHorizontalScrollIndicator = NO;
    
    _selectPureColorView.backgroundColor = [UIColor whiteColor];
    
    UIEdgeInsets selectPureColorViewMargin = [self.jj_skinManager getEdgeInsetsByID:@"R.titleBarChangeSkin.selectPureColorView.margin"];
    NSInteger selectViewInterval = [self.jj_skinManager getIntegerByID:@"R.titleBarChangeSkin.selectPureColorView.selectViewInterval"];
    
    CGSize selectViewSize = [self.jj_skinManager getSizeByID:@"R.titleBarChangeSkin.selectPureColorView.selectView.size"];
    
    __block NSInteger x = selectPureColorViewMargin.left;
    
    NSArray *sortPureColorArray = [[JJChangeSkinManager sharedInstance].pureColorItemDic.allValues sortedArrayUsingComparator:^NSComparisonResult(JJChangeSkinPureColorItem *obj1, JJChangeSkinPureColorItem *obj2)
    {
        if (obj1.index > obj2.index)
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (obj1.index < obj2.index)
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    [sortPureColorArray enumerateObjectsUsingBlock:^(JJChangeSkinPureColorItem *obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         JJSelectView *selectView = [[JJSelectView alloc] init];
         selectView.colorString = obj.colorString;
         selectView.jj_backgroundView.backgroundColor = [UIColor jj_colorWithHexString:obj.colorString];
         selectView.frame = CGRectMake(x, selectPureColorViewMargin.top, selectViewSize.width, selectViewSize.height);
         
         selectView.titleLabel.text = obj.title;
         if (obj.titleColorString)
         {
             UIColor *titleColor = [UIColor jj_colorWithHexString:obj.titleColorString];
             selectView.titleLabel.textColor = titleColor;
             selectView.titleLabel.layer.borderColor = titleColor.CGColor;
         }
         
         selectView.jj_selectBlock = ^()
         {
             [[JJChangeSkinManager sharedInstance] changePureColor:obj.colorString];
             
             [self __statisticsForPreview];
         };
         [_selectPureColorView addSubview:selectView];
         
         x += selectViewSize.width + selectViewInterval;
     }];
    
    CGSize contentSize = CGSizeMake(x - selectViewInterval + selectPureColorViewMargin.right, selectPureColorViewMargin.top + selectViewSize.height + selectPureColorViewMargin.bottom);
    _selectPureColorView.contentSize = contentSize;
    
    _selectPureColorView.jjHeight = contentSize.height;
    
    return _selectPureColorView;
}

- (UIScrollView *)selectPhotoView
{
    if (_selectPhotoView)
    {
        return _selectPhotoView;
    }
    
    _selectPhotoView = [[UIScrollView alloc] init];
    _selectPhotoView.showsHorizontalScrollIndicator = NO;
    
    _selectPhotoView.backgroundColor = [UIColor whiteColor];
    
    UIEdgeInsets selectPhotoViewMargin = [self.jj_skinManager getEdgeInsetsByID:@"R.titleBarChangeSkin.selectPhotoView.margin"];
    NSInteger selectViewInterval = [self.jj_skinManager getIntegerByID:@"R.titleBarChangeSkin.selectPhotoView.selectViewInterval"];
    
    CGSize selectViewSize = [self.jj_skinManager getSizeByID:@"R.titleBarChangeSkin.selectPhotoView.selectView.size"];
    
    __block NSInteger x = selectPhotoViewMargin.left;
    
    JJSelectPhotoView *selectView = [[JJSelectPhotoView alloc] init];
    [selectView.titleLabel removeFromSuperview];
    selectView.backgroundColor = [UIColor jj_colorWithRGBA:248 green:248 blue:248];
    [selectView.jj_backgroundView setImage:[UIImage imageNamed:@"JJChangeSkinView_rss_addPhotoAlbum"] forState:UIControlStateNormal];
    selectView.frame = CGRectMake(x, selectPhotoViewMargin.top, selectViewSize.width, selectViewSize.height);
    __weak typeof(self) weakSelf = self;
    selectView.jj_selectBlock = ^()
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[@"public.image"];
        imagePicker.delegate = weakSelf;
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    };
    [_selectPhotoView addSubview:selectView];
    x += selectViewSize.width + selectViewInterval;
    
    [[JJChangeSkinManager sharedInstance].photoItemList.items enumerateObjectsUsingBlock:^(JJChangeSkinPhotoItem *obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (obj.haveDeletedMark)
         {
             return;
         }
         
         JJSelectPhotoView *selectView = [[JJSelectPhotoView alloc] init];
         [selectView setPhotoName:obj.name];
         [selectView.jj_backgroundView setImage:[obj thumbnailPhotoImage] forState:UIControlStateNormal];
         [selectView.jj_backgroundView setImage:[obj thumbnailPhotoImage] forState:UIControlStateHighlighted];
         selectView.frame = CGRectMake(x, selectPhotoViewMargin.top, selectViewSize.width, selectViewSize.height);
         
         if (obj.title)
         {
             selectView.titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
             selectView.titleLabel.text = obj.title;
         }
         else
         {
             [selectView.titleLabel removeFromSuperview];
         }
         
         if (obj.titleColorString)
         {
             UIColor *titleColor = [UIColor jj_colorWithHexString:obj.titleColorString];
             selectView.titleLabel.textColor = titleColor;
             selectView.titleLabel.layer.borderColor = titleColor.CGColor;
         }
         
         selectView.jj_selectBlock = ^()
         {
             [[JJChangeSkinManager sharedInstance] changePhotoName:obj.name];
             
             [self __statisticsForPreview];
         };
         [_selectPhotoView addSubview:selectView];
         
         x += selectViewSize.width + selectViewInterval;
     }];
    
    CGSize contentSize = CGSizeMake(x - selectViewInterval + selectPhotoViewMargin.right, selectPhotoViewMargin.top + selectViewSize.height + selectPhotoViewMargin.bottom);
    _selectPhotoView.contentSize = contentSize;
    
    _selectPhotoView.jjHeight = contentSize.height;
    
    return _selectPhotoView;
}

- (JJToolBar *)toolBar
{
    if (_toolBar)
    {
        return _toolBar;
    }
    
    _toolBar = [[JJToolBar alloc] init];
    _toolBar.backgroundColor = [UIColor jj_colorWithRGBA:247 green:247 blue:248];
    
    UIButton *backButton = [self.jj_skinManager getButtonByID:@"R.titleBarChangeSkin.toolBar.backButton"];
    [backButton setTitleColor:UIColorWithRGBA(113, 113, 113, 1) forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:28.f];
    [backButton addTarget:self action:@selector(pressBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger toolBarHeight = [self.jj_skinManager getIntegerByID:@"R.titleBarChangeSkin.toolBar.height"];
    _toolBar.jjHeight = toolBarHeight;
    
    NSInteger toolBarRightMargin = [self.jj_skinManager getIntegerByID:@"R.titleBarChangeSkin.toolBar.rightMargin"];
    
    UIButton *selectButton = [self.jj_skinManager getButtonByID:@"R.titleBarChangeSkin.toolBar.selectButton"];
    [selectButton setTitleColor:UIColorWithRGBA(113, 113, 113, 1) forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:30.f];
    [selectButton addTarget:self action:@selector(pressSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.jjLeft = [UIDevice jj_screenWidth] - toolBarRightMargin - selectButton.jjWidth;
    
    [_toolBar setItems:@[backButton, selectButton] animated:YES];
    
    return _toolBar;
}

- (UIView *)pureColorBackgroundMaskView
{
    if (_pureColorBackgroundMaskView)
    {
        return _pureColorBackgroundMaskView;
    }
    
    _pureColorBackgroundMaskView = [[UIView alloc] init];
    _pureColorBackgroundMaskView.frame = [UIDevice jj_screenBounds];
    _pureColorBackgroundMaskView.backgroundColor = [UIColor blackColor];
    _pureColorBackgroundMaskView.alpha = 0.5;
    
    return _pureColorBackgroundMaskView;
}

@end
