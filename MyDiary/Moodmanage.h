//
//  Moodmanage.h
//  MyDiary
//
//  Created by zhouhao on 15/5/18.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define moodDidChangeNotification @"moodDidchangeNotification"

@interface Moodmanage : NSObject
@property(nonatomic,retain) NSDictionary* colorConfig;

+(Moodmanage*)shareInstance;
-(UIColor*)getColorWithName:(NSString*)name;

//- (UIColor *)getColorWithName:(NSString *)name;
@end
