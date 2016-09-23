//
//  ViewController.m
//  CJPopoverViewDemo
//
//  Created by lichq on 6/24/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ViewController.h"
#import "CJPopoverView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
        NSLog(@"select index:%d", index);
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
        NSLog(@"select index:%d", index);
        [btn setTitle:titles[index] forState:UIControlStateNormal];
    };
    [pop showPopoverView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
