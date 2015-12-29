//
//  PhotoViewController.m
//  MyDiary
//
//  Created by zhouhao on 15-3-20.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "PhotoViewController.h"
#import "DiaryStore.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
   
//static CGRect oldframe;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *iamgeView4;
@property (weak, nonatomic) IBOutlet UIImageView *iamgeView5;
@property (weak, nonatomic) IBOutlet UIImageView *iamgeView6;
@property (strong,nonatomic)UIImagePickerController* imagePicker;
@property (weak, nonatomic) IBOutlet UIButton *paizhao;
@property (weak, nonatomic) IBOutlet UIButton *xiangpian;

@property(assign,nonatomic)int isTakePhoto;
//@property(strong,nonatomic)NSString *photoPath;
@property(assign,nonatomic)BOOL isSave;


@end

static CGRect oldframe;

@implementation PhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect=[[UIScreen mainScreen]bounds];
    CGSize size=rect.size;
    UINavigationBar* navigationBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, size.width, 55)];
    UINavigationItem *navigationItem=[[UINavigationItem alloc]initWithTitle:@""];
 
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    UIBarButtonItem* rightButton=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(savePressed)];
    navigationItem.leftBarButtonItem=leftButton;
    navigationItem.rightBarButtonItem=rightButton;
    [leftButton setTintColor:[UIColor whiteColor]];
    [rightButton setTintColor:[UIColor whiteColor]];
    navigationBar.barTintColor=UIColorFromRGB(0xc73302);
    [navigationBar pushNavigationItem:navigationItem animated:YES];
    [self.view addSubview:navigationBar];
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8];
    self.imageView1.layer.masksToBounds=YES;
    self.imageView1.layer.cornerRadius=10.0f;
    if (_photoPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        libraryDirectory = [libraryDirectory stringByAppendingPathComponent:_photoPath];
      
        self.imageView1.image=[UIImage imageWithContentsOfFile:libraryDirectory];
        

       // NSData* imageData=[NSData dataWithContentsOfFile:_photoPath];
       // self.imageView1.image=[UIImage imageWithData:imageData];
        _isSave=YES;
    }
    else{
        _isSave=NO;
    }
    //UIImage* photoImage=self.photo;
    //self.imageView1.image=photoImage;
    //在imageView中设置Gesture
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.imageView1 addGestureRecognizer:singleTap];
    [self.imageView1 setUserInteractionEnabled:YES];
    self.paizhao.layer.cornerRadius=5.0f;
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)backPressed {
    
    if (!_isSave) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"您还没有保存，确定要返回吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
        
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    

   
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        NSFileManager *fileM=[NSFileManager defaultManager];
        
        // BOOL fileExist=[fileM fileExistsAtPath:[_audioRecorde.url absoluteString]];
        
        //if (fileExist) {
        NSLog(@"remove file");
        NSError *error;
        [fileM removeItemAtPath:_photoPath error:&error];
        
        // }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}



- (void)savePressed {

    [self.delegate viewPassValue:_photoPath];
    _isSave=YES;
    [self dismissViewControllerAnimated:YES completion:nil];

    
}


- (IBAction)takePhotoPressed:(id)sender {
    
        self.isTakePhoto=YES;
        _imagePicker=[self imagePicker];
        [self presentViewController:_imagePicker animated:YES completion:nil];
        

    
}

- (IBAction)choseFromLibrary:(id)sender {
    
    self.isTakePhoto=NO;
    _imagePicker=[self imagePicker];
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
}

- (UIImagePickerController *)imagePicker {
    
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
        
    }
    if (self.isTakePhoto) {
         _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头

    }
    else{
        _imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    _imagePicker.allowsEditing=YES;//允许编辑
    _imagePicker.delegate=self;//设置代理，检测操作
    _isSave=NO;
    
    return _imagePicker;
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Get the image from the info dictionary.
  
     UIImage *image = [self scaleAndRotateImage: [info objectForKey:UIImagePickerControllerOriginalImage]];
    
    
    // Show the image to the user.
    [self.imageView1 setImage:image];

    if(_isTakePhoto){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    // We also want to store the image in the database. We need to
    // convert the image into a format that can be stored - either
    // PNG or JPEG. In this example, we'll go with JPEG.
    // JPEG lets you choose how much to compress by, from 0 to 1;
    // numbers closer to 0 are smaller files, but numbers closer to
    // 1 are better quality. 0.8 is a decent compromise.
    
    NSData* data;
    if (!UIImagePNGRepresentation(image)) {
        
        data=UIImageJPEGRepresentation(image, 1);
    }
    else {
       
        data=UIImagePNGRepresentation(image);
    }
   /* NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"photo"];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
    NSUUID *uuid=[[NSUUID alloc]init];
    NSString *imageKey=[uuid UUIDString];
    NSString *fileName = [stringPath stringByAppendingFormat:@"/%@.jpg",imageKey];
    _photoPath=fileName;
    NSLog(@"%@",fileName);
    [data writeToFile:fileName atomically:YES];*/
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSUUID *uuid=[[NSUUID alloc]init];
    NSString *imageKey=[uuid UUIDString];
    NSString *fileName = [NSString stringWithFormat:@"/%@.jpg",imageKey];
    NSString *path = [libraryDirectory stringByAppendingPathComponent:fileName];
    //NSData *imageData = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];
    _photoPath=fileName;
     NSLog(@"file name%@",fileName);
    NSLog(@"path%@",path);
    // Save file name to Core Data. Don't store absolute paths.
    
    // Store the data in the note object, and save the database.
    
    // Finally, we need to make the image picker go away.
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControlDidCancel:(UIImagePickerController*)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer {
    
    [PhotoViewController showImage:self.imageView1];//调用方法
}


+(void)showImage:(UIImageView*)orignImageView{
    UIImage* image=orignImageView.image;
    UIView* goBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    oldframe = [orignImageView convertRect:orignImageView.bounds toView:window];
    goBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = orignImageView.image;
    imageView.tag = 1;
    [goBackgroundView addSubview:imageView];
    [window addSubview:goBackgroundView];
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [goBackgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        goBackgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

- (UIImage *)scaleAndRotateImage:(UIImage *) image {
    int kMaxResolution = 320;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
