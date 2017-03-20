//
//  MyDragView.h
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/11/05.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJDragView.h"

@interface MyDragView : CJDragView

@property (nonatomic, strong) IBOutlet UIButton *button;

@property (nonatomic,copy) void(^clickButtonBlock)(MyDragView *dragView);   /**< 点击按钮的block回调 */

@end
