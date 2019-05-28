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

@interface FSCalendarCell ()
@property (readonly, nonatomic) UIColor *colorForBackgroundLayer;
@property (readonly, nonatomic) UIColor *colorForTitleLabel;
@property (readonly, nonatomic) UIColor *colorForSubtitleLabel;
@property (readonly, nonatomic) UIColor *colorForCellBorder;
@property (readonly, nonatomic) UILabel *topLable;
@property (strong, nonatomic) NSMutableArray *imageArr;

@property (readonly, nonatomic) FSCalendarCellShape cellShape;

@end

@implementation FSCalendarCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setUpView];
        
//        _needsAdjustingViewFrame = YES;
//        
//        UILabel *label;
//        CAShapeLayer *shapeLayer;
//        UIImageView *imageView;
//        FSCalendarEventIndicator *eventView;
//        
//        label = [[UILabel alloc] initWithFrame:CGRectZero];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor blackColor];
//        [self.contentView addSubview:label];
//        self.titleLabel = label;
//        
//        label = [[UILabel alloc] initWithFrame:CGRectZero];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:label];
//        self.subtitleLabel = label;
//        
//        shapeLayer = [CAShapeLayer layer];
//        shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
//        shapeLayer.hidden = YES;
//        [self.contentView.layer insertSublayer:shapeLayer below:_titleLabel.layer];
//        self.backgroundLayer = shapeLayer;
//        
//        eventView = [[FSCalendarEventIndicator alloc] initWithFrame:CGRectZero];
//        eventView.backgroundColor = [UIColor clearColor];
//        eventView.hidden = YES;
//        [self.contentView addSubview:eventView];
//        self.eventIndicator = eventView;
//        
//        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
//        [self.contentView addSubview:imageView];
//        self.imageView = imageView;
//        
//        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
//        [self.contentView addSubview:imageView];
//        [self.contentView bringSubviewToFront:imageView];
//        self.subImageView = imageView;
//        
//        
//        self.clipsToBounds = NO;
//        self.contentView.clipsToBounds = NO;
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
    
    
    _placeView = [[UIView alloc]initWithFrame:CGRectZero];
    _placeView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_placeView];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    self.subtitleLabel = label;
    
//    label = [[UILabel alloc] initWithFrame:CGRectZero];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor lightGrayColor];
//    label.font = [UIFont systemFontOfSize:11];
//    [self.contentView addSubview:label];
//    self.subDetailtitleLabel = label;
    
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
    
    
//    if (_calendar.rainCalendar) {
        _imageArr = [NSMutableArray arrayWithObjects:@"",@"calendar_weather_Clear",@"calendar_weather_Overcast",@"calendar_weather_cloudy",@"calendar_weather_rain",@"calendar_weather_wind",@"calendar_weather_snow",@"calendar_weather_fog",@"calendar_weather_haze",@"calendar_weather_frost",@"calendar_weather_power-outage", nil];

//    }
    
    //holdview
//    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
//    [self.contentView addSubview:imageView];
//    self.HoldView = imageView;
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
//    _backgroundLayer.frame = CGRectMake((self.bounds.size.width-diameter)/2-3,
//                                        (titleHeight-diameter)/2+3,
//                                        diameter+10,
//                                        diameter+6);
#pragma mark -刘远强修改城到边缘
    _backgroundLayer.frame = self.bounds;

    _backgroundLayer.borderWidth = 2.0;
    _backgroundLayer.borderColor = [UIColor clearColor].CGColor;//边框
    
    CGFloat eventSize = _backgroundLayer.frame.size.height/6.0;
    //Tony修改过的地方，去掉了eventSize*0.17,并且再减去0.5
#if 1
    _eventIndicator.frame = CGRectMake(0, CGRectGetMaxY(_backgroundLayer.frame) - eventSize*0.5, bounds.size.width, eventSize*0.83);
#else
    _eventIndicator.frame = CGRectMake(0, CGRectGetMaxY(_backgroundLayer.frame)+eventSize*0.17- eventSize*0.17, bounds.size.width, eventSize*0.83);
#endif
    _imageView.frame = self.contentView.bounds;
    //Tony修改过的地方
    CGFloat subImageViewW = self.bounds.size.width*0.2;
    _subImageView.frame = CGRectMake(self.bounds.size.width*(1 - 0.2 - 0.05)-1, self.bounds.size.width*0.1+2, subImageViewW, subImageViewW);
}

//2.1.0添加修改
/*
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    CGFloat titleHeight = self.bounds.size.height*5.0/6.0;
    CGFloat diameter = MIN(titleHeight,self.bounds.size.width);
    diameter = diameter > FSCalendarStandardCellDiameter ? (diameter - (diameter-FSCalendarStandardCellDiameter)*0.5) : diameter;
    _backgroundLayer.frame = CGRectMake((self.bounds.size.width-diameter)/2,
                                        (titleHeight-diameter)/2,
                                        diameter,

                                        diameter);
    _backgroundLayer.borderWidth = 1.0;
    _backgroundLayer.borderColor = [UIColor clearColor].CGColor;
    
    CGFloat eventSize = _backgroundLayer.frame.size.height/6.0;
    //Tony修改过的地方，去掉了eventSize*0.17,并且再减去0.5
#if 1
    _eventIndicator.frame = CGRectMake(0, CGRectGetMaxY(_backgroundLayer.frame) - eventSize*0.5, bounds.size.width, eventSize*0.83);
#else
    _eventIndicator.frame = CGRectMake(0, CGRectGetMaxY(_backgroundLayer.frame)+eventSize*0.17- eventSize*0.17, bounds.size.width, eventSize*0.83);
#endif
    _imageView.frame = self.contentView.bounds;
    
    //Tony修改过的地方
    CGFloat subImageViewW = self.bounds.size.width*0.2;
    _subImageView.frame = CGRectMake(self.bounds.size.width*(1 - 0.2 - 0.05), self.bounds.size.width*0.05, subImageViewW, subImageViewW);
}
*/
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

//        [self initRainCalendar];

        if (array.count ) {
            if ([array[0] isEqualToString:@""] ||[array[0] isEqualToString:@"0"] ) {
                self.contentView.backgroundColor = [UIColor whiteColor];
            }else{
                _upleftimageView.image = [UIImage imageNamed:_imageArr[[array[0] integerValue]]];
//                self.contentView.backgroundColor = AppFontf3f3f3Color;
            }
            if (array.count >1) {
            if ([array[1] isEqualToString:@""]||[array[1] isEqualToString:@"0"]) {
                self.contentView.backgroundColor = [UIColor whiteColor];

            }else{
                _uprightimageView.image = [UIImage imageNamed:_imageArr[[array[1] integerValue]]];
//                self.contentView.backgroundColor = AppFontf3f3f3Color;
 
            }
                }
            
            if (array.count > 2) {
                
            
            if ([array[2] isEqualToString:@""]||[array[2] isEqualToString:@"0"]) {
                self.contentView.backgroundColor = [UIColor whiteColor];
 
            }else{
                _downleftimageView.image = [UIImage imageNamed:_imageArr[[array[2] integerValue]]];
//                self.contentView.backgroundColor = AppFontf3f3f3Color;
            }
            }
            
            if (array.count > 3) {
            
            if ([array[3] isEqualToString:@""]||[array[3] isEqualToString:@"0"]) {
                self.contentView.backgroundColor = [UIColor whiteColor];

            }else{
                _downrightimageView.image = [UIImage imageNamed:_imageArr[[array[3] integerValue]]];
//                self.contentView.backgroundColor = AppFontf3f3f3Color;
 
            }
            }
       


        }
    if (_upleftimageView.image) {
        
    self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
        [self initRainCalendar];


        

    }else{
        
    [self initNormalcalendar];
        
    }

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
    _subImage = _subImage?:[UIImage imageNamed:@"warning"];
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
- (void)initNormalcalendar
{
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if ([self isToday]) {
        
        _titleLabel.text = [NSString stringWithFormat:@" %@今天",@([_calendar dayOfDate:_date])];
        [_titleLabel markText:@"今天" withFont:[UIFont systemFontOfSize:AppFont18Size] color:AppFontd7252cColor];
        
        
        
    }else{
        _titleLabel.text = [NSString stringWithFormat:@" %@",@([_calendar dayOfDate:_date])];
        
    }
    
    if (_subtitle ) {
        //设置有数据的日历单元格背景颜色
        self.backgroundColor = AppFontffffffColor;
        if (_subtitle.length>=1 &&self.calendar.scope != FSCalendarScopeWeek) {
            
        }
        _subtitleLabel.numberOfLines = 2;
        NSArray *array = [NSArray array];
        array = [_subtitle componentsSeparatedByString:@"-"];
        if (array.count == 2) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@ ",array.firstObject,array.lastObject]];
            [attrStr addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:12.0f]
                            range:NSMakeRange(0, [(NSString *)array.firstObject length])];
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:JGJMainColor
                            range:NSMakeRange(0, [(NSString *)array.firstObject length])];
            [attrStr addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:12.0f]
                            range:NSMakeRange([(NSString *)array.firstObject length], [(NSString *)array.lastObject length]+1)];
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:AppFont6487e0Color
                            range:NSMakeRange([(NSString *)array.firstObject length], [(NSString *)array.lastObject length]+1)];
            
            _subtitleLabel.attributedText = attrStr;
            self.backgroundColor = AppFontfdf0f0Color;
        }else{
            _subtitleLabel.text = [NSString stringWithFormat:@" %@",array.firstObject];
            _subtitleLabel.textColor = JGJMainColor;
        }
        if ([_subtitle containsString: @"休息"]) {
            if ([_subtitle isEqualToString:@"休息"]) {
                self.backgroundColor = AppFontf1f1f1Color;
                _subtitleLabel.text = @" 休息";
                _subtitleLabel.font = [UIFont systemFontOfSize:12];
                _subtitleLabel.textColor = AppFonte73bf5cColor;
            }else{
                if (array.count >=2) {
                    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@ ",array.firstObject,array.lastObject]];
                    [attrStr addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:12.0f]
                                    range:NSMakeRange(0, [(NSString *)array.firstObject length])];
                    [attrStr addAttribute:NSForegroundColorAttributeName
                                    value:AppFonte83c76eColor
                                    range:NSMakeRange(0, [(NSString *)array.firstObject length])];
                    [attrStr addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:12.0f]
                                    range:NSMakeRange([(NSString *)array.firstObject length], [(NSString *)array.lastObject length]+1)];
                    [attrStr addAttribute:NSForegroundColorAttributeName
                                    value:AppFont6487e0Color
                                    range:NSMakeRange([(NSString *)array.firstObject length], [(NSString *)array.lastObject length]+1)];
                    _subtitleLabel.attributedText = attrStr;
                    
                    
                }
            }
        }
        
        
        if (_needsAdjustingViewFrame || CGSizeEqualToSize(_titleLabel.frame.size, CGSizeZero)) {
            _needsAdjustingViewFrame = NO;
            if (_subtitle) {
                CGFloat titleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}].height;
                CGFloat subtitleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:_subtitleLabel.font}].height;
                CGFloat height = titleHeight + subtitleHeight;
                
                //Tony修改过的地方
                if (self.calendar.scope == FSCalendarScopeMonth) {
                    _titleLabel.frame = CGRectMake(0,
                                                   (self.contentView.fs_height*5.0/6.0-height)*0.5+_appearance.titleVerticalOffset - 2.5,
                                                   self.fs_width,
                                                   titleHeight);
                }else{
                    _titleLabel.frame = CGRectMake(0,
                                                   7,
                                                   self.fs_width,
                                                   titleHeight);
                }
                _subtitleLabel.frame = CGRectMake(5,
                                                  _titleLabel.fs_bottom - (_titleLabel.fs_height-_titleLabel.font.pointSize)+_appearance.subtitleVerticalOffset+2.1,
                                                  self.fs_width - 5,
                                                  subtitleHeight+15);
#pragma mark- 添加加班时长按钮
                //            _subDetailtitleLabel.frame = CGRectMake(0,
                //                                               _titleLabel.fs_bottom - (_titleLabel.fs_height-_titleLabel.font.pointSize)+_appearance.subtitleVerticalOffset+_subtitleLabel.frame.size.height+1,
                //                                                    self.fs_width,
            } else {
                _titleLabel.frame = CGRectMake(0, _appearance.titleVerticalOffset, self.fs_width, floor(self.contentView.fs_height*5.0/6.0));
            }
        }
        if (_subtitleLabel.hidden) {
            _subtitleLabel.hidden = NO;
            _subDetailtitleLabel.hidden = NO;
        }
    } else {
        if (!_subtitleLabel.hidden) {
            _subtitleLabel.hidden = YES;
            _subDetailtitleLabel.hidden = YES;
        }
    }
    
    
    UIColor *textColor = self.colorForTitleLabel;
    if (![textColor isEqual:_titleLabel.textColor]) {
        _titleLabel.textColor = textColor;
    }
    if (_subtitle) {
        textColor = self.colorForSubtitleLabel;
        if (![textColor isEqual:_subtitleLabel.textColor]) {
            //            _subtitleLabel.textColor = textColor;
            //            _subtitleLabel.textColor = JGJMainColor;
            
            //            if ([_subtitle containsString:@"休息"]  ) {
            //            _subtitleLabel.textColor = [UIColor greenColor];
            //            }
        }
    }
    //    _titleLabel.textColor = AppFont333333Color;
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
        if (!CGColorEqualToColor(_backgroundLayer.fillColor, backgroundColor)) {
            
            //            _backgroundLayer.fillColor = backgroundColor;//填充颜色
            if (_calendar.scope == FSCalendarScopeMonth) {
                if ([_subtitle containsString:@"休息"]) {
                    _backgroundLayer.fillColor = AppFontf1f1f1Color.CGColor;
                }else{
                    if (_subtitle) {
                        _backgroundLayer.fillColor = AppFontfdf0f0Color.CGColor;
                        
                    }else{
                        _backgroundLayer.fillColor = [UIColor whiteColor].CGColor;
                    }
                }
            }else{
#pragma mark -单独设置月份的选择颜色
                _backgroundLayer.fillColor = backgroundColor;
            }
        }
        CGColorRef borderColor = self.colorForCellBorder.CGColor;
        if (!CGColorEqualToColor(_backgroundLayer.strokeColor, borderColor)) {
            _backgroundLayer.strokeColor = borderColor;
        }
    }
    if (![_image isEqual:_imageView.image]) {
        [self invalidateImage];
    }
    //设置颜色  外部设置无效
    if (self.calendar.scope == FSCalendarScopeWeek) {
        _subtitleLabel.textColor = AppFontccccccColor;
    }
    if (self.selected) {
        if (_calendar.scope == FSCalendarScopeWeek) {
            _subtitleLabel.textColor = AppFontd7252cColor;
        }
    }else{
        
    }
    //右上角差账图标
    
    [self invalidateSubImage];
    
    if (_eventIndicator.hidden == (_numberOfEvents > 0)) {
        _eventIndicator.hidden = !_numberOfEvents;
    }
    _eventIndicator.numberOfEvents = self.numberOfEvents;
    _eventIndicator.color = self.preferedEventColor ?: _appearance.eventColor;
    
    
    if (_subtitle.length &&_calendar.scope == FSCalendarScopeMonth) {
        if ([_subtitle containsString: @"休息"]) {
            self.backgroundColor = AppFontf1f1f1Color;
        }
    }


}
- (void)initRainCalendar
{
    
    if ([self isToday] && !_dateIsSelected && _upleftimageView.image) {
//        self.contentView.backgroundColor = AppFontf3f3f3Color;
        
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
                                               (self.contentView.fs_height*5.0/6.0-height)*0.5+_appearance.titleVerticalOffset - 5.5,
                                               self.fs_width,
                                               titleHeight);
                
                _placeView.frame = CGRectMake(1, 1, CGRectGetWidth(self.contentView.frame) - 2, CGRectGetHeight(self.contentView.frame) - 2);

                
                _upleftimageView.frame = CGRectMake(5, (self.contentView.fs_height*5.0/6.0-height)*0.5+_appearance.titleVerticalOffset -5.5 + titleHeight , 14, 14);
                _uprightimageView.frame = CGRectMake(22,  (self.contentView.fs_height*5.0/6.0-height)*0.5+_appearance.titleVerticalOffset -5.5 + titleHeight , 14, 14);
                _downleftimageView.frame = CGRectMake(5, (self.contentView.fs_height*5.0/6.0-height)*0.5+_appearance.titleVerticalOffset -4.8 + titleHeight  + 15, 14, 14);
                _downrightimageView.frame = CGRectMake(22,  (self.contentView.fs_height*5.0/6.0-height)*0.5+_appearance.titleVerticalOffset -4.8 + titleHeight  +15, 14, 14);
                
            }        }

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
            self.placeView.backgroundColor = AppFontf3f3f3Color;

             }else{
            self.placeView.backgroundColor = [UIColor whiteColor];
                 
             }
            if (_dateIsSelected) {
                self.placeView.backgroundColor = AppFontfafafaColor;
  
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
//                self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
//                self.contentView.layer.borderWidth = 0;
            _backgroundLayer.strokeColor = [UIColor whiteColor].CGColor;

            }else{
            _backgroundLayer.strokeColor = AppFontE44343DColor.CGColor;
//                self.contentView.layer.borderColor = [UIColor redColor].CGColor;
//                self.contentView.layer.borderWidth = 0.5;
            }
      

        }

        
        
    }
    if (![_image isEqual:_imageView.image]) {
        [self invalidateImage];
    }

    //设置颜色  外部设置无效

    //右上角差账图标
    
//    [self invalidateSubImage];
    
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
        
        UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5)];
        
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
- (void)setRainImageviewimage:(UIImageView *)imageview withTag:(NSString *)inter withCount:(NSInteger)count
{
    self.contentView.backgroundColor = AppFontf3f3f3Color;



}

@end



