//
//  registViewController.m
//  MyDiary
//
//  Created by zhouhao on 15/7/13.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "registViewController.h"
#import <BmobSDK/Bmob.h>

@interface registViewController()

@property(nonatomic,strong)UITextField *account;
@property(nonatomic,strong)UITextField *pwd;

@end

@implementation registViewController

- (void)viewDidLoad {
    //UIBarButtonItem *navFinish=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick)];
   // self.navigationItem.rightBarButtonItem=navFinish;
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"注册"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self registView];
}

- (void)registView {
    CGFloat padx=95.0f;
    CGRect rect=[[UIScreen mainScreen]bounds];
    CGSize size=rect.size;
    CGRect RegisterFrame=CGRectMake(10, 88, size.width-20, 100);
    UIFont *font=[UIFont boldSystemFontOfSize:16];
    //账户和密码背景颜色设置
    UIView* view1=[[UIView alloc]initWithFrame:RegisterFrame];
    view1.layer.cornerRadius=8.0f;
    view1.layer.borderWidth=1.0f;
    view1.layer.borderColor=[UIColor colorWithRed:209.0f/255.0f green:209.0f/255.0f blue:209.0f/255.0f alpha:1.0f].CGColor;
    [view1 setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];
    [self.view addSubview:view1];
    //账户与密码中间分界线
    CGFloat lineWidth=view1.frame.size.width;
    CGFloat lineY=view1.frame.size.height/2;
    UIView *lineOne=[[UIView alloc]initWithFrame:CGRectMake(0, lineY, lineWidth, 1)];
    [lineOne setBackgroundColor:[UIColor colorWithRed:209.0f/255.0f green:209.0f/255.0f blue:209.0f/255.0f alpha:1.0f]];
    [view1 addSubview:lineOne];
    //账号
    UILabel *accountLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 40, 30)];
    [accountLabel setText:@"账号"];
    accountLabel.highlighted=YES;
    [accountLabel setHighlightedTextColor:[UIColor blackColor]];
    [accountLabel setFont:font];
    [accountLabel setBackgroundColor:[UIColor clearColor]];
    [accountLabel setTextColor:[UIColor blackColor]];
    [view1 addSubview:accountLabel];
    
    _account=[[UITextField alloc]initWithFrame:CGRectMake(60, 10, 200, 30)] ;
    [_account setBackgroundColor:[UIColor clearColor]];
    [_account setKeyboardType:UIKeyboardTypeEmailAddress];
    [_account setTextColor:[UIColor grayColor]];
    [_account setTag:101];
    [_account setReturnKeyType:UIReturnKeyNext];
    [_account setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_account setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_account setFont:[UIFont systemFontOfSize:17]];
    [_account setPlaceholder:@"电子邮箱地址"];
    // [_email setText:@""];
    [_account setHighlighted:YES];
    [view1 addSubview:_account];
    //账号注册提醒
    //CGFloat registFram2_Y=view1.frame.size.height+view1.frame.origin.y+5;
    /*UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(10, textFieldY, size.width-20, 20)];
    textField.text=@"6-20个字符";
    textField.textColor=[UIColor lightGrayColor];
    [self.view addSubview:textField];*/
    //密码
    //CGRect RegisterFrame_2=CGRectMake(10, registFram2_Y, size.width-20, 50);
   /* UIView* view1=[[UIView alloc]initWithFrame:RegisterFrame_2];
    view2.layer.cornerRadius=8.0f;
    view2.layer.borderWidth=1.0f;
    view2.layer.borderColor=[UIColor colorWithRed:209.0f/255.0f green:209.0f/255.0f blue:209.0f/255.0f alpha:1.0f].CGColor;
    [view2 setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];
    [self.view addSubview:view2];*/

    UILabel *pwdLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 45, 30)];
    [pwdLabel setText:@"密码"];
    pwdLabel.highlighted=YES;
    [pwdLabel setHighlightedTextColor:[UIColor blackColor]];
    [pwdLabel setFont:font];
    [pwdLabel setBackgroundColor:[UIColor clearColor]];
    [pwdLabel setTextColor:[UIColor blackColor]];
    [view1 addSubview:pwdLabel];
    
    _pwd=[[UITextField alloc]initWithFrame:CGRectMake(padx, 60, 200, 30)] ;
    [_pwd setBackgroundColor:[UIColor clearColor]];
    [_pwd setKeyboardType:UIKeyboardTypeDefault];
    [_pwd setTextColor:[UIColor grayColor]];
    [_pwd setTag:102];
    [_pwd setReturnKeyType:UIReturnKeyDone];
    [_pwd setSecureTextEntry:YES];
    [_pwd setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_pwd setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_pwd setPlaceholder:@"不少于8位"];
    [_pwd setFont:font];
    //[_pwd setText:@""];
    [_pwd setHighlighted:YES];
    [view1 addSubview:_pwd];
    // UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(40, 200, size.width-80, 50)];
    UIButton *registButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registButton setFrame:CGRectMake(40, 200, size.width-80, 30)];
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    //[loginButton setBackgroundColor:[UIColor grayColor] ];
    //loginButton.titleLabel.text=@"登录";
    [registButton addTarget:self
                    action:@selector(buttonClick)
          forControlEvents:UIControlEventTouchUpInside];
    [registButton.layer setMasksToBounds:YES];
    registButton.layer.borderColor=[UIColor colorWithRed:209.0f/255.0f green:209.0f/255.0f blue:209.0f/255.0f alpha:1.0f].CGColor;
    [registButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    [registButton.layer setBorderWidth:1.0];   //边框宽度
    [self.view addSubview:registButton];

    
}

- (void)buttonClick {
    //if ((_account.text.length!=0)&&(_pwd.text.length>=8) ) {
        
       /* if(![self NSStringIsValidEmail:_email.text]){
            // NSString *title=@"InValid email";
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"invalid email" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            alertView.alertViewStyle=UIAlertActionStyleDefault;
            [alertView show];
        }*/
    
    
    if (_account.text.length!=0 && _pwd.text.length>=8) {
            // NSDictionary* default=[[NSUserDefaults standardUserDefaults]dictionaryRepresentation];
            //NSLog(@"%@",default);
            /*NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults] ;
            NSString* userName=self.email.text;
            NSString* passWord=self.pwd.text;
            [defaults setObject:userName forKey:@"username"];
            [defaults setObject:passWord forKey:@"passward"];
            NSLog(@"save");*/
        if(![self NSStringIsValidEmail:_account.text]){
            NSString *title=@"InValid email";
            [self alertShow:title];
        }
        else{

            NSString* userName=self.account.text;
            NSString* passWord=self.pwd.text;
           
            BmobUser *bUser=[[BmobUser alloc]init];
            bUser.username=userName;
            bUser.password=passWord;
            [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"sign up successfully");
                }
                else{
                    NSLog(@"error");
                }
            }];
            [self.navigationController popViewControllerAnimated:YES];
            // NSLog(@"Defaults: %@", defaults);
         }
        
        }
    if((!_account.text.length||!_pwd.text.length)){
        NSString* title=@"输入不能为空";
        [self alertShow:title];
    }
    
    if (_pwd.text.length<8){
        NSString* title=@"密码长度不少于8位";
        [self alertShow:title];
    }


}

- (void)alertShow:(NSString*)title {
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:title delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    alertView.alertViewStyle=UIAlertActionStyleDefault;
    [alertView show];

}
- (BOOL) NSStringIsValidEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}


@end


