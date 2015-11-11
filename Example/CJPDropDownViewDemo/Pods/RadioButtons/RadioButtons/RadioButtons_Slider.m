//
//  RadioButtons_Slider.m
//  RadioButtonsDemo
//
//  Created by lichq on 15/11/11.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "RadioButtons_Slider.h"

@interface RadioButtons_Slider() {
    UIButton *btnArrowL;
    UIButton *btnArrowR;
}

@end



@implementation RadioButtons_Slider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)shouldUpdateRadioButtonSelected_WhenClickSameRadioButton{   //固定为NO
    return NO;
}

- (BOOL)shouldDidDelegate_WhenClickSameRadioButton{ //可根据情况为YES或NO
    return YES;
}

- (void)doSomethingExtra_WhenClickSameRadioButton:(RadioButton *)radioButton_same{ //重写继承的方法
    //do nothing...
}

- (void)doSomethingExtra_WhenClickNewRadioButton:(RadioButton *)radioButton{
    //do nothing...
    NSInteger index = radioButton.tag - RadioButton_TAG_BEGIN;
    [self selectRadioButtonIndex:index];
}



- (void)shouldMoveScrollViewToSelectItem:(RadioButton *)item{//滑动scrollView到显示出完整的radioButton
    
#pragma mark 移动方法①
    /*
     //该item与320宽的边缘的距离计算。
     CGFloat leftX = CGRectGetMinX(item.frame) - sv.contentOffset.x;
     CGFloat rightX = CGRectGetMaxX(item.frame) - sv.contentOffset.x;
     
     if (leftX < btnArrowL.frame.size.width) {
     //如果左边的边缘 < 左箭头的宽，则进行滚出来显示出完整的这个item.
     CGFloat contentX = item.frame.origin.x - btnArrowL.frame.size.width;
     CGRect frame = CGRectMake(contentX, 0, item.frame.size.width, item.frame.size.height);
     
     [self.sv scrollRectToVisible:frame animated:YES];//滚动到显示出整个rect
     
     }else if(rightX > btnArrowR.frame.origin.x){
     //如果右的边缘 > 右箭头的宽，则进行滚回来显示出完整的这个item.
     CGFloat contentX = item.frame.origin.x + btnArrowR.frame.size.width;
     CGRect frame = CGRectMake(contentX, 0, item.frame.size.width, item.frame.size.height);
     
     [self.sv scrollRectToVisible:frame animated:YES];//滚动到显示出整个rect
     }
     */
    
    
#pragma mark 移动方法②
    //该item的距离计算。
    //CGFloat leftX = CGRectGetMinX(item.frame);
    CGFloat rightX = CGRectGetMaxX(item.frame);
    
    if (rightX >= self.frame.size.width - 60) { //如果rightX离self.frame边缘太近(小于40)就要移动,设移动距离为moveOffset
        CGFloat moveOffset = self.frame.size.width/2 + 40;
        CGFloat rightX_new;
        
        if (rightX + moveOffset >= self.sv.contentSize.width) {//如果向左移动moveOffset后，会超出边界，则移动到末尾
            moveOffset = self.frame.size.width;
            rightX_new = self.sv.contentSize.width - moveOffset;
            
            [self.sv setContentOffset:CGPointMake(rightX_new, self.sv.contentOffset.y) animated:YES];
        }else{
            
            rightX_new = rightX - moveOffset;
            
            if (rightX_new > 0) {
                [self.sv setContentOffset:CGPointMake(rightX_new, self.sv.contentOffset.y) animated:YES];
            }
        }
        
    }else{
        [self.sv setContentOffset:CGPointMake(0, self.sv.contentOffset.y) animated:YES];
    }
}


//添加左右滑动箭头
- (void)addArrowImage_Left:(UIImage *)imageLeft Right:(UIImage *)imageRight{
    //创建左滑动箭头
    btnArrowL = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnArrowL setFrame:CGRectMake(0, 0, imageLeft.size.width, imageLeft.size.height)];
    [btnArrowL setCenter:CGPointMake(btnArrowL.frame.size.width/2,self.frame.size.height/2)];
    [btnArrowL setBackgroundImage:imageLeft forState:UIControlStateNormal];
    [btnArrowL addTarget:self action:@selector(btnArrowLAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnArrowL];
    
    //创建右滑动箭头
    btnArrowR = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnArrowR setFrame:CGRectMake(0, 0, imageRight.size.width, imageRight.size.height)];
    [btnArrowR setCenter:CGPointMake(self.frame.size.width - btnArrowR.frame.size.width/2, self.frame.size.height/2)];
    [btnArrowR setBackgroundImage:imageRight forState:UIControlStateNormal];
    [btnArrowR addTarget:self action:@selector(btnArrowRAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnArrowR];
    
    
    //刚开始隐藏左箭头，显示右箭头
    btnArrowL.hidden = YES;
    btnArrowR.hidden = NO;
}


#pragma mark - 箭头点击事件
- (void)btnArrowLAction:(UIButton *)btn{
    CGFloat leftX = self.sv.contentOffset.x;
    NSInteger tempDx = self.frame.size.width;
    RadioButton *targetItem = nil;
    for (int i = 0; i < countTitles; i++) {
        RadioButton *radioButton = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + i];
        
        NSInteger maxX = MAX(leftX, CGRectGetMaxX(radioButton.frame));
        NSInteger minX = MIN(leftX, CGRectGetMaxX(radioButton.frame));
        if (maxX - minX < tempDx) {
            tempDx = maxX - minX;
            targetItem = radioButton;
        }
    }
    [self shouldMoveScrollViewToSelectItem:targetItem];
}

- (void)btnArrowRAction:(UIButton *)btn{
    CGFloat rightX = self.sv.contentOffset.x + self.sv.frame.size.width;
    NSInteger tempDx = self.frame.size.width;
    RadioButton *targetItem = nil;
    for (int i = 0; i < countTitles; i++) {
        RadioButton *radioButton = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + i];
        NSInteger maxX = MAX(rightX, CGRectGetMinX(radioButton.frame));
        NSInteger minX = MIN(rightX, CGRectGetMinX(radioButton.frame));
        if (maxX - minX < tempDx) {
            tempDx = maxX - minX;
            targetItem = radioButton;
        }
    }
    [self shouldMoveScrollViewToSelectItem:targetItem];
}





- (void)selectRadioButtonIndex:(NSInteger)index{
    RadioButton *radioButton_old = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + currentExtendSection];
    radioButton_old.selected = NO;
    
    RadioButton *radioButton_cur = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + index];
    radioButton_cur.selected = YES;
    [self shouldMoveScrollViewToSelectItem:radioButton_cur];
    
    currentExtendSection = index;
}



#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        btnArrowL.hidden = YES;
        btnArrowR.hidden = NO;
    }else if (scrollView.contentOffset.x+scrollView.frame.size.width == scrollView.contentSize.width) {
        btnArrowL.hidden = NO;
        btnArrowR.hidden = YES;
    }else {
        btnArrowL.hidden = NO;
        btnArrowR.hidden = NO;
    }
}


@end
