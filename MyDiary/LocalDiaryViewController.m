//
//  LocalDiaryViewController.m
//  MyDiary
//
//  Created by zhouhao on 15-3-9.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "LocalDiaryViewController.h"
#import "WriteDiaryViewController.h"
#import "CKCalendarView.h"
#import"DiaryListTableViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LocalDiaryViewController ()

    @property(nonatomic,strong) CKCalendarView *calendar;

@end

@implementation LocalDiaryViewController


- (void)viewDidLoad {
     //[self.view removeFromSuperview];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGRect frame = CGRectMake(0, 80, size.width, 470);
    _calendar = [[CKCalendarView alloc] initWithStartDay:startSunday frame:frame];
    
    _calendar.delegate = self;

    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xc73302);
    self.tabBarController.tabBar.barTintColor=UIColorFromRGB(0xc73302);
    self.tabBarController.tabBar.tintColor=[UIColor whiteColor];
    
    //self.tabBarController.tabBar.barTintColor=UIColorFromRGB(0xc73302);
    [self.view addSubview:_calendar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
   
 /*  CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGRect frame = CGRectMake(0, 65, size.width, 500);
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startSunday frame:frame];
    
    calendar.delegate = self;
    
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xe3ad6f);
    self.tabBarController.tabBar.barTintColor=UIColorFromRGB(0xe3ad6f);
    
    
    [self.view addSubview:calendar];
    self.view.backgroundColor = [UIColor whiteColor];
     //[self.view removeFromSuperview];*/
   // [self.view setNeedsDisplayInRect:<#(CGRect)#>]
    [super viewWillAppear:animated];

    [_calendar layoutSubviews];
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    DiaryListTableViewController* tableView=[[DiaryListTableViewController alloc]init];
    //gather current calendar
    NSCalendar *newCalendar = [NSCalendar currentCalendar];
    
    //gather date components from date
    NSDateComponents *dateComponents=[newCalendar components:NSYearCalendarUnit |NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    //set date components
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate* startofDay=[newCalendar dateFromComponents:dateComponents];
    NSDateComponents *dateComponents_1=[newCalendar components:NSYearCalendarUnit |NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    //set date components
    [dateComponents_1 setHour:23];
    [dateComponents_1 setMinute:59];
    [dateComponents_1 setSecond:59];
     NSDate* endofDay=[newCalendar dateFromComponents:dateComponents_1];
    tableView.startofDate=startofDay;
    tableView.endofDate=endofDay;
   
    [self.navigationController pushViewController:tableView animated:YES];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDate* dateToday=[[NSDate alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    WriteDiaryViewController* view=segue.destinationViewController;
    view.date=[dateFormatter stringFromDate:dateToday];
    view.nowDate=dateToday;
    
    
}

@end
