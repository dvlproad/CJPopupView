//
//  CustomMaskGuideHUD.h
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/3/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJMaskGuideHUD+addHUDSubview.h"

@interface CustomMaskGuideHUD : CJMaskGuideHUD

+ (instancetype)showHUDWithText:(NSString *)text visibleView:(UIView *)visibleView;
+ (instancetype)showHUDWithText:(NSString *)text addedTo:(UIView *)view visibleView:(UIView *)visibleView;


@end
