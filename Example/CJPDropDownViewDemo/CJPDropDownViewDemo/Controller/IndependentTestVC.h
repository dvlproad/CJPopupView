//
//  IndependentTestVC.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RadioButtons.h"
#import "TableViewsArrayDictionary.h"
#import "TableViewArraySingle.h"

@interface IndependentTestVC : UIViewController<RadioButtonsDelegate, TableViewsArrayDictionaryDelegate, TableViewArraySingleDelegate>{
    RadioButtons *commonRadioButtons111;
    RadioButtons *commonRadioButtons222;
}

@end
