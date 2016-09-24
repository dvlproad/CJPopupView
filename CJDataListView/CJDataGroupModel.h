//
//  CJDataGroupModel.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJComponentModelData.h"

@interface CJDataGroupModel : NSObject {

}
@property(nonatomic, strong) NSMutableArray<NSArray *> *componentModelDatasDatas;/**< 所有component选中的modleDatas（datas中的每个componentModelDatas中的数据除都是<NSString *>） */

@property(nonatomic, strong) NSMutableArray<NSString *> *selectedIndexs;/**< 所有component选中的index */
@property(nonatomic, strong) NSMutableArray<NSString *> *selectedTitles;/**< 所有component选中的title */

/**
 *  初始化数据
 *
 *  @param selectedIndexs    当前选中的indexs
 *  @param component0Datas   数据
 *  @param categoryKeys      要取得分类所需的key
 *  @param categoryValueKeys 要取得该分类子值所需的key(eg:选择福建省，得到的值是福建省下的所有市)
 *
 *  @return 数据模型
 */
- (id)initWithSelectedIndexs:(NSArray *)selectedIndexs
           InComponent0Datas:(NSArray<NSDictionary *>*)component0Datas
          sortByCategoryKeys:(NSArray<NSString *> *)categoryKeys
           categoryValueKeys:(NSArray<NSString *> *)categoryValueKeys;


- (void)updateSelectedIndexs:(NSArray *)selectedIndexs;

@end
