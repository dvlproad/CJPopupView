//
//  ImagePickerViewController.h
//  CJPickerDemo
//
//  Created by 李超前 on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJUploadImageCollectionView.h"

//TODO：选择图片后，是否立即上传，还是等候上传？
@interface ImagePickerViewController : UIViewController {
    
}
@property (nonatomic, strong) IBOutlet CJUploadImageCollectionView *uploadImageCollectionView;


@end
