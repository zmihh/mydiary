//
//  weatherAndMoodViewController.h
//  MyDiary
//
//  Created by zhouhao on 15/4/27.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WriteDiaryViewController.h"

@protocol ViewPassValueDelegate<NSObject>

-(void)passValue:(NSString *)value1 moodValue:(NSString*)value2;

@end

@interface weatherAndMoodViewController : UIViewController
   
//@property(nonatomic,retain)id<UIViewPassValueDelegate> *delegate;
@property(weak,nonatomic)id<ViewPassValueDelegate> delegate;


@end
