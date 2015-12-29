//
//  DiaryListTableViewController.m
//  MyDiary
//
//  Created by zhouhao on 15-3-24.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "DiaryListTableViewController.h"
//#import "DiaryTableCell.h"
#import "diaryTableViewCell.h"
#import "Diary.h"
#import "DiaryStore.h"
#import "WriteDiaryViewController.h"
#import "editDiaryViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define cellSpacing 10

@interface DiaryListTableViewController ()<NSFetchedResultsControllerDelegate>{
    
    NSArray *_diary;
    NSMutableArray *_diaryCells;
    NSFetchedResultsController* _fetchedResultController;
//@property NSFetchedResultsController* serchedResultController;

//@property NSArray* dateArray;

//@property(nonatomic,strong)NSString* date;

}
@end

@implementation DiaryListTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.rowHeight = 44.0f;
    
    // UIBarButtonItem *writeDiaryItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeDiary)];
    UIBarButtonItem *writeDiaryItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"compose66.png"] style:UIBarButtonItemStylePlain target:self action:@selector(writeDiary)];
    
    [self.navigationItem setRightBarButtonItem:writeDiaryItem];
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xc73302);
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8];
    
    _fetchedResultController=[[DiaryStore defaultStack]createfetchedResultsController];
    [_fetchedResultController performFetch:nil];
    _diaryCells=[[NSMutableArray alloc]init];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _diary=[self getDiaryByDate];
    [self.tableView reloadData];
    self.parentViewController.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.parentViewController.tabBarController.tabBar.hidden = NO;
    
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    //return self.dateArray.count;
    
    return _fetchedResultController.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return _diary.count;
    //return ([sectionInfo numberOfObjects]);
    //return 1;
    
    // Return the number of rows in the section.
    
}



- (NSArray *)getDiaryByDate {
    
    DiaryStore *diaryStack = [DiaryStore defaultStack];
    NSFetchRequest *fetchRequest = _fetchedResultController.fetchRequest;
    fetchRequest.predicate=[NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)" ,_startofDate,_endofDate, nil];
    
    NSArray *array=[diaryStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
   
   
    
    return array;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* diaryIdentifier=@"DiaryTableCell";
   // DiaryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:diaryIdentifier];
    diaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:diaryIdentifier];
    if (cell==nil) {
        //NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"diaryCell" owner:self options:nil];
        //cell=[nib objectAtIndex:0];
         cell=[[diaryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:diaryIdentifier];
    }
    
   /* Diary *diary=[_dateArray objectAtIndex:indexPath.row];
    cell.diaryBodyLabel.text = diary.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm EEEE"];
    cell.timeLabel.text=[dateFormatter stringFromDate:diary.date];
    [cell.diaryBodyLabel sizeToFit];
    */
    Diary* diary=_diary[indexPath.row];
    
    cell.diary=diary;
    [ _diaryCells addObject:cell];
    

    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   /* editDiaryViewController* editDiaryController=[[editDiaryViewController alloc]init];
    Diary *diary=[_diary objectAtIndex:indexPath.row];
    editDiaryController.text=diary.text;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm EEEE"];
    editDiaryController.text=diary.text;
    editDiaryController.backImage=[UIImage imageNamed:diary.background];
    editDiaryController.date=[dateFormatter stringFromDate:diary.date];
    // [editDiaryController.dateLable sizeToFit];
    
    [self.navigationController pushViewController:editDiaryController animated:YES];*/
    
    editDiaryViewController* editDiaryController=[[editDiaryViewController alloc]init];
    Diary *diary=[_diary objectAtIndex:indexPath.row];
    editDiaryController.diary=diary;
    // NSLog(@"diary text %@",diary.text);
    editDiaryController.text=diary.text;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm EEEE"];
    editDiaryController.text=diary.text;
    editDiaryController.date=[dateFormatter stringFromDate:diary.date];
    editDiaryController.backImage=[UIImage imageNamed:diary.background];
    diaryTableViewCell* cell=_diaryCells[indexPath.row];
    editDiaryController.photo=cell.photo.image;
    editDiaryController.audioPath=diary.audioNote;
    editDiaryController.videoPath=diary.video;
    [self.navigationController pushViewController:editDiaryController animated:YES];
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Diary *diary= [_fetchedResultController objectAtIndexPath:indexPath];
    
    DiaryStore *coreDataStack = [DiaryStore defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:diary];
    [coreDataStack saveContext];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
    
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if(type==NSFetchedResultsChangeInsert){
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    if(type==NSFetchedResultsChangeDelete){
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    if(type==NSFetchedResultsChangeUpdate){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    if (type==NSFetchedResultsChangeInsert) {
        
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];}
    if (type== NSFetchedResultsChangeDelete) {
        
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)writeDiary{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    WriteDiaryViewController *newDiaryController = (WriteDiaryViewController*)[storyboard instantiateViewControllerWithIdentifier:@"writeViewController"];
    NSDate *now=[[NSDate alloc]init];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *temp=[dateFormatter stringFromDate:self.startofDate];
    NSDateComponents *compt =[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.startofDate];
    NSDateComponents *dateComponents=[calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:now];
    long int hour=[dateComponents hour];
    long int minute=[dateComponents minute];
    NSString *temp2=[NSString stringWithFormat:@" %ld:%ld",hour,minute];
    temp=[temp stringByAppendingString:temp2];
    [compt setHour:hour];
    [compt setMinute:minute];
    NSDate *date = [calendar dateFromComponents:compt];
    //得到本地时间，避免时区问题
    /*NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    
    NSLog(@"%@",localeDate);*/
    newDiaryController.date=temp;
    
    newDiaryController.nowDate=date;
    [self presentViewController:newDiaryController animated:YES completion:nil];
    // [self.navigationController pushViewController:newDiaryController animated:YES];
    
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *newView=[UIView new];
    [newView setBackgroundColor:[UIColor clearColor]];
    return newView;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 
 
 
 
 
 #pragma mark - Table view data source
 
 
 
 
 
 
 
 
 
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([segue.identifier isEqualToString:@"edit"]) {
 UITableViewCell *cell = sender;
 NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
 UINavigationController *navigationController = segue.destinationViewController;
 EntryViewController *entryViewController = (EntryViewController *)navigationController.topViewController;
 entryViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
 }
 }
 
 
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 DiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
 return [EntryCell heightForEntry:entry];
 }
 
 
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 
 
 
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 
 
 
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 
 
 
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 
 
 
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
