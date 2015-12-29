//
//  fontView.m
//  MyDiary
//
//  Created by zhouhao on 15/4/21.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "fontView.h"
#define NumberFontSize 2
#define NumberFontColor 6
#define Lines 1
#define FontLines 2
#define PictureSize 40
#define LabelSizeWidith 50
#define LabelSizeHeight 20
/*离左侧间距*/
#define EdgeDistance 40
/*上边缘间距*/
#define EdgeInterval 10
#define horizontalInteVal 10

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]




@implementation fontView



- (id)initWithFrame:(CGRect)frame forIndexPath:(NSInteger)index {
    self=[super initWithFrame:frame];
    if (self){
        UILabel *fontSizelabel=[[UILabel alloc]initWithFrame:CGRectMake(EdgeInterval, 10, LabelSizeWidith, LabelSizeHeight)];
        fontSizelabel.text=@"字号";
        [self addSubview:fontSizelabel];
        for (int x=0;x<NumberFontSize;x++){
            
            UIButton* fontSize=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [self addSubview:fontSize];
            [fontSize setFrame:CGRectMake(x*horizontalInteVal+EdgeDistance+x*PictureSize,
                                          10 +LabelSizeHeight, PictureSize,
                                          PictureSize)];
            long fontID=x+1;
            NSString *imageStr = [NSString stringWithFormat:@"fontSize_%ld@2x.png",fontID];
            [fontSize setBackgroundImage:[UIImage imageNamed:imageStr]
                                forState:UIControlStateNormal];
            fontSize.tag =fontID;
            [fontSize addTarget:self
                         action:@selector(fontSizeClick:)
               forControlEvents:UIControlEventTouchUpInside];
            [fontSize.layer setMasksToBounds:YES];
            [fontSize.layer setCornerRadius:8.0]; //设置矩圆角半径
            [fontSize.layer setBorderWidth:1.0];   //边框宽度
            
            
            [fontSize.layer setBorderColor:(__bridge CGColorRef)([UIColor grayColor])];//边框颜色
            
        }
        UILabel *fontColor=[[UILabel alloc]initWithFrame:CGRectMake(EdgeInterval, LabelSizeHeight+PictureSize+20, LabelSizeWidith, LabelSizeHeight)];
        fontColor.text=@"颜色";
        [self addSubview:fontColor];
        CGFloat font_HorizontalInteVal= (CGRectGetWidth(self.bounds)-EdgeInterval*2-NumberFontColor*PictureSize)/(NumberFontColor-1);
        for (int y=0; y<NumberFontColor; y++) {
            UIButton* fontColor=[UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:fontColor];
            [fontColor setFrame:CGRectMake(y*font_HorizontalInteVal+EdgeInterval+y*PictureSize, 2*LabelSizeHeight+PictureSize+30, PictureSize, PictureSize)];
            [fontColor addTarget:self action:@selector(fontColorClick:) forControlEvents:UIControlEventTouchUpInside];
            if (y==0) {
                fontColor.backgroundColor=[UIColor blackColor];
            }
            else if (y==1) {
                fontColor.backgroundColor=[UIColor whiteColor];
            }
            else if(y==2){
                fontColor.backgroundColor=[UIColor redColor];
            }
            else if(y==3){
                fontColor.backgroundColor=[UIColor blueColor];
            }
            else if(y==4){
                fontColor.backgroundColor=[UIColor greenColor];
            }
            else if(y==5){
                fontColor.backgroundColor=[UIColor yellowColor];
            }
            //fontColor.backgroundColor=UIColorFromRGB(0x0000+y*2000);
            //[fontColor setBackgroundColor:[UIColor redColor]];
            [fontColor.layer setMasksToBounds:YES];
            [fontColor.layer setCornerRadius:8.0];
            [fontColor.layer setBorderWidth:2.0];
            [fontColor.layer setBorderColor:(__bridge CGColorRef)([UIColor blackColor])];//边框颜色
            
            
        }
        
        // }
        
    }
    return self;
    
}



- (void)fontSizeClick:(UIButton*)button {
    
    NSString *fontSize = [NSString stringWithFormat:@"fontSize_%ld@2x.png",button.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFontSize:)]) {
        [self.delegate didSelectFontSize:fontSize];
    }
    
    
    
}

- (void)fontColorClick:(UIButton*)button {
    UIColor *color=button.backgroundColor;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didselectFontColor:)]) {
        [self.delegate didselectFontColor:color];
    
    }
}


@end
