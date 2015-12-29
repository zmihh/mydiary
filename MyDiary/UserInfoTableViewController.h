//
//  UserInfoTableViewController.h
//  MyDiary
//
//  Created by zhouhao on 15/10/29.
//  Copyright © 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewController : UITableViewController

//@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *qqLoginButton;
@property(weak,nonatomic)IBOutlet UIButton *weiboButton;
@property(weak,nonatomic)IBOutlet UIButton* emailBUtton;

@property(strong,nonatomic)NSString *userName;

@end
