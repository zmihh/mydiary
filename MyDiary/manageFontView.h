//
//  manageFontView.h
//  MyDiary
//
//  Created by zhouhao on 15/4/24.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fontView.h"

@protocol manageFontViewDelegate <NSObject>
-(void)setFontSize:(NSString*)fontSize;
-(void)setFontColor:(UIColor*)color;
@end

@interface manageFontView : UIView<UIScrollViewDelegate,fontViewDelegate>

@property(nonatomic,weak)id<manageFontViewDelegate>delegate;

@end


