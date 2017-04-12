//
//  ViewController.m
//  CJPickerDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ViewController.h"
#import "PickerViewController.h"
#import "RelatedPickerViewController.h"
#import "RelatedPickerViewController2.h"

#import "ImagePickerViewController.h"

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

- (IBAction)goRelatedPickerViewController:(id)sender {
    RelatedPickerViewController *viewController = [[RelatedPickerViewController alloc] initWithNibName:@"RelatedPickerViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goRelatedPickerViewController2:(id)sender {
    RelatedPickerViewController2 *viewController = [[RelatedPickerViewController2 alloc] initWithNibName:@"RelatedPickerViewController2" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goImagePickerViewController:(id)sender {
    ImagePickerViewController *viewController = [[ImagePickerViewController alloc] initWithNibName:@"ImagePickerViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
