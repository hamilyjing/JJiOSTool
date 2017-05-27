//
//  BIUserDefaultsDefines.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsDefines.h"

CGFloat const kControlLeftPadding  = 12;
CGFloat const kControlRightPadding = 12;

//兼容iOS类型

NSString *const BIUserDefaultsRootFile = @"Root";
NSString *const BIUserDefaultsTitle = @"Title";
NSString *const BIUserDefaultsStringsTable = @"StringsTable";
NSString *const BIUserDefaultsSpecifiers = @"PreferenceSpecifiers";

NSString *const BIGroupSpecifier = @"PSGroupSpecifier";
NSString *const BIRadioGroupSpecifier = @"PSRadioGroupSpecifier";
NSString *const BISliderSpecifier = @"PSSliderSpecifier";
NSString *const BIChildPaneSpecifier = @"PSChildPaneSpecifier";
NSString *const BITextFieldSpecifier = @"PSTextFieldSpecifier";
NSString *const BITitleValueSpecifier = @"PSTitleValueSpecifier";
NSString *const BIMultiValueSpecifier = @"PSMultiValueSpecifier";
NSString *const BIToggleSwitchSpecifier = @"PSToggleSwitchSpecifier";

NSString *const BISpecifierKey = @"Key";
NSString *const BISpecifierType = @"Type";
NSString *const BISpecifierFile = @"File";
NSString *const BISpecifierFileType = @"FileType";
NSString *const BISpecifierTableViewStyle = @"TableViewStyle";
NSString *const BISpecifierTitle = @"Title";
NSString *const BISpecifierFooterText = @"FooterText";
NSString *const BISpecifierTitles = @"Titles";
NSString *const BISpecifierShortTitles = @"ShortTitles";
NSString *const BISpecifierValues = @"Values";
NSString *const BISpecifierDefaultValue = @"DefaultValue";
NSString *const BISpecifierTrueValue = @"TrueValue";
NSString *const BISpecifierFalseValue = @"FalseValue";
NSString *const BISpecifierMinimumValue = @"MinimumValue";
NSString *const BISpecifierMaximumValue = @"MaximumValue";
NSString *const BISpecifierMinimumValueImage = @"MinimumValueImage";
NSString *const BISpecifierMaximumValueImage = @"MaximumValueImage";
NSString *const BISpecifierMinimumTextValue = @"MinimumTextValue";
NSString *const BISpecifierMaximumTextValue = @"MaximumTextValue";
NSString *const BISpecifierIsSecure = @"IsSecure";
NSString *const BISpecifierKeyboardType = @"KeyboardType";
NSString *const BISpecifierAutoCapitalizationType = @"AutoCapitalizationType";
NSString *const BISpecifierAutoCorrectionType = @"AutoCorrectionType";

//自定义类型
NSString *const BIButtonSpecifier = @"ButtonSpecifier";
NSString *const BICustomSpecifier = @"CustomSpecifier";

NSString *const BISpecifierID = @"ID";
NSString *const BISpecifierCellClass = @"CellClass";
NSString *const BISpecifierCellStyle = @"CellStyle";
NSString *const BISpecifierDetailText = @"DetailText";
NSString *const BISpecifierDetailControllerClass = @"DetailControllerClass";

NSString *const BISpecifierKeyStoryboardName = @"StoryboardName";
NSString *const BISpecifierKeyViewControllerIdentifier = @"ViewControllerIdentifier";

NSString *const BISpecifierStyle = @"Style";
NSString *const BISpecifierMessage = @"Message";
NSString *const BISpecifierHideIndexsAction = @"HideIndexsAction";
NSString *const BISpecifierAction = @"Action";
NSString *const BISpecifierGetter = @"Getter";
NSString *const BISpecifierSetter = @"Setter";
NSString *const BISpecifierTextAlignment = @"Alignment";
NSString *const BISpecifierConfirmAction = @"ConfirmAction";
NSString *const BISpecifierConfirmActionTitle = @"ConfirmActionTitle";
NSString *const BISpecifierCancelAction = @"CancelAction";
NSString *const BISpecifierCancelActionTitle = @"CancelActionTitle";
NSString *const BISpecifierAlertController = @"AlertController";
NSString *const BISpecifierDependences = @"Dependences";
NSString *const BISpecifierDependenceType = @"Type";
NSString *const BISpecifierDependenceKey = @"Key";
NSString *const BISpecifierDependenceDefaultValue = @"DefaultValue";
NSString *const BISpecifierDependenceTrueValue = @"TrueValue";

//字符常量
NSString *const BISpecifierFileTypePlist = @"Plist";
NSString *const BISpecifierFileTypeBundle = @"Bundle";
NSString *const BISpecifierFileTypeURI = @"URI";
NSString *const BISpecifierFileTypeViewController = @"ViewController";
NSString *const BISpecifierAlertControllerStyleAlert = @"Alert";
NSString *const BISpecifierAlertControllerStyleActionSheet = @"ActionSheet";
NSString *const BISpecifierTextAlignmentLeft = @"Left";
NSString *const BISpecifierTextAlignmentCenter = @"Center";
NSString *const BISpecifierAutoCorrectionTypeDefault = @"Default";
NSString *const BISpecifierAutoCorrectionTypeYes = @"Yes";
NSString *const BISpecifierAutoCorrectionTypeNo = @"No";
NSString *const BISpecifierAutoCapitalizationTypeNone = @"None";
NSString *const BISpecifierAutoCapitalizationTypeSentences = @"Sentences";
NSString *const BISpecifierAutoCapitalizationTypeWords = @"Words";
NSString *const BISpecifierAutoCapitalizationTypeAllCharacters = @"AllCharacters";
NSString *const BISpecifierKeyboardTypeDefault = @"Default";
NSString *const BISpecifierKeyboardTypeAlphabet = @"Alphabet";
NSString *const BISpecifierKeyboardTypeNumbersAndPunctuation = @"NumbersAndPunctuation";
NSString *const BISpecifierKeyboardTypeNumberPad = @"NumberPad";
NSString *const BISpecifierKeyboardTypePhonePad = @"PhonePad";
NSString *const BISpecifierKeyboardTypeURL = @"URL";
NSString *const BISpecifierKeyboardTypeEmailAddress = @"EmailAddress";
NSString *const BISpecifierKeyboardTypeKeyboardTypePhonePad = @"KeyboardTypePhonePad";
NSString *const BISpecifierKeyboardTypeNamePhonePad = @"NamePhonePad";
NSString *const BISpecifierKeyboardTypeASCIICapable = @"ASCIICapable";
NSString *const BISpecifierKeyboardTypeDecimalPad = @"DecimalPad";
NSString *const BISpecifierTableViewStyleGroup = @"Group";
NSString *const BISpecifierTableViewStylePlain = @"Plain";
NSString *const BISpecifierCellStyleDefault = @"Default";
NSString *const BISpecifierCellStyleValue1 = @"Value1";
NSString *const BISpecifierCellStyleValue2 = @"Value2";
NSString *const BISpecifierCellStyleSubtitle = @"Subtitle";
NSString *const BISpecifierDependenceTypeVisibility = @"Visibility";
NSString *const BISpecifierDependenceTypeReload = @"Reload";

