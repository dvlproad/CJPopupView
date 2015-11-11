//
//  TableViewsArrayDictionary.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 7/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrayDictonaryModel.h"


@class TableViewsArrayDictionary;
@protocol TableViewsArrayDictionaryDelegate <NSObject>

- (void)tv_ArrayDictionary:(TableViewsArrayDictionary *)tv_ArrayDictionary didSelectText:(NSString *)text;
@end


#define kAD_Title @"head"
#define kAD_Value @"value"
    
@interface TableViewsArrayDictionary : UIView<UITableViewDataSource, UITableViewDelegate>{
    NSInteger componentCount;
}
@property(nonatomic, strong) ArrayDictonaryModel *adModel;//含NSMutableArray *datas;和 NSArray *dicArray
@property(nonatomic, strong) id<TableViewsArrayDictionaryDelegate> delegate;


@end
