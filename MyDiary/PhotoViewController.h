//
//  PhotoViewController.h
//  MyDiary
//
//  Created by zhouhao on 15-3-20.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary+CoreDataProperties.h"

@protocol viewPassValueDelagate <NSObject>

-(void)viewPassValue:(NSString*)photoPath;

@end

@interface PhotoViewController : UIViewController

//@property(strong)Diary* diary;
@property(nonatomic,strong)UIImage* photo;
@property(nonatomic,strong)NSString* photoPath;
@property(nonatomic,weak)id <viewPassValueDelagate> delegate;

@end
