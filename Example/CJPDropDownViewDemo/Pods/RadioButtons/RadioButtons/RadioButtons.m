//
//  RadioButtons.m
//  RadioButtonsDemo
//
//  Created by lichq on 7/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "RadioButtons.h"

@implementation RadioButtons
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
    
    
    self.index_cur = showIndex; //如果self.index_cur = -1，则代表未有任何radioButton选中
    
    
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
            [self shouldMoveScrollViewToSelectItem:radioButton];//改名addAnimation
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

//注意radioButton_cur经常有未选中的状态，即经常会有self.index_cur == -1的情况
- (void)radioButtonClick:(RadioButton *)radioButton_cur{
    
    NSInteger index_old = self.index_cur;
    self.index_cur = radioButton_cur.tag - RadioButton_TAG_BEGIN;
    
    BOOL isSameIndex = self.index_cur == index_old ? YES : NO;
    //NSLog(@"index_cur = %zd, index_old = %zd, isSameIndex= %@", self.index_cur,index_old,isSameIndex?@"YES":@"NO");
    
    if (index_old == -1) {//如果当前没有radioButton是被选中。
        
    }else{  //currentExtendSection != -1，即表示如果当前有radioButton是被选中。
        if (index_old == self.index_cur) {
            isSameIndex = YES;
            
        }else{
            //如果有选中,且点击不同index的话，则还需要把之前的那个按钮的状态也改变掉。
            RadioButton *radioButton_old = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + index_old];
            radioButton_old.selected = !radioButton_old.selected;
        }
    }
    
    
    BOOL shouldUpdateCurrentRadioButtonSelected = [self shouldUpdateRadioButtonSelected_WhenClickSameRadioButton];
    if (isSameIndex) {
        if (shouldUpdateCurrentRadioButtonSelected) {
            radioButton_cur.selected = !radioButton_cur.selected;
        }
        
    }else{
        radioButton_cur.selected = !radioButton_cur.selected;
    }
    
    if([self.delegate respondsToSelector:@selector(radioButtons:chooseIndex:oldIndex:)]){
        [self.delegate radioButtons:self chooseIndex:self.index_cur oldIndex:index_old];
        
        if (isSameIndex && shouldUpdateCurrentRadioButtonSelected) {
            [self setSelectedNone];
        }
    }
}



- (BOOL)shouldUpdateRadioButtonSelected_WhenClickSameRadioButton{
    return NO;  //设默认不可重复点击（YES:可重复点击  NO:不可重复点击）
}


- (void)shouldMoveScrollViewToSelectItem:(RadioButton *)radioButton{
    
}




- (void)changeCurrentRadioButtonStateAndTitle:(NSString *)title{
    RadioButton *radioButton_cur = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + self.index_cur];
    radioButton_cur.selected = !radioButton_cur.selected;
    [radioButton_cur setTitle:title];
}

- (void)changeCurrentRadioButtonState{
    RadioButton *radioButton_cur = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + self.index_cur];
    radioButton_cur.selected = !radioButton_cur.selected;
}

- (void)setSelectedNone{
    self.index_cur = -1;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
