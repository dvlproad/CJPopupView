//
//  IndependentTestVC.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RadioButtons/RadioButtonsCanDrop.h>
#import "CJDataListViewSingle.h"
#import "CJDataListViewGroup.h"

@interface IndependentTestVC : UIViewController<RadioButtonsCanDropDelegate, CJDataListViewSingleDelegate, CJDataListViewGroupDelegate>{
    RadioButtonsCanDrop *commonRadioButtons111;
    RadioButtonsCanDrop *commonRadioButtons222;
}
@property (nonatomic, strong) IBOutlet RadioButton *radioButton;

@end
