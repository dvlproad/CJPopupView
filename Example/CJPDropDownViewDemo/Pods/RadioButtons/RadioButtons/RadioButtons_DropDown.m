//
//  RadioButtons_DropDown.m
//  RadioButtonsDemo
//
//  Created by lichq on 15/11/11.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "RadioButtons_DropDown.h"

@implementation RadioButtons_DropDown

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//注意：shouldUpdateRadioButtonSelected和shouldDidDelegate的返回值一定是相反的
- (BOOL)shouldUpdateRadioButtonSelected_WhenClickSameRadioButton{   //可根据情况为YES或NO
    return YES; //设默认可重复点击（YES:可重复点击  NO:不可重复点击）
}

- (BOOL)shouldDidDelegate_WhenClickSameRadioButton{
    return ![self shouldUpdateRadioButtonSelected_WhenClickSameRadioButton];
}



- (void)doSomethingExtra_WhenClickSameRadioButton:(RadioButton *)radioButton_same{//重写继承的方法
    [self hideCurrentExtendView];
}

- (void)doSomethingExtra_WhenClickNewRadioButton:(RadioButton *)radioButton{
    //do nothing...
}

- (void)shouldMoveScrollViewToSelectItem:(RadioButton *)radioButton{
    //do nothing...
}


- (void)hideCurrentExtendView{
    currentExtendSection = -1;  //设置成-1表示当前未选中任何radioButton
    
    CGRect rect = self.extendView.frame;
    rect.size.height = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.tapV.alpha = 1.0f;
        self.extendView.alpha = 1.0f;
        
        //要设置成0，不设置非零值如0.2，是为了防止在显示出来的时候，在0.3秒内很快按两次按钮，仍有view存在
        self.tapV.alpha = 0.0f;
        self.extendView.alpha = 0.0f;
        
        self.extendView.frame = rect;
    }completion:^(BOOL finished) {
        [self.extendView removeFromSuperview];
        [self.tapV removeFromSuperview];
    }];
}



- (void)showDropDownExtendView:(UIView *)extendView_m inView:(UIView *)superView complete:(void(^)(void))block{
    
    if (self.extendView) {
        [self.extendView removeFromSuperview];
        [self.tapV removeFromSuperview];
    }
    
    
    //执行隐藏的手势视图
    self.extendView = extendView_m;
    self.m_SuperView = superView;
    
    
    //radioButtons在superView中对应的y、rect值为：
    CGRect rectInSuperView_self = [self.superview convertRect:self.frame toView:superView];
    //第一个参数必须为所要转化的rect的视图的父视图，这里可以将父视图直接写出，也可用该视图的superview来替代，这样更方便
    //NSLog(@"rectInSuperView_self = %@", NSStringFromCGRect(rectInSuperView_self));
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = rectInSuperView_self.origin.y + self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    if (!self.tapV) { //tapV是指radioButtons组合下的点击区域（不包括radioButtons区域），用来点击之后隐藏列表
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        
        CGFloat h = self.m_SuperView.frame.size.height - self.frame.origin.y - self.frame.size.height;
        
        self.tapV = [[UIView alloc] initWithFrame:CGRectMake(x, y , w, h)];
        self.tapV.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        [self.tapV addGestureRecognizer:tapGesture];
    }
    [self.m_SuperView addSubview:self.tapV];
    
    x = extendView_m.frame.origin.x;
    w = extendView_m.frame.size.width;
    
    CGFloat h_extendView = self.extendView.frame.size.height;
    CGRect rect = CGRectMake(x, y, w, 0);
    self.extendView.frame = rect;
    [self.m_SuperView addSubview:self.extendView];
    
    //动画设置位置
    [UIView animateWithDuration:0.3 animations:^{
        self.tapV.alpha = 0.2;
        self.extendView.alpha = 0.2;
        
        self.tapV.alpha = 1.0;
        self.extendView.alpha = 1.0;
        
        CGRect rect_extendView = self.extendView.frame;
        rect_extendView.size.height = h_extendView;
        self.extendView.frame = rect_extendView;
    }];
    
    if(block){
        block();
    }
}


- (void)didSelectInExtendView:(NSString *)title{
    RadioButton *radioButton_cur = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + currentExtendSection];
    radioButton_cur.selected = !radioButton_cur.selected;
    [radioButton_cur setTitle:title];
    
    [self doSomethingExtra_WhenClickSameIndex];
}


- (void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    RadioButton *radioButton = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + currentExtendSection];
    radioButton.selected = !radioButton.selected;
    
    [self doSomethingExtra_WhenClickSameIndex];
}

- (void)doSomethingExtra_WhenClickSameIndex{
    [self doSomethingExtra_WhenClickSameRadioButton:nil];
}


@end
