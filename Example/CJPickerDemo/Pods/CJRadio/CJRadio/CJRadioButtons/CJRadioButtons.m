//
//  CJRadioButtons.m
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import "CJRadioButtons.h"

typedef NS_ENUM(NSUInteger, RadioButtonPositionType) {
    RadioButtonPositionTypeMiddle,
    RadioButtonPositionTypeEdgeStart,
    RadioButtonPositionTypeEdgeEnd,
};

@interface CJRadioButtons () <UIScrollViewDelegate> {
    BOOL _haveArrowButton;      /**< 是否有左右箭头 */
    UIButton *_leftArrowButton; /**< 左侧箭头 */
    UIButton *_rightArrowButton;/**< 右侧箭头 */
}
@property (nonatomic, strong) UIScrollView *scrollView; //滚动视图（用于radiobutton过多时的滑动）
@property (nonatomic, strong) UIView *contentView;      //scrollView上的contentView
@property (nonatomic, assign) NSInteger oldSelectedIndex;   /**< 之前选中的按钮的index值（当该值为默认的－1时，表示都没有选中） */


//lineImageView
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) NSLayoutConstraint *lineImageViewHeightLayoutConstraint;
@property (nonatomic, strong) NSLayoutConstraint *lineImageViewWidthLayoutConstraint;
@property (nonatomic, strong) NSLayoutConstraint *lineImageViewLeftLayoutConstraint;

@end


@implementation CJRadioButtons

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self cjRadioButtons_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self cjRadioButtons_commonInit];
    }
    return self;
}

- (void)cjRadioButtons_commonInit {
#pragma mark - 当scrollView位于第一个子视图时，其会对内容自动调整。如果你不想让scrollView的内容自动调整，可采取如下两种方法中的任一一种(这里采用第一种)。方法一：取消添加lab，以使得scrollView不是第一个子视图，从而达到取消scrollView的自动调整效果方法二：automaticallyAdjustsScrollViewInsets：如果你不想让scrollView的内容自动调整，将这个属性设为NO（默认值YES）。详细情况可参考evernote笔记中的UIStatusBar笔记内容
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:lab];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self cj_makeView:self addSubView:_scrollView withEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self reloadViews];
}

/** 完整的描述请参见文件头部 */
- (void)reloadViews {
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSInteger componentCount = [self.dataSource cj_numberOfComponentsInRadioButtons:self];
    
    /* 计算scrollView的contentSizeWidth */
    CGFloat totalComponentWidth = 0;
    for (NSInteger index = 0; index < componentCount; index++) {
        CGFloat currentComponentWidth = [self.dataSource cj_radioButtons:self widthForComponentAtIndex:index];
        
        totalComponentWidth += currentComponentWidth;
        if (index == componentCount-1) {
            self.contentView = [self cj_addContentViewToScrollView:self.scrollView withContentSizeWidth:totalComponentWidth];
        }
    }
    //NSLog(@" --- totalComponentWidth = %f", totalComponentWidth);
    self.scrollView.contentSize = CGSizeMake(totalComponentWidth, CGRectGetHeight(self.frame));
    
    NSInteger defaultSelectedIndex = -1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cj_defaultShowIndexInRadioButtons:)]) {
        defaultSelectedIndex = [self.dataSource cj_defaultShowIndexInRadioButtons:self];
    }
    _currentSelectedIndex = defaultSelectedIndex;
    
    
    
    /* 添加radioButton到scrollView中 */
    NSMutableArray *radioButtons = [[NSMutableArray alloc] init];
    UIView *lastView = nil;
    for (NSInteger index = 0; index < componentCount; index++) {
        CJButton *radioButton = [self.dataSource cj_radioButtons:self cellForComponentAtIndex:index];
        radioButton.index = index;
        
        __weak typeof(self)weakSelf = self;
        [radioButton setTapAction:^(CJButton *radioButton) {
            [weakSelf clickRadioButton:radioButton];
        }];
        
        if (index == defaultSelectedIndex) {
            [radioButton setSelected:YES];
        } else {
            [radioButton setSelected:NO];
        }
        
        CGFloat currentComponentWidth = [self.dataSource cj_radioButtons:self widthForComponentAtIndex:index];
        [self cj_addSubView:radioButton toSuperView:self.scrollView afterCurrentView:lastView withWidth:currentComponentWidth];
        [radioButtons addObject:radioButton];
        
        lastView = radioButton;
    }
    _radioButtons = radioButtons;
    
    
    if (self.hideSeparateLine == NO) {
        for (NSInteger index = 0; index < componentCount-1; index++) {
            UIView *separateLineView = [[UIView alloc] initWithFrame:CGRectZero];
            separateLineView.backgroundColor = [UIColor lightGrayColor];
            
            CJButton *radioButton = [radioButtons objectAtIndex:index];
            [self cj_addSubView:separateLineView toSuperView:self.scrollView afterCurrentView:radioButton withWidth:1];
        }
    }
    
    if (self.showBottomLineView) {
        [self addBottomViewToScrollView];
    }
    
    /* 如果有左右箭头 */
    if (_haveArrowButton) {
        [self judgeAndSetArrowButtonState];
    }
    
    [self layoutIfNeeded]; //不要漏
}

/** 添加底部视图(常为线条或图片) */
- (void)addBottomViewToScrollView {
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    if (self.bottomLineImage) {
        self.lineImageView.image = self.bottomLineImage;
    }
    if (self.bottomLineColor) {
        self.lineImageView.backgroundColor = self.bottomLineColor;
    }
    [self.scrollView addSubview:self.lineImageView];
    
    
    self.lineImageView.translatesAutoresizingMaskIntoConstraints = NO;
    //bottom
    [self.scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.lineImageView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.scrollView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:0]];
    //height
    self.lineImageViewHeightLayoutConstraint =
            [NSLayoutConstraint constraintWithItem:self.lineImageView
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                         attribute:NSLayoutAttributeNotAnAttribute
                                        multiplier:1
                                          constant:self.bottomLineViewHeight];
    [self.scrollView addConstraint:self.lineImageViewHeightLayoutConstraint];
    //left
    self.lineImageViewLeftLayoutConstraint =
            [NSLayoutConstraint constraintWithItem:self.lineImageView
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.scrollView
                                         attribute:NSLayoutAttributeLeft
                                        multiplier:1
                                          constant:0];
    [self.scrollView addConstraint:self.lineImageViewLeftLayoutConstraint];
    //width
    self.lineImageViewWidthLayoutConstraint =
                [NSLayoutConstraint constraintWithItem:self.lineImageView
                                             attribute:NSLayoutAttributeWidth
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:nil
                                             attribute:NSLayoutAttributeNotAnAttribute
                                            multiplier:1
                                              constant:0];
    [self.scrollView addConstraint:self.lineImageViewWidthLayoutConstraint];
}


//注意radioButton_cur经常有未选中的状态，即经常会有self.currentSelectedIndex == -1的情况
- (void)clickRadioButton:(CJButton *)radioButton_cur {
    NSInteger index_old = self.currentSelectedIndex;
    NSInteger index_cur = radioButton_cur.index;
    
    BOOL shouldUpdateCurrentRadioButtonSelected = [self shouldUpdateRadioButtonSelected_WhenClickSameRadioButton];
    
    if (index_old == -1) {  //①、如果当前没有radioButton是被选中。
        radioButton_cur.selected = !radioButton_cur.selected;
        
        
    }else{                  //②、index_old != -1，即表示如果当前有radioButton是被选中。
        if (index_old == index_cur) {
            if (shouldUpdateCurrentRadioButtonSelected) {
                radioButton_cur.selected = !radioButton_cur.selected;
            }
            
        }else{              //③、如果有选中,且点击不同index的话，则还需要把之前的那个按钮的状态也改变掉。
            CJButton *radioButton_old = [self.radioButtons objectAtIndex:index_old];
            radioButton_old.selected = !radioButton_old.selected;
            
            radioButton_cur.selected = !radioButton_cur.selected;
        }
    }
    [self cj_selectComponentAtIndex:index_cur animated:YES];
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
    CJButton *radioButton_cur = [self.radioButtons objectAtIndex:self.currentSelectedIndex];
    radioButton_cur.selected = !radioButton_cur.selected;
    [radioButton_cur setTitle:title];
}

/** 完整的描述请参见文件头部 */
- (void)changeCurrentRadioButtonState {
    CJButton *radioButton_cur = [self.radioButtons objectAtIndex:self.currentSelectedIndex];
    radioButton_cur.selected = !radioButton_cur.selected;
}

/** 完整的描述请参见文件头部 */
- (void)setSelectedNone {
    _currentSelectedIndex = -1;
}


/** 完整的描述请参见文件头部 */
- (void)addLeftArrowImage:(UIImage *)leftArrowImage
          rightArrowImage:(UIImage *)rightArrowImage
      withArrowImageWidth:(CGFloat)arrowImageWidth {
    
    _haveArrowButton = YES;
    
    //创建左滑动箭头
    _leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftArrowButton setFrame:CGRectZero];
    [_leftArrowButton setBackgroundImage:leftArrowImage forState:UIControlStateNormal];
    [_leftArrowButton addTarget:self action:@selector(leftArrowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftArrowButton];
    _leftArrowButton.translatesAutoresizingMaskIntoConstraints = NO;
    //width
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_leftArrowButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:arrowImageWidth]];
    //height
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_leftArrowButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeHeight
                                 multiplier:1
                                   constant:0]];
    //top
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_leftArrowButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:0]];
    //left
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_leftArrowButton
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:0]];
    
    
    
    //创建右滑动箭头
    _rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightArrowButton setFrame:CGRectZero];
    [_rightArrowButton setBackgroundImage:rightArrowImage forState:UIControlStateNormal];
    [_rightArrowButton addTarget:self action:@selector(rightArrowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightArrowButton];
    _rightArrowButton.translatesAutoresizingMaskIntoConstraints = NO;
    //width
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_rightArrowButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:arrowImageWidth]];
    //height
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_rightArrowButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeHeight
                                 multiplier:1
                                   constant:0]];
    //top
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_rightArrowButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:0]];
    //right
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_rightArrowButton
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:0]];
    
    
    //隐藏左、右箭头
    _leftArrowButton.hidden = YES;
    _rightArrowButton.hidden = YES;
}

//左箭头点击
- (void)leftArrowButtonAction:(UIButton *)sender {
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    
    CJButton *targetRadioButton = nil;
    NSInteger count = self.radioButtons.count;
    for (NSInteger i = 0; i < count; i++) { //从第一个开始找，找到的第一个即是所求
        CJButton *radioButton = [self.radioButtons objectAtIndex:i];
        
        /* 确保”要找的按钮“的左侧至少在显示的“左侧箭头的最右侧值”之左 */
        CGFloat minShowX = CGRectGetMinX(radioButton.frame) - contentOffsetX;
        if (minShowX >= 0) {
            continue;
        }
        
        /* 同时确保”要找的按钮“的右侧要至少在显示的“左侧箭头的最右侧值”之右 */
        CGFloat maxShowX = CGRectGetMaxX(radioButton.frame) - contentOffsetX;
        if (maxShowX < 0) {
            continue;
        }
        
        targetRadioButton = radioButton;
        NSLog(@"left: targetRadioButtonText = %@", targetRadioButton.label.text);
        break;
    }
    
    /* 移动操作 */
    [self moveScrollViewToItem:targetRadioButton
       accordingToPositionType:RadioButtonPositionTypeEdgeStart
                 andSelectedIt:NO
                      animated:YES];
}

//右箭头点击
- (void)rightArrowButtonAction:(UIButton *)sender {
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    
    CJButton *targetRadioButton = nil;
    NSInteger count = self.radioButtons.count;
    for (NSInteger i = 0; i < count; i++) {   //从最后一个开始找，找到的第一个即是所求
        CJButton *radioButton = [self.radioButtons objectAtIndex:i];
        
        /* 确保”要找的按钮“的左侧至少在显示的屏幕的最左侧之右 */
        CGFloat minShowX = CGRectGetMinX(radioButton.frame) - contentOffsetX;
        if (minShowX < 0) {
            continue;
        }
        
        /* 同时确保”要找的按钮“的右侧要至少在显示的“右侧箭头的最左侧值”之右 */
        //尤其注意：这里的btnArrowR不是添加在scrollView上的，所以不要忘了要加上contentOffsetX来比较
        CGFloat maxShowX = CGRectGetMaxX(radioButton.frame) - contentOffsetX;
        if (maxShowX <= CGRectGetWidth(self.frame)) {
            continue;
        }
        targetRadioButton = radioButton;
        NSLog(@"right: targetRadioButtonText = %@", targetRadioButton.label.text);
        
        break;
    }
    
    /* 移动操作 */
    [self moveScrollViewToItem:targetRadioButton
       accordingToPositionType:RadioButtonPositionTypeEdgeEnd
                 andSelectedIt:NO
                      animated:YES];
}

/** 完整的描述请参见文件头部 */
- (void)cj_selectComponentAtIndex:(NSInteger)index_cur animated:(BOOL)animated {
    NSInteger index_old = self.currentSelectedIndex;
    
    if (index_cur != index_old) {
        self.oldSelectedIndex = self.currentSelectedIndex;
        _currentSelectedIndex = index_cur;
        
        if (index_old != -1) {
            CJButton *radioButton_old = [self.radioButtons objectAtIndex:self.oldSelectedIndex];
            radioButton_old.selected = NO;
        }
        
        CJButton *radioButton_cur = [self.radioButtons objectAtIndex:self.currentSelectedIndex];
        radioButton_cur.selected = YES;
        
        [self moveScrollViewToItem:radioButton_cur
           accordingToPositionType:RadioButtonPositionTypeMiddle
                     andSelectedIt:YES
                          animated:animated];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_haveArrowButton) {
        [self judgeAndSetArrowButtonState];
    }
}

/** 判断设设置箭头状态(显示或隐藏) */
- (void)judgeAndSetArrowButtonState {
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat scrollViewContentSizeWidth = self.scrollView.contentSize.width;
    
    BOOL startIsShowing = (contentOffsetX == 0);  //头有显示
    BOOL endIsShowing = (contentOffsetX + scrollViewWidth == scrollViewContentSizeWidth);//尾有显示
    _leftArrowButton.hidden = startIsShowing;
    _rightArrowButton.hidden = endIsShowing;
}


#pragma mark - addSubView
- (void)cj_makeView:(UIView *)superView addSubView:(UIView *)subView withEdgeInsets:(UIEdgeInsets)edgeInsets {
    [superView addSubview:subView];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeLeft   //left
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:edgeInsets.left]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeRight  //right
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:edgeInsets.right]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeTop    //top
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:edgeInsets.top]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeBottom //bottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:edgeInsets.bottom]];
}

- (UIView *)cj_addContentViewToScrollView:(UIView *)scrollView withWidthMultiplier:(CGFloat)widthMultiplier heightMultiplier:(CGFloat)heightMultiplier {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor clearColor];
    
    [scrollView addSubview:contentView];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:0]];
    //right
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:0]]; //right = 0;
    //top
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:0]];
    
    //bottom(实际上这条是反向设置了scrollView的高)
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:0]]; //bottom = 0
    
    
    //设置container的width（这里我们暂时设置contentView为3被scrollView的宽）
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeWidth
                                 multiplier:widthMultiplier
                                   constant:0]];
    //设置container的height
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeHeight
                                 multiplier:heightMultiplier
                                   constant:0]];
    
    return contentView;
}

- (UIView *)cj_addContentViewToScrollView:(UIView *)scrollView withContentSizeWidth:(CGFloat)contentSizeWidth {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor clearColor];
    
    [scrollView addSubview:contentView];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:0]];
    //right
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:0]]; //right = 0;
    //top
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:0]];
    
    //bottom(实际上这条是反向设置了scrollView的高)
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:0]]; //bottom = 0
    
    
    //设置container的width
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:contentSizeWidth]];
    //设置container的height
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeHeight
                                 multiplier:1
                                   constant:0]];
    
    return contentView;
}


- (NSLayoutConstraint *)cj_addSubView:(UIView *)subView toSuperView:(UIView *)superView afterCurrentView:(UIView *)currentView withWidth:(CGFloat)width {
    [superView addSubview:subView];
    
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    /* width、height、top是不变的所以这里可以先写 */
    
    //width
    NSLayoutConstraint *subViewWidthLayoutConstraint =
            [NSLayoutConstraint constraintWithItem:subView
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                         attribute:NSLayoutAttributeNotAnAttribute
                                        multiplier:1
                                          constant:width];
    [superView addConstraint:subViewWidthLayoutConstraint];
    
    //height
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:0]];
    //top
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    /* 计算left要多少 */
    //left
    if (currentView == nil) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:superView
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0]];
    } else {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:currentView
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]];
    }
    
    return subViewWidthLayoutConstraint;
}


/** 完整的描述请参见文件头部 */
- (void)scollToCurrentSelectedViewWithAnimated:(BOOL)animated {
    /* 如果初始有默认选择哪个按钮，则滑动到该按钮位置 */
    if (self.currentSelectedIndex != -1) {
        CJButton *targetRadioButton = [self.radioButtons objectAtIndex:self.currentSelectedIndex];
        
        [self moveScrollViewToItem:targetRadioButton
                     accordingToPositionType:RadioButtonPositionTypeMiddle
                     andSelectedIt:YES
                          animated:animated];
    }
}

/**
 *  滚动到指定的单选按钮 targetRadioButton 上 （当按钮太多显示不全时常需要设置这个为YES）
 *
 *  @param targetRadioButton    要滚动到的指定按钮
 *  @param selectedIt           是否选中
 *  @param animated             是否动画
 */
- (void)moveScrollViewToItem:(CJButton *)targetRadioButton
     accordingToPositionType:(RadioButtonPositionType)positionType
               andSelectedIt:(BOOL)selectedIt
                    animated:(BOOL)animated
{
    if (selectedIt && self.showBottomLineView) {
        CGFloat lineImageViewWidth = self.bottomLineViewWidth == 0 ? CGRectGetWidth(targetRadioButton.frame) : self.bottomLineViewWidth;
        CGFloat lineImageViewHeight = self.bottomLineViewHeight == 0 ? 1 : self.bottomLineViewHeight;
        CGFloat lineImageViewX = CGRectGetMidX(targetRadioButton.frame) - lineImageViewWidth/2;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.lineImageViewLeftLayoutConstraint.constant = lineImageViewX;
            self.lineImageViewWidthLayoutConstraint.constant = lineImageViewWidth;
            self.lineImageViewHeightLayoutConstraint.constant = lineImageViewHeight;
        }];
    }
    
    CGFloat newContentOffsetX = 0;
    switch (positionType) {
        case RadioButtonPositionTypeMiddle:
        {
            newContentOffsetX = CGRectGetMidX(targetRadioButton.frame) - CGRectGetWidth(self.frame)/2;//滑动到该按钮的最中间
            break;
        }
        case RadioButtonPositionTypeEdgeEnd:
        {
            newContentOffsetX = CGRectGetMaxX(targetRadioButton.frame) - CGRectGetWidth(self.frame);//滑动到该按钮的最边缘(最右)
            break;
        }
        case RadioButtonPositionTypeEdgeStart:
        {
            newContentOffsetX = CGRectGetMinX(targetRadioButton.frame);//滑动到该按钮的最边缘(最左)
            break;
        }
        default:
            break;
    }
    
    CGFloat minContentOffsetX = 0;
    CGFloat maxContentOffsetX = self.scrollView.contentSize.width - CGRectGetWidth(self.frame);
    if (newContentOffsetX < minContentOffsetX) {
        newContentOffsetX = minContentOffsetX;
    }
    if (newContentOffsetX > maxContentOffsetX) {
        newContentOffsetX = maxContentOffsetX;
    }
    
    [self.scrollView setContentOffset:CGPointMake(newContentOffsetX, self.scrollView.contentOffset.y) animated:animated];
    
    /*
    return;
    
    //该item的距离计算。(滑动scrollView到显示出完整的targetRadioButton)
    //CGFloat leftX = CGRectGetMinX(targetRadioButton.frame);
    CGFloat rightX = CGRectGetMaxX(targetRadioButton.frame);
    
    CGFloat width = CGRectGetWidth(self.frame);
    if (rightX >= width - 60) { //如果rightX离self.frame边缘太近(小于40)就要移动,设移动距离为moveOffset
        CGFloat moveOffset = self.frame.size.width/2 + 40;
        CGFloat rightX_new;
        
        if (rightX + moveOffset >= self.scrollView.contentSize.width) {//如果向左移动moveOffset后，会超出边界，则移动到末尾
            moveOffset = self.frame.size.width;
            rightX_new = self.scrollView.contentSize.width - moveOffset;
            
            [self scrollToContentOffsetX:rightX_new withAnimate:animated];
        }else{
            
            rightX_new = rightX - moveOffset;
            
            if (rightX_new > 0) {
                [self scrollToContentOffsetX:rightX_new withAnimate:animated];
            }
        }
        
    } else {
        [self scrollToContentOffsetX:0 withAnimate:animated];
    }
    */
}

@end
