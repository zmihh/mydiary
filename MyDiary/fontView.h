//
//  fontView.h
//  MyDiary
//
//  Created by zhouhao on 15/4/21.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol fontViewDelegate<NSObject>
@optional
-(void)didSelectFontSize:(NSString*)fontSize;
-(void)didselectFontColor:(UIColor*)fontColor;


@end

@interface fontView : UIView

@property(nonatomic,weak)id<fontViewDelegate>delegate;
@property(nonatomic,strong)NSString *fontSize;
@property(nonatomic,strong)NSArray *colorOfText;

-(id)initWithFrame:(CGRect)frame forIndexPath:(NSInteger)index;



@end
 