//
//  NewerGuideViewController.m
//  CJMaskGuideViewDemo
//
//  Created by 李超前 on 2016/12/6.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "NewerGuideViewController.h"
#import "CJMaskGuideView.h"

static NSString *kHasShowIMMaskGuid = @"kHasShowIMMaskGuid";

@interface NewerGuideViewController () <CJMaskGuideViewDataSource, CJMaskGuideViewDelegate> {
    
}
@property (nonatomic, weak) IBOutlet UIButton *maskButton;

@end

@implementation NewerGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = @"10001";
    NSString *kHasShowIMMaskGuidKey = [NSString stringWithFormat:@"%@_%@", userId, kHasShowIMMaskGuid];
    BOOL hasShowIMMaskGuid = [[userDefaults objectForKey:kHasShowIMMaskGuidKey] boolValue];
    hasShowIMMaskGuid = NO;//测试专用
    if (!hasShowIMMaskGuid) {
        CJMaskGuideView *maskGuideView = [[CJMaskGuideView alloc] init];
        maskGuideView.dataSource = self;
        maskGuideView.delegate = self;
        __weak typeof(CJMaskGuideView *)weakMaskGuideView = maskGuideView;
        maskGuideView.cjMaskGuideViewFrameSettingBlock = ^(UIView *maskImageView, UIView *arrowImageView, UILabel *tipsLabel, UIButton *okButton) {
            CGRect arrowImageViewFrame = arrowImageView.frame;
            arrowImageViewFrame.origin.x = CGRectGetMinX(maskImageView.frame) + 10;
            arrowImageViewFrame.origin.y = CGRectGetMaxY(maskImageView.frame) + 10;
            arrowImageView.frame = arrowImageViewFrame;
            
            CGRect tipsLabelFrame = tipsLabel.frame;
            tipsLabel.center = weakMaskGuideView.center;
            tipsLabelFrame.origin.y = CGRectGetMaxY(maskImageView.frame) + 50;
            tipsLabelFrame.size = CGSizeMake(300, 60);
            tipsLabel.frame = tipsLabelFrame;
            
            CGRect okButtonFrame = okButton.frame;
            okButtonFrame.origin.x = (CGRectGetWidth(weakMaskGuideView.frame)- CGRectGetWidth(okButton.frame))/2;
            okButtonFrame.origin.y = CGRectGetMaxY(weakMaskGuideView.frame) - 140 - CGRectGetHeight(okButton.frame);
            okButton.frame = okButtonFrame;
        };
        
        [maskGuideView showInView:self.view maskBtn:self.maskButton canDismissByTouchBackground:NO];
        [self.maskButton setImage:[UIImage imageNamed:@"IMMaskButton"] forState:UIControlStateNormal];
        
        [userDefaults setObject:@(YES) forKey:kHasShowIMMaskGuidKey];
    }
}

#pragma mark - CJMaskGuideViewDataSource && CJMaskGuideViewDelegate
- (void)cj_maskGuideView:(CJMaskGuideView *)maskGuidView okButton:(UIButton *)okButton {
    
}

- (void)cj_maskGuideView:(CJMaskGuideView *)maskGuidView arrowImageView:(UIImageView *)arrowImageView {
    
}

- (void)cj_maskGuideView:(CJMaskGuideView *)maskGuidView tipsLabel:(UILabel *)tipsLabel {
    tipsLabel.text = @"点击查找更多群组与通讯录进行\n交流沟通!";
}


- (void)cj_maskGuideView:(CJMaskGuideView *)maskGuidView clickOKButton:(UIButton *)okButton {
    NSLog(@"点击了确定按钮");
}

- (void)cj_maskGuideView:(CJMaskGuideView *)maskGuidView clickMaskButton:(UIButton *)maskButton {
    NSLog(@"点击了遮罩按钮");
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
