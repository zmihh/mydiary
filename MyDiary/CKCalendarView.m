//
// Copyright (c) 2012 Jason Kozemczak
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//


#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKCalendarView.h"
#import "DiaryListTableViewController.h"
#import "Diary.h"
#import "DiaryStore.h"

#define BUTTON_MARGIN 4
#define CALENDAR_MARGIN 5
#define TOP_HEIGHT 44
#define DAYS_HEADER_HEIGHT 22
#define DEFAULT_CELL_WIDTH 43
#define CELL_BORDER_WIDTH 1

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@class CALayer;
@class CAGradientLayer;

@interface GradientView : UIView

@property(nonatomic, strong, readonly) CAGradientLayer *gradientLayer;

- (void)setColors:(NSArray *)colors;


@end

@implementation GradientView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

- (void)setColors:(NSArray *)colors {
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    self.gradientLayer.colors = cgColors;
}

@end


@interface DateButton : UIButton

@property (nonatomic, strong) NSDate *date;

@end

@implementation DateButton

//获取每个button是一个月中的第几天
- (void)setDate:(NSDate *)aDate {
    _date = aDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"d";
    [self setTitle:[dateFormatter stringFromDate:_date] forState:UIControlStateNormal];
}

@end


@interface CKCalendarView ()

@property(nonatomic, strong) UIView *highlight;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *prevButton;
@property(nonatomic, strong) UIButton *nextButton;
@property(nonatomic, strong) UIView *calendarContainer;
@property(nonatomic, strong) GradientView *daysHeader;
@property(nonatomic, strong) NSArray *dayOfWeekLabels;
@property(nonatomic, strong) NSMutableArray *dateButtons;
@property(nonatomic,strong) NSMutableArray *haveDiaryDateButtons;


@property (nonatomic) startDay calendarStartDay;
@property (nonatomic, strong) NSDate *monthShowing;
@property (nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, assign) CGFloat cellWidth;
@property(nonatomic,strong)NSFetchedResultsController*  fetchedResultsController;

@end

@implementation CKCalendarView



- (id)init {
    return [self initWithStartDay:startSunday];
}

- (id)initWithStartDay:(startDay)firstDay {
    self.calendarStartDay = firstDay;
    return [self initWithFrame:CGRectMake(0, 0, 320, 320)];
}

- (id)initWithStartDay:(startDay)firstDay frame:(CGRect)frame {
    self.calendarStartDay = firstDay;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [self.calendar setLocale:[NSLocale currentLocale]]; 
        [self.calendar setFirstWeekday:self.calendarStartDay];
        self.cellWidth = DEFAULT_CELL_WIDTH;
        
        //最外边框的弧度
        self.layer.cornerRadius = 0.0f;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        //设计阴影
        self.layer.shadowRadius = 2.0f;
        self.layer.shadowOpacity = 0.4f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.0f;
        
        // set the frame of header
        UIView *highlight = [[UIView alloc] initWithFrame:CGRectZero];
        //highlight.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        highlight.backgroundColor =UIColorFromRGB(0xc73302);
        // 边角的弧度
        highlight.layer.cornerRadius = 6.0f;
        [self addSubview:highlight];
        self.highlight = highlight;

        // SET UP THE HEADER
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        //titleLabel.backgroundColor= UIColorFromRGB(0xc73302);
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
       
        // 设置月份上移的按钮
        UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [prevButton setImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
        prevButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [prevButton addTarget:self action:@selector(moveCalendarToPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:prevButton];
        self.prevButton = prevButton;
        
        //设置月份下移按钮
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setImage:[UIImage imageNamed:@"right_arrow.png"] forState:UIControlStateNormal];
        nextButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [nextButton addTarget:self action:@selector(moveCalendarToNextMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
        self.nextButton = nextButton;

        // THE CALENDAR ITSELF
        UIView *calendarContainer = [[UIView alloc] initWithFrame:CGRectZero];
        calendarContainer.layer.borderWidth = 1.0f;
       // calendarContainer.layer.borderColor = [UIColor clearColor].CGColor;
        calendarContainer.layer.borderColor=UIColorFromRGB(0xc73302).CGColor;
        calendarContainer.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        calendarContainer.layer.cornerRadius = 6.0f;
        calendarContainer.clipsToBounds = YES;
        [self addSubview:calendarContainer];
        self.calendarContainer = calendarContainer;

        GradientView *daysHeader = [[GradientView alloc] initWithFrame:CGRectZero];
        daysHeader.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.calendarContainer addSubview:daysHeader];
        self.daysHeader = daysHeader;

        NSMutableArray *labels = [NSMutableArray array];
        for (NSString *day in [self getDaysOfTheWeek]) {
            UILabel *dayOfWeekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            dayOfWeekLabel.text = [day uppercaseString];
            dayOfWeekLabel.textAlignment =NSTextAlignmentCenter;
            //dayOfWeekLabel.backgroundColor = [UIColor clearColor];
            dayOfWeekLabel.backgroundColor=UIColorFromRGB(0xc73302);
            //dayOfWeekLabel.shadowColor = [UIColor whiteColor];
            //dayOfWeekLabel.shadowOffset = CGSizeMake(0, 1);
            [labels addObject:dayOfWeekLabel];
            [self.calendarContainer addSubview:dayOfWeekLabel];
        }
        self.dayOfWeekLabels = labels;

        // at most we'll need 42 buttons, so let's just bite the bullet and make them now...
        NSMutableArray *dateButtons = [NSMutableArray array];
        dateButtons = [NSMutableArray array];
        for (int i = 0; i < 43; i++) {
            DateButton *dateButton = [DateButton buttonWithType:UIButtonTypeCustom];
        

            [dateButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            
            [dateButton addTarget:self action:@selector(dateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [dateButtons addObject:dateButton];
        }
        self.dateButtons = dateButtons;

        // initialize the thing
        self.monthShowing = [NSDate date];
        [self setDefaultStyle];
    }

    [self layoutSubviews]; // TODO: this is a hack to get the first month to show properly
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat containerWidth = self.bounds.size.width - (CALENDAR_MARGIN * 2);
    self.cellWidth = (containerWidth / 7.0) - CELL_BORDER_WIDTH;

    CGFloat containerHeight = ([self numberOfWeeksInMonthContainingDate:self.monthShowing] * (self.cellWidth + CELL_BORDER_WIDTH) + DAYS_HEADER_HEIGHT);


    CGRect newFrame = self.frame;
    newFrame.size.height = containerHeight + CALENDAR_MARGIN + TOP_HEIGHT;
    self.frame = newFrame;

    self.highlight.frame = CGRectMake(1, 1, self.bounds.size.width - 2, 1);

    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, TOP_HEIGHT);
    self.prevButton.frame = CGRectMake(BUTTON_MARGIN, BUTTON_MARGIN, 48, 38);
    self.nextButton.frame = CGRectMake(self.bounds.size.width - 48 - BUTTON_MARGIN, BUTTON_MARGIN, 48, 38);

    self.calendarContainer.frame = CGRectMake(CALENDAR_MARGIN, CGRectGetMaxY(self.titleLabel.frame), containerWidth, containerHeight);
    self.daysHeader.frame = CGRectMake(0, 0, self.calendarContainer.frame.size.width, DAYS_HEADER_HEIGHT);

    CGRect lastDayFrame = CGRectZero;
    for (UILabel *dayLabel in self.dayOfWeekLabels) {
        dayLabel.frame = CGRectMake(CGRectGetMaxX(lastDayFrame) + CELL_BORDER_WIDTH, lastDayFrame.origin.y, self.cellWidth, self.daysHeader.frame.size.height);
        lastDayFrame = dayLabel.frame;
    }

    for (DateButton *dateButton in self.dateButtons) {
        [dateButton removeFromSuperview];
    }

    NSDate *date = [self firstDayOfMonthContainingDate:self.monthShowing];
   

    uint dateButtonPosition = 0;
    while ([self dateIsInMonthShowing:date]) {
        //[self setDefaultStyle];
        
        DateButton *dateButton = [self.dateButtons objectAtIndex:dateButtonPosition];
        dateButton.date = date;
        NSString* title=dateButton.titleLabel.text;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
        [dateButton setAttributedTitle:str forState:UIControlStateNormal];
        
       [dateButton setTitle:[NSString stringWithFormat:@"%@",title ] forState:UIControlStateNormal];
        
      
        if ([self haveDiaryByDate:dateButton.date]){
            // [self.haveDiaryDateButtons addObject:dateButton];
            NSString* title=dateButton.titleLabel.text;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
            NSRange strRange = {0,[str length]};
            //[str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:strRange];  //设置颜色
            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
            [dateButton setAttributedTitle:str forState:UIControlStateNormal];
            //[dateButton setTitle:[NSString stringWithFormat:@"%@*", title] forState:UIControlStateNormal];
            
            
        }
       

        if ([dateButton.date isEqualToDate:self.selectedDate]) {
            dateButton.backgroundColor = self.selectedDateBackgroundColor;
          
            [dateButton setTitleColor:self.selectedDateTextColor forState:UIControlStateNormal];
        }
        else if ([self dateIsToday:dateButton.date]) {
            [dateButton setTitleColor:self.currentDateTextColor forState:UIControlStateNormal];
            dateButton.backgroundColor = self.currentDateBackgroundColor;
            
        }
        
        else {
            dateButton.backgroundColor = [self dateBackgroundColor];
            [dateButton setTitleColor:[self dateTextColor] forState:UIControlStateNormal];
           
            //[self drawRect:dateButton.frame];
            
        }

        dateButton.frame = [self calculateDayCellFrame:date];

        [self.calendarContainer addSubview:dateButton];

        date = [self nextDay:date];
        dateButtonPosition++;
    }
}

- (BOOL)haveDiaryByDate:(NSDate*)date{
    NSCalendar *newCalendar = [NSCalendar currentCalendar];
    
    //gather date components from date
    NSDateComponents *dateComponents=[newCalendar components:NSYearCalendarUnit |NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    //set date components
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate* startofDay=[newCalendar dateFromComponents:dateComponents];
    NSDateComponents *dateComponents_1=[newCalendar components:NSYearCalendarUnit |NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    //set date components
    [dateComponents_1 setHour:23];
    [dateComponents_1 setMinute:59];
    [dateComponents_1 setSecond:59];
    NSDate* endofDay=[newCalendar dateFromComponents:dateComponents_1];
    
    DiaryStore *diaryStack = [DiaryStore defaultStack];
    _fetchedResultsController=[[DiaryStore defaultStack]createfetchedResultsController];
    NSFetchRequest *fetchRequest = _fetchedResultsController.fetchRequest;
    fetchRequest.predicate=[NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)" ,startofDay, endofDay, nil];
    
    NSArray *array=[diaryStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if ([array count]) {
        return true;
    }
    
    return false;
}

/*- (void) drawRect:(CGRect)rect {
    NSInteger dateButtonPosition;
    NSLog(@"%ld",[self.haveDiaryDateButtons count]);
    for (dateButtonPosition=0; dateButtonPosition<[self.haveDiaryDateButtons count]; dateButtonPosition++) {
   
    DateButton *dateButton = [self.haveDiaryDateButtons objectAtIndex:dateButtonPosition];
    //DateButton *dateButton = [self.dateButtons objectAtIndex:dateButtonPosition];
    //for (DateButton *dateButton in self.haveDiaryDateButtons) {
    NSLog(@"jjjjss");
    CGRect textRect = dateButton.frame;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
   // CGFloat descender = dateButton.font.descender;
    if([lineColor isKindOfClass:[UIColor class]]){
        CGContextSetStrokeColorWithColor(contextRef, lineColor.CGColor);
    }
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height +1);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height+1);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
    }
}*/

- (void)setMonthShowing:(NSDate *)aMonthShowing {
    _monthShowing = aMonthShowing;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM YYYY";
    self.titleLabel.text = [dateFormatter stringFromDate:aMonthShowing];
    [self setNeedsLayout];
}

- (void)setDefaultStyle {
    //self.backgroundColor = UIColorFromRGB(0x393B40);
     self.backgroundColor=[UIColor clearColor];
    //[self setTitleColor:[UIColor whiteColor]];
    [self setTitleColor:UIColorFromRGB(0xc73302)];
    [self setTitleFont:[UIFont boldSystemFontOfSize:17.0]];

    [self setDayOfWeekFont:[UIFont boldSystemFontOfSize:12.0]];
    [self setDayOfWeekTextColor:UIColorFromRGB(0x999999)];
    [self setDayOfWeekBottomColor:UIColorFromRGB(0xCCCFD5) topColor:[UIColor whiteColor]];

    [self setDateFont:[UIFont boldSystemFontOfSize:16.0f]];
    [self setDateTextColor:UIColorFromRGB(0x393B40)];
    [self setDateBackgroundColor:UIColorFromRGB(0xF2F2F2)];
    [self setDateBorderColor:UIColorFromRGB(0xDAE1E6)];

    [self setSelectedDateTextColor:UIColorFromRGB(0xF2F2F2)];
   // [self setSelectedDateBackgroundColor:UIColorFromRGB(0x88B6DB)];
    [self setSelectedDateBackgroundColor:[UIColor lightGrayColor]];

    [self setCurrentDateTextColor:UIColorFromRGB(0xF2F2F2)];
    //[self setCurrentDateBackgroundColor:[UIColor lightGrayColor]];
    [self setCurrentDateBackgroundColor:UIColorFromRGB(0xab2d03)];
}

- (CGRect)calculateDayCellFrame:(NSDate *)date {
    int row = [self weekNumberInMonthForDate:date] - 1;
    int placeInWeek = (([self dayOfWeekForDate:date] - 1) - self.calendar.firstWeekday + 8) % 7;

    return CGRectMake(placeInWeek * (self.cellWidth + CELL_BORDER_WIDTH), (row * (self.cellWidth + CELL_BORDER_WIDTH)) + CGRectGetMaxY(self.daysHeader.frame) + CELL_BORDER_WIDTH, self.cellWidth, self.cellWidth);
}

- (void)moveCalendarToNextMonth {
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    [comps setMonth:1];
    self.monthShowing = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];
}

- (void)moveCalendarToPreviousMonth {
    //self.monthShowing = [[self firstDayOfMonthContainingDate:self.monthShowing] dateByAddingTimeInterval:-100000];
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    [comps setMonth:-1];
    self.monthShowing = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];

}

- (void)dateButtonPressed:(id)sender {
    DateButton *dateButton = sender;
    self.selectedDate = dateButton.date;
    [self.delegate calendar:self didSelectDate:self.selectedDate];
    [self setNeedsLayout];
   
}
   


#pragma mark - Theming getters/setters

- (void)setTitleFont:(UIFont *)font {
    self.titleLabel.font = font;
}
- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (void)setTitleColor:(UIColor *)color {
    self.titleLabel.textColor = color;
}
- (UIColor *)titleColor {
    return self.titleLabel.textColor;
}

- (void)setButtonColor:(UIColor *)color {
    [self.prevButton setImage:[CKCalendarView imageNamed:@"left_arrow.png" withColor:color] forState:UIControlStateNormal];
    [self.nextButton setImage:[CKCalendarView imageNamed:@"right_arrow.png" withColor:color] forState:UIControlStateNormal];
}

- (void)setInnerBorderColor:(UIColor *)color {
    self.calendarContainer.layer.borderColor = color.CGColor;
}

- (void)setDayOfWeekFont:(UIFont *)font {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.font = font;
    }
}
- (UIFont *)dayOfWeekFont {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).font : nil;
}

- (void)setDayOfWeekTextColor:(UIColor *)color {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.textColor = color;
    }
}
- (UIColor *)dayOfWeekTextColor {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).textColor : nil;
}

- (void)setDayOfWeekBottomColor:(UIColor *)bottomColor topColor:(UIColor *)topColor {
    [self.daysHeader setColors:[NSArray arrayWithObjects:topColor, bottomColor, nil]];
}

- (void)setDateFont:(UIFont *)font {
    for (DateButton *dateButton in self.dateButtons) {
        dateButton.titleLabel.font = font;
    }
}
- (UIFont *)dateFont {
    return (self.dateButtons.count > 0) ? ((DateButton *)[self.dateButtons lastObject]).titleLabel.font : nil;
}

- (void)setDateTextColor:(UIColor *)color {
    for (DateButton *dateButton in self.dateButtons) {
        [dateButton setTitleColor:color forState:UIControlStateNormal];
    }
}
- (UIColor *)dateTextColor {
    return (self.dateButtons.count > 0) ? [((DateButton *)[self.dateButtons lastObject]) titleColorForState:UIControlStateNormal] : nil;
}

- (void)setDateBackgroundColor:(UIColor *)color {
    for (DateButton *dateButton in self.dateButtons) {
        dateButton.backgroundColor = color;
    }
}
- (UIColor *)dateBackgroundColor {
    return (self.dateButtons.count > 0) ? ((DateButton *)[self.dateButtons lastObject]).backgroundColor : nil;
}

- (void)setDateBorderColor:(UIColor *)color {
    self.calendarContainer.backgroundColor = color;
}
- (UIColor *)dateBorderColor {
    return self.calendarContainer.backgroundColor;
}

#pragma mark - Calendar helpers

- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comps setDay:1];
    return [self.calendar dateFromComponents:comps];
}

- (NSArray *)getDaysOfTheWeek {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // adjust array depending on which weekday should be first
    NSArray *weekdays = [dateFormatter shortWeekdaySymbols];
    NSUInteger firstWeekdayIndex = [self.calendar firstWeekday] -1;
    if (firstWeekdayIndex > 0){
        weekdays = [[weekdays subarrayWithRange:NSMakeRange(firstWeekdayIndex, 7-firstWeekdayIndex)]
                    arrayByAddingObjectsFromArray:[weekdays subarrayWithRange:NSMakeRange(0,firstWeekdayIndex)]];
    }
    return weekdays;
}

- (int)dayOfWeekForDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:NSWeekdayCalendarUnit fromDate:date];
    return(int)comps.weekday;
}

- (BOOL)dateIsToday:(NSDate *)date {
    NSDateComponents *otherDay = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *today = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    return ([today day] == [otherDay day] &&
            [today month] == [otherDay month] &&
            [today year] == [otherDay year] &&
            [today era] == [otherDay era]);
}

- (int)weekNumberInMonthForDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSWeekOfMonthCalendarUnit) fromDate:date];
    return (int)comps.weekOfMonth;
}

- (int)numberOfWeeksInMonthContainingDate:(NSDate *)date {
    return (int)[self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

- (BOOL)dateIsInMonthShowing:(NSDate *)date {
    NSDateComponents *comps1 = [self.calendar components:(NSMonthCalendarUnit) fromDate:self.monthShowing];
    NSDateComponents *comps2 = [self.calendar components:(NSMonthCalendarUnit) fromDate:date];
    return comps1.month == comps2.month;
}

- (NSDate *)nextDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color {
    UIImage *img = [UIImage imageNamed:name];

    UIGraphicsBeginImageContext(img.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];

    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);

    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);

    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return coloredImg;
}

@end