//
//  backgroundView.h
//  MyDiary
//
//  Created by zhouhao on 15/4/21.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol backgroundViewDelegate<NSObject>
@optional
-(void)didSelectBackground:(NSString*)imageName;

@end
@interface backgroundView : UIView

@property(nonatomic,weak)id<backgroundViewDelegate>delegate;
@property(nonatomic,strong)NSString *imageName;

-(id)initWithFrame:(CGRect)frame forIndexPath:(NSInteger)index;

@end
