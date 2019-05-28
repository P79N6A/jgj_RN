//
//  FSCalendarCell.m
//  Pods
//
//  Created by Wenchao Ding on 12/3/15.
//
//

#import "FSCalendarCell.h"
#import "FSCalendar.h"
#import "UIView+FSExtension.h"
#import "FSCalendarDynamicHeader.h"
#import "FSCalendarConstance.h"
#import "UILabel+GNUtil.h"
#import "NSDate+Extend.h"
@interface FSCalendarCell ()
@property (readonly, nonatomic) UIColor *colorForBackgroundLayer;
@property (readonly, nonatomic) UIColor *colorForTitleLabel;
@property (readonly, nonatomic) UIColor *colorForSubtitleLabel;
@property (readonly, nonatomic) UIColor *colorForCellBorder;
@property (readonly, nonatomic) UILabel *topLable;
@property (strong, nonatomic) NSMutableArray *imageArr;

@property (readonly, nonatomic) FSCalendarCellShape cellShape;
@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;// 当前显示单位方式

@property (nonatomic, strong) UILabel *overTimeLabel;// 加班时长

@property (nonatomic, strong) UIImageView *noteStartImageView;//记事本有数据时的星星
@property (nonatomic, strong) UIView *noteListRecordView;//记事本有数据是的背景

@property (nonatomic, strong) UIImageView *moreDaySelectedContractorView;

@end

@implementation FSCalendarCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpView];
        
    }
    return self;
}

//2.1.0添加修改
- (void)setUpView{
    _needsAdjustingViewFrame = YES;
    
    UILabel *label;
    CAShapeLayer *shapeLayer;
    UIImageView *imageView;
    FSCalendarEventIndicator *eventView;
    
    _noteListRecordView = [[UIView alloc] initWithFrame:CGRectZero];
    _noteListRecordView.backgroundColor = AppFont1B71D2Color;
    _noteListRecordView.hidden = YES;
    _noteListRecordView.clipsToBounds = YES;
    [self.contentView addSubview:self.noteListRecordView];
    
    _placeView = [[UIView alloc]initWithFrame:CGRectZero];
    _placeView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_placeView];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    
    YYLabel *yy_label = [[YYLabel alloc] init];
    if (TYIS_IPHONE_5_OR_LESS) {
        
        yy_label.frame = CGRectMake(self.fs_width - 25, 5, 22, 13);
        
    }else {
        
        yy_label.frame = CGRectMake(self.fs_width - 28, 5, 25, 13);
        
    }
    yy_label.font = FONT(8);
    yy_label.textContainerInset = UIEdgeInsetsMake(1, 0, 0, 0);
    yy_label.textAlignment = NSTextAlignmentCenter;
    yy_label.clipsToBounds = YES;
    yy_label.layer.cornerRadius = 6;
    yy_label.backgroundColor = AppFontEB4E4EColor;

    yy_label.textColor = [UIColor whiteColor];
    yy_label.text = @"今天";
    [self.contentView addSubview:yy_label];
    self.todayLable = yy_label;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    self.subtitleLabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    self.overTimeLabel = label;
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.hidden = YES;
    [self.contentView.layer insertSublayer:shapeLayer below:_titleLabel.layer];
    self.backgroundLayer = shapeLayer;
    
    eventView = [[FSCalendarEventIndicator alloc] initWithFrame:CGRectZero];
    eventView.backgroundColor = [UIColor clearColor];
    eventView.hidden = YES;
    [self.contentView addSubview:eventView];
    self.eventIndicator = eventView;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    [self.contentView bringSubviewToFront:imageView];
    self.subImageView = imageView;
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    self.upleftimageView = imageView;
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    self.uprightimageView = imageView;
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    self.downleftimageView = imageView;
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    self.downrightimageView = imageView;
    
    //右上角的已经记过帐的图标
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    self.recordedImageView = imageView;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    self.leftRecordedImageView = imageView;
    self.leftRecordedImageView.hidden = YES;
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    self.rightRecordedImageView = imageView;
    self.rightRecordedImageView.hidden = YES;
    
    
    _noteStartImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _noteStartImageView.image = IMAGE(@"notepadCanledarStar");
    _noteStartImageView.hidden = YES;
    [self.contentView addSubview:self.noteStartImageView];
    
    
    _moreDaySelectedContractorView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _moreDaySelectedContractorView.hidden = YES;
    [self.contentView addSubview:self.moreDaySelectedContractorView];
    
    _imageArr = [NSMutableArray arrayWithObjects:@"",@"calendar_weather_Clear",@"calendar_weather_Overcast",@"calendar_weather_cloudy",@"calendar_weather_rain",@"calendar_weather_wind",@"calendar_weather_snow",@"calendar_weather_fog",@"calendar_weather_haze",@"calendar_weather_frost",@"calendar_weather_power-outage", nil];
    
    self.clipsToBounds = NO;
    self.contentView.clipsToBounds = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    CGFloat titleHeight = self.bounds.size.height*5.0/6.0;
    CGFloat diameter = MIN(titleHeight,self.bounds.size.width);
    diameter = diameter > FSCalendarStandardCellDiameter ? (diameter - (diameter-FSCalendarStandardCellDiameter)*0.5) : diameter;
#pragma mark -刘远强修改城到边缘
    _backgroundLayer.frame = self.bounds;
    
    _backgroundLayer.borderWidth = 1.5;
    _backgroundLayer.borderColor = [UIColor clearColor].CGColor;//边框
    
    
    CGFloat eventSize = _backgroundLayer.frame.size.height/6.0;
    //Tony修改过的地方，去掉了eventSize*0.17,并且再减去0.5
#if 1
    _eventIndicator.frame = CGRectMake(0, CGRectGetMaxY(_backgroundLayer.frame) - eventSize*0.5, bounds.size.width, eventSize*0.83);
#else
    _eventIndicator.frame = CGRectMake(0, CGRectGetMaxY(_backgroundLayer.frame)+eventSize*0.17- eventSize*0.17, bounds.size.width, eventSize*0.83);
#endif
    _imageView.frame = self.contentView.bounds;
    
    
    CGFloat subImageViewW = self.bounds.size.width*0.1;
    _subImageView.frame = CGRectMake(self.bounds.size.width*(1 - 0.2 - 0.05)-1, 12.5, subImageViewW, subImageViewW);
    
    self.recordedImageView.hidden = YES;
    _leftRecordedImageView.hidden = YES;
    
    CGFloat labelHeight = (self.fs_height - _titleLabel.fs_height - _titleLabel.fs_top - 13) / 2;
    _subtitleLabel.frame = CGRectMake(0, 0, self.fs_width - 5, labelHeight);
    _overTimeLabel.frame = CGRectMake(0, 0, self.fs_width - 5, labelHeight);
    _placeView.frame = CGRectMake(1, 1, CGRectGetWidth(self.contentView.frame) - 2, CGRectGetHeight(self.contentView.frame) - 2);
    _subtitleLabel.textColor = AppFontccccccColor;
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self configureCell];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setUpPrepareForReuse];
}

- (void)setUpPrepareForReuse{
    
    [CATransaction setDisableActions:YES];
    _backgroundLayer.hidden = YES;
}

#pragma mark - Public

- (void)performSelecting
{
    _backgroundLayer.hidden = NO;
#pragma mark - 去掉动画绘制效果
    /*
     CAAnimationGroup *group = [self setUpAnimation];
     [_backgroundLayer addAnimation:group forKey:@"bounce"];
     */
    [self configureCell];
    
}

- (CAAnimationGroup * )setUpAnimation{
    
#define kAnimationDuration FSCalendarDefaultBounceAnimationDuration
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.fromValue = @0.3;
    zoomOut.toValue = @1.2;
    zoomOut.duration = kAnimationDuration/4*3;
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomIn.fromValue = @1.2;
    zoomIn.toValue = @1.0;
    zoomIn.beginTime = kAnimationDuration/4*3;
    zoomIn.duration = kAnimationDuration/4;
    group.duration = kAnimationDuration;
    group.animations = @[zoomOut, zoomIn];
    return group;
}

-(BOOL)isToday{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString*dateTime = [formatter stringFromDate:[NSDate  date]];
    dateTime = [dateTime substringToIndex:8];
    NSString *calenderTime = [formatter stringFromDate:_date];
    calenderTime = [calenderTime substringToIndex:8];
    if ([dateTime isEqualToString:calenderTime])
        return YES;
    else
        return NO;
}
- (void)configureCell
{
    
    if (_calendar.rainCalendar) {
        
        if (_upleftimageView.image) {
            _upleftimageView.image = nil;
        }
        if (_uprightimageView.image) {
            _uprightimageView.image = nil;
        }
        if (_downleftimageView.image) {
            _downleftimageView.image = nil;
        }
        if (_downrightimageView.image) {
            _downrightimageView.image = nil;
        }
        NSArray *array = [NSArray array];
        
        array = [_subtitle componentsSeparatedByString:@"-"];
        
        if (array.count ) {
            if ([array[0] isEqualToString:@""] ||[array[0] isEqualToString:@"0"] ) {
                self.contentView.backgroundColor = [UIColor whiteColor];
            }else{
                _upleftimageView.image = [UIImage imageNamed:_imageArr[[array[0] integerValue]]];
            }
            if (array.count >1) {
                if ([array[1] isEqualToString:@""]||[array[1] isEqualToString:@"0"]) {
                    self.contentView.backgroundColor = [UIColor whiteColor];
                    
                }else{
                    _uprightimageView.image = [UIImage imageNamed:_imageArr[[array[1] integerValue]]];
                    
                }
            }
            
            if (array.count > 2) {
                
                if ([array[2] isEqualToString:@""]||[array[2] isEqualToString:@"0"]) {
                    self.contentView.backgroundColor = [UIColor whiteColor];
                    
                }else{
                    _downleftimageView.image = [UIImage imageNamed:_imageArr[[array[2] integerValue]]];
                }
            }
            
            if (array.count > 3) {
                
                if ([array[3] isEqualToString:@""]||[array[3] isEqualToString:@"0"]) {
                    self.contentView.backgroundColor = [UIColor whiteColor];
                    
                }else{
                    _downrightimageView.image = [UIImage imageNamed:_imageArr[[array[3] integerValue]]];
                    
                }
            }
            
            
            
        }
        if (_upleftimageView.image) {
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        [self initRainCalendar];
        
        
        
    }else if (_calendar.notepadListCalendar) {
        
        // 设置记事本日历
        [self initNotePadListCalendar];
        
        
    }else if (_calendar.moreDayCalendar || _calendar.homeRecordBillCalendar) {// 记工首页 或者记多天日历
        
        _needsAdjustingViewFrame = YES;
        [self recordBill];
        
    }else {// 每日考勤或者记多人 日历
        
        [self morePeopleOrOneDayCalendar];
        
    }
    
}

- (void)morePeopleOrOneDayCalendar {
    
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
    _subtitleLabel.frame = CGRectZero;
    _overTimeLabel.textAlignment = NSTextAlignmentLeft;
    _overTimeLabel.frame = CGRectZero;
#pragma mark - 此处添加一个self.subImageHidden判断  金天有差账  不显示今天两个字
    
    // 3.2.0 首先判断没有记账数据，没有数据判断是否为今天日期，为显示今天，否这隐藏， 其次有数据隐藏今天显示勾勾, [NSString isEmpty:self.subtitle]不为空则为有数据
    if ([self isToday] && !self.calendar.mainVC) {
        
        _todayLable.hidden = NO;
        
        
        if (_showTodayNotShowSubImage) {
            
            _todayLable.hidden = NO;
            self.recordedImageView.hidden = YES;
            _leftRecordedImageView.hidden = YES;
        }
        
    }else{
        
        _todayLable.hidden = YES;
    }
    _titleLabel.text = [NSString stringWithFormat:@" %@",@([_calendar dayOfDate:_date])];
    UIColor *textColor = self.colorForTitleLabel;
    if (![textColor isEqual:_titleLabel.textColor]) {
        
        _titleLabel.textColor = textColor;
    }
    
    if (_subtitle) {
        
        _subtitleLabel.numberOfLines = 1;// _subtitleLabel用于显示上班时间和加班时间
        NSArray *array = [NSArray array];
        array = [_subtitle componentsSeparatedByString:@"-"];
        
        _placeView.hidden = NO;
        _leftRecordedImageView.hidden = YES;
        _recordedImageView.hidden = YES;
        CGFloat titleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}].height;
        _titleLabel.frame = CGRectMake(0, 2, self.fs_width, titleHeight);
        
        if (_calendar.scope == FSCalendarScopeWeek) {
            
            _subtitleLabel.hidden = NO;
            _subtitleLabel.frame = CGRectMake(5, _titleLabel.fs_bottom + 5, self.fs_width - 5, 20);
            _subtitleLabel.font = FONT(AppFont20Size);
            _subtitleLabel.text = _subtitle;
            
        }
        
        
        if (_subtitleLabel.hidden) {
            _subtitleLabel.hidden = NO;
            _subDetailtitleLabel.hidden = NO;
        }
        
        
    }else {
        
        _placeView.hidden = YES;
        _leftRecordedImageView.hidden = YES;
        _recordedImageView.hidden = YES;
        
        if (!_subtitleLabel.hidden) {
            _subtitleLabel.hidden = YES;
            _subDetailtitleLabel.hidden = YES;
            
        }
        
    }
    
    
    if (_calendar.selectedDates.count > 0) {
        
        _recordedImageView.hidden = YES;
        _leftRecordedImageView.hidden = YES;
    }
    
    
    if (_subtitle) {
        
        textColor = self.colorForSubtitleLabel;
    }
    
    UIColor *borderColor = self.colorForCellBorder;
    BOOL shouldHiddenBackgroundLayer = !self.selected && !self.dateIsToday && !self.dateIsSelected && !borderColor;
    
    if (_backgroundLayer.hidden != shouldHiddenBackgroundLayer) {
        _backgroundLayer.hidden = shouldHiddenBackgroundLayer;
    }
    
    if (!shouldHiddenBackgroundLayer) {
        
        if (_calendar.scope == FSCalendarScopeWeek) {
            
            CGPathRef path = self.cellShape == FSCalendarCellShapeCircle ?
            [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath :
            [UIBezierPath bezierPathWithRect:_backgroundLayer.bounds].CGPath;
            if (!CGPathEqualToPath(_backgroundLayer.path,path)) {
                
                _backgroundLayer.path = path;
            }
            _backgroundLayer.fillColor = AppFontffffffColor.CGColor;//填充颜色
            
            if (_dateIsSelected) {
                
                self.contentView.backgroundColor = AppFontfdf0f0Color;
                
            }else{
                
                self.contentView.backgroundColor = [UIColor whiteColor];
            }
            
            //边框颜色
            UIBezierPath *triangle = [UIBezierPath bezierPath];
            
            [triangle moveToPoint:CGPointMake(0, 0)];
            
            [triangle addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
            
            _backgroundLayer.path = triangle.CGPath;
            
            _backgroundLayer.lineWidth = 2.5;
            
            if (_dateIsSelected) {
                
                _backgroundLayer.strokeColor = AppFontE44343DColor.CGColor;
                
            }else{
                
                _backgroundLayer.strokeColor = [UIColor whiteColor].CGColor;
            }
        }else{
            
            
            _backgroundLayer.frame = CGRectMake(0.6, 0, CGRectGetWidth(self.contentView.frame) - 1.4, CGRectGetHeight(self.contentView.frame));
            
            CGPathRef path = self.cellShape == FSCalendarCellShapeCircle ? [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath :[UIBezierPath bezierPathWithRect:_backgroundLayer.bounds].CGPath;
            
            if (!CGPathEqualToPath(_backgroundLayer.path,path)) {
                
                _backgroundLayer.path = path;
                
            }
            
            CGColorRef backgroundColor = self.colorForBackgroundLayer.CGColor;
            
            if (!CGColorEqualToColor(_backgroundLayer.fillColor, backgroundColor)) {
                
                if (_calendar.scope == FSCalendarScopeMonth) {
                    
                    if ([_subtitle containsString:@"休息"]) {
                        
                        
                        _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
                        
                    }else{
                        
                        if (_subtitle) {
                            
                            _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
                            
                            
                        }else{
                            
                            _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
                            
                        }
                    }
                    
                }else{
#pragma mark -单独设置月份的选择颜色
                    _backgroundLayer.fillColor = backgroundColor;
                }
            }
            
            CGColorRef borderColor = self.colorForCellBorder.CGColor;
            
            
            if (!CGColorEqualToColor(_backgroundLayer.strokeColor, borderColor)) {
                
                //此处不需要绘制了 不清楚会不会遗漏写功能  洗注释
                
                if (self.calendar.mainVC || self.calendar.selectShow) {
                    
                    borderColor = [UIColor clearColor].CGColor;
                    
                }
                
                _backgroundLayer.strokeColor = borderColor;
                
            }
            
        }
    }
    
    
    if (![_image isEqual:_imageView.image]) {
        
        [self invalidateImage];
    }
    
    //右上角差账图标
    [self invalidateSubImage];
    if (_eventIndicator.hidden == (_numberOfEvents > 0)) {
        _eventIndicator.hidden = !_numberOfEvents;
    }
    _eventIndicator.numberOfEvents = self.numberOfEvents;
    _eventIndicator.color = self.preferedEventColor ?: _appearance.eventColor;
    
}


- (BOOL)isWeekend
{
    return _date && ([_calendar weekdayOfDate:_date] == 1 || [_calendar weekdayOfDate:_date] == 7);
}
- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary
{
    if (self.isSelected || self.dateIsSelected) {
        if (self.dateIsToday) {
            return dictionary[@(FSCalendarCellStateSelected|FSCalendarCellStateToday)] ?: dictionary[@(FSCalendarCellStateSelected)];
        }
        return dictionary[@(FSCalendarCellStateSelected)];
    }
    if (self.dateIsToday && [[dictionary allKeys] containsObject:@(FSCalendarCellStateToday)]) {
        
        return dictionary[@(FSCalendarCellStateToday)];
    }
    if (self.dateIsPlaceholder && [[dictionary allKeys] containsObject:@(FSCalendarCellStatePlaceholder)]) {
        
        return dictionary[@(FSCalendarCellStatePlaceholder)];
    }
    if (self.isWeekend && [[dictionary allKeys] containsObject:@(FSCalendarCellStateWeekend)]) {
        
        return dictionary[@(FSCalendarCellStateWeekend)];
    }
    return dictionary[@(FSCalendarCellStateNormal)];
}

- (void)invalidateTitleFont
{
    if (_calendar.scope == FSCalendarScopeWeek) {
        
    }else{
        _titleLabel.font = self.appearance.preferredTitleFont;
    }
}
- (void)invalidateTitleTextColor
{
    _titleLabel.textColor = self.colorForTitleLabel;
}
- (void)invalidateSubtitleFont
{
    _subtitleLabel.font = self.appearance.preferredSubtitleFont;
}

- (void)invalidateSubtitleTextColor
{
    _subtitleLabel.textColor = self.colorForSubtitleLabel;
}

- (void)invalidateBorderColors
{
    _backgroundLayer.strokeColor = self.colorForCellBorder.CGColor;
}
- (void)invalidateBackgroundColors
{
    _backgroundLayer.fillColor = self.colorForBackgroundLayer.CGColor;
    
}
- (void)invalidateEventColors
{
    _eventIndicator.color = self.preferedEventColor ?: _appearance.eventColor;
}
- (void)invalidateCellShapes
{
    CGPathRef path = self.cellShape == FSCalendarCellShapeCircle ?
    [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath :
    [UIBezierPath bezierPathWithRect:_backgroundLayer.bounds].CGPath;
    _backgroundLayer.path = path;
}
//遮盖曾
- (void)invalidateImage
{
    _imageView.image = _image;
    _imageView.hidden = !_image;
}
//右上角图片

- (void)invalidateSubImage
{
    _subImageView.hidden = self.subImageHidden;
#pragma mark - 此处如果有差张 就把黄勾勾去掉
    if (!_subImageView.hidden) {
        
        self.recordedImageView.hidden = !_subImageView.hidden;
        self.leftRecordedImageView.hidden = !_subImageView.hidden;
    }
    
    _subImage = _subImage?:[UIImage imageNamed:@"markBillModifydiff"];
    
    //    _subImage = _subImage?:[UIImage imageNamed:@"warning"];
    _subImageView.image = _subImage;
    
}
#pragma mark - Properties

- (UIColor *)colorForBackgroundLayer
{
    if (self.dateIsSelected || self.isSelected) {
        return self.preferedSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.backgroundColors];
    }
    return [self colorForCurrentStateInDictionary:_appearance.backgroundColors];
}

- (UIColor *)colorForTitleLabel
{
    if (self.dateIsSelected || self.isSelected) {
        return self.preferedTitleSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.titleColors];
    }
    return self.preferedTitleDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.titleColors];
}

- (UIColor *)colorForSubtitleLabel
{
    if (self.dateIsSelected || self.isSelected) {
        
        return self.preferedSubtitleSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.subtitleColors];
    }
    return self.preferedSubtitleDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.subtitleColors];
}

- (UIColor *)colorForCellBorder
{
    if (self.dateIsSelected || self.isSelected) {
        return _preferedBorderSelectionColor ?: _appearance.borderSelectionColor;
    }
    return _preferedBorderDefaultColor ?: _appearance.borderDefaultColor;
}

- (FSCalendarCellShape)cellShape
{
    return _preferedCellShape ?: _appearance.cellShape;
}

- (void)setCalendar:(FSCalendar *)calendar
{
    if (![_calendar isEqual:calendar]) {
        _calendar = calendar;
    }
    if (![_appearance isEqual:calendar.appearance]) {
        _appearance = calendar.appearance;
        [self invalidateTitleFont];
        [self invalidateSubtitleFont];
        [self invalidateTitleTextColor];
        [self invalidateSubtitleTextColor];
        [self invalidateEventColors];
    }
}

- (void)setSubtitle:(NSString *)subtitle
{
    if (![_subtitle isEqualToString:subtitle]) {
        _needsAdjustingViewFrame = !(_subtitle.length && subtitle.length);
        _subtitle = subtitle;
        if (_needsAdjustingViewFrame) {
            [self setNeedsLayout];
        }
    }
}

- (void)setShowTodayNotShowSubImage:(BOOL)showTodayNotShowSubImage {
    
    _showTodayNotShowSubImage = showTodayNotShowSubImage;
}
#pragma mark - 记账
- (void)recordBill{
    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.frame = CGRectZero;
    _overTimeLabel.textAlignment = NSTextAlignmentCenter;
    _overTimeLabel.frame = CGRectZero;
    
    _titleLabel.text = [NSString stringWithFormat:@" %@",@([_calendar dayOfDate:_date])];
    UIColor *textColor = self.colorForTitleLabel;
    if (![textColor isEqual:_titleLabel.textColor]) {
        
        _titleLabel.textColor = textColor;
    }
    // v 3.4.1添加这个复杂的奇葩需求 v3.4.2修改标识字段舍弃 is_record is_flag 新增 rwork_type awork_type标识
    // _subtitleLabel 这里试外面通过 JGJLeaderRecordsViewController/JGJWorkMatesRecordsViewController 代理返回传进来的值:calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
    // v3.4.2新增标识 rwork_type 1:休息表示。 2:表示包工记账 0:表示记账(点工/包工考勤) 有备注 is_notes == 1   awork_type 3:表示借支； 4:结算
#pragma mark - 参数说明
    // 第一个元素代表 awork_type 3:表示借支； 4:结算
    // 第二个元素代表 manhour 上班时间
    // 第三个元素代表 overtime 加班时间
    // 第四个元素代表 rwork_type 1:休息表示。 2:表示包工记账 0:表示记账(点工/包工考勤)
    // 第五个元素代表 is_notes 有无备注
    // 第六个元素代表 working_hours 上班工天
    // 第七个元素代表 overtime_hours 加班工天
    NSInteger awork_type;
    NSString *workHour;
    NSString *overHour;
    NSInteger rwork_type;
    NSInteger is_notes;
    NSString *workDay;
    NSString *overDay;
    NSInteger is_record_to_me;
    NSInteger is_record;//1.表示有点工/包工考勤
    if (_subtitle) {
        
        _subtitleLabel.numberOfLines = 1;// _subtitleLabel用于显示上班时间和加班时间
        NSArray *array = [NSArray array];
        array = [_subtitle componentsSeparatedByString:@"-"];
        
        if (array.count > 1) {
            
            _subtitleLabel.hidden = NO;
            _overTimeLabel.hidden = NO;
            _todayLable.hidden = YES;
            _placeView.hidden = NO;
            
            awork_type = [array.firstObject integerValue];
            workHour = array[1];
            overHour = array[2];
            rwork_type = [array[3] integerValue];
            is_notes = [array[4] integerValue];
            workDay = array[5];
            overDay = array[6];
            is_record_to_me = [array[7] integerValue];
            is_record = [array[8] integerValue];
            if ([workHour isEqualToString:@"0"] || [NSString isEmpty:workHour]) {
                
                workHour = @"";
            }
            
            if ([overHour isEqualToString:@"0"] || [NSString isEmpty:overHour]) {
                
                overHour = @"";
            }
            
            if ([workDay isEqualToString:@"0"] || [NSString isEmpty:workDay]) {
                
                workDay = @"";
            }
            
            if ([overDay isEqualToString:@"0"] || [NSString isEmpty:overDay]) {
                
                overDay = @"";
            }
            
            // 获取当前显示方式
            self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
            
            //0.上班按工天、加班按小时 1.按工天, 2. 按小时
            _titleLabel.textColor = AppFontFF6600Color;
            _subtitleLabel.font = [UIFont boldSystemFontOfSize:8];
//            _subtitleLabel.textColor = AppFontFF6600Color;
            _subtitleLabel.textColor = AppFont000000Color;
            _overTimeLabel.font = [UIFont boldSystemFontOfSize:8];
            _overTimeLabel.textColor = AppFont6487e0Color;
            
            if (_needsAdjustingViewFrame || CGSizeEqualToSize(_titleLabel.frame.size, CGSizeZero)) {
                
                _needsAdjustingViewFrame = NO;
                
                CGFloat titleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}].height;
                CGFloat subtitleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:_subtitleLabel.font}].height;
                CGFloat height = titleHeight + subtitleHeight;
                _titleLabel.frame = CGRectMake(1, 2, self.fs_width - 2 - 5,titleHeight);
        
                _placeView.frame = CGRectMake(0.5, 0.5, CGRectGetWidth(self.contentView.frame) - 1, CGRectGetHeight(self.contentView.frame) - 1);
                _placeView.backgroundColor = AppFontFFF0E8Color;
                _placeView.layer.borderColor = AppFontFF6600Color.CGColor;
                _placeView.layer.cornerRadius = 4;
                _placeView.clipsToBounds = YES;
                
                self.recordedImageView.hidden = NO;
                self.recordedImageView.image = IMAGE(@"slected_yellow");
                self.recordedImageView.frame = CGRectMake(self.fs_width - 12 - 1, 2 + titleHeight / 2 - 3, 7, 6);
                
                CGFloat labelHeight = (self.fs_height - _titleLabel.fs_height - _titleLabel.fs_top - 19) / 2;
                
                if (is_record == 1) {//表示有点工/包工考勤
                    
                    if (is_record_to_me == 1) {
                        
                        _subtitleLabel.hidden = YES;
                        _overTimeLabel.hidden = YES;
                        _placeView.hidden = YES;
                        _leftRecordedImageView.hidden = YES;
                        _recordedImageView.hidden = YES;
                        _rightRecordedImageView.hidden = YES;
                        if ([self isToday]) {
                            
                            _titleLabel.textColor = AppFontEB4E4EColor;
                            
                        }else {
                            
                            _titleLabel.textColor = AppFont000000Color;
                        }
                        
                        
                    }else {
                        
                        _subtitleLabel.frame = CGRectMake(1, _titleLabel.fs_bottom + 15, self.fs_width - 2, labelHeight);
                        _overTimeLabel.frame = CGRectMake(1, _subtitleLabel.fs_bottom, self.fs_width - 2, labelHeight);
                        
                        if (self.selTypeModel.type == 0) {
                            
                            if (![NSString isEmpty:workDay]) {
                                
                                _subtitleLabel.text = [NSString stringWithFormat:@"%@个工",workDay];
                                
                            }else {
                                
                                _subtitleLabel.text = @"";
                            }
                            
                            if (![NSString isEmpty:overHour]) {
                                
                                _overTimeLabel.text = [NSString stringWithFormat:@"%@小时",overHour];
                                
                            }else {
                                
                                
                                _overTimeLabel.text = @"";
                            }
                            
                        }else if (self.selTypeModel.type == 1) {
                            
                            if (![NSString isEmpty:workDay]) {
                                
                                _subtitleLabel.text = [NSString stringWithFormat:@"%@个工",workDay];
                                
                            }else {
                                
                                _subtitleLabel.text = @"";
                            }
                            
                            if (![NSString isEmpty:overDay]) {
                                
                                _overTimeLabel.text = [NSString stringWithFormat:@"%@个工",overDay];
                                
                            }else {
                                
                                _overTimeLabel.text = @"";
                            }
                            
                            
                        }else if (self.selTypeModel.type == 2) {
                            
                            if (![NSString isEmpty:workHour]) {
                                
                                _subtitleLabel.text = [NSString stringWithFormat:@"%@小时",workHour];
                                
                            }else {
                                
                                _subtitleLabel.text = @"";
                            }
                            
                            if (![NSString isEmpty:overHour]) {
                                
                                _overTimeLabel.text = [NSString stringWithFormat:@"%@小时",overHour];
                                
                            }else {
                                
                                _overTimeLabel.text = overHour;
                            }
                            
                        }
                        
                        // 判断右上角显示图标
                        if (is_notes) {// 有备注
                            
                            self.rightRecordedImageView.hidden = NO;
                            self.rightRecordedImageView.image = [UIImage imageNamed:@"note_icon"];
                            self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                            
                            if (awork_type == 3) { // 表示有借支
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"borrow_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 13.5, _titleLabel.fs_bottom, 12, 12);
                                self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 + 1.5, _titleLabel.fs_bottom, 12, 12);
                                
                            }else if (awork_type == 4) { // 表示有结算
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"closeAnAccount_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 13.5, _titleLabel.fs_bottom, 12, 12);
                                self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 + 1.5, _titleLabel.fs_bottom, 12, 12);
                            }
                            
                        }else {
                            
                            self.rightRecordedImageView.hidden = YES;
                            if (awork_type == 3) { // 表示有借支
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"borrow_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                            }else if (awork_type == 4) { // 表示有结算
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"closeAnAccount_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                                
                            }
                            
                        }
                        
                    }
                }else {
                    
                    if (rwork_type == 1) {//1:休息表示。
                        
                        _subtitleLabel.frame = CGRectMake(1, _titleLabel.fs_bottom + 12, self.fs_width - 2, labelHeight * 2);
                        _overTimeLabel.frame = CGRectMake(1, _subtitleLabel.fs_bottom, self.fs_width - 2, 0);
                        
                        _subtitleLabel.text = @"休";
                        _subtitleLabel.textColor = AppFonte15A153Color;
                        _subtitleLabel.font = FONT(AppFont36Size);
                        _placeView.layer.borderColor = AppFonte15A153Color.CGColor;
                        _placeView.backgroundColor = AppFonteE8FEF2Color;
                        _titleLabel.textColor = AppFonte15A153Color;
                        
                        _recordedImageView.hidden = YES;
                        
                        // 判断右上角显示图标
                        if (is_notes) {// 有备注
                            
                            self.rightRecordedImageView.hidden = NO;
                            self.rightRecordedImageView.image = [UIImage imageNamed:@"note_icon"];
                            self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                            
                            if (awork_type == 3) { // 表示有借支
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"borrow_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 13.5, _titleLabel.fs_bottom, 12, 12);
                                self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 + 1.5, _titleLabel.fs_bottom, 12, 12);
                                
                            }else if (awork_type == 4) { // 表示有结算
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"closeAnAccount_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 13.5, _titleLabel.fs_bottom, 12, 12);
                                self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 + 1.5, _titleLabel.fs_bottom, 12, 12);
                            }
                        }else {
                            
                            self.rightRecordedImageView.hidden = YES;
                            
                            if (awork_type == 3) { // 表示有借支
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"borrow_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                            }else if (awork_type == 4) { // 表示有结算
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"closeAnAccount_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                            }
                            
                            
                        }
                        
                        
                        
                    }else if (rwork_type == 2) {// 2:表示包工记账
                        
                        _subtitleLabel.frame = CGRectMake(1, _titleLabel.fs_bottom + 15, self.fs_width - 2, labelHeight);
                        _overTimeLabel.frame = CGRectMake(1, _subtitleLabel.fs_bottom, self.fs_width - 2, 0);
                        
                        _subtitleLabel.text = @"包工";
                        _subtitleLabel.textColor = AppFont000000Color;
                        _subtitleLabel.font = FONT(AppFont24Size);
                        
                        // 判断右上角显示图标
                        if (is_notes) {// 有备注
                            
                            self.rightRecordedImageView.hidden = NO;
                            self.rightRecordedImageView.image = [UIImage imageNamed:@"note_icon"];
                            self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                            
                            if (awork_type == 3) { // 表示有借支
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"borrow_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 13.5, _titleLabel.fs_bottom, 12, 12);
                                self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 + 1.5, _titleLabel.fs_bottom, 12, 12);
                                
                            }else if (awork_type == 4) { // 表示有结算
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"closeAnAccount_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 13.5, _titleLabel.fs_bottom, 12, 12);
                                self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 + 1.5, _titleLabel.fs_bottom, 12, 12);
                            }
                        }else {
                            
                            self.rightRecordedImageView.hidden = YES;
                            if (awork_type == 3) { // 表示有借支
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"borrow_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                            }else if (awork_type == 4) { // 表示有结算
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"closeAnAccount_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                            }
                            
                        }
                        
                    }else {// 表示只有借支或者结算
                        
                        _subtitleLabel.hidden = YES;
                        _overTimeLabel.hidden = YES;
                        _recordedImageView.hidden = YES;
                        // 判断右上角显示图标
                        if (is_notes) {// 有备注
                            
                            self.rightRecordedImageView.hidden = NO;
                            self.rightRecordedImageView.image = [UIImage imageNamed:@"note_icon"];
                            self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                            
                            if (awork_type == 3) { // 表示有借支
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"borrow_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 13.5, _titleLabel.fs_bottom, 12, 12);
                                self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 + 1.5, _titleLabel.fs_bottom, 12, 12);
                                
                            }else if (awork_type == 4) { // 表示有结算
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"closeAnAccount_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 13.5, _titleLabel.fs_bottom, 12, 12);
                                self.rightRecordedImageView.frame = CGRectMake(self.fs_width / 2 + 1.5, _titleLabel.fs_bottom, 12, 12);
                            }
                            
                        }else {
                            
                            self.rightRecordedImageView.hidden = YES;
                            if (awork_type == 3) { // 表示有借支
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"borrow_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                            }else if (awork_type == 4) { // 表示有结算
                                
                                self.leftRecordedImageView.hidden = NO;
                                self.leftRecordedImageView.image = IMAGE(@"closeAnAccount_icon");
                                self.leftRecordedImageView.frame = CGRectMake(self.fs_width / 2 - 6, _titleLabel.fs_bottom, 12, 12);
                                
                            }
                            
                        }
                    }
                }
            }
        }else {
            
            _placeView.hidden = YES;
            _leftRecordedImageView.hidden = YES;
            _recordedImageView.hidden = YES;
            _rightRecordedImageView.hidden = YES;
            
            CGFloat titleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}].height;
            _titleLabel.frame = CGRectMake(1, 2, self.fs_width - 2 - 5, titleHeight);
            
            
            _subtitleLabel.hidden = NO;
            _subtitleLabel.frame = CGRectMake(1, _titleLabel.fs_bottom + 7, self.fs_width - 2, 10);
            _subtitleLabel.font = FONT(AppFont20Size);
            
            _subtitleLabel.text = _subtitle;
            
            _overTimeLabel.frame = CGRectMake(1, _subtitleLabel.fs_bottom, self.fs_width - 2, 0);
            if ([self isToday]){
                
                _todayLable.hidden = NO;
                _todayLable.frame = CGRectMake(self.fs_width / 2 - 12.5, _subtitleLabel.fs_bottom + 4, 25, 12);
                _subtitleLabel.textColor = AppFontEB4E4EColor;
                _titleLabel.textColor = AppFontEB4E4EColor;
                
            }else {
                
                // 判断 日期是否大于今天
                NSInteger diff_time = [NSDate dateTimesTampDValue:_date.timestamp];
                if (diff_time < 0) {// 时间在今天之后
                    
                    _subtitleLabel.textColor = [AppFont999999Color colorWithAlphaComponent:0.5];
                    _titleLabel.textColor = [AppFont000000Color colorWithAlphaComponent:0.5];
                    
                }else if (diff_time > 0) {// 时间在今天之前
                    
                    _subtitleLabel.textColor = AppFont999999Color;
                    _titleLabel.textColor = AppFont000000Color;
                }
                
                _todayLable.hidden = YES;
                
            }
        }
        
        
        if (_subtitleLabel.hidden) {
            _subtitleLabel.hidden = NO;
            _subDetailtitleLabel.hidden = NO;
        }
        
        
    }else {
        
        _placeView.hidden = YES;
        _leftRecordedImageView.hidden = YES;
        _recordedImageView.hidden = YES;
        
        if (!_subtitleLabel.hidden) {
            _subtitleLabel.hidden = YES;
            _subDetailtitleLabel.hidden = YES;
            
        }
        
    }
    
    
    if (_calendar.selectedDates.count > 0) {
        
        _recordedImageView.hidden = YES;
        _leftRecordedImageView.hidden = YES;
    }
    
    
    if (_subtitle) {
        
        textColor = self.colorForSubtitleLabel;
    }
    
    UIColor *borderColor = self.colorForCellBorder;
    BOOL shouldHiddenBackgroundLayer = !self.selected && !self.dateIsToday && !self.dateIsSelected && !borderColor;
    
    if (_backgroundLayer.hidden != shouldHiddenBackgroundLayer) {
        _backgroundLayer.hidden = shouldHiddenBackgroundLayer;
    }
    
    if (!shouldHiddenBackgroundLayer) {
        
        if (_calendar.scope == FSCalendarScopeWeek) {
            
            CGPathRef path = self.cellShape == FSCalendarCellShapeCircle ?
            [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath :
            [UIBezierPath bezierPathWithRect:_backgroundLayer.bounds].CGPath;
            if (!CGPathEqualToPath(_backgroundLayer.path,path)) {
                
                _backgroundLayer.path = path;
            }
            _backgroundLayer.fillColor = AppFontffffffColor.CGColor;//填充颜色
            
            if (_dateIsSelected) {
                
                self.contentView.backgroundColor = AppFontfdf0f0Color;
                
            }else{
                
                self.contentView.backgroundColor = [UIColor whiteColor];
            }
            
            //边框颜色
            UIBezierPath *triangle = [UIBezierPath bezierPath];
            
            [triangle moveToPoint:CGPointMake(0, 0)];
            
            [triangle addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
            
            _backgroundLayer.path = triangle.CGPath;
            
            _backgroundLayer.lineWidth = 2.5;
            
            if (_dateIsSelected) {
                
                _backgroundLayer.strokeColor = AppFontE44343DColor.CGColor;
                
            }else{
                
                _backgroundLayer.strokeColor = [UIColor whiteColor].CGColor;
            }
        }else{
            
            
            _backgroundLayer.frame = CGRectMake(0.6, 0, CGRectGetWidth(self.contentView.frame) - 1.4, CGRectGetHeight(self.contentView.frame));
            
            CGPathRef path = self.cellShape == FSCalendarCellShapeCircle ? [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath :[UIBezierPath bezierPathWithRect:_backgroundLayer.bounds].CGPath;
            
            if (!CGPathEqualToPath(_backgroundLayer.path,path)) {
                
                _backgroundLayer.path = path;
                
            }
            
            CGColorRef backgroundColor = self.colorForBackgroundLayer.CGColor;
            
            if (!CGColorEqualToColor(_backgroundLayer.fillColor, backgroundColor)) {
                
                if (_calendar.scope == FSCalendarScopeMonth) {
                    
                    if ([_subtitle containsString:@"休息"]) {
                        
                        
                        _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
                        
                    }else{
                        
                        if (_subtitle) {
                            
                            _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
                            
                            
                        }else{
                            
                            _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
                            
                        }
                    }
                    
                }else{
#pragma mark -单独设置月份的选择颜色
                    _backgroundLayer.fillColor = backgroundColor;
                }
            }
            
            CGColorRef borderColor = self.colorForCellBorder.CGColor;
            
            
            if (!CGColorEqualToColor(_backgroundLayer.strokeColor, borderColor)) {
                
                //此处不需要绘制了 不清楚会不会遗漏写功能  洗注释
                
                if (self.calendar.mainVC || self.calendar.selectShow) {
                    
                    borderColor = [UIColor clearColor].CGColor;
                    
                }
                
                _backgroundLayer.strokeColor = borderColor;
                
            }
            
        }
    }
    
    if (![_image isEqual:_imageView.image]) {
        
        [self invalidateImage];
    }
    
    //右上角差账图标
    [self invalidateSubImage];
    if (_eventIndicator.hidden == (_numberOfEvents > 0)) {
        _eventIndicator.hidden = !_numberOfEvents;
    }
    _eventIndicator.numberOfEvents = self.numberOfEvents;
    _eventIndicator.color = self.preferedEventColor ?: _appearance.eventColor;
    
    if (self.calendar.moreDayCalendar) {
        
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.cornerRadius = 5;
        
        if (self.moreDaySelectedModel.isSelected) {
            
            _placeView.hidden = YES;
            self.titleLabel.textColor = AppFontEB4E4EColor;
            _moreDaySelectedContractorView.hidden = NO;
            _moreDaySelectedContractorView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
            
            if (self.moreDaySelectedModel.type == 0) {
                
                _moreDaySelectedContractorView.image = [UIImage imageNamed:@"more_day_tiny"];
                
            }else {
                
                _moreDaySelectedContractorView.image = [UIImage imageNamed:@"more_day_contractor"];
            }
            
            
            _moreDaySelectedContractorView.contentMode = UIViewContentModeScaleToFill;
            
        }else {
            
            self.contentView.layer.borderWidth = 0;
            self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
            _moreDaySelectedContractorView.frame = CGRectZero;
            _moreDaySelectedContractorView.hidden = YES;
            
        }
    }
    
    
}


#pragma mark - 记多天 -> 设置时间的选择模型
- (void)setMoreDaySelectedModel:(JGJMoreDaySelectedModel *)moreDaySelectedModel {
    
    _moreDaySelectedModel = moreDaySelectedModel;
    
    
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    
    _selectedDate = selectedDate;
    
    NSInteger selectedDay = [_calendar dayOfDate:_selectedDate];
    NSInteger currentDay = [_calendar dayOfDate:_date];
    if (selectedDay == currentDay) {
        
        self.contentView.backgroundColor = AppFontfdf0f0Color;
        
        if (_calendar.scope == FSCalendarScopeWeek) {
            
            _subtitleLabel.textColor = AppFontEB4E4EColor;
        }
    }else {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        if (_calendar.scope == FSCalendarScopeWeek) {
            
            _subtitleLabel.textColor = AppFontccccccColor;
        }
    }
}

#pragma mark - 记事本日历
- (void)initNotePadListCalendar {
    
    if (_upleftimageView.image) {
        _upleftimageView.image = nil;
    }
    if (_uprightimageView.image) {
        _uprightimageView.image = nil;
    }
    if (_downleftimageView.image) {
        _downleftimageView.image = nil;
    }
    if (_downrightimageView.image) {
        _downrightimageView.image = nil;
    }
    
    _subtitleLabel.frame = CGRectZero;
    _imageView.hidden = YES;
    _subImageView.hidden = YES;
    _recordedImageView.hidden = YES;
    _leftRecordedImageView.hidden = YES;
    _todayLable.hidden = YES;
    _placeView.hidden = YES;
    _overTimeLabel.hidden = YES;
    _subtitleLabel.numberOfLines = 0;
    
    _noteStartImageView.hidden = YES;
    _noteListRecordView.hidden = YES;
    
    CGFloat titleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}].height;
    _titleLabel.frame = CGRectMake(2, 19, self.fs_width - 4, titleHeight);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat labelHeight = self.fs_height - _titleLabel.fs_height - 19;
    _subtitleLabel.frame = CGRectMake(2, _titleLabel.fs_bottom, self.fs_width - 4, labelHeight);
    _subtitleLabel.font = FONT(AppFont20Size);
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _subtitleLabel.text = _subtitle;
    _titleLabel.text = [NSString stringWithFormat:@"%@",@([_calendar dayOfDate:_date])];
    
    // 记事本记录背景
    _noteListRecordView.frame = CGRectMake(2, 10, self.fs_width - 4, self.fs_height - 10);
    _noteListRecordView.layer.cornerRadius = 5;
    
    // 记事本重要标记
    _noteStartImageView.frame = CGRectMake(self.fs_width / 2 - 9, 1, 18, 18);
    
    
    NSString *holiday;// 农历时间
    NSString *date;// 接口返回时间
    NSString *is_import;// 是否有重要标记
    NSString *note_num;// 当天是否有记录
    
    _subtitleLabel.numberOfLines = 0;// _subtitleLabel用于显示上班时间和加班时间
    NSArray *array = [NSArray array];
    array = [_subtitle componentsSeparatedByString:@"-"];
    holiday = array[0];
    
    if (array.count > 1) {
        
        date = array[1];
        is_import = array[2];
        note_num = array[3];
        
        if ([self isToday]) {
            
            _subtitleLabel.text = [NSString stringWithFormat:@"%@\n(今天)",holiday];
            
        }else {
            
            _subtitleLabel.text = holiday;
        }
        if ([note_num integerValue] > 0) {// 当前时间有记事本记录
            
            _titleLabel.textColor = AppFontffffffColor;
            _subtitleLabel.textColor = AppFontffffffColor;
            // 设置背景颜色
            _noteListRecordView.hidden = NO;
            
            // 当前时间有重要要标记
            if ([is_import integerValue] == 1) {
                
                _noteStartImageView.hidden = NO;
                
            }else {
                
                _noteStartImageView.hidden = YES;
            }
            
        }else {
            
            _titleLabel.textColor = AppFont333333Color;
            _subtitleLabel.textColor = AppFont999999Color;
            // 设置背景颜色
            _noteStartImageView.hidden = YES;
            _noteListRecordView.hidden = YES;
        }
        
    }else {
        
        if ([self isToday]) {
            
            _subtitleLabel.text = [NSString stringWithFormat:@"%@\n(今天)",holiday];
            _titleLabel.textColor = AppFontEB4E4EColor;
            _subtitleLabel.textColor = AppFontEB4E4EColor;
            
        }else {
            
            _subtitleLabel.text = holiday;
            _titleLabel.textColor = AppFont333333Color;
            _subtitleLabel.textColor = AppFont999999Color;
            
        }
    }
    
    
}

#pragma mark -晴雨表
- (void)initRainCalendar
{
    _recordedImageView.hidden = YES;
    _leftRecordedImageView.hidden = YES;
    _todayLable.hidden = YES;
    if ([self isToday] && !_dateIsSelected && _upleftimageView.image) {
        
    }
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    if ([self isToday]) {
        
        _titleLabel.text = [NSString stringWithFormat:@" %@今天",@([_calendar dayOfDate:_date])];
        
        [_titleLabel markText:@"今天" withFont:[UIFont systemFontOfSize:AppFont18Size] color:AppFontd7252cColor];
        
        
    }else{
        
        _titleLabel.text = [NSString stringWithFormat:@" %@",@([_calendar dayOfDate:_date])];
        
    }
    
    if (_needsAdjustingViewFrame || CGSizeEqualToSize(_titleLabel.frame.size, CGSizeZero)) {
        
        _needsAdjustingViewFrame = NO;
        CGFloat titleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}].height;
        CGFloat subtitleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:_subtitleLabel.font}].height;
        CGFloat height = titleHeight + subtitleHeight;
        if (self.calendar.scope == FSCalendarScopeMonth) {
            
            _titleLabel.frame = CGRectMake(0,
                                           (self.contentView.fs_height*5.0/6.0-height)*0.5+_appearance.titleVerticalOffset - 6,
                                           self.fs_width,
                                           titleHeight);
            
            
            _placeView.frame = CGRectMake(1, 1, CGRectGetWidth(self.contentView.frame) - 2, CGRectGetHeight(self.contentView.frame) - 2);
            
            _upleftimageView.frame = CGRectMake(5, (self.contentView.fs_height*5.0/6.0-height)*0.5+_appearance.titleVerticalOffset -5.5 + titleHeight , 14, 14);
            _uprightimageView.frame = CGRectMake(22,  (self.contentView.fs_height*5.0/6.0-height)*0.5+_appearance.titleVerticalOffset -5.5 + titleHeight , 14, 14);
            _downleftimageView.frame = CGRectMake(5, (self.contentView.fs_height*5.0/6.0-height)*0.5+_appearance.titleVerticalOffset -4.8 + titleHeight  + 15, 14, 14);
            _downrightimageView.frame = CGRectMake(22,  (self.contentView.fs_height*5.0/6.0-height)*0.5+_appearance.titleVerticalOffset -4.8 + titleHeight  +15, 14, 14);
            
        }
    }
    _subtitleLabel.hidden = YES;
    
    UIColor *textColor = self.colorForTitleLabel;
    if (![textColor isEqual:_titleLabel.textColor]) {
        _titleLabel.textColor = textColor;
    }
    if (_subtitle) {
        textColor = self.colorForSubtitleLabel;
        if (![textColor isEqual:_subtitleLabel.textColor]) {
            
        }
    }
    UIColor *borderColor = self.colorForCellBorder;
    BOOL shouldHiddenBackgroundLayer = !self.selected && !self.dateIsToday && !self.dateIsSelected && !borderColor;
    
    if (_backgroundLayer.hidden != shouldHiddenBackgroundLayer) {
        _backgroundLayer.hidden = shouldHiddenBackgroundLayer;
    }
    
    if (!shouldHiddenBackgroundLayer) {
        
        CGPathRef path = self.cellShape == FSCalendarCellShapeCircle ?
        [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath :
        [UIBezierPath bezierPathWithRect:_backgroundLayer.bounds].CGPath;
        if (!CGPathEqualToPath(_backgroundLayer.path,path)) {
            _backgroundLayer.path = path;
        }
        CGColorRef backgroundColor = self.colorForBackgroundLayer.CGColor;
        //填充颜色
        if (!CGColorEqualToColor(_backgroundLayer.fillColor, backgroundColor)) {
            //             _backgroundLayer.fillColor = backgroundColor;//填充颜色
            _backgroundLayer.fillColor = AppFontffffffColor.CGColor;//填充颜色
            if ([self isToday] && !_dateIsSelected && _upleftimageView.image) {
                //                self.contentView.backgroundColor = AppFontf3f3f3Color;
                
            }else{
                self.contentView.backgroundColor = [UIColor whiteColor];
            }
            if (_dateIsSelected) {
                self.contentView.backgroundColor = AppFontfafafaColor;
                
            }
        }
        CGColorRef borderColor = self.colorForCellBorder.CGColor;
        //边框颜色
        if (!CGColorEqualToColor(_backgroundLayer.strokeColor, borderColor)) {
            UIBezierPath *triangle = [UIBezierPath bezierPath];
            [triangle moveToPoint:CGPointMake(0, 0)];
            [triangle addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
            
            _backgroundLayer.path = triangle.CGPath;
            _backgroundLayer.lineWidth = 2.5;
            
            if ([self isToday] && !_dateIsSelected) {
                _backgroundLayer.strokeColor = [UIColor whiteColor].CGColor;
                
            }else{
                _backgroundLayer.strokeColor = AppFontE44343DColor.CGColor;
            }
            
        }
        
    }
    if (![_image isEqual:_imageView.image]) {
        
        [self invalidateImage];
    }
    //设置颜色  外部设置无效
    //右上角差账图标
    
    if (_eventIndicator.hidden == (_numberOfEvents > 0)) {
        _eventIndicator.hidden = !_numberOfEvents;
    }
    _eventIndicator.numberOfEvents = self.numberOfEvents;
    _eventIndicator.color = self.preferedEventColor ?: _appearance.eventColor;
    
    if (_dateIsSelected) {
        
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 2, 0.5, CGRectGetHeight(self.frame) - 2)];
        view.backgroundColor = AppFontccccccColor;
        view.tag = 1122;
        [self addSubview:view];
        
        UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 0.5)];
        views.backgroundColor = AppFontccccccColor;
        views.tag = 1122;
        [self addSubview:views];
        UIView *viewss = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 0.5, 2, 0.5, CGRectGetHeight(self.frame) - 2)];
        viewss.backgroundColor = AppFontccccccColor;
        viewss.tag = 1122;
        [self addSubview:viewss];
    }
    if (_upleftimageView.image) {
        self.placeView.backgroundColor = AppFontf3f3f3Color;
    }else{
        self.placeView.backgroundColor = [UIColor clearColor];
        
    }
    
}

@end



