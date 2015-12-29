//
//  DiaryTableCell.h
//  MyDiary
//
//  Created by zhouhao on 15-3-24.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *diaryBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(assign,nonatomic)CGFloat height;



@end
