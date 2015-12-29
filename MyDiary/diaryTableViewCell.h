//
//  diaryTableViewCell.h
//  MyDiary
//
//  Created by zhouhao on 15/5/11.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"

@interface diaryTableViewCell : UITableViewCell

@property(nonatomic,strong) Diary* diary;
@property(assign,nonatomic) CGFloat height;
@property(nonatomic,strong) UIImage* image;
@property(nonatomic,strong) UIImageView* weather;
@property(nonatomic,strong) UIImageView* mood;
@property(nonatomic,strong) UIImageView* video;
@property(nonatomic,strong) UIImageView* audio;
@property(nonatomic,strong) UIImageView* photo;
/* UIImageView* _weather;
 UIImageView* _mood;
 UIImageView* _photo1;
 UIImageView* _video;
 UIImageView* _audio;
 UILabel *_year;
 UILabel *_month;
 UILabel * _day;
 UILabel *_week;
 UILabel *_time;
 UILabel *_text;
 NSArray *_weekArray;*/
@end
