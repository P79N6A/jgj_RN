//
//  JGJWorkTypeCollectionView.h
//  mix
//
//  Created by yj on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
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
    NormalWorkTimeType = 1,
    OverWorkTimeType,
} SelectedTimeType;
@class JGJWorkTypeCollectionView;

@protocol JGJWorkTypeCollectionViewDelegate <NSObject>
- (void)didClickedCancelButtonPressed:(JGJWorkTypeCollectionView *)workTypeCollectionView;
- (void)didClickedMoreButtonPressed:(JGJWorkTypeCollectionView *)workTypeCollectionView;
@end

@interface JGJWorkTypeCollectionView : UIView
@property (nonatomic, assign) BOOL isOpen;//设置时候展开
@property (nonatomic, assign) BOOL isOnlyShowHeaderView;//只显示头部
@property (nonatomic, assign) NSUInteger limitCount;//默认显示数量
@property (nonatomic, copy)   BlockCancelButtonDidClicked blockCancelButtonDidClicked;
@property (nonatomic, assign) CGFloat workTypeHeight;
@property (nonatomic, weak) id <JGJWorkTypeCollectionViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame workType:(void(^)(FHLeaderWorktype *workTypeModel)) workTypeModel;//显示工种
- (instancetype)initWithFrame:(CGRect)frame timeModel:(JGJShowTimeModel *)timeModel SelectedTimeType:(SelectedTimeType )selectedTimeType isOnlyShowHeaderView:(BOOL)isOnlyShowHeaderView blockSelectedTime:(void(^)(JGJShowTimeModel *timeModel)) blockSelectedTime;//仅显示时间
@end
