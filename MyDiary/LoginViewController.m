//
//  LoginViewController.m
//  MyDiary
//
//  Created by zhouhao on 15/7/10.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "LoginViewController.h"
#import "registViewController.h"
#import "FindPassWordViewController.h"
#import <BmobSDK/Bmob.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LoginViewController()

@property(nonatomic,strong)UITextField *account;
@property(nonatomic,strong)UITextField *pwd;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *navFinish=[[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick)];
    navFinish.tintColor=[UIColor whiteColor];
    //self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=navFinish;
    self.navigationItem.leftBarButtonItem.title=@"";
    [self.navigationItem setTitle:@"账号管理"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self registView];
}

-(void)viewWillAppear:(BOOL)animated{
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)registView {
    CGFloat padx=95.0f;
    CGRect rect=[[UIScreen mainScreen]bounds];
    CGSize size=rect.size;
    CGRect RegisterFrame=CGRectMake(10, 88,size.width-20, 80);
    UIFont *font=[UIFont boldSystemFontOfSize:16];
    //邮箱和密码背景颜色设置
    UIView* view1=[[UIView alloc]initWithFrame:RegisterFrame];
    view1.layer.cornerRadius=8.0f;
    view1.layer.borderWidth=1.0f;
    view1.layer.borderColor=[UIColor colorWithRed:209.0f/255.0f green:209.0f/255.0f blue:209.0f/255.0f alpha:1.0f].CGColor;
    [view1 setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];
    [self.view addSubview:view1];
    //邮箱与密码中间分界线
    CGFloat lineWidth=view1.frame.size.width;
    CGFloat lineY=view1.frame.size.height/2;
    UIView *lineOne=[[UIView alloc]initWithFrame:CGRectMake(0, lineY, lineWidth, 1)];
    [lineOne setBackgroundColor:[UIColor colorWithRed:209.0f/255.0f green:209.0f/255.0f blue:209.0f/255.0f alpha:1.0f]];
    [view1 addSubview:lineOne];
    //
    UILabel *emailLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 280, 20)];
    [emailLabel setText:@"登录邮箱"];
    emailLabel.highlighted=YES;
    [emailLabel setHighlightedTextColor:[UIColor blackColor]];
    [emailLabel setFont:font];
    [emailLabel setBackgroundColor:[UIColor clearColor]];
    [emailLabel setTextColor:[UIColor blackColor]];
    [view1 addSubview:emailLabel];
    
    _account=[[UITextField alloc]initWithFrame:CGRectMake(padx, 10, 200, 20)] ;
    [_account setBackgroundColor:[UIColor clearColor]];
    [_account setKeyboardType:UIKeyboardTypeEmailAddress];
    [_account setTextColor:[UIColor grayColor]];
    [_account setTag:101];
    [_account setReturnKeyType:UIReturnKeyNext];
    [_account setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_account setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_account setFont:[UIFont systemFontOfSize:17]];
    [_account setPlaceholder:@"登录邮箱"];
    // [_account setText:@""];
    [_account setHighlighted:YES];
    [view1 addSubview:_account];
    
    
    //密码
    UILabel *pwdLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 53, 45, 20)];
    [pwdLabel setText:@"密码"];
    pwdLabel.highlighted=YES;
    [pwdLabel setHighlightedTextColor:[UIColor blackColor]];
    [pwdLabel setFont:font];
    [pwdLabel setBackgroundColor:[UIColor clearColor]];
    [pwdLabel setTextColor:[UIColor blackColor]];
    [view1 addSubview:pwdLabel];
    
    _pwd=[[UITextField alloc]initWithFrame:CGRectMake(padx, 53, 200, 20)] ;
    [_pwd setBackgroundColor:[UIColor clearColor]];
    [_pwd setKeyboardType:UIKeyboardTypeDefault];
    [_pwd setTextColor:[UIColor grayColor]];
    [_pwd setTag:102];
    [_pwd setReturnKeyType:UIReturnKeyDone];
    [_pwd setSecureTextEntry:YES];
    [_pwd setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_pwd setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_pwd setFont:font];
    [_pwd setPlaceholder:@"输入密码"];
    //[_pwd setText:@""];
    [_pwd setHighlighted:YES];
    [view1 addSubview:_pwd];
    
    // UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(40, 200, size.width-80, 50)];
    //登录
    UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    //loginButton.backgroundColor=[UIColor redColor];
    loginButton.backgroundColor=UIColorFromRGB(0xcc3706);
//    /UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
   // [loginButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
   // loginButton.tileLabel.textColor=[UIColor whiteColor];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setFrame:CGRectMake(padx, 180, size.width-180, 30)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    //[loginButton setBackgroundColor:[UIColor grayColor] ];
    //loginButton.titleLabel.text=@"登录";
    [loginButton addTarget:self
                    action:@selector(loginClick)
          forControlEvents:UIControlEventTouchUpInside];
    [loginButton.layer setMasksToBounds:YES];
    loginButton.layer.borderColor=[UIColor colorWithRed:209.0f/255.0f green:209.0f/255.0f blue:209.0f/255.0f alpha:1.0f].CGColor;
    [loginButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    [loginButton.layer setBorderWidth:1.0];   //边框宽度
    [self.view addSubview:loginButton];
    //忘记密码
    UIButton* forgetPwd=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [forgetPwd setFrame:CGRectMake(size.width-80, 200, 60, 20)];
    [forgetPwd setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPwd.titleLabel.font=[UIFont boldSystemFontOfSize:10];
    [forgetPwd addTarget:self action:@selector(forgetPwdClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwd];
    //分割线虚线
    
    //qq 微博登录按钮
    UIButton* qqLogin=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [qqLogin setFrame:CGRectMake(40, 300, 80, 30)];
    [qqLogin setTitle:@"qq登录" forState:UIControlStateNormal];
    [qqLogin addTarget:self action:@selector(qqLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqLogin];
    
    UIButton* weiboLogin=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [weiboLogin setFrame:CGRectMake(size.width-120, 300, 80, 30)];
    [weiboLogin setTitle:@"微博登录" forState:UIControlStateNormal];
    [weiboLogin addTarget:self action:@selector(weiboLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboLogin];
    
    
}

- (void)loginClick {
    if ((_account.text.length!=0)&&(_pwd.text.length!=0) ) {
        
        /* if(![self NSStringIsValidEmail:_account.text]){
         // NSString *title=@"InValid email";
         UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"invalid email" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
         alertView.alertViewStyle=UIAlertActionStyleDefault;
         [alertView show];
         }*/
        
        //判断账户是否存在
        id userName=[NSString stringWithFormat:@"%@",self.account.text];
        BmobQuery* query=[BmobQuery queryForUser];
        [query whereKey:@"username" equalTo:userName];
        __weak typeof(BmobQuery *)weakQuery = query;//?????
        [weakQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if(array.count==1){
                [BmobUser loginWithUsernameInBackground:self.account.text password:self.pwd.text block:^(BmobUser *user, NSError *error) {
                    if(!error){
                        NSLog(@"登录成功");
                        [[NSUserDefaults standardUserDefaults]setObject:self.account.text forKey:@"loginUserName"];
                        [[NSUserDefaults standardUserDefaults]setObject:self.pwd.text forKey:@"loginPassword"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                    }
                    else {
                        NSString* title=@"账号密码不匹配，登录失败";
                        [self alertShow:title];
                    }
                    
                    
                }];
            }
            else if(array.count==0){
                NSString* title=@"该用户未注册";
                [self alertShow:title];
                
            }
        }];
    }
    
    
    else {
        
        NSString *title=@"账户密码不能为空";
        [self alertShow:title];
    }
    
}

- (void)alertShow:(NSString*)title {
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:title delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    alertView.alertViewStyle=UIAlertActionStyleDefault;
    [alertView show];
    
}

- (void)forgetPwdClick {
    FindPassWordViewController *pwd=[[FindPassWordViewController alloc]init];
    [self.navigationController pushViewController:pwd animated:YES];
    
    
}

- (void)qqLoginClick {
    
}

- (void)weiboLoginClick {
    
}

- (void)buttonClick {
    registViewController *registView=[[registViewController alloc]init];
    [self.navigationController pushViewController:registView animated:YES];
}

-(BOOL) NSStringIsValidEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}


@end
