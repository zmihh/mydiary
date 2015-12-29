//
//  FindPassWordViewController.m
//  MyDiary
//
//  Created by zhouhao on 15/10/21.
//  Copyright © 2015年 zhengmeng. All rights reserved.
//

#import "FindPassWordViewController.h"

@interface FindPassWordViewController ()

@end

@implementation FindPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"找回密码"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //CGFloat padx=95.0f;
    CGRect rect=[[UIScreen mainScreen]bounds];
    CGSize size=rect.size;
    CGRect RegisterFrame=CGRectMake(20, 88,size.width-40, 40);
   // UIFont *font=[UIFont boldSystemFontOfSize:16];
    UIView* view1=[[UIView alloc]initWithFrame:RegisterFrame];
    view1.layer.cornerRadius=8.0f;
    view1.layer.borderWidth=1.0f;
    view1.layer.borderColor=[UIColor colorWithRed:209.0f/255.0f green:209.0f/255.0f blue:209.0f/255.0f alpha:1.0f].CGColor;
    [view1 setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];
    [self.view addSubview:view1];
    UITextField *email=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, RegisterFrame.size.width-20, 20)];
    [email setReturnKeyType:UIReturnKeyDone];
    [email setPlaceholder:@"注册的邮箱地址"];
    
    [view1 addSubview:email];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
