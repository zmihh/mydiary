//
//  weatherAndMoodView.m
//  MyDiary
//
//  Created by zhouhao on 15/4/26.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "weatherAndMoodView.h"
//THE distance between label and the view bounds
#define  LabelEdgeHoriztol 50
#define  LabelEdgeVertical 40
#define  LabelHeight 30
#define  LabelSpace 30
#define  ButtonEdgeHoriztol 10
#define  ButtonSize 30
#define  ButtonNumberPerLine 3
#define  Lines 2



@implementation weatherAndMoodView

- (id)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        CGSize size=[self bounds].size;
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(LabelEdgeHoriztol, LabelEdgeVertical, size.width-2*LabelEdgeHoriztol, LabelHeight)];
        [self addSubview:dateLabel];
        NSDate* dateToday=[[NSDate alloc]init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy,MMMM,dd"];
        NSString* date=[dateFormatter stringFromDate:dateToday];
        dateLabel.text=date;
        
        UILabel *weatherLabel=[[UILabel alloc]initWithFrame:CGRectMake(LabelEdgeHoriztol,LabelEdgeVertical+LabelHeight+LabelSpace, size.width-2*LabelEdgeHoriztol, LabelHeight)];
        [self addSubview:weatherLabel];
        self.weatherLabel=weatherLabel;
        self.weatherLabel.textAlignment=NSTextAlignmentCenter;
        self.weatherLabel.text=@"今天的天气如何？";
        
        CGFloat verticalInterval=(size.height-LabelEdgeVertical*2-LabelHeight*4-LabelSpace*2)/(2*Lines);
        CGFloat horizolInterval=(size.width-ButtonNumberPerLine*ButtonSize-ButtonEdgeHoriztol*2)/(ButtonNumberPerLine-1);
      /*  for (int line=0; line<Lines; line++) {
            for (int buttonNum=0; buttonNum<ButtonNumberPerLine; buttonNum++) {
                UIButton* weatherButton=[[UIButton alloc]initWithFrame:CGRectMake(ButtonEdgeHoriztol+ButtonNumberPerLine*horizolInterval, LabelEdgeVertical+2*LabelHeight+LabelSpace+(line+1)*verticalInterval, ButtonSize, ButtonSize)];
                [self addSubview:weatherButton];
                long buttonID=line*ButtonNumberPerLine+buttonNum+1;
                NSLog(@"%ld",buttonID);
                NSString *weatherName=[NSString stringWithFormat:@"weather_%ld@3x.png",buttonID];
                [weatherButton setBackgroundImage:[UIImage imageNamed:weatherName] forState:    UIControlStateNormal];
                weatherButton.tag=buttonID;
                [weatherButton addTarget:self action:@selector(weatherButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }*/
        UILabel *moodLabel=[[UILabel alloc]initWithFrame:CGRectMake(LabelEdgeHoriztol,LabelEdgeVertical+2*LabelHeight+2*LabelSpace+2*verticalInterval, size.width-2*LabelEdgeHoriztol, LabelHeight)];
        [self addSubview:moodLabel];
        moodLabel.textAlignment=NSTextAlignmentCenter;
        self.moodLabel=moodLabel;
        self.moodLabel.text=@"今天的心情如何?";
        for (int line=0; line<Lines; line++) {
            for (int buttonNum=0; buttonNum<ButtonNumberPerLine; buttonNum++) {
                UIButton* moodButton=[[UIButton alloc]initWithFrame:CGRectMake(ButtonEdgeHoriztol+ButtonNumberPerLine*horizolInterval, LabelEdgeVertical+3*LabelHeight+2*LabelSpace+(line+3)*verticalInterval, ButtonSize, ButtonSize)];
                [self addSubview:moodButton];
                long buttonID=line*ButtonNumberPerLine+buttonNum+1;
                NSString *moodName=[NSString stringWithFormat:@"mood_%ld.png",buttonID];
                [moodButton setBackgroundImage:[UIImage imageNamed:moodName] forState:    UIControlStateNormal];
                moodButton.tag=buttonID;
                [moodButton addTarget:self action:@selector(moodButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        
        UIButton *saveButton=[[UIButton alloc]initWithFrame:CGRectMake(0, size.height-40, size.width, 40)];
        saveButton.backgroundColor=[UIColor grayColor];
        [saveButton setTitle:@"完成" forState:UIControlStateNormal];
       // [saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:saveButton];
        
        
        
    }
    
    return self;
}

- (void)weatherButtonClicked:(UIButton*)button {
        NSString *weatherName;
        NSString *weatherString = [NSString stringWithFormat:@"weather_%ld@3x.png",(long)button.tag];
        //button.selected=YES;
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

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectWeather:)]) {
        [self.delegate didSelectWeather:weatherName];
    }
    
    
    
}

- (void)moodButtonClicked:(UIButton*)button {
    NSString *moodName;
    NSString *moodString = [NSString stringWithFormat:@"mood_%ld@3x.png",(long)button.tag];
    //button.selected=YES;
    NSString *plistStr=[[NSBundle mainBundle]pathForResource:@"mood" ofType:@"plist"];
    NSDictionary *plistDic=[[NSDictionary alloc]initWithContentsOfFile:plistStr];
    for (int j = 0; j<[[plistDic allKeys]count]-1; j++) {
        if ([[plistDic objectForKey:[[plistDic allKeys]objectAtIndex:j]]
             isEqualToString:[NSString stringWithFormat:@"%@",moodString]]) {
            moodName = [[plistDic allKeys]objectAtIndex:j];
            self.moodLabel.text=moodName;
            NSLog(@"%@",moodName);
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didselectMood:)]) {
        [self.delegate didselectMood:moodName];
    }
    
    
    
}


@end
