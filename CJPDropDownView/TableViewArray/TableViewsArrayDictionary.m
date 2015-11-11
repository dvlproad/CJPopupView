//
//  TableViewsArrayDictionary.m
//  CJPDropDownViewDemo
//
//  Created by lichq on 7/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "TableViewsArrayDictionary.h"

#define kTableViewTagBegin  1010

@implementation TableViewsArrayDictionary
@synthesize adModel = _adModel;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

- (void)setAdModel:(ArrayDictonaryModel *)adModel{
    _adModel = adModel;
    
    NSInteger listNum = 1;
    if (nil == adModel.dicArray) {
        listNum = 1; //即0+1
    }else{
        listNum = [adModel.dicArray count] + 1;
    }
    componentCount = listNum;

    
    //修改tableview的frame
    CGFloat width = self.frame.size.width;
    if(width <= 0){
        NSLog(@"检查下是否忘记设置frame，而导致width为0");
    }
    int sectionWidth = width/componentCount;
    for(int i = 0; i < componentCount; i++){
        CGRect rect = CGRectMake(sectionWidth*i, 0, sectionWidth, 0);
        UITableView *tv = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tv.delegate = self;
        tv.dataSource = self;
        tv.tag = kTableViewTagBegin+i;
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        if(i == 1){
            tv.backgroundColor = [UIColor lightGrayColor];
        }
        [self addSubview:tv];
    }
    
    //动画设置位置
    CGFloat height = self.frame.size.height;
    if(height <= 0){
        NSLog(@"检查下是否忘记设置frame，而导致height为0");
    }
    [UIView animateWithDuration:0.3 animations:^{
        for(int i = 0; i < componentCount; i++){
            UITableView *tv = (UITableView *)[self viewWithTag:kTableViewTagBegin+i];
            CGRect rect = tv.frame;
            rect.size.height = height;
            tv.frame = rect;
            tv.alpha = 1.0;
        }
    }];
    
    [self updateTv_wDidSelectInComponent:-1];
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
    NSInteger component = tableView.tag - kTableViewTagBegin;
    NSArray *C_0_data = self.adModel.datas[component];
    return [C_0_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSInteger component = tableView.tag - kTableViewTagBegin;
    NSArray *C_0_data = self.adModel.datas[component];
    if(component == 1){
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if (component != componentCount - 1) {
        NSDictionary *object = [C_0_data objectAtIndex:indexPath.row];
        NSString *key_title = [self key_titleInComponent:component];
        NSString *title = [object valueForKey:key_title];
        
        NSString *key_value = [self key_valueInComponent:component];
        NSArray *values = [object valueForKey:key_value];
        BOOL isHaveNext = [values count] > 0;
        if(isHaveNext){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = title;
        
    }else{
        NSString *object = [C_0_data objectAtIndex:indexPath.row];
        cell.textLabel.text = object;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger component = tableView.tag - kTableViewTagBegin;
    NSArray *C_0_data = self.adModel.datas[component];
    
    [self didSelectRow:indexPath.row inComponent:component];
    
    if (component == componentCount - 1) {
        NSString *object = [C_0_data objectAtIndex:indexPath.row];
        if([self.delegate respondsToSelector:@selector(tv_ArrayDictionary:didSelectText:)]){
            [self.delegate tv_ArrayDictionary:self didSelectText:object];
        }
        return;
    }
    
    

    NSDictionary *object = [C_0_data objectAtIndex:indexPath.row];
    NSString *key_value = [self key_valueInComponent:component];
    NSArray *values = [object valueForKey:key_value];
    BOOL isHaveNext = [values count] > 0;
    if(isHaveNext){ //如果有下个操作，则更新后续的列表，之后再继续根据新的点击操作来判断选择出来的是什么值
        [self updateTv_wDidSelectInComponent:component];
        
    }else{
        NSString *key_title = [self key_titleInComponent:component];
        NSString *title = [object valueForKey:key_title];
        if([self.delegate respondsToSelector:@selector(tv_ArrayDictionary:didSelectText:)]){
            [self.delegate tv_ArrayDictionary:self didSelectText:title];
        }
    }
    
}


- (NSString *)key_titleInComponent:(NSInteger)component{
    NSString *key_title = [[self.adModel.dicArray objectAtIndex:component] objectForKey:kAD_Title];
    return key_title;
}

- (NSString *)key_valueInComponent:(NSInteger)component{
    NSString *key_value = [[self.adModel.dicArray objectAtIndex:component] objectForKey:kAD_Value];
    return key_value;
}

//在component中，选择row行，则更新 selecteds_index 和 selecteds_titles。
- (void)didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSMutableArray *selecteds_index = [NSMutableArray arrayWithArray:self.adModel.selecteds_index];
    [selecteds_index replaceObjectAtIndex:component withObject:[NSString stringWithFormat:@"%zd", row]];
    for (NSInteger i = component+1; i < componentCount; i++) {
        //注意:当前列表之后的，其他列表的selected_index要改为0
        [selecteds_index replaceObjectAtIndex:i withObject:@"0"];
    }
    [self.adModel updateSelecteds_index:selecteds_index];
}

//在component中，选择行后，则更新 后续的列表
- (void)updateTv_wDidSelectInComponent:(NSInteger)component{
    for(NSInteger i = component+1; i < componentCount; i++){
        UITableView *tv = (UITableView *)[self viewWithTag:kTableViewTagBegin+i];
        [tv reloadData];
        [tv selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
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
