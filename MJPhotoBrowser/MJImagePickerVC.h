//
//  MJImagePickerVC.h
//  ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
#import "HCModel.h"

@interface MJImageItem : HCModel

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, assign) int type;

@end


@interface MJImagePickerVC : UIViewController

@property (nonatomic, assign) NSInteger canMaxChooseImageCount;     /**< 可一次性选取的最大数目 */
@property (nonatomic, copy) void (^pickCompleteBlock)(NSArray * images);    /**< 照片选取完毕后 */

@end
