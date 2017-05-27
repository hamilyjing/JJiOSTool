//
//  BIUserDefaultsSliderCell.h
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsTableViewCell.h"

@interface BIUserDefaultsSliderCell : BIUserDefaultsTableViewCell

@property (nonatomic, strong, readonly) UISlider *slider;
@property (nonatomic, strong, readonly) UILabel *minLabel;
@property (nonatomic, strong, readonly) UILabel *maxLabel;

@property (nonatomic) UIEdgeInsets minLabelEdgeInsets;
@property (nonatomic) UIEdgeInsets maxLabelEdgeInsets;

@end
