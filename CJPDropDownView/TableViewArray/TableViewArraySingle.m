//
//  TableViewArraySingle.m
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "TableViewArraySingle.h"

@implementation TableViewArraySingle
@synthesize tv;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

- (void)setDatas:(NSArray *)datas{
    _datas = datas;
    
    //修改tableview的frame
    CGFloat width = self.frame.size.width;
    if(width <= 0){
        NSLog(@"检查下是否忘记设置frame，而导致width为0");
    }
   
    if (tv == nil) {
        CGRect rect = CGRectMake(0, 0, width, 0);
        tv = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tv.delegate = self;
        tv.dataSource = self;
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tv];
    }
    
    
    //动画设置位置
    CGFloat height = self.frame.size.height;
    if(height <= 0){
        NSLog(@"检查下是否忘记设置frame，而导致height为0");
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = tv.frame;
        rect.size.height = height;
        tv.frame = rect;
        tv.alpha = 1.0;
    }];
    
    [tv reloadData];
    [tv selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}



#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark -- UITableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    NSString *object = [self.datas objectAtIndex:indexPath.row];
    cell.textLabel.text = object;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *object = [self.datas objectAtIndex:indexPath.row];
    if([self.delegate respondsToSelector:@selector(tv_ArraySingle:didSelectText:)]){
        [self.delegate tv_ArraySingle:self didSelectText:object];
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
