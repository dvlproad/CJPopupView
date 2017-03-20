//
//  CJDragView.m
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/11/05.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJDragView.h"

@interface CJDragView () {
    
}
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint startFramePoint;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation CJDragView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self cjDragView_commonInit];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self cjDragView_commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self cjDragView_commonInit];
    }
    return self;
}

/** 完整的描述请参见文件头部 */
- (void)cjDragView_commonInit {
    self.clipsToBounds = YES;
    self.dragEnable = YES;  //默认可以拖曳
    self.isKeepBounds = NO; //默认不黏合边界

    //添加拖动手势
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    _panGestureRecognizer.minimumNumberOfTouches = 1;
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:_panGestureRecognizer];
}


- (void)layoutSubviews {
    if (self.freeRect.origin.x != 0 ||
        self.freeRect.origin.y !=0 ||
        self.freeRect.size.height !=0 ||
        self.freeRect.size.width != 0) {
        //设置了freeRect--活动范围
        
    }else{
        //没有设置freeRect--活动范围，则设置默认的活动范围为父视图的frame
        self.freeRect = (CGRect){CGPointZero,self.superview.bounds.size};
    }
}

/**
 *  拖动事件
 *
 *  @param pan    拖动的手势
 */
- (void)dragAction:(UIPanGestureRecognizer *)pan {
    if (self.dragEnable == NO) {    //不可以拖动，直接返回
        return;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: //拖动开始
        {
            if (self.dragBeginBlock) {
                self.dragBeginBlock(self);
            }
            //注意一旦你完成上述的移动，将translation重置为0十分重要。否则translation每次都会叠加
            [pan setTranslation:CGPointMake(0, 0) inView:self];
            //保存触摸起始点位置
            self.startPoint = [pan translationInView:self];
            //该view置于最前
            [[self superview] bringSubviewToFront:self];
            break;
        }
        case UIGestureRecognizerStateChanged:   //拖动中
        {
           
            //计算位移=当前位置-起始位置
            if (self.dragDuringBlock) {
                self.dragDuringBlock(self);
            }
            CGPoint point = [pan translationInView:self];
            float dx;
            float dy;
            
            switch (self.dragDirection) {
                case CJDragDirectionAny:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
                case CJDragDirectionHorizontal:
                    dx = point.x - self.startPoint.x;
                    dy = 0;
                    break;
                case CJDragDirectionVertical:
                    dx = 0;
                    dy = point.y - self.startPoint.y;
                    break;
                default:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
            }
            
            //计算移动后的view中心点
            CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
            /* 限制用户不可将视图托出给定的范围 */
            /*
            float halfx = CGRectGetMidX(self.bounds);
            
            newcenter.x = MAX(halfx + self.freeRect.origin.x , newcenter.x);
            //x坐标右边界
            newcenter.x = MIN(self.freeRect.size.width+self.freeRect.origin.x - halfx, newcenter.x);
            
            
            if (self.isKeepBounds) {
                //y坐标同理
                float halfy = CGRectGetMidY(self.bounds);
                //y的上面进行限制
                newcenter.y = MAX(halfy + self.freeRect.origin.y, newcenter.y);
                //y的下面进行限制
                newcenter.y = MIN(self.freeRect.size.height+self.freeRect.origin.y - halfy, newcenter.y);
            }
            //*/
           
            
            //移动view
            self.center = newcenter;
            //  注意一旦你完成上述的移动，将translation重置为0十分重要。否则translation每次都会叠加
            [pan setTranslation:CGPointMake(0, 0) inView:self];
            break;
        }
        case UIGestureRecognizerStateEnded: //拖动结束
        {
            [self keepBounds];
            
            if (self.dragEndBlock) {
                self.dragEndBlock(self);
            }

            break;
        }
        default:
            break;
    }
   
}

- (void)keepBounds
{
    //中心点判断
    float centerX = self.freeRect.origin.x+(self.freeRect.size.width - self.frame.size.width)/2;

    CGRect rect = self.frame;

    if (self.isKeepBounds == NO) {  //没有黏贴边界的效果
        if (self.frame.origin.x < self.freeRect.origin.x) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"leftMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.freeRect.origin.x;
            [self setFrame:rect];
            [UIView commitAnimations];
        } else if(self.freeRect.origin.x+self.freeRect.size.width < self.frame.origin.x+self.frame.size.width){
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"rightMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.freeRect.origin.x+self.freeRect.size.width-self.frame.size.width;
            [self setFrame:rect];
            [UIView commitAnimations];
        }
    } else if(self.isKeepBounds==YES){//自动粘边
        if (self.frame.origin.x< centerX) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"leftMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.freeRect.origin.x;
            [self setFrame:rect];
            [UIView commitAnimations];
        } else {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"rightMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x =self.freeRect.origin.x+self.freeRect.size.width - self.frame.size.width;
            [self setFrame:rect];
            [UIView commitAnimations];
        }
    }
    
    if (self.frame.origin.y < self.freeRect.origin.y) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"topMove" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        rect.origin.y = self.freeRect.origin.y;
        [self setFrame:rect];
        [UIView commitAnimations];
        
    } else if(self.freeRect.origin.y+self.freeRect.size.height< self.frame.origin.y+self.frame.size.height){
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"bottomMove" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        rect.origin.y = self.freeRect.origin.y+self.freeRect.size.height-self.frame.size.height;
        [self setFrame:rect];
        [UIView commitAnimations];
    }
}

@end
