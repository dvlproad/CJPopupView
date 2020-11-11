//
//  AlertViewController.m
//  CJPopupViewDemo
//
//  Created by ciyouzen on 8/27/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//UIAlert常用方法(<=2)
- (IBAction)showAlert_NormalUse1:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert标题"
                                                   message:nil
                                                  delegate:nil
                                         cancelButtonTitle:@"Cancel标题"
                                         otherButtonTitles:@"OK", nil];
    [alert show];
}

//UIAlert常用方法(>2)
- (IBAction)showAlert_NormalUse2:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert标题"
                                                   message:nil
                                                  delegate:nil
                                         cancelButtonTitle:@"Cancel标题"
                                         otherButtonTitles:@"One", @"Two", @"Three", nil];
    [alert show];
}

//UIAlert自动消失
- (IBAction)showAlert_AutoDismiss:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert标题"
                                                   message:nil
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:nil];
    [alert show];
    [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(disMissAlert:) userInfo:alert repeats:NO];
}

- (void)disMissAlert:(NSTimer *)timer{
    UIAlertView *alert = timer.userInfo;
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}


//UIAlert带文本输入框
- (IBAction)showAlert_TextField:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"登录", nil)
                                                   message:NSLocalizedString(@"请输入用户名和密码", nil)
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                         otherButtonTitles:NSLocalizedString(@"登录", nil), nil];
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    UITextField *tfName = [alert textFieldAtIndex:0];
    UITextField *tfPasd = [alert textFieldAtIndex:1];
    tfName.placeholder = NSLocalizedString(@"请输入用户名", nil);
    tfPasd.placeholder = NSLocalizedString(@"请输入密码", nil);
    [tfPasd setSecureTextEntry:NO];
    [alert show];
    /*
    typedef NS_ENUM(NSInteger, UIAlertViewStyle) {
        UIAlertViewStyleDefault = 0,
        UIAlertViewStyleSecureTextInput,
        UIAlertViewStylePlainTextInput,
        UIAlertViewStyleLoginAndPasswordInput
    };
    */
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    printf("User Pressed Button %ld\n", buttonIndex + 1);
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *tfName = [alertView textFieldAtIndex:0];
        UITextField *tfPasd = [alertView textFieldAtIndex:1];
        NSLog(@"输入的用户名和密码是:%@：%@", tfName.text, tfPasd.text);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
