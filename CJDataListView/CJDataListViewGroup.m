//
//  CJDataListViewGroup.m
//  CJPDropDownViewDemo
//
//  Created by lichq on 7/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJDataListViewGroup.h"

#define kTableViewTagBegin  1010

@implementation CJDataListViewGroup

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
    
}

- (void)setDataGroupModel:(CJDataGroupModel *)dataGroupModel {
    _dataGroupModel = dataGroupModel;
    
    NSInteger listNum = [dataGroupModel.componentModelDatasDatas count];
    componentCount = listNum;

    
    //修改tableview的frame
    CGFloat width = self.frame.size.width;
    if(width <= 0){
        NSLog(@"检查下是否忘记设置frame，而导致width为0");
    }
    int componentWidth = width/componentCount;
    for(int i = 0; i < componentCount; i++){
        CGRect rect = CGRectMake(componentWidth*i, 0, componentWidth, self.frame.size.height);
        UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = kTableViewTagBegin+i;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
    }
    
    [self updateTableViewsFromComponentIndex:0];
}


/** 完整的描述请参见文件头部 */
- (void)updateTableViewBackgroundColor:(UIColor *)color inComponent:(NSInteger)component {
    UITableView *tv = (UITableView *)[self viewWithTag:kTableViewTagBegin+component];
    [tv setBackgroundColor:color];
}


#pragma mark -- UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger component = tableView.tag - kTableViewTagBegin;
    NSArray *componentDatas = self.dataGroupModel.componentModelDatasDatas[component];
    return [componentDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    NSInteger component = tableView.tag - kTableViewTagBegin;
    
    /*
    NSArray *componentDatas = self.dataGroupModel.componentDatasDatas[component];
    if (component != componentCount - 1) {
        NSDictionary *object = [componentDatas objectAtIndex:indexPath.row];
        
        NSString *categoryKey =[self.dataGroupModel.categoryKeys objectAtIndex:component];
        NSString *categoryValueKey =[self.dataGroupModel.categoryValueKeys objectAtIndex:component];
        
        NSString *category = [object valueForKey:categoryKey];
        NSArray *categoryValues = [object valueForKey:categoryValueKey];
        
        BOOL isHaveNext = [categoryValues count] > 0;
        
        
        if(isHaveNext){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = category;
        
    }else{
        NSString *object = [componentDatas objectAtIndex:indexPath.row];
        cell.textLabel.text = object;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    */
    NSArray *componentModelDatas = self.dataGroupModel.componentModelDatasDatas[component];
    CJComponentModelData *componentModelData = [componentModelDatas objectAtIndex:indexPath.row];
    NSString *text = componentModelData.text;
    BOOL isHaveNext = componentModelData.containValueCount > 0 ? YES : NO;
    
    cell.textLabel.text = text;
    if(isHaveNext){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}


#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger component = tableView.tag - kTableViewTagBegin;
    
    [self didSelectRow:indexPath.row inComponent:component];
    
    /*
    NSArray *componentDatas = self.dataGroupModel.componentDatasDatas[component];
    
    if (component == componentCount - 1) {
        NSString *object = [componentDatas objectAtIndex:indexPath.row];
        if([self.delegate respondsToSelector:@selector(cj_dataListViewGroup:didSelectText:)]){
            [self.delegate cj_dataListViewGroup:self didSelectText:object];
        }
        return;
    }
    
    NSDictionary *object = [componentDatas objectAtIndex:indexPath.row];
    NSString *categoryValueKey =[self.dataGroupModel.categoryValueKeys objectAtIndex:component];
    NSArray *categoryValues = [object valueForKey:categoryValueKey];
    
    BOOL isHaveNext = [categoryValues count] > 0;
    if(isHaveNext){ //如果有下个操作，则更新后续的列表，,如果有没有，也要更新。防止之前的数据残留。
        [self updateTableViewsFromComponentIndex:component+1];
        
    }else{
        if (component+1 <= componentCount-1) {
            [self updateTableViewsFromComponentIndex:component+1];
        }
        
        NSString *category =[self.dataGroupModel.categoryKeys objectAtIndex:component];
        NSString *title = [object valueForKey:category];
        if([self.delegate respondsToSelector:@selector(cj_dataListViewGroup:didSelectText:)]){
            [self.delegate cj_dataListViewGroup:self didSelectText:title];
        }
    }
    */
    
    NSArray *componentModelDatas = self.dataGroupModel.componentModelDatasDatas[component];
    CJComponentModelData *componentModelData = [componentModelDatas objectAtIndex:indexPath.row];
    NSString *text = componentModelData.text;
    BOOL isHaveNext = componentModelData.containValueCount > 0 ? YES : NO;
    
    if(isHaveNext){ //如果有下个操作，则更新后续的列表，,如果有没有，也要更新。防止之前的数据残留。
        [self updateTableViewsFromComponentIndex:component+1];
        
    }else{
        if (component+1 <= componentCount-1) {
            [self updateTableViewsFromComponentIndex:component+1];
        }
        
        if([self.delegate respondsToSelector:@selector(cj_dataListViewGroup:didSelectText:)]){
            [self.delegate cj_dataListViewGroup:self didSelectText:text];
        }
    }
}


/**
 *  点击第component个列表中的row行，更新 selecteds_index 和 selecteds_titles。
 *
 *  @param row       列表点击的行
 *  @param component 第component个列表
 */
- (void)didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSMutableArray *selectedIndexs = [NSMutableArray arrayWithArray:self.dataGroupModel.selectedIndexs];
    [selectedIndexs replaceObjectAtIndex:component withObject:[NSString stringWithFormat:@"%zd", row]];
    for (NSInteger i = component+1; i < componentCount; i++) {
        [selectedIndexs replaceObjectAtIndex:i withObject:@"0"];//注意:点击当前列表之后，后续的其他列表的selectedIndexs改为0
    }
    [self.dataGroupModel updateSelectedIndexs:selectedIndexs];
}


/**
 *  更新从第component个开始的每个列表tableView
 *
 *  @param component component
 */
- (void)updateTableViewsFromComponentIndex:(NSInteger)componentIndexStart {
    for(NSInteger  component= componentIndexStart; component < componentCount; component++) {
        UITableView *tableView = (UITableView *)[self viewWithTag:kTableViewTagBegin+component];
        [tableView reloadData];
        
        NSString *selectedIndex = [self.dataGroupModel.selectedIndexs objectAtIndex:component];
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:[selectedIndex integerValue] inSection:0];
        [tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
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
