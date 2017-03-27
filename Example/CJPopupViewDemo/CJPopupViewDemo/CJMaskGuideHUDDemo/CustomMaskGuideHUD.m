//
//  CustomMaskGuideHUD.m
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/3/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CustomMaskGuideHUD.h"
#import "SubGuideView.h"

@implementation CustomMaskGuideHUD

+ (instancetype)showHUDWithText:(NSString *)text visibleView:(UIView *)visibleView {
    UIView *addToView = [UIApplication sharedApplication].keyWindow;
    
    return [self showHUDWithText:text addedTo:addToView visibleView:visibleView];
}

+ (instancetype)showHUDWithText:(NSString *)text addedTo:(UIView *)view visibleView:(UIView *)visibleView
{
    CustomMaskGuideHUD *hud = [self showHUDAddedTo:view visibleView:visibleView animated:NO];
    hud.style = CJMaskGuideHUDBackgroundStyleBlur;
    hud.lineWidth = 5;
    hud.margin = 0;
    hud.edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    hud.cornerRadius = visibleView.frame.size.width / 2.0;
    hud.alpha = 0.9;
    hud.blurColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    __weak typeof(hud)weakHud = hud;
    [hud setTouchBackgroundHandle:^{
        [weakHud hideAnimated:YES afterDelay:0];
    }];
    
    CGFloat hudSubviewWidth = CGRectGetWidth(hud.frame);
    CGRect rect = [text boundingRectWithSize:CGSizeMake(hudSubviewWidth - 80, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
                                     context:nil];
    CGFloat hudSubviewHeight = rect.size.height ;
    hudSubviewHeight = hudSubviewHeight > 44 ? hudSubviewHeight + 16 : 60;
    
//    SubGuideView *hudSubview = [[NSBundle mainBundle] loadNibNamed:@"SubGuideView" owner:nil options:nil].firstObject;
//    __weak typeof(hud) weakHud = hud;
//    [hudSubview setText:text];
//    hudSubview.confirmBlock = ^{
//        [weakHud hide:YES];
//    };
    
    UILabel *hudSubview = [[UILabel alloc] initWithFrame:CGRectZero];
    [hudSubview setTextColor:[UIColor whiteColor]];
    [hudSubview setText:text];
    
//    [hud addHUDSubview:hudSubview withHudSubviewHeight:hudSubviewHeight];
    UIImage *image = [UIImage imageNamed:@"cjMaskGuideArrowDownWhite"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width-1, 0, image.size.width) resizingMode:UIImageResizingModeStretch]; //拉伸模式
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = image;
    [hud addHUDSubview:hudSubview withHeight:hudSubviewHeight andSubViewIndicator:imageView withWidth:29 position:CJMaskGuideIndicatorPositonStartInCenter];
    
    return hud;
}

@end
