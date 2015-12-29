//
//  setUpViewController.m
//  MyDiary
//
//  Created by zhouhao on 15/5/18.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "setUpViewController.h"
#import "SettingTableViewCell.h"
#import "LoginViewController.h"
#import "UserInfoTableViewController.h"
#import <BmobSDK/BmobUser.h>


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface setUpViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView* _tableView;
    NSMutableArray *_dataArray;
    NSArray* _imageArray;
    UIButton *_button;
    int Tag;
}

@end

@implementation setUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xcc3706);
    self.navigationItem.title=@"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self uiInit];
    
}

- (void)uiInit {
    
    _dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++)
    {
        switch (i)
        {
            case 0:
                [_dataArray addObject:@[@"账号管理",@"同步管理",@"密码锁",@"通知提醒",@"itunes备份/恢复"]];
                
                break;
                
            case 1:
                [_dataArray addObject:@[@"关于", @"求五星好评",@"意见反馈"]];
                break;
            default:
                break;
        }
    }
    //double height=self.navigationController.navigationBar.frame.size.height;
    CGRect frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _tableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView setAllowsSelection:YES];
    [self.view addSubview:_tableView];
   
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*if ((indexPath.section==0 )&& (indexPath.row==5)) {
        
        NSString *cellID=@"Setting cell";
        SettingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID ];
        
        if (!cell)
        {
            cell=[[NSBundle mainBundle]loadNibNamed:@"setUpcell" owner:self options:nil][0];
        }
       
        cell.nightMoodText.text = _dataArray[indexPath.section][indexPath.row];
        
        
        if ([@"nt" isEqualToString:[ThemeManager shareInstance].themeName] && cell.settingSwitch.tag == 10)
         {
         cell.nightSwitch.on = YES;
         }
     
        return cell;
    }*/
    
    
    static NSString *cellid2 = @"other Cells";
    
    SettingTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellid2];
    
    if (!cell2){
        cell2 = [[NSBundle mainBundle] loadNibNamed:@"setUpcell" owner:self options:nil][1];
    }
   
    cell2.otherText.text = _dataArray[indexPath.section][indexPath.row];
    cell2.otherText.tag=Tag;
   
    NSLog(@"%ld and %ld %@ %d",indexPath.section,indexPath.row,cell2.otherText.text,Tag);
    Tag++;
    /* if (indexPath.row == 5)
     {
     cell2.selectionStyle = UITableViewCellSelectionStyleNone;
     }*/
    return cell2;
    
    
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld %ld,try",(long)indexPath.section,(long)indexPath.row);
   
    if (indexPath.section==0) {
        
        if (indexPath.row==0){
                NSLog(@"账号管理 %ld",(long)indexPath.row);
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
            BmobUser *user=[BmobUser getCurrentUser];
            if (user) {
               // UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"userinfo" bundle://[NSBundle mainBundle]];
               // UserInfoTableViewController *viewController = (UserInfoTableViewController*)[storyboard instantiateViewControllerWithIdentifier:@"userinfo"];
                UserInfoTableViewController *viewController=[[UserInfoTableViewController alloc]init];
                viewController.userName=user.username;
                 [self.navigationController pushViewController:viewController animated:YES];
                
            }
            else {
                 LoginViewController* viewController=[[LoginViewController alloc]init];
                 [self.navigationController pushViewController:viewController animated:YES];
            }
           
            
            
        }
        else if(indexPath.row==1){
                NSLog(@"同步管理");
            
        }
        else if(indexPath.row==2){
                NSLog(@"密码锁");
        }
        else if(indexPath.row==3){
                NSLog(@"通知提醒");
        }
        else if(indexPath.row==4){
                NSLog(@"备份");
            
        }
        
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0){
            NSLog(@"关于");
        }
        else if(indexPath.row==1){
            NSLog(@"好评");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
        }
        else if(indexPath.row==2){
            NSLog(@"意见反馈");
            
              
        }
    }
    
    /*SettingTableViewCell *myCell = (SettingTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
    switch (myCell.otherText.tag) {
        case 0:
        { NSLog(@"账号管理 %ld",(long)myCell.otherText.tag);
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
            LoginViewController* loginView=[[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginView animated:YES];
        }

            break;
            
        default:
            break;
    }*/
  
    
}

@end
