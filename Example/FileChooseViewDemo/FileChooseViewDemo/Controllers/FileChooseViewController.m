//
//  FileChooseViewController.m
//  FileChooseViewDemo
//
//  Created by 李超前 on 2017/1/19.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "FileChooseViewController.h"

@interface FileChooseViewController ()

@end

@implementation FileChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableArray *dataModels = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 10; i++) {
        CJBaseUploadItem *baseUploadItem = [[CJBaseUploadItem alloc] init];
        baseUploadItem.operation = nil;
        
        [dataModels addObject:baseUploadItem];
    }
    self.uploadCollectionView.dataModels = dataModels;
    
    self.uploadCollectionView.belongToViewController = self;
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
