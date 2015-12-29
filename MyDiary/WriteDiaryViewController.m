//
//  WriteDiaryViewController.m
//  MyDiary
//
//  Created by zhouhao on 15-3-8.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "WriteDiaryViewController.h"
#import "PhotoViewController.h"
#import "DiaryStore.h"
#import "manageBackgroundView.h"
#import "manageFontView.h"
#import "weatherAndMoodViewController.h"
#import "videoViewController.h"
#import "AudioViewController.h"
#import "BadgeStyle.h"
#import "CustomBadge.h"
#import <BmobSDK/BmobObject.h>
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobProFile.h>
#import <BmobSDK/BmobFile.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface WriteDiaryViewController ()<manageBackgroundViewDelegate,manageFontViewDelegate,UIAlertViewDelegate>{
    
    double animationDuration;
    CGRect keyboardRect;
    BOOL selected;
    BOOL fontSelected;
    BOOL buttonSelected;
    BOOL isSave;
}

@property(nonatomic,strong)UIButton* button1;

@end

@implementation WriteDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self shareBackgroundView];
    [self shareFontView];
  
}




- (void)initView {
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    CGSize size = rect.size;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, size.width, 66)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(doneWasPressed)];
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"]
                                                                style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [rightButton setTintColor:[UIColor whiteColor]];
    navigationItem.rightBarButtonItem=rightButton;
    navigationItem.leftBarButtonItem=leftButton;
    navigationBar.barTintColor=UIColorFromRGB(0xcc3706);
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    self.toolBar.barTintColor=UIColorFromRGB(0xc73302);
    self.toolBar.backgroundColor=[UIColor clearColor];
    //self.datelabel.text=self.date;
    //_weatherName=@"weather_1";
    //_moondName=@"mood_1";
    if (self.diary) {
        self.textField.text = self.diary.text;
        NSDateFormatter* dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.datelabel.text=[dateFormatter stringFromDate:self.diary.date];
        _moondName=self.diary.mood;
        _weatherName=self.diary.weather;
        self.view.layer.contents=(id)[UIImage imageNamed:self.diary.background].CGImage;
        // self.textField.layer.contents=(id)[UIImage imageNamed:backgroundName].CGImage;
        
        self.backgroundImage=[UIImage imageNamed:self.diary.background];
        //self.backName=backgroundName;
        
        if (self.diary.video) {
            self.videoUrl=self.diary.video;
            CustomBadge *bage=[CustomBadge customBadgeWithString:@"1"];
            [self.vidoButton addSubview: bage];
            [self.view sendSubviewToBack:self.vidoButton];

        }
        if (self.diary.audioNote) {
            self.audioUrls=self.diary.audioNote;
            CustomBadge *bage=[CustomBadge customBadgeWithString:@"1"];
            [self.audioButton addSubview: bage];
            [self.view sendSubviewToBack:self.audioButton];

        }
        if (self.diary.photo) {
            self.photoPath=self.diary.photo;
            CustomBadge *bage=[CustomBadge customBadgeWithString:@"1"];
            [self.photoButton addSubview: bage];
            [self.view sendSubviewToBack:self.photoButton];

        }
        
    }
    else {
        self.datelabel.text=self.date;
        _weatherName=@"weather_1";
        _moondName=@"mood_1";
        
    }
    isSave=NO;
    
   
    
}



- (void)shareBackgroundView {
    if (!self.backgroundView) {
        self.backgroundView=[[manageBackgroundView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 196)];
    }
    self.backgroundView.delegate=self;
    [self.view  addSubview:self.backgroundView];
}

- (void)shareFontView {
    if (!self.fontView) {
        self.fontView=[[manageFontView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 196)];
    }
    self.fontView.delegate=self;
    [self.view  addSubview:self.fontView];
}

// Called when the view controller is about to appear.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillChange:)
                                                name:UIKeyboardDidChangeFrameNotification
                                              object:nil];
    
    self.parentViewController.tabBarController.tabBar.hidden = YES;
    if (buttonSelected ){
        if ((!selected)&&(!fontSelected)) {
            [self.textField becomeFirstResponder];
        }
        buttonSelected=!buttonSelected;
    }
    
    
    
}

- (void)didReceiveMemoryWarning {;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([self.textField isFirstResponder]) {
        buttonSelected=YES;
    }
    if ([self.textField isFirstResponder]) {
        selected=NO;
        fontSelected=NO;
    }
    if([[segue identifier]isEqualToString:@"photoScene"]){
       
        PhotoViewController *viewController=[segue destinationViewController];
        viewController.delegate=self;
        //viewController.diary=self.diary;
        viewController.photoPath=self.photoPath;
        
    }
    
    if([[segue identifier]isEqualToString:@"videoScene"]){
        videoViewController *viewController=segue.destinationViewController;
        viewController.delegate=self;
        //viewController.diary=self.diary;
        if (self.videoUrl) {

        NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath_ = [searchPaths objectAtIndex: 0];
        NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:self.videoUrl];
        viewController.videoURL    =[NSURL fileURLWithPath:pathToSave];
         //   viewController.videoURL=pathToSave;
        //viewController.videoURL=[NSURL URLWithString:pathToSave];
        
        }
        
     
    }
    if([[segue identifier]isEqualToString:@"audioScene"]){
        AudioViewController *viewController=segue.destinationViewController;
        viewController.delegate=self;
        //viewController.diary=self.diary;
        
        viewController.audioData=self.audioUrls;
    }
    
}
/*
 #pragma mark - Navigation
 */

// Called when the keyboard is about to appear.
- (void) keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardFrame=[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    [self updateTextWithBottomHeight:CGRectGetHeight(keyboardFrame)];
    animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
}


// Called when the keyboard is about to disappear.
- (void) keyboardWillHide:(NSNotification*)notification {
    
    animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
    
}


//Called when the keyboard is about to change.
- (void)keyboardWillChange:(NSNotification*)notification {
    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y<CGRectGetHeight(self.view.frame)) {
        [self messageViewAnimationWithMessageRect:[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                         withMessageInputViewRect:self.toolBar.frame
                                      andDuration:0.25
                                         andState:MessageViewStateShowNone];
       
    }
    
    
}

- (void)messageViewAnimationWithMessageRect:(CGRect)rect  withMessageInputViewRect:(CGRect)inputViewRect andDuration:(double)duration andState:(MessageViewState)state{
    
    [UIView animateWithDuration:duration animations:^{
        
        [self updateTextWithBottomHeight:CGRectGetHeight(rect)];
        
        switch (state) {
            case MessageViewStateShowBackground:
                
            {
                
                self.backgroundView.frame= CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect),CGRectGetWidth(self.view.frame),CGRectGetHeight(rect));
                
                
                self.fontView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.fontView.frame));
                
            }
                break;
            case MessageViewStateShowNone:
            {
                self.backgroundView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.backgroundView.frame));
                
                self.fontView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.fontView.frame));
                //[self updateTextWithBottomHeight:0];
                
                
            }
                break;
            case MessageViewStateShowShare:
            {
                self.fontView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect),CGRectGetWidth(self.view.frame),CGRectGetHeight(rect));
                
                self.backgroundView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.backgroundView.frame));
            }
                break;
                
            default:
                break;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}



- (IBAction)backgroundPressed:(id)sender {
    if ([self.textField isFirstResponder]) {
        selected=NO;
        fontSelected=NO;
    }
    selected=!selected;
    fontSelected=NO;
    if (selected) {
        [self.textField resignFirstResponder];
        [self messageViewAnimationWithMessageRect:self.backgroundView.frame
                         withMessageInputViewRect:self.toolBar.frame
                                      andDuration:0.25
                                         andState:MessageViewStateShowBackground];
        
        
    }
    else
    {
        
        
        [self.textField becomeFirstResponder];
    }
    
    
    
}

- (IBAction)fontPressed:(id)sender {
    
    //selected=!selected;
    if ([self.textField isFirstResponder]) {
        selected=NO;
        fontSelected=NO;
    }
    fontSelected=!fontSelected;
    selected=NO;
    if (fontSelected) {
        [self messageViewAnimationWithMessageRect:self.fontView.frame
                         withMessageInputViewRect:self.toolBar.frame
                                      andDuration:0.25
                                         andState:MessageViewStateShowShare];
        [self.textField resignFirstResponder];
    }
    else{

        [self.textField becomeFirstResponder];
    }
}

// Called when the user taps on the text view.
- (IBAction)textViewTapped:(id)sender {
    
    // If the text view is currently the first responder (i.e. owns the keyboard),
    // make it resign the keyboard.
    
    /*if ([self.textField isFirstResponder])
     [self.textField resignFirstResponder];
     
     // Otherwise, make it _become_ the first responder.
     else
     [self.textField becomeFirstResponder];*/
}


- (void) updateTextWithBottomHeight:(float)height {
    
    [self.view layoutIfNeeded];
    // Animate the constraint to update
    [UIView animateWithDuration:0.25 animations:^{self.bottomConstraint.constant=height;[self.view layoutIfNeeded];}];
    [UIView animateWithDuration:0.25 animations:^{self.bottomTextConstraints.constant=height+self.toolBar.bounds.size.height;[self.view layoutIfNeeded];}];
    
    
}

/*-(IBAction)backDiary:(UIStoryboardSegue *)segue{
 [self dismissViewControllerAnimated:YES completion:NULL];
 }*/



- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneWasPressed {
    
    
    if(self.diary){
         
        [self updateDiary];
        
    } else {
        UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:nil message:@"日记已保存" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
        [self insertDiary];
    
        
    }
    [self dismissSelf];
    
}

- (IBAction)weatherPressed:(id)sender {
    
    weatherAndMoodViewController *wmController=[[weatherAndMoodViewController alloc]init];
    [wmController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    if ([self.textField isFirstResponder]) {
        buttonSelected=YES;
    }
    if ([self.textField isFirstResponder]) {
        selected=NO;
        fontSelected=NO;
    }
    
    wmController.delegate=self;
    [self presentViewController:wmController animated:YES completion:nil];
    
}

- (IBAction)moodPressed:(id)sender {
    weatherAndMoodViewController *wmController=[[weatherAndMoodViewController alloc]init];
    wmController.delegate=self;
    //[self.view presentViewController:wmController animated:YES completion:nil];
    [wmController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    if ([self.textField isFirstResponder]) {
        buttonSelected=YES;
    }
    if ([self.textField isFirstResponder]) {
        selected=NO;
        fontSelected=NO;
    }
    
    
    [self presentViewController:wmController animated:YES completion:nil];
    
    
}


- (void)backPressed {
    if (!isSave) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"您还没有保存，确定要返回吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
        
    }
    /*else{
    [self dismissSelf];
    }*/
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self dismissSelf];
    }
    
    
}
- (void)insertDiary {
    //新日记，存储在本地
    
    DiaryStore *diaryStore = [DiaryStore defaultStack];
    Diary *diary=[NSEntityDescription insertNewObjectForEntityForName:@"Diary" inManagedObjectContext:diaryStore.managedObjectContext];
    diary.text = self.textField.text;
    diary.date=self.nowDate;
    diary.photo=self.photoPath;
    diary.video=self.videoUrl;
    diary.audioNote=self.audioUrls;
    //NSData* moodImageData = UIImageJPEGRepresentation(_moodButton.currentBackgroundImage, 1);
    diary.mood = _moondName;
    diary.weather=_weatherName;
    diary.background=_backName;
    //diary.font=(float)self.textField.font.pointSize;
    [diaryStore saveContext];
    isSave=YES;
    
    //新日记
    //如果用户已经登录，wifi同步开启，自动存储在Bmob
    BmobUser* user=[BmobUser getCurrentUser];
    if (user) {
        NSLog(@"tongbu");
        BmobObject* myDiary=[BmobObject objectWithClassName:@"diary"];
        [myDiary setObject:self.textField.text forKey:@"diaryContent"];
        [myDiary setObject:diary.date forKey:@"date"];
        [myDiary setObject:user forKey:@"user"];
        // NSDictionary *dic1=[NSDictionary alloc]initWithObjectsAndKeys:<#(nonnull id), ...#>, nil
        [myDiary saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                //创建成功后会返回objectId，updatedAt，createdAt等信息
                //打印objectId
                NSLog(@"objectid :%@",myDiary.objectId);
            } else if (error){
                //发生错误后的动作
                NSLog(@"%@",error);
            } else {
                NSLog(@"Unknow error");
            }
        }
         ];
/*
        NSString* path1=diary.photo;
        NSString* path2=diary.video;
        NSString* path3=diary.audioNote;
        NSString* path4=diary.mood;
        NSString* path5=diary.weather;
        NSString* path6=diary.background;*/
        NSMutableArray* mularray;
        /*if (diary.photo) {
            [mularray addObject:diary.photo];
            NSLog(@"%@",diary.photo);
        }
        if (diary.video) {
            [mularray addObject:diary.video];
        }*/
        /*if (path3) {
            [mularray addObject:path3];
        }
        if (path4) {
            [mularray addObject:path4];
        }
        if (path5) {
            [mularray addObject:path5];
        }
        if (path6) {
            [mularray addObject:path6];
        }*/
        
       // NSArray* array=@[diary.photo,diary.mood,diary.weather];
      /* [BmobProFile uploadFilesWithPaths:array resultBlock:^(NSArray *filenameArray, NSArray *urlArray, NSArray *bmobFileArray, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            }
            else {
                NSLog(@"pathArray %@ urlArray %@",filenameArray,urlArray);
                for (BmobFile* bmobFile in bmobFileArray ) {
                    NSLog(@"%@",bmobFile);
                }
            }
            
        } progress:^(NSUInteger index, CGFloat progress) {
            NSLog(@"index %lu progress %f",(unsigned long)index,progress);
        }];*/
        
        
        /*[BmobProFile uploadFilesWithPaths:array resultBlock:^(NSArray *pathArray, NSArray *urlArray,NSArray *bmobFileArray,NSError *error) {
            //路径数组和url数组（url数组里面的元素为NSString）
            if (error) {
                NSLog(@"%@",error);
            } else {
                //路径数组和url数组（url数组里面的元素为NSString）
                NSLog(@"pathArray %@ urlArray %@",pathArray,urlArray);
                for (BmobFile* bmobFile in bmobFileArray ) {
                    NSLog(@"%@",bmobFile);
                }
            }
        } progress:^(NSUInteger index, CGFloat progress) {
            //index表示正在上传的文件其路径在数组当中的索引，progress表示该文件的上传进度
            NSLog(@"index %lu progress %f",(unsigned long)index,progress);
        }];*/
        /*BmobFile *file1 = [[BmobFile alloc] initWithFilePath:diary.photo];
        [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
            //如果文件保存成功，则把文件添加到filetype列
            if (isSuccessful) {
                //[obj setObject:file1  forKey:@"filetype"];
                //[obj saveInBackground];
                //打印file文件的url地址
                NSLog(@"file1 url %@",file1.url);
            }else{
                //进行处理
            }
        }];*/
        
        [BmobProFile uploadFileWithPath:diary.photo block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
            if (isSuccessful) {
                //上传成功后返回文件名及url
                NSLog(@"filename:%@",filename);
                NSLog(@"url:%@",url);
                NSLog(@"bmobFile:%@\n",bmobFile);
            } else{
                if(error){
                    NSLog(@"error%@",error);
                }
            }
        } progress:^(CGFloat progress) {
            //上传进度，此处可编写进度条逻辑
            NSLog(@"progress %f",progress);
        }];
        
        [BmobProFile uploadFileWithPath:diary.video block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
            if (isSuccessful) {
                //上传成功后返回文件名及url
                NSLog(@"filename:%@",filename);
                NSLog(@"url:%@",url);
                NSLog(@"bmobFile:%@\n",bmobFile);
            } else{
                if(error){
                    NSLog(@"error%@",error);
                }
            }
        } progress:^(CGFloat progress) {
            //上传进度，此处可编写进度条逻辑
            NSLog(@"progress %f",progress);
        }];
        
        

    }
    
   
    
    
    
}

- (void)updateDiary {
    self.diary.text = self.textField.text;
    self.diary.photo=self.photoPath;
    self.diary.video=self.videoUrl;
    self.diary.audioNote=self.audioUrls;
    DiaryStore *diaryStore=[DiaryStore defaultStack];
    [diaryStore saveContext];
    isSave=YES;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: YES];
    self.parentViewController.tabBarController.tabBar.hidden = NO;
    [self.textField resignFirstResponder];
    
}


#pragma mark - manageBackgroundViewDelegate
- (void)setBackground:(NSString *)backgroundName {
    
    // [self.textField becomeFirstResponder];
    self.view.layer.contents=(id)[UIImage imageNamed:backgroundName].CGImage;
   // self.textField.layer.contents=(id)[UIImage imageNamed:backgroundName].CGImage;
    
    self.backgroundImage=[UIImage imageNamed:backgroundName];
    self.backName=backgroundName;
    
}

#pragma mark - manageBackFontViewDelegate

- (void)setFontSize:(NSString *)fontSize {
    NSString* tempSize=fontSize;
    CGFloat fontSize_1=self.textField.font.pointSize;
    
    if ([tempSize isEqualToString:@"fontSize_1@2x.png"]) {
        self.textField.font=[UIFont systemFontOfSize:fontSize_1+1];
    }
    else
    {
        self.textField.font=[UIFont systemFontOfSize:fontSize_1-1];
        
    }
}

- (void)setFontColor:(UIColor *)color {
    self.textField.textColor=color;
    self.datelabel.textColor=color;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [textView becomeFirstResponder];
    
    // if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
    //[self.delegate inputTextViewDidBeginEditing:self.messageInputTextView];
    //}
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
}

- (void)passValue:(NSString*)value1 moodValue:(NSString *)value2 {
    NSLog(@"%@",value1);
    [_weatherButton setBackgroundImage:[UIImage imageNamed:value1] forState:UIControlStateNormal];
    [_moodButton setBackgroundImage:[UIImage imageNamed:value2] forState:UIControlStateNormal];
    _weatherName=value1;
    _moondName=value2;
    
    
}

- (void)viewPassValue:(NSString*)photoPath {
    self.photoPath=photoPath;
    if (self.photoPath) {
    
    CustomBadge *bage=[CustomBadge customBadgeWithString:@"1"];
    [self.photoButton addSubview: bage];
    [self.view sendSubviewToBack:self.photoButton];
        
    }
    
    
}
- (void)videoPassValue:(NSString*) videoUrl {
    self.videoUrl=videoUrl;
    if (self.videoUrl) {
    CustomBadge *bage=[CustomBadge customBadgeWithString:@"1"];
    [self.vidoButton addSubview: bage];
    [self.view sendSubviewToBack:self.vidoButton];
    }

    
}

- (void)viewPassAudio:(NSString *)audio {
    
    self.audioUrls=audio;
    if (self.audioUrls) {
        CustomBadge *bage=[CustomBadge customBadgeWithString:@"1"];
        [self.audioButton addSubview: bage];
        [self.view sendSubviewToBack:self.vidoButton];

    }
}


@end
