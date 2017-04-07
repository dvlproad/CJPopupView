//
//  UIGlobal.h
//
//  Created by yuliang on 8/8/13.
//  Copyright (c) 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class WCAlertView;
@class MBProgressHUD;

typedef void(^UIGlobalAlertCompletionBlock)(NSUInteger buttonIndex, WCAlertView *alertView);

@interface UIGlobal : NSObject

+ (void)alert:(NSString*)message;
+ (void)alert:(NSString*)message withTitle:(NSString*)title;
+ (void)alertLongMessage:(NSString*)message withTitle:(NSString*)title;
+ (void)showAlertViewWithMessage:(NSString *)message
                        delegate:(id /*<UIAlertViewDelegate>*/)delegate
               cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
+ (id)showAlertWithTitle:(NSString *)title message:(NSString *)message customizationBlock:(void (^)(WCAlertView *alertView))customization completionBlock:(void (^)(NSUInteger buttonIndex, WCAlertView *alertView))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

+ (void)showMessage:(NSString*)message;
+ (void)showMessage:(NSString *)message inView:(UIView *)view;
+ (void)showError:(NSError *)error;
+ (MBProgressHUD*)showHudForView:(UIView*)view animated:(BOOL)animated;
+ (void)hideHudForView:(UIView*)view animated:(BOOL)animated;


@end
