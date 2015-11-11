//
//  RadioButtons.m
//  CJPDropDownViewDemo
//
//  Created by lichq on 7/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "RadioButtons.h"
#define RadioButton_TAG_BEGIN   1000
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

@implementation RadioButtons


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}


- (void)setTitles:(NSArray *)titles radioButtonNidName:(NSString *)nibName{
    NSInteger sectionNum = [titles count];
    if (sectionNum == 0) {
        NSLog(@"error: sectionNum == 0");
    }
    
    self.backgroundColor = [UIColor whiteColor];
    currentExtendSection = -1;
    
    //初始化默认显示view
    CGFloat sectionWidth = (1.0*(self.frame.size.width)/sectionNum);
    for (int i = 0; i <sectionNum; i++) {
        CGRect rect_radioButton = CGRectMake(sectionWidth*i, 1, sectionWidth, self.frame.size.height-2);
        //radioButton初始化方法①
        //RadioButton *radioButton = [[RadioButton alloc]initWithFrame:rect_radioButton];
        //radioButton初始化方法②
        RadioButton *radioButton = [[RadioButton alloc]initWithNibNamed:nibName frame:rect_radioButton];
        
        [radioButton setTitle:titles[i]];
        radioButton.delegate = self;
        radioButton.tag = RadioButton_TAG_BEGIN + i;
        [self addSubview:radioButton];
        
        if (i<sectionNum && i != 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth*i, self.frame.size.height/4, 1, self.frame.size.height/2)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:lineView];
        }
    }
}

- (void)radioButtonClick:(RadioButton *)radioButton_cur{
    
    radioButton_cur.selected = !radioButton_cur.selected;
    
    [UIView animateWithDuration:0.3 animations:^{
        radioButton_cur.imageV.transform = CGAffineTransformRotate(radioButton_cur.imageV.transform, DEGREES_TO_RADIANS(180));
    }];
    
    
    NSInteger section = radioButton_cur.tag - RadioButton_TAG_BEGIN;
    if (currentExtendSection == section) {
        [self hideCurrentExtendView];
        
    }else{
        if (currentExtendSection != -1) {//存在的话，就先消除旧的。（不存在的可能①第一次点击;②点击后又隐藏）
            //不是之前点击的radioButton的时候,除了要把现有的按钮方向改变外，还需要把之前的那个按钮的方向也再改变掉。
            RadioButton *radioButton_old = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + currentExtendSection];
            radioButton_old.selected = !radioButton_old.selected;
            
            [self.extendView removeFromSuperview];
            [self.tapV removeFromSuperview];
        }
        
        currentExtendSection = section;
        
        if([self.delegate respondsToSelector:@selector(radioButtons:chooseIndex:)]){
            [self.delegate radioButtons:self chooseIndex:section];
        }
    }
}

- (void)didSelectInExtendView:(NSString *)title{
    RadioButton *radioButton_cur = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + currentExtendSection];
    radioButton_cur.selected = !radioButton_cur.selected;
    [radioButton_cur setTitle:title];
    
    [self hideCurrentExtendView];
}

- (void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    RadioButton *radioButton = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + currentExtendSection];
    radioButton.selected = !radioButton.selected;
    
    [self hideCurrentExtendView];
}

- (void)hideCurrentExtendView{
    if (currentExtendSection != -1) {
        currentExtendSection = -1;
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
}





- (void)showDropDownExtendView:(UIView *)extendView_m inView:(UIView *)superView complete:(void(^)(void))block{
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
