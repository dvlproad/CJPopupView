//
//  MaskGuideHUDViewController.m
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/3/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "MaskGuideHUDViewController.h"
#import "CJMaskGuideHUD.h"
#import "CustomMaskGuideHUD.h"

@interface MaskGuideHUDViewController ()<CJMaskGuideHUDDeledate> {
    
}
@property (nonatomic, weak) IBOutlet UIImageView *topImageView;
@property (nonatomic, weak) IBOutlet UIImageView *middle1;
@property (nonatomic, weak) IBOutlet UIImageView *middle2;
@property (nonatomic, weak) IBOutlet UIImageView *middle3;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIButton *iconButton;


@property (nonatomic, strong) CJMaskGuideHUD *hud;

@property (nonatomic, assign) NSInteger totalStep;
@property (nonatomic, assign) NSInteger currentStep;

@end

@implementation MaskGuideHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalStep = 5;
    self.currentStep = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CJMaskGuideHUD *hud = [CJMaskGuideHUD showHUDAddedTo:self.navigationController.view visibleView:self.middle2 animated:NO];
    hud.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    hud.margin = 0;
    hud.delegate = self;
    hud.style = CJMaskGuideHUDBackgroundStyleSolidColor;
    
    self.hud = hud;
    self.hud.alpha = 1;
    self.hud.userInteractionEnabled = YES;
}

#pragma makr - CJMaskGuideHUDDeledate
- (void)cjMaskGuideHUD_TouchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.currentStep++;
    
    if (self.currentStep > self.totalStep) {
        [self.hud hide:NO];
        return;
    }
    
    switch (self.currentStep) {
        case 1:
        {
            self.hud.visibleView = self.topImageView;
            self.hud.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            break;
        }
        case 2:
        {
            self.hud.visibleView = self.middle1;
            self.hud.edgeInsets = UIEdgeInsetsZero;
            break;
        }
        case 3:
        {
            self.hud.visibleView = self.middle2;
            self.hud.style = CJMaskGuideHUDBackgroundStyleBlur;
            self.hud.blurStyle = CJMaskGuideHUDBlurStyleDark;
            self.hud.blurColor = [UIColor colorWithWhite:0 alpha:0.8];
            break;
        }
        case 4:
        {
            self.hud.visibleView = self.middle3;
            self.hud.alpha = 0.8;
            break;
        }
        case 5:
        {
            self.hud.visibleView = self.searchBar;
            self.hud.style = CJMaskGuideHUDBackgroundStyleSolidColor;
            break;
        }
        default:
        {
            break;
        }
    }
}

- (IBAction)showMaskGuideHUDBottom:(id)sender {
    [CustomMaskGuideHUD showHUDWithText:@"这里弹出的视图显示在下面" visibleView:self.topImageView];
}

- (IBAction)showMaskGuideHUDTop:(id)sender {
    [CustomMaskGuideHUD showHUDWithText:@"我把梦撕了一页，不懂明天该怎么写" visibleView:self.iconButton];
}


@end
