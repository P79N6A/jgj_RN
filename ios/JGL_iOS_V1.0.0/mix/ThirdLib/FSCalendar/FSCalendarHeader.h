//
//  FSCalendarHeader.h
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import <UIKit/UIKit.h>
#import "FSCalendarCollectionView.h"

@class FSCalendar,FSCalendarAppearance,FSCalendarHeader;
@protocol FSCalendarHeaderDelegate <NSObject>
@optional
- (void)FSCalendarHeaderSelected:(FSCalendarHeader *)fsCalendarHeader;
- (void)FSCalendarHeaderLeftandRIGHTSelected:(NSInteger )TAG;
@end

@interface FSCalendarHeader : UIView
@property (nonatomic , weak) id<FSCalendarHeaderDelegate> delegate;

@property (weak, nonatomic) FSCalendarCollectionView *collectionView;
@property (weak, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) FSCalendarAppearance *appearance;

@property (assign, nonatomic) CGFloat scrollOffset;
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (assign, nonatomic) BOOL scrollEnabled;
@property (assign, nonatomic) BOOL needsAdjustingViewFrame;
//刘远强添加两种样式分别
@property (assign,nonatomic) BOOL leftAndRightShow;//是否显示左右的箭头
@property (assign,nonatomic) BOOL hiddenHeaderTitle;//隐藏头部
@property (assign,nonatomic) BOOL isMainRecord;//是否显示左右的箭头
@property (assign,nonatomic) BOOL bigfont;//大字体
//添加点击更新头部年月
@property (nonatomic ,strong) NSDate *selectWeekDate;
//Tony修改过的地方
@property (assign,nonatomic) BOOL needSelectedTime;//YES:需要添加手势用于选择时间
@property (strong, nonatomic) UILabel *weekLable;
- (void)reloadData;

@end


@interface FSCalendarHeaderCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) FSCalendarHeader *header;
//Tony修改过的地方
@property (assign,nonatomic) BOOL needSelectedTime;//YES:需要添加手势用于选择时间
@property (weak, nonatomic) UIImageView *selectedImageView;
@property (weak, nonatomic) UIImageView *LeftselectedImageView;

@property (assign,nonatomic) BOOL leftAndRightShow;//是否显示左右的箭头

- (void)invalidateHeaderFont;
- (void)invalidateHeaderTextColor;

@end


@protocol FSCalendarHeaderLeftAndrightDelegate <NSObject>
- (void)FSCalendarHeaderLeftandRIGHTSelected:(NSInteger )TAG;
@end

//刘远强添加左右箭头布局样式
@interface FSLeftCalendarHeaderCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) FSCalendarHeader *header;

@property (assign,nonatomic) BOOL needSelectedTime;//YES:需要添加手势用于选择时间
@property (weak, nonatomic) UIImageView *selectedImageView;
@property (weak, nonatomic) UIImageView *rightSelectedImageView;
@property (strong, nonatomic) UIButton *calLeftBtn;
@property (strong, nonatomic) UIButton *calRightBtn;

@property (weak, nonatomic) id<FSCalendarHeaderLeftAndrightDelegate> delegate;

@property (assign,nonatomic) BOOL leftAndRightShow;//是否显示左右的箭头
@property (strong ,nonatomic) UIFont *titleFont;
- (void)invalidateHeaderFont;
- (void)invalidateHeaderTextColor;

@end


@interface FSBigfontCalendarHeaderCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) FSCalendarHeader *header;

@property (assign,nonatomic) BOOL needSelectedTime;//YES:需要添加手势用于选择时间
@property (weak, nonatomic) UIImageView *selectedImageView;
@property (weak, nonatomic) UIImageView *LeftselectedImageView;
@property (weak, nonatomic) id<FSCalendarHeaderLeftAndrightDelegate> delegate;

@property (assign,nonatomic) BOOL leftAndRightShow;//是否显示左右的箭头
@property (strong ,nonatomic) UIFont *titleFont;
- (void)invalidateHeaderFont;
- (void)invalidateHeaderTextColor;

@end



@interface FSCalendarHeaderTouchDeliver : UIView

@property (weak, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) FSCalendarHeader *header;

@end




