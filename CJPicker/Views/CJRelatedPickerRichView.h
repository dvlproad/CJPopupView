//
//  CJRelatedPickerRichView.h
//  CJRelatedPickerRichViewDemo
//
//  Created by lichq on 7/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJComponentDataModelUtil.h"

@class CJRelatedPickerRichView;
@protocol CJRelatedPickerRichViewDelegate <NSObject>

- (void)cj_groupTableView:(CJRelatedPickerRichView *)groupTableView didSelectText:(NSString *)text;

@end


/**
 *  用于例如地区"福建-厦门-思明"各部分的关联选择
 *
 */
@interface CJRelatedPickerRichView : UIView<UITableViewDataSource, UITableViewDelegate>{
    NSInteger componentCount;
}
@property(nonatomic, strong) NSMutableArray<CJComponentDataModel *> *componentDataModels;

@property(nonatomic, strong) id<CJRelatedPickerRichViewDelegate> delegate;

/**
 *  更新第component个列表的颜色
 *
 *  @param color     要更新成的颜色
 *  @param component 第component个列表
 */
- (void)updateTableViewBackgroundColor:(UIColor *)color inComponent:(NSInteger)component;

@end
