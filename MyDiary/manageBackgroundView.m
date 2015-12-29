//
//  manageBackgroundView.m
//  MyDiary
//
//  Created by zhouhao on 15/4/22.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "manageBackgroundView.h"
#import "backgroundView.h"


#define FaceSectionBarHeight  36   // 表情下面控件
#define BackgroundPageControlHeight 30  // 表情pagecontrol

#define Pages 2

@implementation manageBackgroundView {
    UIPageControl *pageControl;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor=[UIColor colorWithRed:248.0f/255 green:248.f/255 blue:255.0f/255 alpha:1.0];
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0.0f,0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)-BackgroundPageControlHeight-FaceSectionBarHeight)];
                                                                
    scrollView.delegate = self;
    [self addSubview:scrollView];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.frame)*Pages, CGRectGetHeight(scrollView.frame))];
    for (int i=0;i<Pages;i++){
        backgroundView *backView=[[backgroundView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(self.bounds),0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(scrollView.bounds)) forIndexPath:i];
        [scrollView addSubview:backView];
        backView.delegate=self;
    }
    pageControl=[[UIPageControl alloc]init];
    [pageControl setFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame), CGRectGetWidth(self.bounds),BackgroundPageControlHeight)];
    [self addSubview:pageControl];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
    pageControl.numberOfPages=Pages;
    pageControl.currentPage   = 0;
    //ZBExpressionSectionBar *sectionBar = [[ZBExpressionSectionBar alloc]initWithFrame:CGRectMake(0.0f,CGRectGetMaxY(pageControl.frame),CGRectGetWidth(self.bounds), FaceSectionBarHeight)];
    //[self addSubview:sectionBar];
}

#pragma mark  scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int page = scrollView.contentOffset.x/(CGRectGetWidth(self.bounds));
    pageControl.currentPage = page;
    
}

#pragma mark backgroundView Delegate
- (void)didSelectBackground:(NSString *)backgroundName {
    
    if ([self.delegate respondsToSelector:@selector(setBackground:) ]) {
        [self.delegate setBackground:backgroundName];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
