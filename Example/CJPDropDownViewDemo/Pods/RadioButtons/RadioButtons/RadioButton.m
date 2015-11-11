//
//  RadioButton.m
//  RadioButtonsDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "RadioButton.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

@implementation RadioButton
@synthesize btn;
@synthesize lab;
@synthesize imageV;


- (void)awakeFromNib{
    [btn addTarget:self action:@selector(radioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (id)initWithNibNamed:(NSString *)nibName frame:(CGRect)frame{
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil];
    self = [array lastObject];
    
    [self setFrame:frame];//注意:前提必须在xib中设置autolayout，否则subview不会因设置的frame改变而改变
    
    return self;
}

- (void)setTitle:(NSString *)title{ //@"--";
    //[btn  setTitle:title forState:UIControlStateNormal];
    [lab setText:title];
}

- (void)setSelected:(BOOL)selected{
    if (selected == _selected) {    //如果选中的一样则不进行操作，比如imageV就不进行transform了
        return;
    }
    
    _selected = selected;
    btn.selected = selected;
    
    if (selected) {
        lab.textColor = [UIColor greenColor];
    }else{
        lab.textColor = [UIColor blackColor];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        imageV.transform = CGAffineTransformRotate(imageV.transform, DEGREES_TO_RADIANS(180));
    }];
    
    /*
    if (selected) {
        UIFont *font = btn.titleLabel.font;
        CGSize constrainedToSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        CGSize textSize = [lab.text sizeWithFont:font constrainedToSize:constrainedToSize lineBreakMode:NSLineBreakByTruncatingTail];
        
        UIImage *shadowImage = [UIImage imageNamed:@"btn_BG_selected@2x"];
        CGRect rect_shadowImageV = CGRectMake(0, 0, textSize.width+5, shadowImage.size.height);
        imageV = [[UIImageView alloc] initWithFrame:rect_shadowImageV];
        [imageV setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        imageV.image = shadowImage;
        [self addSubview:imageV];
        [self bringSubviewToFront:lab];
    }else{
        [imageV removeFromSuperview];
    }
    */
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
