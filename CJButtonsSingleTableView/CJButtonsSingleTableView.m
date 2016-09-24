//
//  CJButtonsSingleTableView.m
//  CJGroupTableViewDemo
//
//  Created by lichq on 9/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJButtonsSingleTableView.h"

#define kDefaultMaxShowCount    5

@interface CJButtonsSingleTableView () {
    
}
@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation CJButtonsSingleTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}

- (void)commonInit {
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    _radioButtons = [[RadioButtons alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _radioButtons.dataSource = self;
    _radioButtons.delegate = self;
    [self addSubview:_radioButtons];
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    
    self.titles = [[NSMutableArray alloc]init];
    for (NSArray *array in datas) {
        NSString *title = [array firstObject];
        [self.titles addObject:title];
    }
    [_radioButtons reloadViews];
}

- (void)cj_singleTableView:(CJSingleTableView *)singleTableView didSelectText:(NSString *)text {
    [_radioButtons changeCurrentRadioButtonStateAndTitle:text];
    
    if([self.delegate respondsToSelector:@selector(cj_buttonsSingleTableView:didSelectText:)]){
        [self.delegate cj_buttonsSingleTableView:self didSelectText:text];
    }
}


#pragma mark - RadioButtonsDataSource & RadioButtonsDelegate
- (NSInteger)cj_defaultShowIndexInRadioButtons:(RadioButtons *)radioButtons {
    return -1;
}

- (NSInteger)cj_numberOfComponentsInRadioButtons:(RadioButtons *)radioButtons {
    return self.titles.count;
}

- (CGFloat)cj_radioButtons:(RadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index  {
    NSInteger showViewCount = MIN(self.titles.count, kDefaultMaxShowCount);
    CGFloat sectionWidth = CGRectGetWidth(radioButtons.frame)/showViewCount;
    sectionWidth = ceilf(sectionWidth);
    
    return sectionWidth;
}

- (RadioButton *)cj_radioButtons:(RadioButtons *)radioButtons cellForComponentAtIndex:(NSInteger)index {
    NSArray *radioButtonNib = [[NSBundle mainBundle]loadNibNamed:@"RadioButton_Slider" owner:nil options:nil];
    RadioButton *radioButton = [radioButtonNib lastObject];
    [radioButton setTitle:self.titles[index]];
    radioButton.textNormalColor = [UIColor blackColor];
    radioButton.textSelectedColor = [UIColor greenColor];
    
    return radioButton;
}

- (void)cj_radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old {
    NSLog(@"index_old = %ld, index_cur = %ld", index_old, index_cur);
    
    if (index_cur == index_old) {
        return;
    }
    //    if (radioButtons.isCJPopupViewShowing) {
    //        [self.operationRadioButtons cj_hideExtendViewAnimated:YES];
    //    }
//    self.operationRadioButtons = radioButtons;
//
    
    
    
    CGFloat width = CGRectGetWidth(self.frame);
    NSInteger radioButtonCount = [self.titles count];
    CGFloat singleTableViewWidth = width/radioButtonCount;
    CGFloat singleTableViewX = singleTableViewWidth * index_cur;
    CGFloat singleTableViewY = 264;
    CGFloat singleTableViewHeight = 200;
    
    CJSingleTableView *popupView = [[CJSingleTableView alloc] initWithFrame:CGRectZero];
    [popupView setFrame:CGRectMake(singleTableViewX,
                                    singleTableViewY,
                                    singleTableViewWidth,
                                    singleTableViewHeight)];
    popupView.datas = [self.datas objectAtIndex:index_cur];;
    [popupView setDelegate:self];
    
    [radioButtons cj_showExtendView:popupView
                             inView:self.superview
                         atLocation:CGPointMake(singleTableViewX, singleTableViewY)
                           withSize:CGSizeMake(singleTableViewWidth, singleTableViewHeight)
                       showComplete:^{
//    RadioButton *radioButton = [radioButtons obj..]
//    [radioButtons cj_showDropDownView:popupView inView:self.superview showComplete:^{
        NSLog(@"显示完成");
    } tapBlankComplete:^() {
        NSLog(@"点击背景完成");
    } hideComplete:^() {
        NSLog(@"隐藏完成");
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
