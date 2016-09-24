//
//  CJDataGroupModel.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJDataGroupModel : NSObject {

}
@property(nonatomic, strong) NSArray *categoryKeys;
@property(nonatomic, strong) NSArray *categoryValueKeys;

//datas根据component中选中的不同row随时在改变
@property(nonatomic, strong) NSMutableArray<NSArray *> *componentDatasDatas;/**< 所有component选中的componentDatas（datas中的每个componentDatas中的数据除最后一个componentDatas中是<NSString *>,其他的都是<NSDictionary *>） */

@property(nonatomic, strong) NSMutableArray *selectedIndexs;/**< 所有component选中的index */
@property(nonatomic, strong) NSMutableArray *selectedTitles;/**< 所有component选中的title */

/**
 *  初始化数据
 *
 *  @param component0Datas   数据
 *  @param categoryKeys      要取得分类所需的key
 *  @param categoryValueKeys 要取得该分类子值所需的key(eg:选择福建省，得到的值是福建省下的所有市)
 *
 *  @return 数据模型
 */
- (id)initWithComponent0Datas:(NSArray<NSDictionary *> *)component0Datas
           sortByCategoryKeys:(NSArray<NSString *> *)categoryKeys
            categoryValueKeys:(NSArray<NSString *> *)categoryValueKeys;


- (void)updateSelectedIndexs:(NSArray *)selectedIndexs;

@end
