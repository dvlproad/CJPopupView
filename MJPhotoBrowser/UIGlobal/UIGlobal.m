//
//  UIGlobal.m
//
//
//  Created by yuliang on 8/8/13.
//

#import "UIGlobal.h"
#import "MBProgressHUD.h"

@implementation UIGlobal

#pragma mark - UIAlertView
+ (void)alert:(NSString *)message
{
    [[self class] alert:message withTitle:@"提示"];
}
#pragma mark - MBProgressHUD

+ (void)showMessage:(NSString *)message
{
    NSLog(@"message = %@", message);
}


+ (MBProgressHUD*)showHudForView:(UIView *)view animated:(BOOL)animated
{
    if (!view)
        return nil;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.animationType = MBProgressHUDAnimationFade;
//    NSArray *subs = [hud subviews];
//    for (UIView *v in subs)
//    {
//        if ([v isKindOfClass:[UIActivityIndicatorView class]])
//        {
//            UIActivityIndicatorView *aiv = (UIActivityIndicatorView*)v;
//            aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//            break;
//        }
//        if ([v isKindOfClass:[MBRoundProgressView class]])
//        {
//            MBRoundProgressView *rpv = (MBRoundProgressView*)v;
//            rpv.backgroundColor = [UIColor clearColor];
//            rpv.progressTintColor = [UIColor blueColor];
//            rpv.backgroundColor = [UIColor clearColor];
//            break;
//        }
//    }
//    hud.color = [UIColor clearColor];
    
    return hud;
}

+ (void)hideHudForView:(UIView *)view animated:(BOOL)animated
{
    if (view)
        [MBProgressHUD hideHUDForView:view animated:animated];
}
@end
