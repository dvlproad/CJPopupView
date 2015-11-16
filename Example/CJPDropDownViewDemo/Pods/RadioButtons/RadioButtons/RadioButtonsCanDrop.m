//
//  RadioButtonsCanDrop.m
//  RadioButtonsDemo
//
//  Created by 李超前 on 15/11/16.
//  Copyright © 2015年 dvlproad. All rights reserved.
//

#import "RadioButtonsCanDrop.h"

@implementation RadioButtonsCanDrop
@synthesize sv;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initizalScrollView];
    }
    return self;
}

- (void)awakeFromNib{
    [self initizalScrollView];
}

- (void)initizalScrollView{
#pragma mark - 当scrollView位于第一个子视图时，其会对内容自动调整。如果你不想让scrollView的内容自动调整，可采取如下两种方法中的任一一种(这里采用第一种)。方法一：取消添加lab，以使得scrollView不是第一个子视图，从而达到取消scrollView的自动调整效果方法二：automaticallyAdjustsScrollViewInsets：如果你不想让scrollView的内容自动调整，将这个属性设为NO（默认值YES）。详细情况可参考evernote笔记中的UIStatusBar笔记内容
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:lab];
    
    [self addScrollViewForTab];
}

- (void)addScrollViewForTab{
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    sv.showsVerticalScrollIndicator = NO;
    sv.showsHorizontalScrollIndicator = NO;
    sv.delegate = self;
    sv.bounces = NO;
    sv.backgroundColor = [UIColor orangeColor];
    [self addSubview:sv];
}


- (void)setTitles:(NSArray *)titles radioButtonNidName:(NSString *)nibName{
    [self setTitles:titles radioButtonNidName:nibName andShowIndex:-1];
}

- (void)setTitles:(NSArray *)titles radioButtonNidName:(NSString *)nibName andShowIndex:(NSInteger)showIndex{
    NSAssert(nibName != nil, @"radioButton的nibName未设置，请检查");
    
    NSInteger sectionNum = [titles count];
    if (sectionNum == 0) {
        NSLog(@"error: [titles count] == 0");
    }
    countTitles = sectionNum;
    
    //计算每个radioButton应该有的宽度是多少
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil];
    RadioButton *radioButtonTemp = [array lastObject];
    CGFloat sectionWidth = radioButtonTemp.frame.size.width;
    if (sectionWidth * sectionNum < self.frame.size.width) {
        NSLog(@"Warning：xib中取得的RadioButton宽度太小，重新调整。现先暂时使用平分");
        sectionWidth = self.frame.size.width/sectionNum;
    }
    sv.contentSize = CGSizeMake(sectionWidth * sectionNum, self.frame.size.height);//设置sv.contentSize
    
    
    currentExtendSection = showIndex; //如果currentExtendSection = -1，则代表未有任何radioButton选中
    
    
    //添加radioButton到sv中
    for (int i = 0; i <sectionNum; i++) {
        CGRect rect_radioButton = CGRectMake(sectionWidth*i, 0, sectionWidth, self.frame.size.height);
        //radioButton初始化方法①
        //RadioButton *radioButton = [[RadioButton alloc]initWithFrame:rect_radioButton];
        //radioButton初始化方法②
        RadioButton *radioButton = [[RadioButton alloc]initWithNibNamed:nibName frame:rect_radioButton];
        [radioButton setTitle:titles[i]];
        radioButton.delegate = self;
        radioButton.tag = RadioButton_TAG_BEGIN + i;
        if (i == showIndex) {
            [radioButton setSelected:YES];
            [self shouldMoveScrollViewToSelectItem:radioButton];
        }else{
            [radioButton setSelected:NO];
        }
        [self.sv addSubview:radioButton];
        
        if (i<sectionNum && i != 0) {
            CGRect rect_line = CGRectMake(sectionWidth*i, 5, 1, self.frame.size.height - 10);
            UIView *lineView = [[UIView alloc] initWithFrame:rect_line];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [self.sv addSubview:lineView];
        }
        
        /*
         if (1) {
         NSString *title = titles[i];
         UIFont *font = radioButton.btn.titleLabel.font;
         CGSize constrainedToSize = CGSizeMake(radioButton.frame.size.width, radioButton.frame.size.height);
         CGSize textSize = [title sizeWithFont:font constrainedToSize:constrainedToSize lineBreakMode:NSLineBreakByTruncatingTail];
         
         UIImage *shadowImage = [UIImage imageNamed:@"btn_BG_selected@2x"];
         CGRect rect_shadowImageV = CGRectMake(0, 0, textSize.width+5, shadowImage.size.height);
         UIImageView *shadowImageV = [[UIImageView alloc] initWithFrame:rect_shadowImageV];
         [shadowImageV setCenter:CGPointMake(i*sectionWidth +sectionWidth/2, radioButton.frame.size.height/2)];
         shadowImageV.image = shadowImage;
         [radioButton addSubview:shadowImageV];
         [radioButton bringSubviewToFront:radioButton.lab];
         }
         */
    }
}

//注意radioButton_cur经常有未选中的状态，即经常会有currentExtendSection == -1的情况
- (void)radioButtonClick:(RadioButton *)radioButton_cur{
    
    
    NSInteger section = radioButton_cur.tag - RadioButton_TAG_BEGIN;
    //    if (currentExtendSection == section) {
    //        [self doSomethingExtra_WhenClickSameRadioButton:radioButton_cur];
    //
    //    }else{
    //        if (currentExtendSection != -1) {//currentExtendSection != -1，则表示当前有radioButton是被选中。如果有选中的话，则除了要把现有的按钮方向改变外，还需要把之前的那个按钮的方向也再改变掉。
    //            RadioButton *radioButton_old = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + currentExtendSection];
    //            radioButton_old.selected = !radioButton_old.selected;
    //
    //            [self doSomethingExtra_WhenClickDifferentIndex];
    //        }
    //
    //        currentExtendSection = section;
    //
    //        if([self.delegate respondsToSelector:@selector(radioButtons:chooseIndex:)]){
    //            [self.delegate radioButtons:self chooseIndex:section];
    //        }
    //    }
    
    
    BOOL isClickNewRadioButton = NO;
    
    BOOL shouldDidDelegate = YES;
    BOOL shouldUpdateCurrentRadioButtonSelected = YES;
    
    if (currentExtendSection == -1) {//如果当前没有radioButton是被选中。
        shouldUpdateCurrentRadioButtonSelected = YES;
        shouldDidDelegate = YES;
        
        
        //        currentExtendSection = section;
        //        if([self.delegate respondsToSelector:@selector(radioButtons:chooseIndex:)]){
        //            [self.delegate radioButtons:self chooseIndex:section];
        //        }
        
    }else{  //currentExtendSection != -1，即表示如果当前有radioButton是被选中。
        if (currentExtendSection == section) {
            shouldUpdateCurrentRadioButtonSelected = [self shouldUpdateRadioButtonSelected_WhenClickSameRadioButton];
            shouldDidDelegate = [self shouldDidDelegate_WhenClickSameRadioButton];
            
        }else{
            shouldUpdateCurrentRadioButtonSelected = YES;
            shouldDidDelegate = YES;
            
            //如果有选中,且点击不同index的话，则还需要把之前的那个按钮的状态也改变掉。
            RadioButton *radioButton_old = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + currentExtendSection];
            radioButton_old.selected = !radioButton_old.selected;
            
            isClickNewRadioButton = YES;
            //            [self doSomethingExtra_WhenClickNewRadioButton:radioButton_cur];
            
            //            currentExtendSection = section;
            //            if([self.delegate respondsToSelector:@selector(radioButtons:chooseIndex:)]){
            //                [self.delegate radioButtons:self chooseIndex:section];
            //            }
        }
    }
    
    
    currentExtendSection = section;
    
    if (shouldUpdateCurrentRadioButtonSelected) {
        radioButton_cur.selected = !radioButton_cur.selected;
    }
    
    if (shouldDidDelegate) {
        if([self.delegate respondsToSelector:@selector(radioButtonsCanDrop:chooseIndex:)]){
            [self.delegate radioButtonsCanDrop:self chooseIndex:section];
        }
    }else{
        [self doSomethingExtra_WhenClickSameRadioButton:radioButton_cur];//此中又可能改变currentExtendSection为-1即为选中任何一个radioButton时候的值
    }
    
    if (isClickNewRadioButton) {
        [self doSomethingExtra_WhenClickNewRadioButton:radioButton_cur];//此操作有可能会更新selected,所以不能放到shouldUpdateCurrentRadioButtonSelected之前
    }
    
    
}



- (BOOL)shouldUpdateRadioButtonSelected_WhenClickSameRadioButton{
    return YES;  //设默认不可重复点击（YES:可重复点击  NO:不可重复点击）
}

- (BOOL)shouldDidDelegate_WhenClickSameRadioButton{
    return NO;  //设默认重复点击不做任何动作
}

//- (void)doSomethingExtra_WhenClickSameRadioButton:(RadioButton *)radioButton_same{
//    
//}
//
//- (void)doSomethingExtra_WhenClickNewRadioButton:(RadioButton *)radioButton{
//    
//}
//
//- (void)shouldMoveScrollViewToSelectItem:(RadioButton *)radioButton{
//    
//}





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



- (void)radioButtonsCanDrop_showDropDownExtendView:(UIView *)extendView_m inView:(UIView *)superView complete:(void(^)(void))block{
    
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


- (void)radioButtonsCanDrop_didSelectInExtendView:(NSString *)title{
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
