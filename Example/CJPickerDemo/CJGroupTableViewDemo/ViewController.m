//
//  ViewController.m
//  CJRelatedPickerRichViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ViewController.h"
#import "PickerViewController.h"
#import "GroupTableViewController.h"
#import "GroupTableViewController2.h"
#import "ButtonsSingleTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"首页", nil);
}

- (IBAction)goPickerViewController:(id)sender {
    PickerViewController *viewController = [[PickerViewController alloc] initWithNibName:@"PickerViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goGroupTableViewController:(id)sender {
    GroupTableViewController *viewController = [[GroupTableViewController alloc] initWithNibName:@"GroupTableViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goGroupTableViewController2:(id)sender {
    GroupTableViewController2 *viewController = [[GroupTableViewController2 alloc] initWithNibName:@"GroupTableViewController2" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)goButtonsSingleTableViewController:(id)sender {
    ButtonsSingleTableViewController *viewController = [[ButtonsSingleTableViewController alloc] initWithNibName:@"ButtonsSingleTableViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
