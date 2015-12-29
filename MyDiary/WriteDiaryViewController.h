//
//  WriteDiaryViewController.h
//  MyDiary
//
//  Created by zhouhao on 15-3-8.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Diary.h"
#import "weatherAndMoodViewController.h"
#import "manageBackgroundView.h"
#import "manageFontView.h"
#import "PhotoViewController.h"
#import "videoViewController.h"
#import "AudioViewController.h"

typedef NS_ENUM(NSInteger,MessageViewState) {
    MessageViewStateShowBackground,
    MessageViewStateShowShare,
    MessageViewStateShowNone,
};

@interface WriteDiaryViewController : UIViewController<UITextViewDelegate,ViewPassValueDelegate,viewPassValueDelagate,videoPassValueDelegate,audioPassDeleagte>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;
@property (weak, nonatomic) IBOutlet UILabel *datelabel;
//@property (weak, nonatomic) IBOutlet UIImageView *background;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTextConstraints;

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property(nonatomic, assign) UIEdgeInsets textContainerInset;
@property (weak, nonatomic) IBOutlet UIToolbar*toolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
//@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;

@property (weak, nonatomic) IBOutlet UIButton *vidoButton;

@property (weak, nonatomic) IBOutlet UIButton *audioButton;

@property(strong,nonatomic)manageBackgroundView* backgroundView;
@property(strong,nonatomic)manageFontView*fontView;
@property(strong,nonatomic)UIImageView* background;
@property(strong,nonatomic)UIImage *photo;
@property(strong,nonatomic)UIImage *videoImage;
@property(strong,nonatomic)UIImage *backgroundImage;

@property (weak, nonatomic) IBOutlet UIButton *weatherButton;

@property (weak, nonatomic) IBOutlet UIButton *moodButton;


@property(nonatomic,strong) Diary* diary;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSDate *nowDate;
@property(nonatomic,strong) NSString *textString;
@property(nonatomic,strong) NSString *weatherName;
@property(nonatomic,strong) NSString *moondName;
@property(nonatomic,strong) NSString *videoUrl;
@property(nonatomic,strong) NSData* audioData;
@property(nonatomic,strong) NSString *photoPath;
@property(nonatomic,strong) NSString *audioUrls;
@property(nonatomic,strong)NSString* backName;

- (void)backPressed;
- (void)doneWasPressed;
@end
