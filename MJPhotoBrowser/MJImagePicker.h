//
//  MJImagePicker.h
//   ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ImageItem : NSObject

@property (nonatomic, strong) NSString * fileId;  // 文件ID
@property (nonatomic, strong) NSString * filePath; // 图片路径
@property (nonatomic, strong) NSString * imgUrl; // 图片URL
@property (nonatomic, strong) UIImage * image;

@end

typedef void (^SCallback)(BOOL success);
typedef void (^RCallback)(BOOL success);

typedef void (^ImagePVCCallback) (NSArray * images);
@interface MJImagePicker : UIView

@property (nonatomic, strong, readonly) NSMutableArray * imageItems;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, copy) SCallback scallback;
@property (nonatomic, copy) RCallback rcallback;
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, copy) ImagePVCCallback pvcallback;
/**
 
 @param data @{@"title":@"标题", @"titleColor":[UIColor blackColor] @"limit":@1, @"seperator":@1, @"editable":@1}
 @param title 标题 可选
 @param titleColor 标题颜色
 @param limit 最大张数，默认1
 @param seperator 是否显示分割线 默认不显示
 @param editable 是否可编辑 默认可编辑
 
 **/
- (instancetype)initWithData:(NSDictionary *)data inView:(UIView *)superview controller:(UIViewController *)controller;

- (void)setDefaultImageItems:(NSArray *)imageItems;

- (CGFloat)viewHeight;

@end
