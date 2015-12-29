//
//  SettingTableViewCell.h
//  MyDiary
//
//  Created by zhouhao on 15/5/18.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *nightMoodImage;
@property (weak, nonatomic) IBOutlet UILabel *nightMoodText;

@property (weak, nonatomic) IBOutlet UISwitch *nightSwitch;

@property (weak, nonatomic) IBOutlet UIImageView *otherImage;

@property (weak, nonatomic) IBOutlet UILabel *otherText;

@property(weak,nonatomic)IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *user;

- (IBAction)clickSwitch:(id)sender;

@end
