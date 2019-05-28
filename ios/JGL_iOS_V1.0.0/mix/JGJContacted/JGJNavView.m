//
//  JGJNavView.m
//  mix
//
//  Created by Tony on 2017/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJNavView.h"
#import "JGJRecordsViewController.h"
@implementation JGJNavView
-(void)awakeFromNib
{
    [super awakeFromNib];

}
-(instancetype)initWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor clearColor];
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}
- (IBAction)ClickDownButton:(id)sender {
    [[JGJRecordsViewController new] ClickDownButton];
    
}
-(void)loadView{
    
    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"NavTitleView" owner:nil options:nil]firstObject];
    [view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];

    _monthLables = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.frame)-40, 20)];
    _monthLables.textAlignment = NSTextAlignmentCenter;
    _monthLables.font = [UIFont systemFontOfSize:14];
    _monthLables.textColor = AppFont999999Color;

    [self addSubview:_monthLables];
    
    _weekLables = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_monthLables.frame), CGRectGetWidth(self.frame)-40, 20)];
    _weekLables.textAlignment = NSTextAlignmentCenter;
    _weekLables.font = [UIFont systemFontOfSize:13];
    _weekLables.textColor = AppFont999999Color;
    [self addSubview:_weekLables];
    [self addSubview:view];
}

-(void)setTimeDate:(NSDate *)timeDate
{

    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateTime = [formatter stringFromDate:timeDate];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[timeDate description] substringToIndex:10];
    
     _monthLables.text = dateTime;
  
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now = timeDate;
    
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger interger = [comps weekday];
    if ([dateString isEqualToString:todayString])
    {
        switch (interger) {
            case 1:
                _weekLables.text = [@"星期日" stringByAppendingString:@" (今天)"];
                break;
            case 2:
                _weekLables.text = [@"星期一" stringByAppendingString:@" (今天)"];
                
                break;
            case 3:
                _weekLables.text = [@"星期二" stringByAppendingString:@" (今天)"];
                break;
            case 4:
                _weekLables.text = [@"星期三" stringByAppendingString:@" (今天)"];
                break;
            case 5:
                _weekLables.text = [@"星期四" stringByAppendingString:@" (今天)"];
                break;
            case 6:
                _weekLables.text = [@"星期五" stringByAppendingString:@" (今天)"];
                break;
            case 7:
                _weekLables.text = [@"星期六" stringByAppendingString:@" (今天)"];
                break;
            default:
                break;
        }

        if (_weekLables.text.length >4) {
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_weekLables.text];
       
            [attrStr addAttribute:NSForegroundColorAttributeName
                        value:AppFontd7252cColor
                        range:NSMakeRange(_weekLables.text.length - 3, 2)];
            _weekLables.attributedText = attrStr;
  
        }
   
    }else{
        
        switch (interger) {
            case 1:
                _weekLables.text = @"星期日" ;
                break;
            case 2:
                _weekLables.text = @"星期一";
                
                break;
            case 3:
                _weekLables.text = @"星期二";
                break;
            case 4:
                _weekLables.text = @"星期三";
                break;
            case 5:
                _weekLables.text = @"星期四";
                break;
            case 6:
                _weekLables.text = @"星期五";
                break;
            case 7:
                _weekLables.text = @"星期六";
                break;
            default:
                break;
        }

        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
