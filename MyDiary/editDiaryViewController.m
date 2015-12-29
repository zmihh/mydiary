//
//  editDiaryViewController.m
//  MyDiary
//
//  Created by zhouhao on 15-4-1.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "editDiaryViewController.h"
#import "Diary.h"
#import "Diary+CoreDataProperties.h"
#import "DiaryStore.h"
#import "WriteDiaryViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define textFontSize 14
#define tabelCellWeatherLabelWidth 10
#define tableCellMoodLabelWidth 10
#define tabelCellWeatherLabelHeight 10
#define tableCellMoodLabelHeight   10
#define tabelCellMidiaLableWidth 64
#define tabelCellMidiaLableHeight  tabelCellMidiaLableWidth
#define  cellSpacing 10

@interface editDiaryViewController ()<UIActionSheetDelegate,UITextViewDelegate,UIAlertViewDelegate,NSFetchedResultsControllerDelegate>

@property NSFetchedResultsController* fetchedResultController;
@property(nonatomic,weak) UILabel* dateLable;
@property(nonatomic,strong) UITextView *diaryText;

@end

@implementation editDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.fetchedResultController=[[DiaryStore defaultStack]createfetchedResultsController];
    [self.fetchedResultController performFetch:nil];

    
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    //set moreItem to do more action
    UIBarButtonItem *moreItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    
    //set navigation bar
    self.navigationItem.rightBarButtonItem=moreItem;
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xc73302);
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    //set backGroundView
    self.backImage=[UIImage imageNamed:self.diary.background];
    UIImage *image=self.backImage;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,size.width,size.height)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    
    //set TimeLabel
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 70, 250, 20)];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm EEEE"];
    self.date=[dateFormatter stringFromDate:self.diary.date];
    NSLog(@"self.date%@",self.date);
    label.text=self.date;
    self.dateLable=label;
    [imageView addSubview:self.dateLable];
    label.font=[UIFont systemFontOfSize:10];
    
    //CGFloat weatherX=moodX+cellSpacing+tableCellMoodLabelWidth;
    CGFloat weatherX=label.frame.origin.x+label.frame.size.width+cellSpacing;
    // CGFloat weatherY=moodY;
    CGFloat weatherY=label.frame.origin.y;
    CGRect  weatherRect=CGRectMake(weatherX, weatherY, tabelCellWeatherLabelWidth, tabelCellWeatherLabelHeight);
    // NSString *plistStr_1=[[NSBundle mainBundle]pathForResource:@"weather" ofType:@"plist"];
    //NSDictionary *plistDic_1=[[NSDictionary alloc]initWithContentsOfFile:plistStr_1];
    // NSLog(@"DIAIR WEATHER%@",diary.weather);
    //UIImage* image_1=[plistDic_1 objectForKey:diary.weather];
    UIImageView* weather=[[UIImageView alloc]initWithFrame:weatherRect];
    UIImage* image_1=[UIImage imageNamed:self.diary.weather];
    weather.image=image_1;
    [self.view addSubview:weather];
   
    //set TextView
    //UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 90, size.width-20, size.height)];
    CGFloat textX=10;
    //CGFloat textY=dayY+cellSpacing+tabelCellWeatherLabelHeight;
    CGFloat textY=90;
    CGFloat textMediaSpace;
    CGRect textRect;
    if (self.text.length!=0) {
        CGFloat textWidth=self.view.bounds.size.width-20;
        CGSize  textSize=[self.diary.text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFontSize]} context:nil].size;
        
        textRect=CGRectMake(textX, textY, textSize.width, textSize.height+2*cellSpacing);
        textMediaSpace=2*cellSpacing;
    }
    else{
        textRect=CGRectZero;
        textMediaSpace=0;
    }
    //self.diaryText=textview;
    self.diaryText=[[UITextView alloc]initWithFrame:textRect];
    self.diaryText.text=self.text;
    self.diaryText.delegate=self;
    self.diaryText.textAlignment=NSTextAlignmentLeft;
    self.diaryText.editable=NO;
    self.diaryText.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.diaryText];
    //设置照片位置大小
    CGFloat photoX=textX;
    NSLog(@"self.diaryText.frame.size.height %f",self.diaryText.frame.size.height);
    CGFloat photoY=textY+self.diaryText.frame.size.height+textMediaSpace;
    CGFloat photoVideoSpace;
    CGRect  photoRect;
    if (self.photo) {
       
        photoRect=CGRectMake(photoX, photoY, tabelCellMidiaLableWidth, tabelCellMidiaLableHeight);
        /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        libraryDirectory = [libraryDirectory stringByAppendingPathComponent:self.diary.photo];*/
        UIImageView* photoImage=[[UIImageView alloc]initWithFrame:photoRect];
        //self.photo.image=[UIImage imageWithContentsOfFile:libraryDirectory];
        photoImage.contentMode=UIViewContentModeScaleAspectFill;
        
        // _photo1.center = CGPointMake(tabelCellMidiaLableWidth/2, tabelCellMidiaLableHeight/2);
        // _photo1.contentMode = UIViewContentModeScaleAspectFit;
        photoImage.image=self.photo;
        photoImage.layer.masksToBounds=YES;
        photoImage.layer.cornerRadius=10.0f;
        photoVideoSpace=cellSpacing;
        [self.view addSubview:photoImage];
    }
    else{
        //NSLog(@"ajd");
        photoRect=CGRectZero;
        photoVideoSpace=0;
        UIImageView* photoImage=[[UIImageView alloc]initWithFrame:photoRect];
        [self.view addSubview:photoImage];
        //_photo1.frame=photoRect;
        
    }
    // 设置auido 图片
    // 设置video 图片
    CGFloat videoX=photoX+photoRect.size.width+photoVideoSpace;
    CGFloat videoY=photoY;
    CGFloat videoAudioSpace;
    UIImageView* videoImage;
    CGRect videoRect;
    if (self.videoPath) {
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString *videoPath = [documentsDirectory stringByAppendingPathComponent:self.videoPath];
        NSURL *url=[NSURL fileURLWithPath:videoPath];
        //NSLog(@"%@self.videoPath@",self.videoPath);
       // NSLog(@"url %@",url);
        videoRect=CGRectMake(videoX, videoY, tabelCellMidiaLableWidth, tabelCellMidiaLableHeight);
        videoImage=[[UIImageView alloc]initWithFrame:videoRect];
        videoImage.image=[self findtumbImage:url];
        videoAudioSpace=cellSpacing;
    }
    else {
        videoRect=CGRectZero;
        videoImage=[[UIImageView alloc]initWithFrame:videoRect];
        videoAudioSpace=0;
        
    }
    videoImage.layer.masksToBounds=YES;
    videoImage.layer.cornerRadius=10.0f;
    [self.view addSubview:videoImage];

    CGFloat audioX=videoX+videoRect.size.width+videoAudioSpace;
    CGFloat audioY=photoY;
    UIImageView* audioImage;
    CGRect audioRect;
    if (self.audioPath) {
        //NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //NSString *documentPath_ = [searchPaths objectAtIndex: 0];
       // NSUUID *uuid=[[NSUUID alloc]init];
        //NSString *audioName=[[uuid UUIDString]stringByAppendingString:@".wav"];
        //NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:self.audioPath];
        audioRect=CGRectMake(audioX, audioY, tabelCellMidiaLableWidth, tabelCellMidiaLableHeight);
        audioImage=[[UIImageView alloc]initWithFrame:audioRect];
        audioImage.image=[UIImage imageNamed:@"audioNOTE"];
     


        
    }
    else{
        audioRect=CGRectZero;
        audioImage=[[UIImageView alloc]initWithFrame:audioRect];
        
    }
    audioImage.layer.masksToBounds=YES;
    audioImage.layer.cornerRadius=10.0f;
    [self.view addSubview:audioImage];
    
    
    UIButton *Radiobutton=[[UIButton alloc]initWithFrame:CGRectMake(10,30,20,20)];
    [imageView addSubview:Radiobutton];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
 
    //[self.dateLable sizeToFit];
    [super viewWillAppear:animated];
   // self.diaryText.text=self.text;
    //[self.view addSubview:self.diaryText];
    
   // [self.view insertSubview:self.dateLable aboveSubview:self.diaryText];
   
    self.parentViewController.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.parentViewController.tabBarController.tabBar.hidden = NO;
   // [self.parentViewController controllerWillChangeContent:_fetchedResultController];
    
}

- (void)moreAction {
   
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"更多功能"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"分享日记"];
    [actionSheet addButtonWithTitle:@"编辑日记"];
    [actionSheet addButtonWithTitle:@"删除日记"];
    actionSheet.destructiveButtonIndex=actionSheet.numberOfButtons-1;
    actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void)alertViewShow {
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除该日记吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)deleteDiary {
    DiaryStore *diaryStack=[DiaryStore defaultStack];
    NSManagedObjectContext* context=diaryStack.managedObjectContext;
    
    [context deleteObject:[self getDiaryByText][0]];
    [diaryStack saveContext];
   /* NSError *error = nil;
    [context save:&error];
    
    if (error) {
        [NSException raise:@"删除错误" format:@"%@", [error localizedDescription]];
    }*/
}

/*alertView and actionSheet delegate部分委托实现*/
/******************************************************************/
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self deleteDiary];
        //[self dismissViewControllerAnimated:YES completion:nil];
       // [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }


}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==2) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        WriteDiaryViewController *editWrittenDiaryControl = (WriteDiaryViewController*)[storyboard instantiateViewControllerWithIdentifier:@"writeViewController"];
        NSArray* array=[self getDiaryByText];
        editWrittenDiaryControl.diary=array[0];
        
        [editWrittenDiaryControl setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:editWrittenDiaryControl animated:YES completion:nil];

        
        
    }
    if (buttonIndex==3) {
        [self alertViewShow];
    }
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}

//以下是UITextViewDelegate 的部分委托实现
//*******************************************************************************
#pragma mark -------------------
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    // return NO to disallow editing.
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    // became first responder
    // 在这里监听UITextView becomeFirstResponder事件
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    // 在这里监听UITextView resignFirstResponder事件
}
- (void)textViewDidChangeSelection:(UITextView *)_textView {
    
}

//*******************************************************************************
#pragma mark -------------------
#pragma mark textViewButton 的响应函数
/*- (void)onTextViewButtonClicked:(UIButton*)button{
    [textView resignFirstResponder];
    [textField resignFirstResponder];
    textView.text = @"";
}*/



- (NSArray *)getDiaryByText {
 
    DiaryStore *diaryStack = [DiaryStore defaultStack];
    NSFetchRequest *fetchRequest = _fetchedResultController.fetchRequest;
    fetchRequest.predicate=[NSPredicate predicateWithFormat:@"text=%@",self.text];
    
    NSArray *array=[diaryStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return array;
}

-(UIImage*)findtumbImage:(NSURL*)url{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    // AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    // asset.AVURLAssetReferenceRestrictionsKey= AVAssetReferenceRestrictionForbidNone;
    CMTime time = CMTimeMakeWithSeconds(0.0,10);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (error) {        NSLog(@"截取视频图片失败:%@",error);    }    CMTimeShow(actualTime);
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    //self.videoImage.image=thumb;
    return thumb;
    
    
}

@end
