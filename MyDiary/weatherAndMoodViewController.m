//
//  weatherAndMoodViewController.m
//  MyDiary
//
//  Created by zhouhao on 15/4/27.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "weatherAndMoodViewController.h"
#import "WriteDiaryViewController.h"
#import "DiaryStore.h"
//#import "weatherAndMoodView.h"
#define  LabelEdgeHoriztol 50
#define  LabelEdgeVertical 30
#define  LabelHeight 30
#define  LabelSpace 30
#define  ButtonEdgeHoriztol 30
#define  ButtonSize 30
#define  ButtonNumberPerLine 3
#define  Lines 2

@interface weatherAndMoodViewController ()
{
    //NSString* weather_Name;
    //NSString *mood_Name;
}
@property(copy,nonatomic)NSString* weather_Name;
@property(copy,nonatomic)NSString* mood_Name;
@property(strong,nonatomic)UILabel *weatherLabel;
@property(strong,nonatomic)UILabel *moodLabel;
@property(assign,nonatomic)BOOL isWeatherSelected;
@property(assign,nonatomic)BOOL isMoodSelected;

@end

@implementation weatherAndMoodViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initView];
    
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

- (void)initView {
    
        self.view.backgroundColor=[UIColor whiteColor];
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(LabelEdgeHoriztol, LabelEdgeVertical, size.width-2*LabelEdgeHoriztol, LabelHeight)];
        [self.view addSubview:dateLabel];
        NSDate* dateToday=[[NSDate alloc]init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd EEEE"];
        NSString* date=[dateFormatter stringFromDate:dateToday];
        dateLabel.text=date;
        dateLabel.textAlignment=NSTextAlignmentCenter;
    
        UILabel *weatherLabel=[[UILabel alloc]initWithFrame:CGRectMake(LabelEdgeHoriztol,LabelEdgeVertical+LabelHeight+LabelSpace, size.width-2*LabelEdgeHoriztol, LabelHeight)];
        [self.view addSubview:weatherLabel];
        self.weatherLabel=weatherLabel;
        self.weatherLabel.textAlignment=NSTextAlignmentCenter;
        self.weatherLabel.text=@"现在的天气如何？";
        
        CGFloat verticalInterval=(size.height-LabelEdgeVertical*2-LabelHeight*5-LabelSpace*2)/(2*Lines);
        CGFloat horizolInterval=(size.width-ButtonNumberPerLine*ButtonSize-ButtonEdgeHoriztol*2)/(ButtonNumberPerLine-1);
        for (int line=0; line<Lines; line++) {
            for (int buttonNum=0; buttonNum<ButtonNumberPerLine; buttonNum++) {
                UIButton* weatherButton=[[UIButton alloc]initWithFrame:CGRectMake(ButtonEdgeHoriztol+buttonNum*(horizolInterval+ButtonSize), LabelEdgeVertical+2*LabelHeight+(line+1)*verticalInterval, ButtonSize, ButtonSize)];
                [self.view addSubview:weatherButton];
                long buttonID=line*ButtonNumberPerLine+buttonNum+1;
                NSString *weatherName=[NSString stringWithFormat:@"weather_%ld@3x.png",buttonID];
                [weatherButton setBackgroundImage:[UIImage imageNamed:weatherName] forState:    UIControlStateNormal];
                NSString * weatherName_1=[NSString stringWithFormat:@"weather_%ldh@3x.png",buttonID];
                [weatherButton setBackgroundImage:[UIImage imageNamed:weatherName_1] forState:UIControlStateSelected];
                weatherButton.tag=buttonID;
                [weatherButton addTarget:self action:@selector(weatherButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
       UILabel *moodLabel=[[UILabel alloc]initWithFrame:CGRectMake(LabelEdgeHoriztol,LabelEdgeVertical+2*LabelHeight+2*LabelSpace+2*verticalInterval, size.width-2*LabelEdgeHoriztol, LabelHeight)];
        [self.view addSubview:moodLabel];
        moodLabel.textAlignment=NSTextAlignmentCenter;
        self.moodLabel=moodLabel;
        self.moodLabel.text=@"现在的心情如何?";
        for (int line=0; line<Lines; line++) {
            for (int buttonNum=0; buttonNum<ButtonNumberPerLine; buttonNum++) {
                UIButton* moodButton=[[UIButton alloc]initWithFrame:CGRectMake(ButtonEdgeHoriztol+buttonNum*(horizolInterval+ButtonSize), LabelEdgeVertical+3*LabelHeight+LabelSpace+(line+3)*verticalInterval, ButtonSize, ButtonSize)];
                [self.view addSubview:moodButton];
                long buttonID=line*ButtonNumberPerLine+buttonNum+1;
                NSString *moodName=[NSString stringWithFormat:@"mood_%ld@3x.png",buttonID];
                [moodButton setBackgroundImage:[UIImage imageNamed:moodName] forState:    UIControlStateNormal];
                //[moodButton setSelected:YES];
                NSString *moodNameH=[NSString stringWithFormat:@"mood_%ldh@3x.png",buttonID];
                [moodButton setBackgroundImage:[UIImage imageNamed:moodNameH] forState:UIControlStateSelected];
                moodButton.tag=buttonID;
                [moodButton addTarget:self action:@selector(moodButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        
        UIButton *saveButton=[[UIButton alloc]initWithFrame:CGRectMake(0, size.height-40, size.width, 40)];
        saveButton.backgroundColor=[UIColor lightGrayColor];
        [saveButton setTitle:@"完成" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:saveButton];
        _weather_Name=@"weather_1";
        _mood_Name=@"mood_1";

}

- (void)weatherButtonClicked:(UIButton*)button {
    
    NSString *weatherName;
    NSString *weatherString = [NSString stringWithFormat:@"weather_%ld@3x.png",(long)button.tag];
    NSString *weatherString_1=[NSString stringWithFormat:@"weather_%ld",(long)button.tag];
    if (!button.selected) {
        NSString *plistStr=[[NSBundle mainBundle]pathForResource:@"weather" ofType:@"plist"];
        NSDictionary *plistDic=[[NSDictionary alloc]initWithContentsOfFile:plistStr];
        for (int j = 0; j<[[plistDic allKeys]count]-1; j++)
        {
            if ([[plistDic objectForKey:[[plistDic allKeys]objectAtIndex:j]]
                isEqualToString:[NSString stringWithFormat:@"%@",weatherString]])
            {
                weatherName = [[plistDic allKeys]objectAtIndex:j];
                self.weatherLabel.text=weatherName;
            }
        }
        button.selected=YES;
        
        _weather_Name=weatherString_1;
        
       // _isWeatherSelected=YES;
        
    }
    else{
        self.weatherLabel.text=@"现在的天气如何？";
        button.selected=NO;
        //_isWeatherSelected=NO;
    }
    
   // if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectWeather:)]) {
       // [self.delegate didSelectWeather:weatherName];
   // }
    
    
    
}

- (void)moodButtonClicked:(UIButton*)button {
    
    NSString *moodName;
    NSString *moodString = [NSString stringWithFormat:@"mood_%ld@3x.png",(long)button.tag];
    NSString *moodString_1=[NSString stringWithFormat:@"mood_%ld",(long)button.tag];
    NSString *plistStr=[[NSBundle mainBundle]pathForResource:@"mood" ofType:@"plist"];
    NSDictionary *plistDic=[[NSDictionary alloc]initWithContentsOfFile:plistStr];
    if (!button.selected) {
            for (int j = 0; j<[[plistDic allKeys]count]-1; j++)
            {
                if ([[plistDic objectForKey:[[plistDic allKeys]objectAtIndex:j]]
                     isEqualToString:[NSString stringWithFormat:@"%@",moodString]])
                {
                    moodName = [[plistDic allKeys]objectAtIndex:j];
                    self.moodLabel.text=moodName;
                    NSLog(@"%@",_mood_Name);
                }
            }
        button.selected=YES;
        _mood_Name=moodString_1;
        //_isMoodSelected=YES;
        //[button setBackgroundImage:[UIImage imageNamed:@"mood_4h.png"] forState:UIControlStateSelected];
        
    }
    else{
        self.moodLabel.text=@"现在的心情如何？";
        button.selected=NO;
        //_isMoodSelected=NO;
    }
    
   // if (self.delegate && [self.delegate respondsToSelector:@selector(didselectMood:)]) {
      //  [self.delegate didselectMood:moodName];
   // }
    

    
}


- (void)saveButtonClicked {
    /*if(!_isWeatherSelected){
        _weather_Name=@"weather_1";
        
    }
    
    if(!_isMoodSelected){
        _mood_Name=@"mood_1";
    }*/
   
    [self.delegate passValue:_weather_Name moodValue:_mood_Name];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


@end
