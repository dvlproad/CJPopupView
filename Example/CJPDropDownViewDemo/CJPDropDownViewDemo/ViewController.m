//
//  ViewController.m
//  CJPDropDownViewDemo
//
//  Created by lichq on 15/11/11.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "ViewController.h"
#import "IndependentTestVC.h"
#import "CombineTestVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showIndependentTestVC:(id)sender{
    IndependentTestVC *vc = [[IndependentTestVC alloc]initWithNibName:@"IndependentTestVC" bundle:nil];
    vc.title = NSLocalizedString(@"独立测试", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)showCombineTestVC:(id)sender{
    CombineTestVC *vc = [[CombineTestVC alloc]initWithNibName:@"CombineTestVC" bundle:nil];
    vc.title = NSLocalizedString(@"结合测试", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
