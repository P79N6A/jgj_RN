//
//  FSCalendarCell.h
//  Pods
//
//  Created by Wenchao Ding on 12/3/15.
//
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "FSCalendarEventIndicator.h"
#import "YYText.h"
#import "JGJMoreDaySelectedModel.h"
@interface FSCalendarCell : UICollectionViewCell

@property (weak, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) FSCalendarAppearance *appearance;

@property (weak, nonatomic) UILabel  *titleLabel;
@property (weak, nonatomic) YYLabel  *todayLable;

@property (weak, nonatomic) UILabel  *subtitleLabel;//上班时长
@property (weak, nonatomic) UILabel  *subDetailtitleLabel;//加班
@property (weak, nonatomic) NSString  *subStr;//加班
@property (weak, nonatomic) NSString  *subDetailStr;//加班

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIImageView *subImageView;//右上角放图片的view
@property (weak, nonatomic) UIImageView *HoldView;//选中图片
@property (strong, nonatomic) UIView *placeView;//设置每个item的间隔

@property (weak, nonatomic) CAShapeLayer *backgroundLayer;
@property (weak, nonatomic) FSCalendarEventIndicator *eventIndicator;

@property (strong, nonatomic) NSDate   *date;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) UIImage  *image;
@property (strong, nonatomic) UIImage  *subImage;//显示在右上角的图片
@property (assign, nonatomic) BOOL subImageHidden;//是否显示右上角的图片，YES,显示，NO,不显示
@property (nonatomic, assign) BOOL showTodayNotShowSubImage;// 显示今天 不显示已记账的勾勾  用于一天记多人
// v3.4.1cc 添加
@property (nonatomic, assign) BOOL showHoldView;// 用于一人记多天

// v3.5.2 cc添加 用于一人记多天 区分记的时候选择的是点还是包工考勤  0 -> 点工 1 -> 包工考勤
@property (nonatomic, assign) NSInteger contractorType;
@property (nonatomic, strong) JGJMoreDaySelectedModel *moreDaySelectedModel;

#pragma mark- 晴雨表四个图片
@property (weak, nonatomic) UIImageView *upleftimageView;
@property (weak, nonatomic) UIImageView *uprightimageView;
@property (weak, nonatomic) UIImageView *downleftimageView;
@property (weak, nonatomic) UIImageView *downrightimageView;
//记过帐的当天的右上角的勾勾
@property (weak, nonatomic) UIImageView *recordedImageView;
@property (weak, nonatomic) UIImageView *leftRecordedImageView;// 左边显示的图标
@property (weak, nonatomic) UIImageView *rightRecordedImageView;// 右边显示的图标

@property (assign, nonatomic) BOOL needsAdjustingViewFrame;
@property (assign, nonatomic) NSInteger numberOfEvents;

@property (assign, nonatomic) BOOL dateIsPlaceholder;
@property (assign, nonatomic) BOOL dateIsSelected;
@property (assign, nonatomic) BOOL dateIsToday;
@property (strong, nonatomic) NSDate   *selectedDate;
@property (readonly, nonatomic) BOOL weekend;

@property (strong, nonatomic) UIColor *preferedSelectionColor;
@property (strong, nonatomic) UIColor *preferedTitleDefaultColor;
@property (strong, nonatomic) UIColor *preferedTitleSelectionColor;
@property (strong, nonatomic) UIColor *preferedSubtitleDefaultColor;
@property (strong, nonatomic) UIColor *preferedSubtitleSelectionColor;
@property (strong, nonatomic) UIColor *preferedEventColor;
@property (strong, nonatomic) UIColor *preferedBorderDefaultColor;
@property (strong, nonatomic) UIColor *preferedBorderSelectionColor;
@property (assign, nonatomic) FSCalendarCellShape preferedCellShape;
@property (strong, nonatomic) UILabel *departLable;

//2.1.0添加修改
- (void)setUpView;

//2.1.0添加修改
- (void)setUpBounds:(CGRect)bounds;

//2.1.0添加修改
- (void)configureCell;

//2.1.0添加修改
- (void)setUpPrepareForReuse;

- (CAAnimationGroup * )setUpAnimation;

- (void)invalidateTitleFont;
- (void)invalidateSubtitleFont;
- (void)invalidateTitleTextColor;
- (void)invalidateSubtitleTextColor;

- (void)invalidateBorderColors;
- (void)invalidateBackgroundColors;
- (void)invalidateEventColors;
- (void)invalidateCellShapes;

- (void)invalidateImage;
- (void)invalidateSubImage;

- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary;
- (void)performSelecting;

@end
