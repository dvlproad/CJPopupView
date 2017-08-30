//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import "MJPhoto.h"
#import "MJPhotoToolbar.h"

@protocol MJPhotoBrowserDelegate;
typedef void (^DeleteCallback)(BOOL success);
typedef void (^PSentCallback)(BOOL success);
typedef void (^CurrentNumSentCallback)(NSNumber *currentNum);
@interface MJPhotoBrowser : UIViewController <UIScrollViewDelegate>
// 代理
@property (nonatomic, weak) id<MJPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property (nonatomic, copy) MJPhotoToolbarCallback callback;
@property (nonatomic, copy) void(^backAction)();
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger selectedNum;
@property (nonatomic,assign)  BOOL isDelete;
@property (nonatomic, copy) PSentCallback psentCallBack;
@property (nonatomic, copy) CurrentNumSentCallback currentNumCallback;

// 显示
- (void)show;
-(void)backACT;
-(void)deleteP:(NSInteger)index andPhotos:(NSArray *)photos;
@end

@protocol MJPhotoBrowserDelegate <NSObject>
@optional
// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
@end
