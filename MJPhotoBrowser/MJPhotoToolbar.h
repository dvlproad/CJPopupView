//
//  MJPhotoToolbar.h
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef void (^MJPhotoToolbarCallback)(BOOL needRefresh) ;
typedef void (^MJSelectNumCallback)(int selectNum) ;
@interface MJPhotoToolbar : UIView
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;

// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, copy) MJPhotoToolbarCallback callback;
@property (nonatomic, assign) int maxCount;
@property (nonatomic, assign) int selectedNum;
@property (nonatomic, copy) MJSelectNumCallback selectNumCallBack;

@end

typedef void (^MJSentCallback)(BOOL sent) ;
@interface MJBottomToolbar : UIView
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) NSNumber *sendNum;
@property (nonatomic, strong) UILabel *number;
@property (nonatomic, strong) NSString *numStr;
@property (nonatomic, copy) MJSentCallback sentCallBack;

@end


typedef void (^MJPhotoDeleteToolbarCallback)(NSNumber *currentNum) ;
@interface MJDeleteToolbar : UIView
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, assign) int maxCount;
@property (nonatomic, assign) int selectedNum;
@property (nonatomic, copy) MJPhotoDeleteToolbarCallback callback;
@property (nonatomic, copy) void(^backAction)();
@end
