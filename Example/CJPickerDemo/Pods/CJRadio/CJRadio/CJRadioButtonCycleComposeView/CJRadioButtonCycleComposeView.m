//
//  CJRadioButtonCycleComposeView.m
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import "CJRadioButtonCycleComposeView.h"

@interface CJRadioButtonCycleComposeView () <CJRadioButtonsDataSource, CJRadioButtonsDelegate, CJCycleComposeViewDataSource, CJCycleComposeViewDelegate> {
    BOOL isDelegateDoneInRadioButton; //避免点击单选按钮的时候，delegate执行两次
    
}
@property (nonatomic, strong) CJRadioButtons *sliderRadioButtons;
@property (nonatomic, strong) CJCycleComposeView *cycleComposeView;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) NSLayoutConstraint *radioButtonsHeightLayoutConstraint;
@property (nonatomic, strong) NSLayoutConstraint *radioButtonsLeftLayoutConstraint;
@property (nonatomic, strong) NSLayoutConstraint *radioButtonsRightLayoutConstraint;

@property (nonatomic, strong) NSLayoutConstraint *radioButtonsLeftViewWidthLayoutConstraint;
@property (nonatomic, strong) NSLayoutConstraint *radioButtonsRightViewWidthLayoutConstraint;

@end

@implementation CJRadioButtonCycleComposeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.radioButtonsHeight = 0;
    
    /* Self的一些其他设置 */
    self.defaultSelectedIndex = 0;
    self.maxRadioButtonsShowViewCount = 3;
    
    /* 添加 CJRadioButtons */
    self.sliderRadioButtons = [[CJRadioButtons alloc] initWithFrame:CGRectZero];
//    self.sliderRadioButtons.dataSource = self; //放在reloadData中了
    self.sliderRadioButtons.delegate = self;
    [self addSubview:self.sliderRadioButtons];
    
    /* 添加 RadioControllers */
    self.cycleComposeView = [[CJCycleComposeView alloc] initWithFrame:CGRectZero];
//    self.CJCycleComposeView.dataSource = self;  //放在reloadData中了
    self.cycleComposeView.delegate = self;
    [self addSubview:self.cycleComposeView];
    
    //设置约束
    [self setupConstraints];
}

#pragma mark - 设置CJRadioButtons的附加设置
- (void)setShowBottomLineView:(BOOL)showBottomLineView {
    _showBottomLineView = showBottomLineView;
    
    self.sliderRadioButtons.showBottomLineView = showBottomLineView;
}

- (void)setHideSeparateLine:(BOOL)hideSeparateLine {
    _hideSeparateLine = hideSeparateLine;
    
    self.sliderRadioButtons.hideSeparateLine = hideSeparateLine;
}

- (void)setBottomLineImage:(UIImage *)bottomLineImage {
    _bottomLineImage = bottomLineImage;
    
    self.sliderRadioButtons.bottomLineImage = bottomLineImage;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    
    self.sliderRadioButtons.bottomLineColor = bottomLineColor;
}

- (void)setBottomLineViewHeight:(CGFloat)bottomLineViewHeight {
    _bottomLineViewHeight = bottomLineViewHeight;
    
    self.sliderRadioButtons.bottomLineViewHeight = bottomLineViewHeight;
}

- (void)setBottomLineViewWidth:(CGFloat)bottomLineViewWidth {
    _bottomLineViewWidth = bottomLineViewWidth;
    
    self.sliderRadioButtons.bottomLineViewWidth = bottomLineViewWidth;
}

#pragma mark - 设置CJCycleComposeView的附加设置
- (void)setScrollType:(CJCycleComposeViewScrollType)scrollType {
    _scrollType = scrollType;
    
    self.cycleComposeView.scrollType = scrollType;
}


#pragma mark - reloadData
- (void)reloadData {
    self.radioButtonsHeightLayoutConstraint.constant = self.radioButtonsHeight;
    self.sliderRadioButtons.dataSource = self;
    self.cycleComposeView.dataSource = self; //该set方法有reload操作
}


/** 完整的描述请参见文件头部 */
- (void)scollToCurrentSelectedViewWithAnimated:(BOOL)animated {
    [self.sliderRadioButtons scollToCurrentSelectedViewWithAnimated:animated];
    [self.cycleComposeView cj_scrollToCenterViewWithAnimated:animated];
}


/** 完整的描述请参见文件头部 */
- (void)addLeftArrowImage:(UIImage *)leftArrowImage rightArrowImage:(UIImage *)rightArrowImage withArrowImageWidth:(CGFloat)arrowImageWidth {
    [self.sliderRadioButtons addLeftArrowImage:leftArrowImage
                               rightArrowImage:rightArrowImage
                           withArrowImageWidth:arrowImageWidth];
}

/** 完整的描述请参见文件头部 */
- (void)addRadioButtonsLeftView:(UIView *)radioButtonsLeftView withWidth:(CGFloat)radioButtonsLeftViewWidth {
    self.radioButtonsLeftLayoutConstraint.constant = radioButtonsLeftViewWidth;
    
    [self addSubview:radioButtonsLeftView];
    radioButtonsLeftView.translatesAutoresizingMaskIntoConstraints = NO;
    //top
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:radioButtonsLeftView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:0]];
    //bottom
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:radioButtonsLeftView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.sliderRadioButtons
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:0]];
    //left
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:radioButtonsLeftView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:0]];
    //width
    self.radioButtonsLeftViewWidthLayoutConstraint =
    [NSLayoutConstraint constraintWithItem:radioButtonsLeftView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:radioButtonsLeftViewWidth];
    [self addConstraint:self.radioButtonsLeftViewWidthLayoutConstraint];
}

/** 完整的描述请参见文件头部 */
- (void)addRadioButtonsRightView:(UIView *)radioButtonsRightView withWidth:(CGFloat)radioButtonsRightViewWidth {
    self.radioButtonsRightLayoutConstraint.constant = -radioButtonsRightViewWidth;
    
    [self addSubview:radioButtonsRightView];
    radioButtonsRightView.translatesAutoresizingMaskIntoConstraints = NO;
    //top
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:radioButtonsRightView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:0]];
    //bottom
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:radioButtonsRightView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.sliderRadioButtons
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:0]];
    //right
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:radioButtonsRightView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:0]];
    //width
    self.radioButtonsRightViewWidthLayoutConstraint =
    [NSLayoutConstraint constraintWithItem:radioButtonsRightView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:radioButtonsRightViewWidth];
    [self addConstraint:self.radioButtonsRightViewWidthLayoutConstraint];
}

#pragma mark - CJRadioButtonsDataSource
- (NSInteger)cj_defaultShowIndexInRadioButtons:(CJRadioButtons *)radioButtons {
    return self.defaultSelectedIndex;
}

- (NSInteger)cj_numberOfComponentsInRadioButtons:(CJRadioButtons *)radioButtons {
    return self.radioModules.count;
}

- (CGFloat)cj_radioButtons:(CJRadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index  {
    CGFloat totalWidth = CGRectGetWidth(radioButtons.frame);
    NSInteger showViewCount = MIN(self.radioModules.count, self.maxRadioButtonsShowViewCount);
    CGFloat sectionWidth = totalWidth/showViewCount;
    
    sectionWidth = ceilf(sectionWidth); //重点注意：当使用除法计算width时候，为了避免计算出来的值受除后，余数太多，除不尽(eg:102.66666666666667)，而造成的之后在通过左右箭头点击来寻找”要找的按钮“的时候，计算出现问题（”要找的按钮“需与“左右侧箭头的最左最右侧值”进行精确的比较），所以这里我们需要一个整数值，故我们这边选择向上取整。
    
    if (index == self.radioModules.count-1) {
        CGFloat hasUseWidth = (showViewCount-1) * sectionWidth;
        sectionWidth = totalWidth - hasUseWidth; //确保加起来的width不变
    }
    
    return sectionWidth;
}

- (CJButton *)cj_radioButtons:(CJRadioButtons *)radioButtons cellForComponentAtIndex:(NSInteger)index {
    CJButton *radioButton = [self.dataSource cj_buttonControllerView:self cellForComponentAtIndex:index];
    
    CJRadioModule *radioModule = [self.radioModules objectAtIndex:index];
    [radioButton setTitle:radioModule.title];
    
    return radioButton;
}


#pragma mark - CJCycleComposeViewDataSource
- (NSInteger)cj_defaultShowIndexInCJCycleComposeView:(CJCycleComposeView *)CJCycleComposeView {
    return self.defaultSelectedIndex;
}

- (NSArray<UIView *> *)cj_radioViewsInCJCycleComposeView:(CJCycleComposeView *)CJCycleComposeView {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (CJRadioModule *radioModule in self.radioModules) {
        UIViewController *viewController = radioModule.viewController;
        
        [views addObject:viewController.view];
        [self.componentViewParentViewController addChildViewController:viewController];//记得添加进去
    }
    
    return views;
}


#pragma mark - CJRadioButtonsDelegate & CJCycleComposeViewDelegate
- (void)cj_radioButtons:(CJRadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old {
    isDelegateDoneInRadioButton = YES;
    //NSLog(@"index_old = %ld, index_cur = %ld", index_old, index_cur);
    [self.cycleComposeView cj_selectComponentAtIndex:index_cur animated:YES];
    self.currentSelectedIndex = index_cur;
    
    [self didChangeToIndex:index_cur];
}

- (void)cj_cycleComposeView:(CJCycleComposeView *)cycleComposeView didChangeToIndex:(NSInteger)index {
    if (isDelegateDoneInRadioButton == NO) {
        [self.sliderRadioButtons cj_selectComponentAtIndex:index animated:YES];
        self.currentSelectedIndex  = index;
        
        [self didChangeToIndex:index];
    }
    isDelegateDoneInRadioButton = NO;
}


- (void)didChangeToIndex:(NSInteger)index { //变化之后，常用来做一些比如“强制刷新”的操作
    if (self.delegate && [self.delegate respondsToSelector:@selector(cj_buttonControllerView:didChangeToIndex:)]) {
        [self.delegate cj_buttonControllerView:self didChangeToIndex:index];
    }
}


#pragma mark - setupConstraints
- (void)setupConstraints {
    [self setupConstraintsForRadioButtons];
    [self setupConstraintsForCJCycleComposeView];
}

- (void)setupConstraintsForRadioButtons {
    self.sliderRadioButtons.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    self.radioButtonsLeftLayoutConstraint =
    [NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];
    [self addConstraint:self.radioButtonsLeftLayoutConstraint];
    //right
    self.radioButtonsRightLayoutConstraint =
    [NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0];
    [self addConstraint:self.radioButtonsRightLayoutConstraint];
    //top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    //height
    self.radioButtonsHeightLayoutConstraint =
    [NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:self.radioButtonsHeight];
    [self addConstraint:self.radioButtonsHeightLayoutConstraint];
}

- (void)setupConstraintsForCJCycleComposeView {
    self.cycleComposeView.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cycleComposeView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    //right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cycleComposeView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    //top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cycleComposeView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.sliderRadioButtons
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    //bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cycleComposeView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
}


@end
