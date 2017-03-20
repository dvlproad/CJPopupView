//
//  PopoverViewController.m
//  CJPopupViewDemo
//
//  Created by 李超前 on 2017/3/20.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "PopoverViewController.h"
#import "CJPopoverView.h"

@interface PopoverViewController ()

@end

@implementation PopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"PopoverView箭头", nil);
}


#pragma mark - PopoverView 带箭号的弹出视图
- (IBAction)popItemChoose1:(UIButton *)btn{
    //将像素point由point所在视图(即xx.superview)转换到目标视图view中，返回在目标视图view中的像素值
    CGPoint point_origin = CGPointMake(btn.center.x, btn.center.y + btn.frame.size.height/2);
    CGPoint point = [btn.superview convertPoint:point_origin toView:self.view];
    NSLog(@"point = %@", NSStringFromCGPoint(point));
    
    
    NSArray *titles = @[@"从底到上SlideBottomTop = 0",
                        @"从右到左SlideRightLeft",
                        @"从底到底SlideBottomBottom",
                        @"渐隐Fade"];
    NSArray *images = @[@"image1.png", @"image1.png", @"image1.png", @"image1.png"];
    CJPopoverView *pop = [[CJPopoverView alloc] initWithPoint:point titles:titles images:images];
    pop.selectRowAtIndex = ^(NSInteger index){
        NSLog(@"select index:%ld", index);
        [btn setTitle:titles[index] forState:UIControlStateNormal];
    };
    [pop showPopoverView];
}

- (IBAction)popItemChoose2:(UIButton *)btn{
    CGPoint point_origin = CGPointMake(btn.center.x, btn.center.y + btn.frame.size.height/2);
    CGPoint point = [btn.superview convertPoint:point_origin toView:self.view];
    
    NSArray *titles = @[@"pop_item1", @"pop_item2", @"pop_item3"];
    CJPopoverView *pop = [[CJPopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        NSLog(@"select index:%ld", index);
        [btn setTitle:titles[index] forState:UIControlStateNormal];
    };
    [pop showPopoverView];
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
