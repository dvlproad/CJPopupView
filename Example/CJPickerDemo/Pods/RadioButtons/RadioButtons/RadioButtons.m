//
//  RadioButtons.m
//  RadioButtonsDemo
//
//  Created by lichq on 7/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "RadioButtons.h"

#define kDefaultSelectedIndex   -1

@interface RadioButtons () <RadioButtonDelegate, UIScrollViewDelegate> {
    NSMutableArray *radioButtons;   /**< 所有的单选按钮数组 */
    NSMutableArray *lineViews;
    
    BOOL _haveArrowButton;      /**< 是否有左右箭头 */
    UIButton *_leftArrowButton; /**< 左侧箭头 */
    UIButton *_rightArrowButton;/**< 右侧箭头 */
    CGFloat _arrowImageWidth;   /**< 箭头宽度 */
}
@property (nonatomic, strong) UIScrollView *scrollView; //滚动视图（用于radiobutton过多时的滑动）
@property (nonatomic, assign) NSInteger oldSelectedIndex;   /**< 之前选中的按钮的index值（当该值为默认的－1时，表示都没有选中） */
@property (nonatomic, strong) UIImageView *lineImageView;

@end


@implementation RadioButtons

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self commonInit];
}

- (void)commonInit {
#pragma mark - 当scrollView位于第一个子视图时，其会对内容自动调整。如果你不想让scrollView的内容自动调整，可采取如下两种方法中的任一一种(这里采用第一种)。方法一：取消添加lab，以使得scrollView不是第一个子视图，从而达到取消scrollView的自动调整效果方法二：automaticallyAdjustsScrollViewInsets：如果你不想让scrollView的内容自动调整，将这个属性设为NO（默认值YES）。详细情况可参考evernote笔记中的UIStatusBar笔记内容
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:lab];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor orangeColor];
    [self addSubview:self.scrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat totalHeight = CGRectGetHeight(self.frame);
    CGFloat totalWidth = CGRectGetWidth(self.frame);
    [self.scrollView setFrame:CGRectMake(0, 0, totalWidth, totalHeight)];

//    NSInteger componentCount = [self.dataSource cj_numberOfComponentsInRadioButtons:self];
    NSInteger componentCount = radioButtons.count;
    CGFloat radioButtonX = 0;
    for (NSInteger index = 0; index < componentCount; index++) {
        CGFloat currentComponentWidth = [self.dataSource cj_radioButtons:self widthForComponentAtIndex:index];
        
        RadioButton *radioButton = [radioButtons objectAtIndex:index];
//        RadioButton *radioButton = [self.dataSource cj_radioButtons:self cellForComponentAtIndex:index];
        CGRect rect_radioButton = CGRectMake(radioButtonX, 0, currentComponentWidth, CGRectGetHeight(self.frame));
        [radioButton setFrame:rect_radioButton];
        
        if (index < componentCount -1) {
            UIView *lineView = [lineViews objectAtIndex:index];
            CGRect rect_line = CGRectMake(radioButtonX + currentComponentWidth, 5, 1, self.frame.size.height - 10);
            [lineView setFrame:rect_line];
        }
        
        if (index == componentCount-1) {
            CGFloat contentSizeWidth = radioButtonX + currentComponentWidth;
            CGFloat contentSizeHeight = totalHeight;
            [self.scrollView setContentSize:CGSizeMake(contentSizeWidth, contentSizeHeight)]; //设置self.scrollView.contentSize
        }
        
        if (index == self.currentSelectedIndex) {
            

        }
        
        radioButtonX += currentComponentWidth;
    }
    
    
    /* 如果初始有默认选择哪个按钮，则滑动到该按钮位置 */
    if (self.currentSelectedIndex != -1) {
        RadioButton *targetRadioButton = [radioButtons objectAtIndex:self.currentSelectedIndex];
        
        if (self.showLineImageView) {
            CGFloat lineImageViewX = CGRectGetMinX(targetRadioButton.frame);
            CGFloat lineImageViewWidth = CGRectGetWidth(targetRadioButton.frame);
            CGFloat lineImageViewHeight = self.lineImageViewHeight == 0 ? 1 : self.lineImageViewHeight;
            CGFloat lineImageViewY = CGRectGetHeight(self.frame) - lineImageViewHeight;
            self.lineImageView.frame = CGRectMake(lineImageViewX, lineImageViewY, lineImageViewWidth, lineImageViewHeight);
            self.lineImageView.image = self.lineImage;
        }
        
        [self moveScrollViewToSelectItem:targetRadioButton animated:NO];
    }
    
    /* 如果有左右箭头 */
    if (_haveArrowButton) {
        CGFloat leftArrowButtonHeight = totalHeight;
        CGFloat leftArrowButtonY = 0;
        CGFloat leftArrowButtonWidth = _arrowImageWidth;
        CGFloat leftArrowButtonX = 0;
        [_leftArrowButton setFrame:CGRectMake(leftArrowButtonX,
                                             leftArrowButtonY,
                                             leftArrowButtonWidth,
                                             leftArrowButtonHeight)];
        
        
        CGFloat rightArrowButtonHeight = totalHeight;
        CGFloat rightArrowButtonY = 0;
        CGFloat rightArrowButtonWidth = _arrowImageWidth;
        CGFloat rightArrowButtonX = totalWidth - rightArrowButtonWidth;
        [_rightArrowButton setFrame:CGRectMake(rightArrowButtonX,
                                              rightArrowButtonY,
                                              rightArrowButtonWidth,
                                              rightArrowButtonHeight)];
    }
}

- (void)setDataSource:(id<RadioButtonsDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self reloadViews];
}

/** 完整的描述请参见文件头部 */
- (void)reloadViews {
    NSInteger defaultSelectedIndex = kDefaultSelectedIndex;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cj_defaultShowIndexInRadioButtons:)]) {
        defaultSelectedIndex = [self.dataSource cj_defaultShowIndexInRadioButtons:self];
    }
    self.currentSelectedIndex = defaultSelectedIndex;
    
    NSInteger componentCount = [self.dataSource cj_numberOfComponentsInRadioButtons:self];
    if (componentCount < 3) {
        NSLog(@"warning: componentCount < 3, wouldn't be reloadVies");
        return;
    }
    
    //添加radioButton到sv中
    radioButtons = [[NSMutableArray alloc] init];
    lineViews = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < componentCount; index++) {
        RadioButton *radioButton = [self.dataSource cj_radioButtons:self cellForComponentAtIndex:index];
        radioButton.index = index;
        radioButton.delegate = self;
        radioButton.tag = RadioButton_TAG_BEGIN + index;
        if (index == defaultSelectedIndex) {
            [radioButton setSelected:YES];
            
        }else{
            [radioButton setSelected:NO];
        }
        
        [self.scrollView addSubview:radioButton];
        [radioButtons addObject:radioButton];
        
        if (index < componentCount && index != 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [self.scrollView addSubview:lineView];
            [lineViews addObject:lineView];
        }
    }
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:self.lineImageView];
}

//注意radioButton_cur经常有未选中的状态，即经常会有self.currentSelectedIndex == -1的情况
- (void)radioButtonClick:(RadioButton *)radioButton_cur {
    
    NSInteger index_old = self.currentSelectedIndex;
    NSInteger index_cur = radioButton_cur.tag - RadioButton_TAG_BEGIN;
    
    BOOL shouldUpdateCurrentRadioButtonSelected = [self shouldUpdateRadioButtonSelected_WhenClickSameRadioButton];
    
    if (index_old == -1) {  //①、如果当前没有radioButton是被选中。
        radioButton_cur.selected = !radioButton_cur.selected;
        [self cj_selectComponentAtIndex:index_cur animated:YES];
        
    }else{                  //②、index_old != -1，即表示如果当前有radioButton是被选中。
        if (index_old == index_cur) {
            if (shouldUpdateCurrentRadioButtonSelected) {
                radioButton_cur.selected = !radioButton_cur.selected;
            }
            
        }else{              //③、如果有选中,且点击不同index的话，则还需要把之前的那个按钮的状态也改变掉。
            RadioButton *radioButton_old = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + index_old];
            radioButton_old.selected = !radioButton_old.selected;
            
            radioButton_cur.selected = !radioButton_cur.selected;
            [self cj_selectComponentAtIndex:index_cur animated:YES];
        }
    }
    
    
    if([self.delegate respondsToSelector:@selector(cj_radioButtons:chooseIndex:oldIndex:)]){
        [self.delegate cj_radioButtons:self chooseIndex:index_cur oldIndex:index_old];
    }
    
    BOOL isSameIndex = index_cur == index_old ? YES : NO;
    //NSLog(@"index_old = %zd, index_cur = %zd, isSameIndex= %@", index_old, index_cur, isSameIndex?@"YES":@"NO");
    if (isSameIndex && shouldUpdateCurrentRadioButtonSelected) { //此条if语句位置待确定
        [self setSelectedNone];
    }
}



- (BOOL)shouldUpdateRadioButtonSelected_WhenClickSameRadioButton{
    switch (self.radioButtonType) {
        case RadioButtonTypeNormal:{
            return NO;
            break;
        }
        case RadioButtonTypeCanDrop:{
            return YES;
            break;
        }
        case RadioButtonTypeCanSlider:{
            return NO;
            break;
        }
        default:{
            return NO;
            break;
        }
    }
    return NO;  //设默认不可重复点击（YES:可重复点击  NO:不可重复点击）
}

/** 完整的描述请参见文件头部 */
- (void)changeCurrentRadioButtonStateAndTitle:(NSString *)title {
    RadioButton *radioButton_cur = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + self.currentSelectedIndex];
    radioButton_cur.selected = !radioButton_cur.selected;
    [radioButton_cur setTitle:title];
}

/** 完整的描述请参见文件头部 */
- (void)changeCurrentRadioButtonState {
    RadioButton *radioButton_cur = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + self.currentSelectedIndex];
    radioButton_cur.selected = !radioButton_cur.selected;
}

/** 完整的描述请参见文件头部 */
- (void)setSelectedNone {
    self.currentSelectedIndex = -1;
}

#pragma mark - 有左右箭头时候常会用到的方法
/**
 *  滚动到指定的单选按钮 targetRadioButton 上 （当按钮太多显示不全时常需要设置这个为YES）
 *
 *  @param targetRadioButton 要滚动到的指定按钮
 *  @param animated          是否动画
 */
- (void)moveScrollViewToSelectItem:(RadioButton *)targetRadioButton animated:(BOOL)animated {
    if (self.showLineImageView) {
        CGFloat lineImageViewX = CGRectGetMinX(targetRadioButton.frame);
        CGFloat lineImageViewWidth = CGRectGetWidth(targetRadioButton.frame);
        CGFloat lineImageViewHeight = CGRectGetHeight(self.lineImageView.frame);
        CGFloat lineImageViewY = CGRectGetHeight(self.frame) - lineImageViewHeight;
        [UIView animateWithDuration:0.3 animations:^{
            self.lineImageView.frame = CGRectMake(lineImageViewX, lineImageViewY, lineImageViewWidth, lineImageViewHeight);
        }];
    }
     
    //该item的距离计算。(滑动scrollView到显示出完整的targetRadioButton)
    //CGFloat leftX = CGRectGetMinX(targetRadioButton.frame);
    CGFloat rightX = CGRectGetMaxX(targetRadioButton.frame);
    
    if (rightX >= self.frame.size.width - 60) { //如果rightX离self.frame边缘太近(小于40)就要移动,设移动距离为moveOffset
        CGFloat moveOffset = self.frame.size.width/2 + 40;
        CGFloat rightX_new;
        
        if (rightX + moveOffset >= self.scrollView.contentSize.width) {//如果向左移动moveOffset后，会超出边界，则移动到末尾
            moveOffset = self.frame.size.width;
            rightX_new = self.scrollView.contentSize.width - moveOffset;
            
            [self.scrollView setContentOffset:CGPointMake(rightX_new, self.scrollView.contentOffset.y) animated:animated];
        }else{
            
            rightX_new = rightX - moveOffset;
            
            if (rightX_new > 0) {
                [self.scrollView setContentOffset:CGPointMake(rightX_new, self.scrollView.contentOffset.y) animated:animated];
            }
        }
        
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:animated];
    }
}

/** 完整的描述请参见文件头部 */
- (void)addLeftArrowImage:(UIImage *)leftArrowImage
          rightArrowImage:(UIImage *)rightArrowImage
      withArrowImageWidth:(CGFloat)arrowImageWidth {
    
    _haveArrowButton = YES;
    _arrowImageWidth = arrowImageWidth;
    
    //创建左滑动箭头
    _leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftArrowButton setFrame:CGRectZero];
    [_leftArrowButton setBackgroundImage:leftArrowImage forState:UIControlStateNormal];
    [_leftArrowButton addTarget:self action:@selector(leftArrowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftArrowButton];
    
    //创建右滑动箭头
    _rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightArrowButton setFrame:CGRectZero];
    [_rightArrowButton setBackgroundImage:rightArrowImage forState:UIControlStateNormal];
    [_rightArrowButton addTarget:self action:@selector(rightArrowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightArrowButton];
    
    
    //隐藏左、右箭头
    _leftArrowButton.hidden = YES;
    _rightArrowButton.hidden = YES;
    
    [self judgeAndSetArrowButtonState];
}

//左箭头点击
- (void)leftArrowButtonAction:(UIButton *)sender {
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    
    RadioButton *targetRadioButton = nil;
    for (NSInteger i = 0; i < radioButtons.count; i++) { //从第一个开始找，找到的第一个即是所求
        RadioButton *radioButton = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + i];
        
        /* 确保”要找的按钮“的左侧至少在显示的“左侧箭头的最右侧值”之左 */
        if (CGRectGetMinX(radioButton.frame) >= contentOffsetX + CGRectGetMaxX(_leftArrowButton.frame)) {
            continue;
        }
        
        /* 同时确保”要找的按钮“的右侧要至少在显示的“左侧箭头的最右侧值”之右 */
        if (CGRectGetMaxX(radioButton.frame) < contentOffsetX + CGRectGetMaxX(_leftArrowButton.frame)) {
            continue;
        }
        
        targetRadioButton = radioButton;
        NSLog(@"left: targetRadioButtonText = %@", targetRadioButton.label.text);
        break;
    }
    
    /* 移动操作 */
    CGFloat newContentOffsetX;
    BOOL isFirstRadioButton = (targetRadioButton.index == 0) ? YES : NO;
    if (!isFirstRadioButton) {
        newContentOffsetX = CGRectGetMinX(targetRadioButton.frame) - CGRectGetWidth(_leftArrowButton.frame); //注意这里是减
    } else {
        newContentOffsetX = CGRectGetMinX(targetRadioButton.frame);
    }
    
    [self.scrollView setContentOffset:CGPointMake(newContentOffsetX, self.scrollView.contentOffset.y) animated:YES];
}

//右箭头点击
- (void)rightArrowButtonAction:(UIButton *)sender {
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    
    RadioButton *targetRadioButton = nil;
    for (NSInteger i = 0; i < radioButtons.count; i++) {   //从最后一个开始找，找到的第一个即是所求
        RadioButton *radioButton = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + i];
        
        /* 确保”要找的按钮“的左侧至少在显示的屏幕的最左侧之右 */
        if (CGRectGetMinX(radioButton.frame) - contentOffsetX < 0) {
            continue;
        }
        
        /* 同时确保”要找的按钮“的右侧要至少在显示的“右侧箭头的最左侧值”之右 */
        //尤其注意：这里的btnArrowR不是添加在scrollView上的，所以不要忘了要加上contentOffsetX来比较
        if (CGRectGetMaxX(radioButton.frame) <= contentOffsetX + CGRectGetMinX(_rightArrowButton.frame)) {
            continue;
        }
        targetRadioButton = radioButton;
        NSLog(@"right: targetRadioButtonText = %@", targetRadioButton.label.text);
        
        break;
    }
    
    /* 移动操作 */
    CGFloat rightAddMoveOffset;
    BOOL isLastRadioButton = (targetRadioButton.index == radioButtons.count - 1) ? YES : NO;
    if (!isLastRadioButton) {
        rightAddMoveOffset = CGRectGetMaxX(targetRadioButton.frame) - (contentOffsetX + CGRectGetMinX(_rightArrowButton.frame));
    } else {
        rightAddMoveOffset = CGRectGetMaxX(targetRadioButton.frame) - (contentOffsetX + CGRectGetWidth(self.scrollView.frame));
    }
    CGFloat newContentOffsetX = self.scrollView.contentOffset.x + rightAddMoveOffset;
    [self.scrollView setContentOffset:CGPointMake(newContentOffsetX, self.scrollView.contentOffset.y) animated:YES];
}

/** 完整的描述请参见文件头部 */
- (void)cj_selectComponentAtIndex:(NSInteger)index animated:(BOOL)animated {
    self.oldSelectedIndex = self.currentSelectedIndex;
    self.currentSelectedIndex = index;
    
    RadioButton *radioButton_old = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + self.oldSelectedIndex];
    radioButton_old.selected = NO;
    
    RadioButton *radioButton_cur = (RadioButton *)[self viewWithTag:RadioButton_TAG_BEGIN + self.currentSelectedIndex];
    radioButton_cur.selected = YES;
    [self moveScrollViewToSelectItem:radioButton_cur animated:animated];
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_haveArrowButton) {
        [self judgeAndSetArrowButtonState];
    }
}

/** 判断设设置箭头状态(显示或隐藏) */
- (void)judgeAndSetArrowButtonState {
    CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat scrollViewContentSizeWidth = self.scrollView.contentSize.width;
    if (scrollViewContentSizeWidth == scrollViewWidth) {
        _leftArrowButton.hidden = YES;
        _rightArrowButton.hidden = YES;
        return;
    }
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    if (contentOffsetX == 0) {
        _leftArrowButton.hidden = YES;
        _rightArrowButton.hidden = NO;
    }else if ( contentOffsetX + scrollViewWidth == scrollViewContentSizeWidth) {
        _leftArrowButton.hidden = NO;
        _rightArrowButton.hidden = YES;
    }else {
        _leftArrowButton.hidden = NO;
        _rightArrowButton.hidden = NO;
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
