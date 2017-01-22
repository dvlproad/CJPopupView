//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>


@protocol MJPhotoBrowserDelegate;

@interface MJPhotoBrowser : UIViewController <UIScrollViewDelegate>
// 代理
@property (nonatomic, weak) id<MJPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSMutableArray * photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

// 显示
- (void)show;

-(void)showWithPhotos:(NSMutableArray *)photos currentIndex:(NSUInteger)currentIndex;
/*
- (void)btnImageOnClick {
    // 1.封装图片数据
    int count = 1;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        UIImage *imgCache = [_cellFrame getRealImageCache];
        if (!imgCache) {
            UIImageView *ivReal = [[UIImageView alloc] init];
            [ivReal setImageWithURL:[NSURL URLWithString:_cellFrame.message.url]
                   placeholderImage:[UIImage imageNamed:@"dcj_imgLoading_1"]];
            imgCache = ivReal.image;
        }
        
        photo.srcImageView = [[UIImageView alloc] initWithImage:imgCache]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    //把图片放大拉伸
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    return;
}*/
@end

@protocol MJPhotoBrowserDelegate <NSObject>

-(void)CellPhotoImageReload;

-(void)NewPostImageReload:(NSInteger)ImageIndex;

@optional
// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
@end