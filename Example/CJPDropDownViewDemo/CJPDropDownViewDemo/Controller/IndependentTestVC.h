//
//  IndependentTestVC.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RadioButtons/RadioButtonsCanDrop.h>
#import "TableViewsArrayDictionary.h"
#import "TableViewArraySingle.h"

@interface IndependentTestVC : UIViewController<RadioButtonsCanDropDelegate, TableViewsArrayDictionaryDelegate, TableViewArraySingleDelegate>{
    RadioButtonsCanDrop *commonRadioButtons111;
    RadioButtonsCanDrop *commonRadioButtons222;
}

@end
