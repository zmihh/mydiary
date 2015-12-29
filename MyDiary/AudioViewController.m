//
//  AudioViewController.m
//  MyDiary
//
//  Created by zhouhao on 15-4-13.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "AudioViewController.h"
#import "WriteDiaryViewController.h"
#import <AVFoundation/AVFoundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AudioViewController ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIAlertViewDelegate>{
    BOOL recodingAllowed;
    BOOL isSave;
    NSString* audioPath;
}

@property (weak, nonatomic) IBOutlet UIButton *ControlButton;
@property (weak, nonatomic) IBOutlet UIButton *ControlButton2;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *reRecordButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(strong)AVAudioPlayer* audioPlayer;
@property(strong)AVAudioRecorder* audioRecorde;

- (IBAction)clickReRecordButton:(id)sender;

- (IBAction)clickSaveButton:(id)sender;



@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Set the catagory of Audio. It can both playing and recording.
    UINavigationBar* navigationBar=[self setNavigation];
    [self.view addSubview:navigationBar];
    self.timeLabel.text=@"点击按钮开始录音";
    
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    //if the user admit microphone or not
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        if (granted) {
            recodingAllowed=YES;
        }
        else{
            recodingAllowed=NO;
        }
        
    }];
    
    if (recodingAllowed) {
        self.ControlButton.enabled=YES;
       
    }
    else {
        self.ControlButton.enabled=NO;
      
    }
    
   if (self.audioData) {
        self.ControlButton2.enabled=YES;
        isSave=YES;
    
    }
    else {
        self.ControlButton2.enabled=NO;
        isSave=NO;
      
    }
    // Finally, update the control button to indicate what the user can do.
   // [self updateControlButton];
    self.saveButton.hidden=YES;
    self.reRecordButton.hidden=YES;
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UINavigationBar*)setNavigation {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, size.width, 55)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    
    navigationItem.leftBarButtonItem=leftButton;
    [leftButton setTintColor:[UIColor whiteColor]];
    navigationBar.barTintColor=UIColorFromRGB(0xc73302);
    [navigationBar pushNavigationItem:navigationItem animated:YES];
    
    return navigationBar;
}

- (IBAction)clickButton:(id)sender {
   
    if (self.audioRecorde.isRecording) {
      
        [self stopRecording];
        NSLog(@"hhhh");
        [self.ControlButton setImage:[UIImage imageNamed:@"RecordButton"] forState:UIControlStateNormal];
        
        
    }
    else{
        NSLog(@"hhhhh");
        [self startRecording];
        [self.ControlButton setImage:[UIImage imageNamed:@"StopButton"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)clickButton2:(id)sender {
    if (self.audioPlayer.isPlaying) {
        [self stopPlaying];
        [self.ControlButton2 setImage:[UIImage imageNamed:@"pauseButton"] forState:UIControlStateNormal];
    }
    else{
        [self startPlaying];
        [self.ControlButton2 setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
    }
}


- (NSDictionary*) getAudioSetting {
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    //设置录音格式
    [dic setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率
    [dic setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dic setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dic setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    return dic;
}


/*-(NSURL*)getSavePath{
    NSString *urlStr=[[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"audio"];
     NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:urlStr])
        [[NSFileManager defaultManager] createDirectoryAtPath:urlStr withIntermediateDirectories:NO attributes:nil error:&error];
    NSUUID *uuid=[[NSUUID alloc]init];
    NSString *audio=[uuid UUIDString];
    NSString *fileStr = [urlStr stringByAppendingFormat:@"/%@.wav",audio];
    NSLog(@"file path:%@",fileStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
    
}*/



- (void)startRecording {
    //create temperary to store data
   //NSString* temporaryDirectory=NSTemporaryDirectory();
   //NSURL* url=[[NSURL fileURLWithPath:temporaryDirectory]URLByAppendingPathComponent:@"Recording"];
    
    NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
    NSUUID *uuid=[[NSUUID alloc]init];
    NSString *audioName=[[uuid UUIDString]stringByAppendingString:@".wav"];
    NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:audioName];
    audioPath=pathToSave;
    
    // File URL
    NSURL *url = [NSURL fileURLWithPath:pathToSave];//FILEPATH];
   // NSString* urla=[url absoluteString];
    NSLog(@"%@ 路径",pathToSave);

      //  NSURL *url=[self getSavePath];
        NSDictionary *setting=[self getAudioSetting];
        self.audioRecorde=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:nil];
        _audioRecorde.delegate=self;
        NSString *error=nil;
        if (error) {
            NSLog(@"Error Starting recording %@",error);
        }

    [self.audioRecorde record];
    self.ControlButton2.enabled=NO;
  
}


- (void)stopRecording {
    
    [self.audioRecorde stop];
   // NSData* audio=[NSData dataWithContentsOfURL:self.audioRecorde.url];
   // self.audioData=audio;
    self.ControlButton2.enabled=YES;
    self.reRecordButton.hidden=NO;
    self.saveButton.hidden=NO;
    
}


- (void)startPlaying {
    
    NSError *error=nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    //self.audioPlayer=[[AVAudioPlayer alloc]initWithData:self.audioData error:&error];
    
    NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
    NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:self.audioData];
    self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:pathToSave] error:&error];
    if (error) {
        NSLog(@"fail to startPlaying;%@",error);
    }
    self.audioPlayer.delegate=self;
    [self.audioPlayer play];
  
}



- (void)stopPlaying {
    
    [self.audioPlayer stop];
    
}

- (void)updateControlButton {
    
    NSString* imageName=nil;
    if(self.audioPlayer.isPlaying){
       imageName=@"PauseButton";
       
       }
    else if(self.audioRecorde.isRecording){
        imageName=@"StopButton";
    }
    
    else if(self.audioData){
        imageName=@"PlayButton";
    }
    else{
        imageName=@"RecordButton";
        if (recodingAllowed) {
            self.ControlButton.enabled=YES;
            self.ControlButton.alpha=1.0;
        }
        else{
            self.ControlButton.enabled=NO;
            self.ControlButton.alpha=0.5;
        }
    }
    
   // UIImage *image=[UIImage imageNamed:imageName];
   // [self.ControlButton setImage:image forState:UIControlStateNormal];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    //[self updateControlButton];
    [self.ControlButton2 setImage:[UIImage imageNamed:@"pauseButton"] forState:UIControlStateNormal];
}

- (IBAction)clickReRecordButton:(id)sender {
    [self.audioRecorde deleteRecording];
}

- (IBAction)clickSaveButton:(id)sender {
    //NSURL *urlOfRecording = _audioRecorde.url;
   // NSString *urla = [urlOfRecording absoluteString];
   
    //[self.delegate viewPassAudio:urla];
    [self.delegate viewPassAudio:audioPath];
    isSave=YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
           NSFileManager *fileM=[NSFileManager defaultManager];
       
           // BOOL fileExist=[fileM fileExistsAtPath:[_audioRecorde.url absoluteString]];
        
        //if (fileExist) {
            NSLog(@"remove file");
            NSError *error;
            [fileM removeItemAtURL:_audioRecorde.url error:&error];
        
       // }
            [self dismissViewControllerAnimated:YES completion:nil];
    }
        
        
}

    
    


@end
