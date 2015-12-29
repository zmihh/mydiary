//
//  DiaryTableCell.m
//  MyDiary
//
//  Created by zhouhao on 15-3-24.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "DiaryTableCell.h"
#import "Diary.h"

#define Color(r,g,b)[UIColor colorWithHue:red/255.0 saturation:g/255.0 brightness:b/255.0 alpha:1]//颜色宏定义
#define TabelViewCellControlSpacing 10
//cell的颜色
//

@interface DiaryTableCell(){
    UILabel *_yearLabel;
    UILabel *_monthLabel;
    UILabel *_dayLabel;
    UILabel *_hourLabel;
    UILabel *_weekLabel;
    UILabel *_moonLabel;
    UILabel *_weatherLabel;
    UILabel *_text;
    UILabel *_worldNumber;
    UIImageView *_photo;
    UIImageView *_audio;
    UIImageView *_video;


}

@end

@implementation DiaryTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return  self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)initSubView {
    _hourLabel=[[UILabel alloc]init];
    [self addSubview:_hourLabel];
    
    _dayLabel=[[UILabel alloc]init];
    [self addSubview:_dayLabel];
    
    _monthLabel=[[UILabel alloc]init];
    [self addSubview:_monthLabel];
    
    _yearLabel=[[UILabel alloc]init];
    [self addSubview:_yearLabel];
    
    _weatherLabel=[[UILabel alloc]init];
    [self addSubview:_weatherLabel];
    
    _moonLabel=[[UILabel alloc]init];
    [self addSubview:_moonLabel];
    
    _text=[[UILabel alloc]init];
    _text.numberOfLines=0;
    [self addSubview:_text];
    
    _worldNumber=[[UILabel alloc]init];
    [self addSubview:_worldNumber];
    
    _photo=[[UIImageView alloc]init];
    [self addSubview:_photo];
    
    _audio=[[UIImageView alloc]init];
    [self addSubview:_audio];
    
    _video=[[UIImageView alloc]init];
    [self addSubview:_video];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDiary:(Diary*)diary {
    //CGFloat label
    
}
/*+(CGFloat)makeDiaryTableCell:(Diary*)diary{
    const CGFloat topMargin=35.0f;
    const CGFloat bottomMargin=35.0f;
    const CGFloat minHeight=80.0f;
    UIFont *font=[UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGRect boundingBox=[diary.text boundingRectWithSize:CGSizeMake(202, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    return MAX(minHeight,CGRectGetHeight(boundingBox)+topMargin+bottomMargin);
    
}*/
                            

/*-(void) configDiaryTableCell:(Diary*)diary{
    UILabel *bodyLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    bodyLabel.textAlignment=UITextAlignmentLeft;
    bodyLabel.frame = CGRectMake(20, 10, self.bounds.size.width-40, self.bounds.size.height);
    [self addSubview:bodyLabel];
    UILabel *
    
   

    
}



- (void)configureCellForEntry:(Diary *)diary{
    self.diaryBodyLabel.text = diary.text;
   // self.timeLabel.text = diary.date;
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    
    self.dateLabel.text = [dateFormatter stringFromDate:date];
}*/

@end
