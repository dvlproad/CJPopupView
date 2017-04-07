//
//  HPUIKits.h
//  ijinbu
//
//  Created by Michael on 3/31/16.
//  Copyright © 2016 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface HCView : UIView
// 设置背景图片
@property (nonatomic, strong) IBInspectable UIImage * backgroundImage;

// 设置圆角大小
@property (nonatomic) IBInspectable CGFloat cornerRadius;

// 设置边框颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

// 设置边框大小
@property (nonatomic) IBInspectable CGFloat borderWidth;

@end

@interface HCControl : UIControl

// 设置背景图片
@property (nonatomic, strong) IBInspectable UIImage * backgroundImage;

// 设置圆角大小
@property (nonatomic) IBInspectable CGFloat cornerRadius;

// 设置边框颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

// 设置边框大小
@property (nonatomic) IBInspectable CGFloat borderWidth;

@property (nonatomic, strong) id hcTarget;

@property (nonatomic, strong) IBInspectable UIColor *highlightedColor;
@property (nonatomic, strong) IBInspectable UIColor *defaultColor;

@end


IB_DESIGNABLE
@interface HCButton : UIButton

@property (nonatomic, strong) id hcTarget;

// 设置图片可以重用区域，防止图片边角变形
// CGRect会相应转换为UIEdgeInsets对象 x -> top, y -> left, w -> bottom, h -> right
@property (nonatomic) IBInspectable CGRect imageCapInsets;

// 设置圆角大小
@property (nonatomic) IBInspectable CGFloat cornerRadius;

// 设置边框颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

// 设置边框大小
@property (nonatomic) IBInspectable CGFloat borderWidth;

@end

IB_DESIGNABLE
@interface HCLabel : UILabel

// 设置圆角大小
@property (nonatomic) IBInspectable CGFloat cornerRadius;

// 设置边框颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

// 设置边框大小
@property (nonatomic) IBInspectable CGFloat borderWidth;

@end

IB_DESIGNABLE
@interface HCTextView : UITextView

// 设置圆角大小
@property (nonatomic) IBInspectable CGFloat cornerRadius;

// 设置边框颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

// 设置边框大小
@property (nonatomic) IBInspectable CGFloat borderWidth;

@end

IB_DESIGNABLE
@interface HCImageView : UIImageView

// 设置圆角大小
@property (nonatomic) IBInspectable CGFloat cornerRadius;

// 设置边框颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

// 设置边框大小
@property (nonatomic) IBInspectable CGFloat borderWidth;

@property (nonatomic, assign) BOOL selected;
// 设置图片可以重用区域，防止图片边角变形
// CGRect会相应转换为UIEdgeInsets对象 x -> top, y -> left, w -> bottom, h -> right
@property (nonatomic) IBInspectable CGRect imageCapInsets;

@end
