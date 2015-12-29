//
//  AudioViewController.h
//  MyDiary
//
//  Created by zhouhao on 15-4-13.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary+CoreDataProperties.h"

@protocol audioPassDeleagte <NSObject>

-(void)viewPassAudio:(NSString*)audio;

@end

@interface AudioViewController : UIViewController

@property(strong) Diary* diary;
@property(nonatomic,weak) id <audioPassDeleagte> delegate;
//@property(nonatomic,strong)NSData* audioData;
@property(nonatomic,strong)NSString* audioData;
@end
