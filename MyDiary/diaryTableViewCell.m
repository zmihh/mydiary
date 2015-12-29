//
//  diaryTableViewCell.m
//  MyDiary
//
//  Created by zhouhao on 15/5/11.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "diaryTableViewCell.h"
#import "Diary.h"
#import <MediaPlayer/MediaPlayer.h>

#define Color(r,g,b) [UIColor colorWithHue:r/255.0 saturation:g/255.0 brightness:b/255.0 alpha:1]//颜色宏定义
#define tableCellTimeLabelWidth 40
#define tabelCellTimeLabelHeight 20
#define tabelCellWeatherLabelWidth 10
#define tableCellMoodLabelWidth 10
#define tabelCellWeatherLabelHeight 10
#define tableCellMoodLabelHeight   10
#define tabelCellMidiaLableWidth 60
#define tabelCellMidiaLableHeight  tabelCellMidiaLableWidth
#define tableCellBackgroundColor Color(251,251,251)
#define GrayColor Color(50,50,50)
#define LightGrayColor Color(120,120,120)
#define textFontSize 14
#define dayFontSize 18
#define moonthFontSize 14
#define weekFontSize 12
#define timeFontSzie 10
#define yearFontSize 18
#define block_1 80
#define  cellSpacing 10
#define  timeSpacing 0

@interface diaryTableViewCell(){
   /* UIImageView* _weather;
    UIImageView* _mood;
    UIImageView* _photo1;
    UIImageView* _video;
    UIImageView* _audio;*/
    UILabel *_year;
    UILabel *_month;
    UILabel * _day;
    UILabel *_week;
    UILabel *_time;
    UILabel *_text;
    NSArray *_weekArray;

}
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;

@end

@implementation diaryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
    
}

- (void)initSubView {
    //TimeLabel
    _day=[[UILabel alloc]init];
    _day.font=[UIFont systemFontOfSize:dayFontSize];
    [self addSubview:_day];
    _month=[[UILabel alloc]init];
    _month.font=[UIFont systemFontOfSize:moonthFontSize];
    [self addSubview:_month];
    _week=[[UILabel alloc]init];
    _week.font=[UIFont systemFontOfSize:weekFontSize];
    [self addSubview:_week];
    _time=[[UILabel alloc]init];
    _time.font=[UIFont systemFontOfSize:timeFontSzie];
    [self addSubview:_time];
    _year=[[UILabel alloc]init];
    _year.font=[UIFont systemFontOfSize:yearFontSize];
    
    //weather image
    _weather=[[UIImageView alloc]init];
    [self addSubview:_weather];
    
    //MOOD IMAGE
    _mood=[[UIImageView alloc]init];
    [self addSubview:_mood];
    
    //photo
    self.photo=[[UIImageView alloc]init];
    [self addSubview:self.photo];
    
   /* _photo2=[[UIImageView alloc]init];
    [self addSubview:_photo2];
    
    _photo3=[[UIImageView alloc]init];
    [self addSubview:_photo3];*/
    
    //video
    
    _video=[[UIImageView alloc]init];
    [self addSubview:_video];
    
    //audio
    
    _audio=[[UIImageView alloc]init];
    [self addSubview:_audio];
    
    //diary content
    _text=[[UILabel alloc]init];
    _text.textColor=GrayColor;
    _text.font=[UIFont systemFontOfSize:textFontSize];
    _text.lineBreakMode=NSLineBreakByWordWrapping;
    _text.numberOfLines=0;
    
    [self addSubview:_text];
    
    _weekArray=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    
    
    
}

#pragma arguments 设置日记展示

- (void)setDiary:(Diary *)diary {
    
    //设置日记创建日期大小和位置
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //NSDate* date=diary.date;
    NSDateComponents *component=[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:diary.date];
                          
    CGFloat dayX=20,dayY=10;
    CGRect dayRect=CGRectMake(dayX, dayY,tableCellTimeLabelWidth, tabelCellTimeLabelHeight);
    NSString *dayString = [NSString stringWithFormat:@"%ld",(long)component.day];
    _day.text=dayString;
    _day.textAlignment=NSTextAlignmentCenter;
    _day.frame=dayRect;
    
    CGFloat monthX=dayX;
    CGFloat monthY=dayY+tabelCellTimeLabelHeight+timeSpacing;
    CGRect monthRect=CGRectMake(monthX, monthY,tableCellTimeLabelWidth, tabelCellTimeLabelHeight);
    NSString *monthString = [NSString stringWithFormat:@"%ld月",(long)component.month];
    _month.text=monthString;
    _month.textAlignment=NSTextAlignmentCenter;
    _month.frame=monthRect;
    
    CGFloat weekX=dayX;
    CGFloat weekY=monthY+tabelCellTimeLabelHeight+timeSpacing;
    CGRect  weekRect=CGRectMake(weekX, weekY, tableCellTimeLabelWidth, tabelCellTimeLabelHeight);
    NSString *weekString = _weekArray[(component.weekday+6)%7];
    _week.textAlignment=NSTextAlignmentCenter;
    _week.text=weekString;
    _week.frame=weekRect;
    
    
   /* CGFloat timeX=dayX;
    CGFloat timeY=weekY+tabelCellTimeLabelHeight+timeSpacing;
    CGRect  timeRect=CGRectMake(timeX, timeY, tableCellTimeLabelWidth, tabelCellTimeLabelHeight);
    NSString *timeString = [NSString stringWithFormat:@"%ld",component.time];
    _week.text=weekString;
    _time.frame=timeRect;*/
    //设置心情图标位置
    // CGFloat moodX=self.bounds.size.width-dayX;
    // CGFloat moodX=photoX;
    //CGFloat moodY=textY+textSize.height+cellSpacing;
    //CGFloat moodY=textY+textRect.size.height;
    CGFloat moodX=dayX+cellSpacing;
    // CGFloat weatherY=moodY;
    CGFloat moodY=weekY+tabelCellTimeLabelHeight+timeSpacing;
    CGRect  moodRect=CGRectMake(moodX, moodY, tableCellMoodLabelWidth,tableCellMoodLabelHeight);
    // NSString *plistStr=[[NSBundle mainBundle]pathForResource:@"mood" ofType:@"plist"];
    // NSDictionary *plistDic=[[NSDictionary alloc]initWithContentsOfFile:plistStr];
    //UIImage* image=[plistDic objectForKey:diary.mood];
    UIImage *image=[UIImage imageNamed:diary.mood];
    _mood.image=image;
    _mood.frame=moodRect;
    
    //设置天气图标位置
    
    //CGFloat weatherX=moodX+cellSpacing+tableCellMoodLabelWidth;
    CGFloat weatherX=dayX+cellSpacing+2*tableCellMoodLabelWidth;
    // CGFloat weatherY=moodY;
    CGFloat weatherY=weekY+tabelCellTimeLabelHeight+timeSpacing;
    CGRect  weatherRect=CGRectMake(weatherX, weatherY, tabelCellWeatherLabelWidth, tabelCellWeatherLabelHeight);
    // NSString *plistStr_1=[[NSBundle mainBundle]pathForResource:@"weather" ofType:@"plist"];
    //NSDictionary *plistDic_1=[[NSDictionary alloc]initWithContentsOfFile:plistStr_1];
    // NSLog(@"DIAIR WEATHER%@",diary.weather);
    //UIImage* image_1=[plistDic_1 objectForKey:diary.weather];
    UIImage* image_1=[UIImage imageNamed:diary.weather];
    _weather.image=image_1;
    _weather.frame=weatherRect;
    
    //设置照片位置大小
    
    CGFloat photoX=self.bounds.size.width-cellSpacing-tabelCellMidiaLableWidth;
    CGFloat photoY=dayY;
    CGRect  photoRect;
    if (diary.photo) {
        // NSLog(@"ajd");
        photoRect=CGRectMake(photoX, photoY, tabelCellMidiaLableWidth, tabelCellMidiaLableHeight);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        libraryDirectory = [libraryDirectory stringByAppendingPathComponent:diary.photo];
       // NSLog(@"libraryDirectory %@",libraryDirectory);
        //NSData* data=[NSData dataWithContentsOfFile:libraryDirectory];
        //cell.image=[UIImage imageWithData:data];
        //_photo1.image=[UIImage imageWithData:data];
        self.photo.image=[UIImage imageWithContentsOfFile:libraryDirectory];
        
      
       // UIImage* image=[UIImage imageWithContentsOfFile:libraryDirectory];
        //_photo1.image =
        /*[UIImage imageWithCGImage:[image CGImage]
                            scale:1.0
                      orientation:UIImageOrientationUp];*/
        
        //_photo1.image=[UIImage imageWithContentsOfFile:diary.photo];
        self.photo.frame=photoRect;
        self.photo.contentMode=UIViewContentModeScaleAspectFill;
       // _photo1.center = CGPointMake(tabelCellMidiaLableWidth/2, tabelCellMidiaLableHeight/2);
       // _photo1.contentMode = UIViewContentModeScaleAspectFit;
        self.photo.layer.masksToBounds=YES;
        self.photo.layer.cornerRadius=10.0f;
    }
    else{
        // NSLog(@"ajd");
        photoRect=CGRectZero;
        self.photo.frame=photoRect;
    }
    /*if (self.image) {
        photoRect=CGRectMake(photoX, photoY, tabelCellMidiaLableWidth, tabelCellMidiaLableHeight);
        _photo1.image=self.image;
        _photo1.frame=photoRect;
    }
    else{
        // NSLog(@"ajd");
        photoRect=CGRectZero;
        _photo1.frame=photoRect;
    }*/
    //NSData* data=[NSData da]
    //NSLog(@"diary.path  %@",diary.photo);
    
    // _photo1.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:diary.photo]]];
    //设置text位置大小
    CGFloat textX=block_1+cellSpacing;;
    CGFloat textY=dayY;
    CGFloat textMediaSpcing;
    if (self.diary.text) {
    //textX=block_1+cellSpacing;
    //CGFloat textY=dayY+cellSpacing+tabelCellWeatherLabelHeight;
    //textY=dayY;
    CGFloat textWidth=self.bounds.size.width-textX-2*cellSpacing-photoRect.size.width;
    //CGSize  textSize=[diary.text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFontSize]} context:nil].size;
    
    //CGRect textRect=CGRectMake(textX, textY, textSize.width, textSize.height);
    CGRect textRect=CGRectMake(textX, textY, textWidth, tabelCellMidiaLableHeight);
    //_text.lineBreakMode=NSLineBreakByWordWrapping;
    _text.numberOfLines=0;
    _text.text=diary.text;
    _text.frame=textRect;
    textMediaSpcing=cellSpacing;
    }
    else{
        CGRect texRect=CGRectZero;
        _text.frame=texRect;
    textMediaSpcing=2*cellSpacing;
    }
    
    //设置audio位置大小
    
    CGFloat audioX=textX+timeSpacing;
    CGFloat audioY=_text.frame.size.height+textMediaSpcing;
    CGFloat spacing;
    CGRect audioRect;
    if (diary.audioNote) {
        //audioX=textX+timeSpacing;
        //audioY=_text.frame.size.height+cellSpacing;
        audioRect=CGRectMake(audioX, audioY, 2*tabelCellWeatherLabelWidth, 2*tabelCellWeatherLabelHeight);
        _audio.image=[UIImage imageNamed:@"microphone"];
        _audio.frame=audioRect;
        spacing=cellSpacing;
    }
    else{
        audioRect=CGRectZero;
        spacing=0;
    }
    
    _audio.frame=audioRect;
    
    //设置vidio位置大小
    
    CGFloat videoX=audioX+audioRect.size.width+spacing;
    CGFloat videoY=audioY;
    CGRect  videoRect;
    if (diary.video) {
        videoRect=CGRectMake(videoX, videoY, 2*tabelCellWeatherLabelWidth, 2*tabelCellWeatherLabelHeight);
        self.video.frame=videoRect;
        self.video.image=[UIImage imageNamed:@"video"];
    }
    else{
        videoRect=CGRectZero;
    }

    //_video.frame=videoRect;
    //NSString *urlStr=[url path];
   // NSLog(@"diary video%@",diary.video);
   // NSURL *url=[[NSURL alloc]initFileURLWithPath:diary.video];
   // NSLog(@"%@",[url path]);
    //MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:url];
    //_video.image= [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
   // UIImage *Veimage= [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
   // _video.image=Veimage;
    if (CGRectGetMaxY(_text.frame)<moodY+tabelCellTimeLabelHeight) {
        _height=moodY+tabelCellTimeLabelHeight+cellSpacing;
        
    }
    else{
        _height=CGRectGetMaxY(_text.frame)+audioRect.size.height+photoRect.size.height+2*cellSpacing;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}


@end
