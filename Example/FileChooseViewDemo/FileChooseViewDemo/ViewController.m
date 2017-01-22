//
//  ViewController.m
//  FileChooseViewDemo
//
//  Created by 李超前 on 2017/1/7.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "ViewController.h"
#import "FileChooseViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)goFileChooseViewController:(id)sender {
    FileChooseViewController *viewController = [[FileChooseViewController alloc] initWithNibName:@"FileChooseViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
