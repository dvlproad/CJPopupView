//
//  TPKeyboardAvoidingScrollView.h
//
//  Created by Michael Tyson on 11/04/2011.
//  Copyright 2011 A Tasty Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKeyboardAvoidingScrollView;
@protocol TPKeyboardAvoidingScrollViewDelegate

- (void)delegateMethord;

@end




@interface TPKeyboardAvoidingScrollView : UIScrollView<UIScrollViewDelegate> {
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
    
}

@property(nonatomic, assign) id <TPKeyboardAvoidingScrollViewDelegate> MyDelegate;

- (void)adjustOffsetToIdealIfNeeded;
@end
