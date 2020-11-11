//
//  SubGuideView.m
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/3/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "SubGuideView.h"

@implementation SubGuideView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self cj_sizeToFit];
    
}
- (void)cj_sizeToFit
{
    CGRect rect = [self.title.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame) - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.title.font} context:nil];
    CGFloat height = rect.size.height ;
    
    CGFloat lastHeight = height > 44 ? height + 16 : 60;
    CGRect frame = self.frame;
    frame.size.width = lastHeight;
    self.frame = frame;
}

- (void)setText:(NSString *)text
{
    self.title.text = text;
//    [self updateConstraints];
}

- (IBAction)confirm:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}


- (void)dealloc
{
    NSLog(@"SubGuideView.h 释放了");
}

@end
