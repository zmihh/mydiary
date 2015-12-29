//
//  editDiaryViewController.h
//  MyDiary
//
//  Created by zhouhao on 15-4-1.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary+CoreDataProperties.h"

@interface editDiaryViewController : UIViewController

@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) UIImage *backImage;
@property(nonatomic,strong) UIImage* photo;
//@property(nonatomic,strong) UIImageView* audioView;
//@property(nonatomic,strong) UIImageView* videoView;
@property(nonatomic,strong) NSString* audioPath;
@property(nonatomic,strong) NSString* videoPath;
@property(nonatomic,strong) Diary* diary;


@end
