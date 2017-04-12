//
//  ViewController.m
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/3/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "ViewController.h"
#import "PopoverViewController.h"
#import "DragViewController.h"
#import "MaskGuideHUDViewController.h"
#import "AlertViewController.h"
#import "SheetViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"首页", nil);
}

- (IBAction)goAlertViewController:(id)sender {
    AlertViewController *viewController = [[AlertViewController alloc]initWithNibName:@"AlertViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goSheetViewController:(id)sender {
    SheetViewController *viewController = [[SheetViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goPopoverViewController:(id)sender {
    PopoverViewController *viewController = [[PopoverViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goDragViewController:(id)sender {
    DragViewController *viewController = [[DragViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goMaskGuideHUDViewController:(id)sender {
    MaskGuideHUDViewController *viewController = [[MaskGuideHUDViewController alloc] initWithNibName:@"MaskGuideHUDViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
