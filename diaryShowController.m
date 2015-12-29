//
//  diaryShowController.m
//  MyDiary
//
//  Created by zhouhao on 15/5/11.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "diaryShowController.h"
#import "Diary.h"
#import "DiaryStore.h"
#import "diaryTableViewCell.h"
#import "editDiaryViewController.h"
#define cellSpacing 10

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *cellIdentifier=@"UItableViewCellIdentifierKey1";

@interface diaryShowController()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tabelView;
    NSFetchedResultsController*  _fetchedResultController;
    NSArray *_diary;
    NSMutableArray *_diaryCells;
    
}

@property (nonatomic, strong) diaryTableViewCell *prototypeCell;

@end

@implementation diaryShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self initData];
    double height=self.navigationController.navigationBar.frame.size.height+5;
    _tabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, height, self.view.bounds.size.width, self.view.bounds.size.height-height) style:UITableViewStyleGrouped];
    _tabelView.dataSource=self;
    _tabelView.delegate=self;
    //_tabelView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.01f)];
    _diaryCells=[[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xc73302);
    self.navigationItem.title=@"我的日记";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.view addSubview:_tabelView];
    
     [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    //[super viewWillAppear:animated];
    [_tabelView reloadData];
}

- (void)initData {
    DiaryStore *diaryStack = [DiaryStore defaultStack];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Diary"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    _diary=[diaryStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    
    [_tabelView reloadData];
    //return _diary;
    
}

#pragma mark-数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return _diary.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _diary.count;
    //return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // static NSString *cellIdentifier=@"UItableViewCellIdentifierKey1";
    diaryTableViewCell* cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[diaryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    Diary* diary=_diary[indexPath.row];
    
    cell.diary=diary;
   // NSLog(@"diary photo is %@",diary.photo);
    //if (diary.photo) {
        //NSLog(@"there are image");
       // UIImage* photoImage=[UIImage imageWithContentsOfFile:diary.photo];
        //NSData* data=[NSData dataWithContentsOfFile:diary.photo];
        //UIImage* photoImage=[UIImage imageWithData:data];
       /* NSURL *url = [NSURL URLWithString:diary.photo];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *photoImage = [[UIImage alloc] initWithData:data];*/
        //NSString* imageName = [[NSBundle mainBundle] pathForResource:diary.photo];
        //NSImage* imageObj = [[NSImage alloc] initWithContentsOfFile:imageName];
       /* NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:diary.photo]){
            NSLog(@"file is not exist");
        }
        else{
            NSURL *url = [NSURL URLWithString:diary.photo];
            NSLog(@"%@",[url path]);
             NSData *data = [NSData dataWithContentsOfURL:url];
             UIImage *photoImage = [[UIImage alloc] initWithData:data];
             cell.image=photoImage;
        //}*/
       /* NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        libraryDirectory = [libraryDirectory stringByAppendingPathComponent:diary.photo];
        NSData* data=[NSData dataWithContentsOfFile:libraryDirectory];
        cell.image=[UIImage imageWithData:data];*/
       /* NSURL *url=[NSURL URLWithString:diary.photo];
        NSData *data=[NSData dataWithContentsOfURL:url];
        UIImage *photoImage=[UIImage imageWithData:data];
        cell.image=photoImage;*/
       
    //}
    
    //_photo1.image=[UIImage imageWithContentsOfFile:diary.photo];
    [ _diaryCells addObject:cell];
    //NSURL *url = [NSURL URLWithString:diary.photo];
   // NSLog(@"%@",[url path]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    editDiaryViewController* editDiaryController=[[editDiaryViewController alloc]init];
    Diary *diary=[_diary objectAtIndex:indexPath.row];
    editDiaryController.diary=diary;
   // NSLog(@"diary text %@",diary.text);
    //editDiaryController.text=diary.text;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm EEEE"];
    editDiaryController.text=diary.text;
    editDiaryController.date=[dateFormatter stringFromDate:diary.date];
    editDiaryController.backImage=[UIImage imageNamed:diary.background];
    diaryTableViewCell* cell=_diaryCells[indexPath.row];
    editDiaryController.photo=cell.photo.image;
    editDiaryController.audioPath=diary.audioNote;
    editDiaryController.videoPath=diary.video;
    
    // [editDiaryController.dateLable sizeToFit];
    
    [self.navigationController pushViewController:editDiaryController animated:YES];
    
    
    
}


#pragma mark 重新设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    diaryTableViewCell* cell=_diaryCells[indexPath.row];
    cell.diary=_diary[indexPath.row];
    
    
    return cell.height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark 重写状态样式方法
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark 设置头部高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return cellSpacing;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *newView=[UIView new];
    [newView setBackgroundColor:[UIColor clearColor]];
    return newView;
}

@end
