//
//  DragViewController.m
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/11/05.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "DragViewController.h"

#import "CJDragView.h"
#import "MyDragView.h"

@interface DragViewController ()

@property (nonatomic, strong) IBOutlet CJDragView *redView;
@property (nonatomic, strong) IBOutlet MyDragView *orangeView;

@end

@implementation DragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"可拖曳的View", nil);
    
    [self.orangeView.button setTitle:@"可拖曳" forState:UIControlStateNormal];
    [self.orangeView setClickButtonBlock:^(MyDragView *dragView) {
        NSLog(@"绿色view被点击了");
        dragView.dragEnable = !dragView.dragEnable;
        if (dragView.dragEnable) {
            [dragView.button setTitle:@"可拖曳" forState:UIControlStateNormal];
        }else{
            [dragView.button setTitle:@"不可拖曳" forState:UIControlStateNormal];
        }
    }];
    //开始拖曳block
    self.orangeView.dragBeginBlock = ^(CJDragView *dragView){
        NSLog(@"开始拖曳橙色视图");
    };
    //结束拖曳block
    self.orangeView.dragEndBlock = ^(CJDragView *dragView){
        NSLog(@"结束拖曳橙色视图");
    };
    
    ///初始化可以拖曳的view
    MyDragView *logoView = [[MyDragView alloc] initWithFrame:CGRectMake(0, 0 , 70, 70)];
    logoView.center = self.view.center;
    logoView.layer.cornerRadius = 14;
    [logoView.button setBackgroundImage:[UIImage imageNamed:@"image1"] forState:UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:logoView];
    //可额外设定限定dragView的活动范围及是否黏合
//    logoView.isKeepBounds = YES;
    logoView.freeRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);

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
