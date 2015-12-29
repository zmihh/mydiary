//
//  manageBackgroundView.h
//  MyDiary
//
//  Created by zhouhao on 15/4/22.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "backgroundView.h"

@protocol manageBackgroundViewDelegate <NSObject>

-(void)setBackground:(NSString*)backgroundName;

@end


@interface manageBackgroundView : UIView<UIScrollViewDelegate,backgroundViewDelegate>

@property(nonatomic,weak)id<manageBackgroundViewDelegate>delegate;

@end
