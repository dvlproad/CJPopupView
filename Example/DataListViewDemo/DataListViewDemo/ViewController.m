//
//  ViewController.m
//  DataListViewDemo
//
//  Created by 李超前 on 16/6/18.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "ViewController.h"
#import "DataListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)goDataListViewController:(id)sender {
    DataListViewController *viewController = [[DataListViewController alloc] initWithNibName:@"DataListViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
