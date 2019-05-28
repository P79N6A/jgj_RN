//
//  JGJSelctServerTimeview.h
//  JGJCompany
//
//  Created by Tony on 2017/7/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ItemHeight 40
#define ItemWidth 77.5
#define ItemOtherWidth 65
#define LinePadding 10
#define FooterHegiht 50
#define HeaderHegiht 50
#define TopViewY (TYIS_IPHONE_4_OR_LESS ? 64 : 0)
@class FHLeaderWorktype;
typedef void(^BlockCancelButtonDidClicked)();

typedef enum : NSUInteger {
    NormalWorkTimeTypes = 1,
    OverWorkTimeTypes
//    WageLevelNormalWorkTimeType, //工资标准上班时长
//    WageLevelOverWorkTimeType //工资标准加班时长
} SelectlistedTimeTypess;
@class JGJWorkTypeCollectionView;
@protocol JGJWorkTypeCollectionViewDelegates <NSObject>
- (void)didClickedCancelButtonPressed:(JGJWorkTypeCollectionView *)workTypeCollectionView;
- (void)didClickedMoreButtonPressed:(JGJWorkTypeCollectionView *)workTypeCollectionView;
@end

@interface JGJSelctServerTimeview : UIView
@property (nonatomic, assign) BOOL isOpen;//设置时候展开
@property (nonatomic, assign) BOOL isOnlyShowHeaderView;//只显示头部
@property (nonatomic, assign) BOOL isShowZero;//要不要显示后面那个0

@property (nonatomic, assign) NSUInteger limitCount;//默认显示数量
@property (nonatomic, copy)   BlockCancelButtonDidClicked blockCancelButtonDidClicked;
@property (nonatomic, assign) CGFloat workTypeHeight;
@property (nonatomic, weak) id <JGJWorkTypeCollectionViewDelegates>delegate;
- (instancetype)initWithFrame:(CGRect)frame workType:(void(^)(FHLeaderWorktype *workTypeModel)) workTypeModel;//显示工种
- (instancetype)initWithFrame:(CGRect)frame timeModel:(JGJShowTimeModel *)timeModel SelectedTimeType:(SelectlistedTimeTypess )selectedTimeType isOnlyShowHeaderView:(BOOL)isOnlyShowHeaderView blockSelectedTime:(void(^)(JGJShowTimeModel *timeModel)) blockSelectedTime;//仅显示时间
@end

