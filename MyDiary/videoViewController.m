//
//  videoViewController.m
//  MyDiary
//
//  Created by zhouhao on 15-4-17.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "videoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface videoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(strong,nonatomic)UIImagePickerController *imagePicker;
@property(assign,nonatomic)int isTakeVideo;
@property(assign,nonatomic)BOOL isSave;
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;

@end

@implementation videoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏左右控件
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, size.width, 55)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    
    [leftButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:@"保存"
                                                                 style:UIBarButtonItemStyleBordered target:self
                                                                action:@selector(savePressed)];
    [rightButton setTintColor:[UIColor whiteColor]];
    navigationItem.leftBarButtonItem=leftButton;
    navigationItem.rightBarButtonItem=rightButton;
    navigationBar.barTintColor=UIColorFromRGB(0xc73302);
    [navigationBar pushNavigationItem:navigationItem animated:YES];
    [self.view addSubview:navigationBar];
    
    //获取视频缩略图
    if(self.videoURL){
        NSLog(@"self.videoURL");
    self.videoImage.image=[self findtumbImage:self.videoURL];
    //在imageView中设置Gesture
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.videoImage addGestureRecognizer:singleTap];
    [self.videoImage setUserInteractionEnabled:YES];
   // player = nil;
   _isSave=YES;
        
   }
    else{
         _isSave=NO;
    }
    [self addNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)backPressed {
    
    if (!_isSave) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"您还没有保存，确定要返回吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    //[self dismissViewControllerAnimated:YES completion:nil];
    
    //[self.navigationController pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>]
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        NSFileManager *fileM=[NSFileManager defaultManager];
        
        // BOOL fileExist=[fileM fileExistsAtPath:[_audioRecorde.url absoluteString]];
        
        //if (fileExist) {
        //NSLog(@"remove file");
        NSError *error;
        [fileM removeItemAtURL:_videoURL error:&error];
        
        // }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)savePressed {
       // NSURL *urlOfRecording = _videoURL;
        //NSString *urla = [urlOfRecording absoluteString];
        //NSLog(@"%@",urla);
       [self.delegate videoPassValue:self.videoPath];
       [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)takeVideoPressed:(id)sender {
    _isTakeVideo=YES;
    _imagePicker=[self imagePicker];
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
    
}
- (IBAction)choseFromLibrary:(id)sender {
    _isTakeVideo=NO;
    _imagePicker=[self imagePicker];
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
    }
    if (_isTakeVideo) {
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
        _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
        _imagePicker.videoQuality=UIImagePickerControllerQualityTypeIFrame1280x720;
        _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
        
        
    }
    else{
       // _imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
         _imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    }
    //_imagePicker.allowsEditing=YES;//允许编辑
    _imagePicker.delegate=self;//设置代理，检测操作
    _isSave=NO;
    return _imagePicker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Get the image from the info dictionary.
    //UIImage* image = info[UIImagePickerControllerOriginalImage];
    
    // Show the image to the user.
   //  self.videoImage.image = image;
    
   
    NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
    NSData *videoData = [NSData dataWithContentsOfURL:url];
    NSString *urlStr=[url path];
    self.videoURL=url;
   /* MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:url];
    self.videoImage.image= [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];*/
   // player = nil;
    NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath= [searchPaths objectAtIndex: 0];
    NSUUID *uuid=[[NSUUID alloc]init];
    NSString *videoName=[[uuid UUIDString]stringByAppendingString:@".mp4"];
    NSString *pathToSave = [documentPath stringByAppendingPathComponent:videoName];
    self.videoPath=videoName;
    // MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:pathToSave]];
    // self.videoImage.image= [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [videoData writeToFile:pathToSave atomically:YES];
    self.videoImage.image=[self findtumbImage:[NSURL fileURLWithPath:pathToSave]];
    NSLog(@"_videoPath %@",_videoPath);
    //NSData *imageData = UIImagePNGRepresentation(image);

    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
        //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
        if(_isTakeVideo){
        UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
    }
    // Store the data in the note object, and save the database.
    
    // Finally, we need to make the image picker go away.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }
    else{
        NSLog(@"视频保存成功.");
        //录制完之后自动播放
        /*NSURL *url=[NSURL fileURLWithPath:videoPath];
         _player=[AVPlayer playerWithURL:url];
         AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
         playerLayer.frame=self.photo.frame;
         [self.photo.layer addSublayer:playerLayer];
         [_player play];*/
        
    }
}



- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer {
    [UIView animateWithDuration:0.5 animations:^(void){
        NSLog(@"touch image");
        /*NSURL *url=[NSURL fileURLWithPath:[self.videoURL absoluteString]];
        AVPlayer* player=[AVPlayer playerWithURL:url];
        AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.frame=self.videoImage.frame;
        [self.videoImage.layer addSublayer:playerLayer];
        [player play];*/
        if (!_moviePlayer) {
            //NSURL *url=[self getNetworkUrl];
            _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:self.videoURL];
            [_moviePlayer prepareToPlay];
            _moviePlayer.view.frame=self.view.bounds;
            _moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:_moviePlayer.view];
        }
        
        [self.moviePlayer play];
        

    }];
}

/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
}

-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
            break;
    }
}

-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
    //视频播放对象
    MPMoviePlayerController* theMovie = [notification object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [theMovie.view removeFromSuperview];
    // 释放视频对象
    //[theMovie release];
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
