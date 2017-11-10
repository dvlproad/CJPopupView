//
//  RelatedPickerViewController.h
//  CJRelatedPickerRichViewDemo
//
//  Created by ciyouzen on 9/7/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJRelatedPickerRichView.h"
#import "GroupDataUtil.h"

@interface RelatedPickerViewController : UIViewController<CJRelatedPickerRichViewDelegate> {
    
}
@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *relatedPickerView1;
@property (nonatomic, weak) IBOutlet UILabel *textLabel1;

@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *relatedPickerView2;
@property (nonatomic, weak) IBOutlet UILabel *textLabel2;

@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *relatedPickerView3;
@property (nonatomic, weak) IBOutlet UILabel *textLabel3;

@end
