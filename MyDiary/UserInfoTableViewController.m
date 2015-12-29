//
//  UserInfoTableViewController.m
//  MyDiary
//
//  Created by zhouhao on 15/10/29.
//  Copyright © 2015年 zhengmeng. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "SettingTableViewCell.h"
#import <BmobSDK/BmobUser.h>

@interface UserInfoTableViewController ()<UIAlertViewDelegate>{
    NSMutableArray *_dataArray;
   // UITableView* _tableView;
    int Tag;
}


@end

@implementation UserInfoTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xe3ad6f);
   // self.navigationItem.title=@"设置";
    //[self.navigationController.navigationBar setTitleTextAttributes:
     
    // @{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],
    
       //NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self uiInit];
    
}

- (void)uiInit {
    
    _dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++)
    {
        switch (i)
        {
            case 0:
                [_dataArray addObject:@[@"用户名:"]];
                
                break;
                
            case 1:
                [_dataArray addObject:@[@"myDiary账号", @"QQ账号",@"微博账号"]];
                break;
                
            case 2:
                [_dataArray addObject:@[@"退出登录"]];
                
            default:
                break;
        }
    }
    double height=self.navigationController.navigationBar.frame.size.height;
    CGRect frame=CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
   // _tableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView setAllowsSelection:YES];
    //[self.view addSubview:_tableView];
    
    
    
    
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
    static NSString* cellId;
    
    if(indexPath.section==0){
        cellId=@"userName Cell";
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"setUpcell" owner:self options:nil][2];
            cell.user.text = _dataArray[indexPath.section][indexPath.row];
            NSLog(@"cell.user %@",_dataArray[indexPath.section][indexPath.row]);

            NSLog(@"cell.user %@",cell.user.text);
            cell.userLabel.text=self.userName;

        }
        return cell;
        
    }
    else{
        
        cellId = @"other Cells";
        SettingTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell2){
            cell2 = [[NSBundle mainBundle] loadNibNamed:@"setUpcell" owner:self options:nil][1];
            cell2.otherText.text = _dataArray[indexPath.section][indexPath.row];
            cell2.otherText.tag=Tag;
        }
        return cell2;
    
    }
   // SettingTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellId];
    
   /* if (!cell2){
        cell2 = [[NSBundle mainBundle] loadNibNamed:@"setUpcell" owner:self options:nil][1];
    }
    if ([cellId isEqualToString:@"userName Cell"]) {
        cell2.userLabel.text=self.userName;
    }*/
   
    
  //  NSLog(@"%ld and %ld %@ %d",indexPath.section,indexPath.row,cell2.otherText.text,Tag);
   // Tag++;
    /* if (indexPath.row == 5)
     {
     cell2.selectionStyle = UITableViewCellSelectionStyleNone;
     }*/
   // return cell2;
    
    
   // return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld %ld,try",(long)indexPath.section,(long)indexPath.row);
    
    if (indexPath.section==0) {
        NSLog(@"用户名");
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0){
            NSLog(@"mydiary");
        }
        else if(indexPath.row==1){
            NSLog(@"qq");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
        }
        else if(indexPath.row==2){
            NSLog(@"微博账号");
            
            
        }
        
    }
    else if (indexPath.section==2){
        NSLog(@"退出登录");
        [self alertShow:@"确定退出登录"];
        //[BmobUser logout];
        
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
     }
    
    
}*/
}
- (void)alertShow:(NSString*)title {
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle=UIAlertActionStyleDefault;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [BmobUser logout];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
