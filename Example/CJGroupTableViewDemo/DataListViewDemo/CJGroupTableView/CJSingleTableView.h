//
//  CJSingleTableView.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJSingleTableView;
@protocol CJSingleTableViewDelegate <NSObject>

- (void)cj_singleTableView:(CJSingleTableView *)singleTableView didSelectText:(NSString *)text;

@end




@interface CJSingleTableView : UIView {
    
}

@property(nonatomic, strong) NSArray *datas;
@property(nonatomic, strong) id<CJSingleTableViewDelegate> delegate;

@end
