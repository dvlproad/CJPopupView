//
//  SubGuideView.h
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/3/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubGuideView : UIView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, copy) void(^confirmBlock)(void);

- (void)setText:(NSString *)text;

@end
