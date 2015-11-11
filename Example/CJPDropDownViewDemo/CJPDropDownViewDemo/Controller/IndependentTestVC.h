//
//  IndependentTestVC.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RadioButtons/RadioButtons_DropDown.h>
#import "TableViewsArrayDictionary.h"
#import "TableViewArraySingle.h"

@interface IndependentTestVC : UIViewController<RadioButtonsDelegate, TableViewsArrayDictionaryDelegate, TableViewArraySingleDelegate>{
    RadioButtons_DropDown *commonRadioButtons111;
    RadioButtons_DropDown *commonRadioButtons222;
}

@end
