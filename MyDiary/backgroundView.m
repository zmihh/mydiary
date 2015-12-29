//
//  backgroundView.m
//  MyDiary
//
//  Created by zhouhao on 15/4/21.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "backgroundView.h"
#define NumberPerLine 4
#define Lines 2
#define PictureSize 55
/*离两侧间距*/
#define EdgeDistance 10
/*上下边缘间距*/
#define EdgeInterval 5



@implementation backgroundView
- (id)initWithFrame:(CGRect)frame forIndexPath:(NSInteger)index {
    self=[super initWithFrame:frame];
    if (self){
        // 水平间隔
        CGFloat horizontalInteVal= (CGRectGetWidth(self.bounds)-2*EdgeDistance-NumberPerLine*PictureSize)/(NumberPerLine-1);
        //垂直间隔
        CGFloat verticalInterval=(CGRectGetHeight(self.bounds)-EdgeInterval*2-Lines*PictureSize)/(Lines-1);
        for (int y=0;y<Lines;y++){
            for (int x=0;x<NumberPerLine;x++){
                UIButton* backgroundButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                [self addSubview:backgroundButton];
                [backgroundButton setFrame:CGRectMake(x*horizontalInteVal+EdgeDistance+x*PictureSize,
                                                      y*verticalInterval+y*PictureSize+EdgeInterval, PictureSize,
                                                         PictureSize)];
                long backgroundID=index*8+y*4+x+1;
                NSString *imageStr = [NSString stringWithFormat:@"background_%ld@2x.png",backgroundID];
                [backgroundButton setBackgroundImage:[UIImage imageNamed:imageStr]
                                            forState:UIControlStateNormal];
                backgroundButton.tag =backgroundID;
                [backgroundButton addTarget:self
                                     action:@selector(backgroundClick:)
                           forControlEvents:UIControlEventTouchUpInside];
                [backgroundButton.layer setMasksToBounds:YES];
                [backgroundButton.layer setCornerRadius:8.0]; //设置矩圆角半径
                [backgroundButton.layer setBorderWidth:1.0];   //边框宽度
                //CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                //CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
                //[backgroundButton.layer setBorderColor:(__bridge CGColorRef)([UIColor lightGrayColor])];//边框颜色
                //self.imageName=imageStr;
               
              
                [backgroundButton.layer setBorderColor:(__bridge CGColorRef)([UIColor lightGrayColor])];//边框颜色
            
            }
        }
        
    }
    return self;
    
}

- (void)backgroundClick:(UIButton*)button {
 
    NSString *imageName = [NSString stringWithFormat:@"background_%ld@2x.png",button.tag];
    button.selected=YES;
    /*if (button.selected) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 128, 0, 0, 128});
        [button.layer setBorderColor:colorref];//边框颜色
        
    }*/
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBackground:)]) {
        [self.delegate didSelectBackground:imageName];
    }
    
    
    
}

@end
