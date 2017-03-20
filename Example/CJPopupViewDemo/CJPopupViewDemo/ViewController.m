//
//  ViewController.m
//  CJPopupViewDemo
//
//  Created by 李超前 on 2017/3/20.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "ViewController.h"
#import "PopoverViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"首页", nil);
}

- (IBAction)goPopoverViewController:(id)sender {
    PopoverViewController *viewController = [[PopoverViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
