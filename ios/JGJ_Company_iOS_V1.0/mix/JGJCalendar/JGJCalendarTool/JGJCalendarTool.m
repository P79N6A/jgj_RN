//
//  JGJCalendarTool.m
//  mix
//
//  Created by YJ on 16/7/3.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCalendarTool.h"
#import "NSDate+Extend.h"
#import "JGJAllWebURL.h"
#import "IDJChineseCalendar.h"
#import "IDJCalendarUtil.h"
#define JGJTodayRecommonFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"todayRecommon.data"]
#define TodayRecommonKey @"TodayRecommonModelsKey" //今日推荐三个模型key
#define JGJThisDateKey @"JGJThisDateKey" //存储今日模型可以

@interface JGJCalendarTool ()
@property (nonatomic, strong) NSArray *chineseMonths;
@property (nonatomic, strong) NSArray *chineseDays;
@property (nonatomic, strong) NSArray *upLetterNumbers;
@property (nonatomic, strong) NSArray *icons;//存储今日推荐图片标题
@property (nonatomic, strong) NSArray *titles;//存储今日推荐图片标题
@property (nonatomic, strong) NSArray *addresses;//存储今日推荐地址
@property (nonatomic, strong) JGJTodayRecomModel *todayRecomModel;
@end
@implementation JGJCalendarTool
static JGJCalendarTool *calendarTool;

+ (instancetype)calendarTool {
    if (!calendarTool) {
        calendarTool = [[JGJCalendarTool alloc] init];
    }
    return calendarTool;
}

+ (NSString *)chineseDateYear:(NSString *)year month:(NSString *)month day:(NSString *)day isConvert:(BOOL)isConvert{
    NSString *chineseDay = nil;
    NSString *chineseMonth = nil;
    NSString *chineseDate = nil;
    NSString *leapMonth = @"";
    NSMutableString *chineseYear = [NSMutableString string];
    if (!calendarTool) {
        calendarTool = [[JGJCalendarTool alloc] init];
    }
    NSString *datelowerNumber = nil;
    if (isConvert) {
        for (int i = 0; i < year.length; i ++) {
            datelowerNumber = [year substringWithRange:NSMakeRange(i, 1)];
            NSString *dateUpperString= calendarTool.upLetterNumbers[datelowerNumber.integerValue];
            [chineseYear appendString:dateUpperString];
        }
    }
    if (month.length != 0 && month != nil) {
        
        //        包含月表示是数据库传入，否则为转换的农历月
        if ([month containsString:@"月"]) {
            chineseDate = [NSString stringWithFormat:@"%@ %@ %@",chineseYear, month, day];
            return chineseDate;
        } else {
            
            //            判断是否是大小月
            NSString *flagMonth = nil ;
            //            判断是否闰月
            if ([month containsString:@"-"]) {
                NSArray *arr = [month componentsSeparatedByString:@"-"];
                leapMonth = [arr[0] isEqualToString:@"b"] ? @"闰":@"";
                month = [NSString stringWithFormat:@"%@",arr[1]];
            }
            flagMonth = [calendarTool getCheseMonth:month year:year day:day];//获取大小月
            chineseMonth = [NSString stringWithFormat:@"%@%@", calendarTool.chineseMonths[[month intValue] - 1], flagMonth];
        }
    }
    if (day.length != 0 && day != nil) {
        chineseDay = calendarTool.chineseDays[[day intValue] - 1];
    }
    chineseDate = [NSString stringWithFormat:@"%@  %@%@  %@",chineseYear, leapMonth, chineseMonth, chineseDay];
    return chineseDate;
}

#pragma mark - 获取农历当月总天数判断大小月
- (NSString *)getCheseMonth:(NSString *)month year:(NSString *)year day:(NSString *)day {
    NSUInteger dayLength = 0;
    IDJCalendar *chineseCalendar = [[IDJChineseCalendar alloc]init];
    month = [NSString stringWithFormat:@"a-%@",month];
    dayLength    = [chineseCalendar daysInMonth:month year:[year integerValue]].count;  
    NSString *flagMonth = dayLength >= 30 ? @"大" :@"小";
    return flagMonth;
}

+ (NSMutableAttributedString *)setAllText:(NSString *)allText compare:(NSString *)compareText font:(UIFont *)font {
    NSString *spaceString = @" ";
    if (TYIS_IPHONE_5_OR_LESS) {
        spaceString = @" ";
    }
    if (TYIS_IPHONE_6) {
        spaceString = @"  ";
    }
    if (TYIS_IPHONE_6P) {
        spaceString = @"   ";
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSArray *tags = [allText componentsSeparatedByString:@","];
    for (int i = 0; i < tags.count; i++) {
        NSString *tag = tags[i];
        NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
        [tagText yy_appendString:spaceString];
        tagText.yy_font = font;
        tagText.yy_color = [tag isEqualToString:compareText] ? AppFont207862Color : AppFontb52136Color;
        [text appendAttributedString:tagText];
    }
    return text;
}


#pragma mark - 每天随机生成地址

+ (NSMutableArray *)randomGenerationAddress {
    if (!calendarTool) {
        calendarTool = [[JGJCalendarTool alloc] init];
    }
    NSUInteger count = calendarTool.titles.count;
    NSMutableArray *allModels = [NSMutableArray array];
    for (NSUInteger i = 0; i < calendarTool.titles.count; i ++) {
        JGJTodayRecomModel *recmModel = [[JGJTodayRecomModel alloc] init];
        recmModel.title = calendarTool.titles[i];
        recmModel.icon = calendarTool.icons[i];
        recmModel.address = calendarTool.addresses[i];
        [allModels addObject:recmModel];
    }
    NSMutableArray *todayModels = [NSMutableArray array];
    NSUInteger imageNum = 0;
//    不是同一天随机产生不同的图片和地址
     NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (![calendarTool checkSameDay]) {
        for (int i = 0; i < 3; i ++) {
            imageNum = arc4random() % count ;
            [todayModels addObject:allModels[imageNum]];
            [allModels removeObjectAtIndex:imageNum];
            count --;
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:todayModels];
        [userdefaults setValue:data forKeyPath:TodayRecommonKey];
    }
    todayModels = [NSKeyedUnarchiver unarchiveObjectWithData:[userdefaults objectForKey:TodayRecommonKey]];
    return todayModels;
}

- (BOOL)checkSameDay {
    BOOL isSameDay = NO;
//            转换格式存储数据
    NSString *currentDateString = [NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
    NSDate *currentDate = [NSDate dateFromString:currentDateString withDateFormat:@"yyyy-MM-dd"];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastDate = [userdefaults objectForKey:JGJThisDateKey];
    if (lastDate == nil) {
        [userdefaults setValue:currentDate forKeyPath:JGJThisDateKey];
    }
    if (lastDate != nil) {
        NSUInteger timeInterVal = [NSDate getDaysFrom: currentDate withToDate:lastDate];
        if (timeInterVal != 0) { //判断不是同一天,不是同一天存入当前的值
            [userdefaults setValue:currentDate forKeyPath:JGJThisDateKey];
            isSameDay = NO;
        } else {
            isSameDay = YES;
        }
    }
    return isSameDay;
}

- (NSArray *)chineseDays {

    if (!_chineseDays) {
        _chineseDays=[NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
@"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    }
    return _chineseDays;
}
- (NSArray *)upLetterNumbers {
    
    if (!_upLetterNumbers) {
        
        _upLetterNumbers = @[@"零", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九"];
    }
    return _upLetterNumbers;
}

- (NSArray *)chineseMonths {

    if (!_chineseMonths) {
        
        _chineseMonths = @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                           @"九月", @"十月", @"冬月", @"腊月"];
    }
    return _chineseMonths;
}

- (NSArray *)icons {

    if (!_icons) {
        
        _icons = @[@"calendar_play_Icon",
                   @"calendar_Info",
                   @"calendar_post_message_icon",
                   @"calendar_video_icon",
                   @"calendar_ novel_icon",
                   @"calendar_watch_girl_icon",
                   @"calendar_funny_icon"];
    }
    return _icons;
}

- (NSArray *)titles {

    if (!_titles) {
        
        _titles = @[@"玩游戏\n今天的你运气不错",
                    @"看资讯\n看下资讯 补充知识",
                    @"发消息\n心情不错 讲个故事",
                    @"看视频\n诸事顺利 心情愉快",
                    @"看小说\n阅读能带给你平静的心",
                    @"看美女\n今天的你特别有魅力",
                    @"看段子\n你需要调节一下情绪"];
    }
    return _titles;
}

//- (NSArray *)addresses {
//
//    if (!_addresses) {
//        _addresses = @[@"http://www.doudou.in/",
//                       NewLifeNewsURL,
//                       [JLGHttpRequest_Public stringByAppendingString:MakeFriendWantToSayURL],
//                       @"http://m.tv.sohu.com/",
//                       @"http://m.ireadercity.com/webapp/home/index.html",
//                       NewLifeGalleryURL,
//                       @"http://www.jiongtoutiao.com/m"];
//    }
//    return _addresses;
//}

@end
