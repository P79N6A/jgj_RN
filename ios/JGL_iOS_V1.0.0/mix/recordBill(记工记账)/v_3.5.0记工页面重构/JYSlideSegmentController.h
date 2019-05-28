//
//  JYSlideSegmentController.h
//  JYSlideSegmentController
//
//  Created by Alvin on 14-3-16.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const segmentBarItemID;

@class JYSlideSegmentController;

/**
 *  Need to be implemented this methods for custom UI of segment button
 */
@protocol JYSlideSegmentDataSource <NSObject>
@required

- (NSInteger)slideSegment:(UICollectionView *)segmentBar
   numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)slideSegment:(UICollectionView *)segmentBar
            cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInslideSegment:(UICollectionView *)segmentBar;

@end

@protocol JYSlideSegmentDelegate <NSObject>
@optional
- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController;

- (BOOL)slideSegment:(UICollectionView *)segmentBar shouldSelectViewController:(UIViewController *)viewController;
@end

typedef NS_ENUM(NSInteger, JYSlideSegmentType) {
    
    JYSlideSegmentTinyAndContractType,// 点工 包工记工天 包工记账
    JYSlideSegmentBorrowAndCloseCountType// 借支 结算
};
@interface JYSlideSegmentController : UIViewController

/**
 *  Child viewControllers of SlideSegmentController
 */
@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic, strong, readonly) UICollectionView *segmentBar;
@property (nonatomic, strong, readonly) UIScrollView *slideView;
@property (nonatomic, strong, readonly) UIImageView *indicator;

@property (nonatomic, assign) UIEdgeInsets indicatorInsets;

@property (nonatomic, weak, readonly) UIViewController *selectedViewController;

@property (nonatomic, assign) NSInteger defultSelectedIndex;

//结算用户信息 用于未结工资页面点击 -> 去结算 跳转到结算页面使用
@property (nonatomic, strong) JGJSynBillingModel *closeUserInfo;
@property (nonatomic, assign) BOOL makeBillRecordHomeComeIn;// 4.0.0首页改版，记工记账页面变成首页
@property (nonatomic, assign) BOOL is_Home_ComeIn;// 是否是从首页进入记账页面
@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, assign) BOOL oneDayAttendanceComeIn;// 每日考勤进入
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (strong ,nonatomic)NSDate *selectedDate;// 默认选中的时间
@property (nonatomic, copy) NSString *agency_uid;// 代班长uid
@property (nonatomic,assign) BOOL getTpl;//该不该初始化薪资模板

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (nonatomic, copy) NSArray *typeArrays;
@property (nonatomic, assign) JYSlideSegmentType segmentType;
/**
 *  By default segmentBar use viewController's title for segment's button title
 *  You should implement JYSlideSegmentDataSource & JYSlideSegmentDelegate instead of segmentBar delegate & datasource
 */
@property (nonatomic, assign) id <JYSlideSegmentDelegate> delegate;
@property (nonatomic, assign) id <JYSlideSegmentDataSource> dataSource;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated;

- (void)markBillMoreDaySuccessComeBack;

- (void)refreshGetOutstandingAmount;

- (void)refreshTinyAmountVcAccountMemberWithJGJSynBillingModel:(JGJSynBillingModel *)Model;
- (void)refreshMakeAttendanceVcAccountMemberWithJGJSynBillingModel:(JGJSynBillingModel *)Model;
@end

@interface JYSlideSegmentModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *normal_image;
@property (nonatomic, copy) NSString *selected_image;
@property (nonatomic, assign) BOOL is_selected;

@end
