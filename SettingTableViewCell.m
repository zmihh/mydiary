//
//  SettingTableViewCell.m
//  MyDiary
//
//  Created by zhouhao on 15/5/18.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "Moodmanage.h"

@implementation SettingTableViewCell

- (void)loadImage {
    self.backgroundColor = [[Moodmanage shareInstance] getColorWithName:@"bgColor"];
    _nightMoodText.textColor = [[Moodmanage shareInstance] getColorWithName:@"default"];
    _otherText.textColor = [[Moodmanage shareInstance] getColorWithName:@"default"];
    
}

- (void)awakeFromNib {
    // Initialization code
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadImage) name:moodDidChangeNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)clickSwitch:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:moodDidChangeNotification object:nil];
}
@end
