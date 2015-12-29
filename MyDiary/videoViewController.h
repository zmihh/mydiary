//
//  videoViewController.h
//  MyDiary
//
//  Created by zhouhao on 15-4-17.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary+CoreDataProperties.h"
#import "DiaryStore.h"

@protocol videoPassValueDelegate <NSObject>

-(void)videoPassValue:(NSString *)videoUrl;

@end

@interface videoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property(weak,nonatomic)id<videoPassValueDelegate> delegate;
@property(strong) Diary* diary;
@property(strong,nonatomic)NSString * videoPath;
@property(strong,nonatomic)NSURL* videoURL;
//@property(strong,nonatomic)NSString* videoURL;
@property(strong,nonatomic)NSString* videoFilePath;

@end
