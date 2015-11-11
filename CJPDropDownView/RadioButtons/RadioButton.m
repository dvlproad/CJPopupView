//
//  RadioButton.m
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "RadioButton.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@implementation RadioButton
@synthesize btn;
@synthesize imageV;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor greenColor];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self addSubview:btn];
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 16, (self.frame.size.height-12)/2, 12, 12)];
    [imageV setImage:[UIImage imageNamed:@"down_dark.png"]];
    [imageV setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:imageV];
    
    [btn addTarget:self action:@selector(radioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)awakeFromNib{
    [btn addTarget:self action:@selector(radioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (id)initWithNibNamed:(NSString *)nibName frame:(CGRect)frame{
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil];
    self = [array lastObject];
    
    [self setFrame:frame];////注意:前提必须在xib中设置autolayout，否则subview不会因设置的frame改变而改变
    
    return self;
}

- (void)setTitle:(NSString *)title{
    [btn  setTitle:title forState:UIControlStateNormal];//@"--";
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    btn.selected = selected;
}

- (void)radioButtonClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(radioButtonClick:)]) {
        [self.delegate radioButtonClick:self];
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
