//
//  SheetViewController.m
//  CJPopupViewDemo
//
//  Created by ciyouzen on 8/27/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "SheetViewController.h"

@interface SheetViewController ()

@end

@implementation SheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)show_UIActionSheet:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle: @"File Management"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:@"Delete File"
                                                   otherButtonTitles:@"Rename File", @"Email File", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    printf("User Pressed Button %d\n", buttonIndex + 1);
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
