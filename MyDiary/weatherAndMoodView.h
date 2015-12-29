//
//  weatherAndMoodView.h
//  MyDiary
//
//  Created by zhouhao on 15/4/26.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol weatherAndMoodViewDelegate<NSObject>
@optional
-(void)didSelectWeather:(NSString*)weatherName;
-(void)didselectMood:(NSString*)moodName;

@end

@interface weatherAndMoodView : UIView


@property(nonatomic,weak)id<weatherAndMoodViewDelegate>delegate;
@property(nonatomic,strong)NSString *weatherName;
@property(nonatomic,strong)NSString *moodName;
@property(nonatomic,strong)UILabel *weatherLabel;
@property(nonatomic,strong)UILabel *moodLabel;


-(id)initWithFrame:(CGRect)frame;


@end
