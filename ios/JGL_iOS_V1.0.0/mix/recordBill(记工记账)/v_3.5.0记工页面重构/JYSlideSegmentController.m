
//
//  JYSlideSegmentController.m
//  JYSlideSegmentController
//
//  Created by Alvin on 14-3-16.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "JYSlideSegmentController.h"
#import "SJButton.h"
#import "JGJTinyAmountMarkBillController.h"
#import "JGJContractorMakeAccountController.h"
#import "JGJContractorMakeAttendanceController.h"
#import "JGJBrrowBillController.h"
#import "JGJCloseAccountBillController.h"
#import "JGJSlideSegementTinyMaskingView.h"
#import "JGJQustionShowView.h"
#import "JLGCustomViewController.h"
#import "IQKeyboardManager.h"
#define SEGMENT_BAR_HEIGHT 80
#define INDICATOR_HEIGHT 8


NSString * const segmentBarItemID = @"JYSegmentBarItem";

@interface JYSegmentBarItem : UICollectionViewCell

@property (nonatomic, strong) JYSlideSegmentModel *segmentModel;
@property (nonatomic, strong) SJButton *markBillTypeBtn;

@end


@implementation JYSegmentBarItem

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
      
      self.contentView.backgroundColor = AppFont3A3F4EColor;
      [self initializeAppearance];
  }
  return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.markBillTypeBtn];
}

- (void)setSegmentModel:(JYSlideSegmentModel *)segmentModel {
    
    _segmentModel = segmentModel;
    
    [_markBillTypeBtn setTitle:_segmentModel.title forState:(SJControlStateNormal)];
    
    [_markBillTypeBtn setImage:IMAGE(_segmentModel.normal_image) forState:(SJControlStateNormal)];
    [_markBillTypeBtn setImage:IMAGE(_segmentModel.selected_image) forState:(SJControlStateSelected)];
    
    _markBillTypeBtn.selected = _segmentModel.is_selected;
}


- (SJButton *)markBillTypeBtn {
    
    if (!_markBillTypeBtn) {
        
        _markBillTypeBtn = [SJButton buttonWithType:SJButtonTypeVerticalImageTitle];
        _markBillTypeBtn.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        [_markBillTypeBtn setBackgroundColor:[UIColor clearColor]];
        [_markBillTypeBtn setTitleColor:AppFont9FA1A8Color forState:(SJControlStateNormal)];
        [_markBillTypeBtn setTitleColor:AppFontffffffColor forState:SJControlStateSelected];
        _markBillTypeBtn.titleLabel.font = FONT(AppFont30Size);
        _markBillTypeBtn.space = 0;
        _markBillTypeBtn.userInteractionEnabled = NO;
        
    }
    return _markBillTypeBtn;
}



@end

@interface JYSlideSegmentController ()
<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UICollectionView *segmentBar;
@property (nonatomic, strong, readwrite) UIScrollView *slideView;
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
@property (nonatomic, strong, readwrite) UIImageView *indicator;

@property (nonatomic, strong) UIView *indicatorBgView;

@property (nonatomic, strong) UICollectionViewFlowLayout *segmentBarLayout;
@property (nonatomic, assign) NSInteger defualtSelectedIndex;// 默认选中的位置

@property (nonatomic, strong) JGJSlideSegementTinyMaskingView *maskingView;

@property (nonatomic, strong) JGJTinyAmountMarkBillController *tinyAmountVC;
@property (nonatomic, strong) JGJContractorMakeAttendanceController *makeAttendanceVC;
@property (nonatomic, strong) JGJContractorMakeAccountController *makeAccountVC;

@property (nonatomic, strong) JGJBrrowBillController *brrowBillVC;
@property (nonatomic, strong) JGJCloseAccountBillController *closeAccountVC;



- (void)reset;

@end

@implementation JYSlideSegmentController
@synthesize viewControllers = _viewControllers;
@synthesize typeArrays = _typeArrays;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
    
    self = [super init];
    if (self) {
   
        _viewControllers = [viewControllers copy];
        _selectedIndex = NSNotFound;
    }
  
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupSubviews];
    [self reset];
    
    [self initialAllVC];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
    if (self.segmentType == JYSlideSegmentBorrowAndCloseCountType) {// 这样做是为了让控制器一开始就初始化出来
        
        if (self.defultSelectedIndex == 1) {
            
            self.selectedIndex = 1;
            [self scrollToViewWithIndex:self.selectedIndex animated:NO];
        }
    }
    
#pragma mark - 这里处理记账页面的默认选中逻辑, 点工 包工记账 包工记工天页面---工人身份 -> 默认选中上次记账的类型 人员 上班加班时间和项目 班组长身份 -> 默认只选中上次记账的类型 借支 结算模块 -> 不论什么身份都默认选中第一个(除了未结工资页面进去结算选中结算模块外)
    if (self.segmentType == JYSlideSegmentTinyAndContractType) {// 点工 包工记账 包工记工天 记多人进入记单笔和班组进入记单笔都不做此操作
        
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        
        if (JLGisLeaderBool || _markBillMore) {// 当前身份是班组长 或者是从记多天->记单笔
            
            NSString *key = [NSString stringWithFormat:@"JLGLastRecordLeaderBillPeople_%@",[TYUserDefaults objectForKey:JLGUserUid]];
            parmDic = [TYUserDefaults objectForKey:key];
            if (parmDic) {
                
                if ([parmDic[@"accounts_type"] integerValue] == 1) {
                    
                    self.selectedIndex = 0;
                    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
                    
                }else if ([parmDic[@"accounts_type"] integerValue] == 2) {
                    
                    self.selectedIndex = 2;
                    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
                    
                }else if ([parmDic[@"accounts_type"] integerValue] == 5) {
                    
                    self.selectedIndex = 1;
                    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
                }
            }
        }else {// 当前身份是工人身份 首页班组记工->记单笔
            
            NSString *key = [NSString stringWithFormat:@"JLGLastRecordMateBillPeople_%@",[TYUserDefaults objectForKey:JLGUserUid]];
            parmDic = [TYUserDefaults objectForKey:key];
            if (parmDic) {
                
                if ([parmDic[@"accounts_type"] integerValue] == 1) {
                    
                    self.selectedIndex = 0;
                    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
                    
                }else if ([parmDic[@"accounts_type"] integerValue] == 2) {
                    
                    self.selectedIndex = 2;
                    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
                    
                }else if ([parmDic[@"accounts_type"] integerValue] == 5) {
                    
                    self.selectedIndex = 1;
                    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
                }
            }
            
            
        }
        
    }
    
    [self justRealName];
}

- (void)initialAllVC {
    
    if (self.segmentType == JYSlideSegmentTinyAndContractType) {// 这样做是为了让控制器一开始就初始化出来 并默认选中要选中的控制器
        
        self.selectedIndex = 2;
        [self scrollToViewWithIndex:self.selectedIndex animated:NO];
        
        self.selectedIndex = 1;
        [self scrollToViewWithIndex:self.selectedIndex animated:NO];
        
        #pragma mark - 默认选中包工记工天
        self.selectedIndex = 0;
        [self scrollToViewWithIndex:self.selectedIndex animated:NO];

        BOOL _isHaveOpenMaskinfView = [[NSUserDefaults standardUserDefaults] boolForKey:@"SlideSegementOpenMaskingView"];

        if (!_isHaveOpenMaskinfView) {

            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            [window addSubview:self.maskingView];

            [_maskingView mas_makeConstraints:^(MASConstraintMaker *make) {

                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(JGJ_IphoneX_Or_Later ? 24 : 0);
            }];

            __weak typeof(self) weakSelf = self;
            _maskingView.maskingTouch = ^{

                [weakSelf.maskingView removeFromSuperview];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SlideSegementOpenMaskingView"];
            };
        }
        
        
    }else if (self.segmentType == JYSlideSegmentBorrowAndCloseCountType) {// 这样做是为了让控制器一开始就初始化出来
        
        self.selectedIndex = 1;
        [self scrollToViewWithIndex:self.selectedIndex animated:NO];
        
        self.selectedIndex = 0;
        [self scrollToViewWithIndex:self.selectedIndex animated:NO];
        
    }
}

- (JGJSlideSegementTinyMaskingView *)maskingView {
    
    if (!_maskingView) {
        
        _maskingView = [[JGJSlideSegementTinyMaskingView alloc] init];
    }
    return _maskingView;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    CGSize conentSize = CGSizeMake(self.view.frame.size.width * self.viewControllers.count, 0);
    [self.slideView setContentSize:conentSize];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBarTintColor:AppFont3A3F4EColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppFontffffffColor}];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"barButtonItem_back_white"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"barButtonItem_back_white"] forState:UIControlStateHighlighted];
    
    leftButton.frame = CGRectMake(0, 0, 45, JGJLeftButtonHeight);
    // 让按钮内部的所有内容左对齐
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让按钮的内容往左边偏移10
    leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)backButtonPressed {
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [JGJQustionShowView removeQustionView];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.barTintColor = AppFontffffffColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppFont333333Color,NSFontAttributeName:[UIFont systemFontOfSize:JGJNavBarFont]}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    
    
}
#pragma mark - Setup
- (void)setupSubviews {
    
    // iOS7 set layout
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view addSubview:self.segmentBar];
    [self.view addSubview:self.slideView];
    [self.segmentBar registerClass:[JYSegmentBarItem class] forCellWithReuseIdentifier:segmentBarItemID];
    [self.segmentBar addSubview:self.indicatorBgView];
}

#pragma mark - Property
- (UIScrollView *)slideView {
    
    if (!_slideView) {
        
        CGRect frame = self.view.bounds;
        frame.size.height -= _segmentBar.frame.size.height;
        frame.origin.y = CGRectGetMaxY(_segmentBar.frame);
        _slideView = [[UIScrollView alloc] initWithFrame:frame];
        [_slideView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth
                                         | UIViewAutoresizingFlexibleHeight)];
        [_slideView setShowsHorizontalScrollIndicator:NO];
        [_slideView setShowsVerticalScrollIndicator:NO];
        [_slideView setPagingEnabled:YES];
        [_slideView setBounces:NO];
        [_slideView setDelegate:self];
    }
    return _slideView;
}

- (UICollectionView *)segmentBar {
    
    if (!_segmentBar) {
        
        CGRect frame = self.view.bounds;
        frame.size.height = SEGMENT_BAR_HEIGHT;
        _segmentBar = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.segmentBarLayout];
        _segmentBar.backgroundColor = AppFont3A3F4EColor;
        _segmentBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _segmentBar.delegate = self;
        _segmentBar.dataSource = self;
    }
    return _segmentBar;
}

- (UIView *)indicatorBgView {
 
    if (!_indicatorBgView) {
   
        CGRect frame = CGRectMake(0, self.segmentBar.frame.size.height - INDICATOR_HEIGHT,
                              self.view.frame.size.width / self.viewControllers.count, INDICATOR_HEIGHT);
    
        _indicatorBgView = [[UIView alloc] initWithFrame:frame];
        _indicatorBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _indicatorBgView.backgroundColor = AppFont3A3F4EColor;
        [_indicatorBgView addSubview:self.indicator];
  
    }
  
    return _indicatorBgView;
}

- (UIImageView *)indicator {
    
    if (!_indicator) {
   
        CGRect frame = CGRectMake((self.view.frame.size.width / self.viewControllers.count) / 2 - INDICATOR_HEIGHT, 0, 16, INDICATOR_HEIGHT);
        _indicator = [[UIImageView alloc] initWithFrame:frame];
        _indicator.image = [UIImage imageNamed:@"slideSegementMaskingArrowImage"];
        
        _indicator.backgroundColor = [UIColor clearColor];
        
    }
    return _indicator;
}

- (void)setIndicatorInsets:(UIEdgeInsets)indicatorInsets {
   
    _indicatorInsets = indicatorInsets;
    CGRect frame = _indicator.frame;
    frame.origin.x = _indicatorInsets.left;
    CGFloat width = self.view.frame.size.width / self.viewControllers.count - _indicatorInsets.left - _indicatorInsets.right;
    frame.size.width = width;
    frame.size.height = INDICATOR_HEIGHT;
    _indicator.frame = CGRectMake((self.view.frame.size.width / self.viewControllers.count) / 2 - INDICATOR_HEIGHT, 0, 11, INDICATOR_HEIGHT);;
}

- (UICollectionViewFlowLayout *)segmentBarLayout {
  
    if (!_segmentBarLayout) {
  
        _segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
        _segmentBarLayout.itemSize = CGSizeMake(self.view.frame.size.width / self.viewControllers.count, SEGMENT_BAR_HEIGHT);
        _segmentBarLayout.sectionInset = UIEdgeInsetsZero;
        _segmentBarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _segmentBarLayout.minimumLineSpacing = 0;
        _segmentBarLayout.minimumInteritemSpacing = 0;
    }
    return _segmentBarLayout;
}

- (void)setSegmentType:(JYSlideSegmentType)segmentType {
    
    _segmentType = segmentType;
    
    // 点工 包工
    if (_segmentType == JYSlideSegmentTinyAndContractType) {
        
        // 点工
        NSMutableArray *vcArray = [[NSMutableArray alloc] init];
        JGJTinyAmountMarkBillController *tinyAmountVC = [[JGJTinyAmountMarkBillController alloc] init];
        if (_selectedDate) {
            
            tinyAmountVC.selectedDate = self.selectedDate;
        }
        
        tinyAmountVC.oneDayAttendanceComeIn = self.oneDayAttendanceComeIn;
        tinyAmountVC.is_Home_ComeIn = _is_Home_ComeIn;
        tinyAmountVC.markBillMore = _markBillMore;
        tinyAmountVC.isAgentMonitor = _isAgentMonitor;
        tinyAmountVC.agency_uid = _agency_uid;
        tinyAmountVC.workProListModel = _workProListModel;
        
        _tinyAmountVC = tinyAmountVC;
        [vcArray addObject:tinyAmountVC];

        // 包工记工天
        JGJContractorMakeAttendanceController *attendanceVC = [[JGJContractorMakeAttendanceController alloc] init];
        if (_selectedDate) {
            
            attendanceVC.selectedDate = self.selectedDate;
        }
        
        attendanceVC.oneDayAttendanceComeIn = self.oneDayAttendanceComeIn;
        attendanceVC.is_Home_ComeIn = _is_Home_ComeIn;
        attendanceVC.markBillMore = _markBillMore;
        attendanceVC.isAgentMonitor = _isAgentMonitor;
        attendanceVC.agency_uid = _agency_uid;
        attendanceVC.workProListModel = _workProListModel;
        
        _makeAttendanceVC = attendanceVC;
        [vcArray addObject:attendanceVC];
        
        // 包工记账
        JGJContractorMakeAccountController *accountVC = [[JGJContractorMakeAccountController alloc] init];
        if (_selectedDate) {
            
            accountVC.selectedDate = self.selectedDate;
        }
        accountVC.makeBillRecordHomeComeIn = self.makeBillRecordHomeComeIn;
        accountVC.oneDayAttendanceComeIn = self.oneDayAttendanceComeIn;
        accountVC.is_Home_ComeIn = _is_Home_ComeIn;
        accountVC.markBillMore = _markBillMore;
        accountVC.isAgentMonitor = _isAgentMonitor;
        accountVC.agency_uid = _agency_uid;
        accountVC.workProListModel = _workProListModel;
        
        _makeAccountVC = accountVC;
        [vcArray addObject:accountVC];

        

        JYSlideSegmentModel *tinyModel = [[JYSlideSegmentModel alloc] init];
        tinyModel.title = @"点工";
        tinyModel.normal_image = @"tinyDefult";
        tinyModel.selected_image = @"markBilltiny";

        JYSlideSegmentModel *accountModel = [[JYSlideSegmentModel alloc] init];
        accountModel.title = @"包工记账";
        accountModel.normal_image = @"contractDefult";
        accountModel.selected_image = @"contractNormal";

        JYSlideSegmentModel *attendanceModel = [[JYSlideSegmentModel alloc] init];
        attendanceModel.title = @"包工记工天";
        attendanceModel.normal_image = @"attendanceDefult";
        attendanceModel.selected_image = @"attendanceNormal";
        
        _viewControllers = [vcArray copy];
        self.typeArrays = @[tinyModel,attendanceModel,accountModel];
        
    }else if (_segmentType == JYSlideSegmentBorrowAndCloseCountType) {// 借支 结算
        
        NSMutableArray *vcArray = [[NSMutableArray alloc] init];
        JGJBrrowBillController *brrowBillVC = [[JGJBrrowBillController alloc] init];
        if (_selectedDate) {
            
            brrowBillVC.selectedDate = self.selectedDate;
        }
        brrowBillVC.oneDayAttendanceComeIn = self.oneDayAttendanceComeIn;
        brrowBillVC.is_Home_ComeIn = _is_Home_ComeIn;
        brrowBillVC.markBillMore = _markBillMore;
        brrowBillVC.isAgentMonitor = _isAgentMonitor;
        brrowBillVC.agency_uid = _agency_uid;
        brrowBillVC.workProListModel = _workProListModel;
        
        _brrowBillVC = brrowBillVC;
        [vcArray addObject:brrowBillVC];
        
        JGJCloseAccountBillController *closeAccountVC = [[JGJCloseAccountBillController alloc] init];
        if (_selectedDate) {
            
            closeAccountVC.selectedDate = self.selectedDate;
        }
        closeAccountVC.oneDayAttendanceComeIn = self.oneDayAttendanceComeIn;
        closeAccountVC.is_Home_ComeIn = _is_Home_ComeIn;
        closeAccountVC.markBillMore = _markBillMore;
        closeAccountVC.isAgentMonitor = _isAgentMonitor;
        closeAccountVC.agency_uid = _agency_uid;
        closeAccountVC.workProListModel = _workProListModel;
        if (_closeUserInfo) {
            
            closeAccountVC.closeUserInfo = _closeUserInfo;
        }
        
        _closeAccountVC = closeAccountVC;
        [vcArray addObject:closeAccountVC];
        
        JYSlideSegmentModel *brrowBillModel = [[JYSlideSegmentModel alloc] init];
        brrowBillModel.title = @"借支";
        brrowBillModel.normal_image = @"brrowDefult";
        brrowBillModel.selected_image = @"brrowNormals";
        
        JYSlideSegmentModel *closeAccountModel = [[JYSlideSegmentModel alloc] init];
        closeAccountModel.title = @"结算";
        closeAccountModel.normal_image = @"closeAccount";
        closeAccountModel.selected_image = @"closeAccountNormal";
        
        _viewControllers = [vcArray copy];
        _selectedIndex = 0;
        self.typeArrays = @[brrowBillModel,closeAccountModel];
        
    }
    
}

- (void)markBillMoreDaySuccessComeBack {
    
    [_tinyAmountVC markBillMoreDaySuccessComeBack];
}

- (void)refreshGetOutstandingAmount {
    
    [_closeAccountVC getOutstandingAmount];
}

- (void)refreshTinyAmountVcAccountMemberWithJGJSynBillingModel:(JGJSynBillingModel *)Model {
    
    [_tinyAmountVC getWorkTplByUidWithUid:Model.uid accounts_type:@"1" accoumtMember:Model];
}

- (void)refreshMakeAttendanceVcAccountMemberWithJGJSynBillingModel:(JGJSynBillingModel *)Model {
    
    [_makeAttendanceVC getWorkTplByUidWithUid:Model.uid accounts_type:@"5" accoumtMember:Model];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
 
    if (_selectedIndex == selectedIndex) {
        
        return;
    }
    
    // 点工 包工
    if (_segmentType == JYSlideSegmentTinyAndContractType) {
        
        if (selectedIndex == 0) {
            
            [_makeAccountVC stopCellTwinkleAnimation];
            [_makeAttendanceVC stopCellTwinkleAnimation];
            
        }else if (selectedIndex == 1) {
            
            [_tinyAmountVC stopCellTwinkleAnimation];
            [_makeAttendanceVC stopCellTwinkleAnimation];
            
        }else {
            
            [_tinyAmountVC stopCellTwinkleAnimation];
            [_makeAccountVC stopCellTwinkleAnimation];
        }
        
    }else if (_segmentType == JYSlideSegmentBorrowAndCloseCountType) {// 借支 结算
        
        if (selectedIndex == 0) {
            
            [_closeAccountVC stopCellTwinkleAnimation];
            
        }else {
            
            [_brrowBillVC stopCellTwinkleAnimation];
        }
    }

    for (int i = 0; i < self.typeArrays.count; i ++) {
        
        JYSlideSegmentModel *segementModel = self.typeArrays[i];
        if (selectedIndex == i) {
            
            segementModel.is_selected = YES;
            
        }else {
            
            segementModel.is_selected = NO;
        }
    }
    
    NSParameterAssert(selectedIndex >= 0 && selectedIndex < self.viewControllers.count);
    UIViewController *toSelectController = [self.viewControllers objectAtIndex:selectedIndex];
    // Add selected view controller as child view controller
    
    if (!toSelectController.parentViewController) {

        [self addChildViewController:toSelectController];
        CGRect rect = self.slideView.bounds;
        rect.origin.x = rect.size.width * selectedIndex;
        toSelectController.view.frame = rect;
        [self.slideView addSubview:toSelectController.view];
        [toSelectController didMoveToParentViewController:self];

    }
    _selectedIndex = selectedIndex;
    [self.segmentBar reloadData];
    
}

- (void)setViewControllers:(NSArray *)viewControllers {
  
    // Need remove previous viewControllers
    for (UIViewController *vc in _viewControllers) {
   
        [vc removeFromParentViewController];
    }
    _viewControllers = [viewControllers copy];
    [self reset];
}

- (NSArray *)viewControllers {
    
    return [_viewControllers copy];
}

- (UIViewController *)selectedViewController {
  
    return self.viewControllers[self.selectedIndex];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInslideSegment:)]) {
    
        return [_dataSource numberOfSectionsInslideSegment:collectionView];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    if ([_dataSource respondsToSelector:@selector(slideSegment:numberOfItemsInSection:)]) {
   
        return [_dataSource slideSegment:collectionView numberOfItemsInSection:section];
    }
  
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_dataSource respondsToSelector:@selector(slideSegment:cellForItemAtIndexPath:)]) {
   
        return [_dataSource slideSegment:collectionView cellForItemAtIndexPath:indexPath];
 
    }

    JYSegmentBarItem *segmentBarItem = [collectionView dequeueReusableCellWithReuseIdentifier:segmentBarItemID forIndexPath:indexPath];

    segmentBarItem.segmentModel = self.typeArrays[indexPath.row];
    return segmentBarItem;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
       
        return;
    }
 
    UIViewController *vc = self.viewControllers[indexPath.row];
  
    if ([_delegate respondsToSelector:@selector(slideSegment:didSelectedViewController:)]) {
       
        [_delegate slideSegment:collectionView didSelectedViewController:vc];
    }
  
    [self setSelectedIndex:indexPath.row];
    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
    
        return NO;
    }
  
    BOOL flag = YES;
    UIViewController *vc = self.viewControllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(slideSegment:shouldSelectViewController:)]) {
   
        flag = [_delegate slideSegment:collectionView shouldSelectViewController:vc];
    }
 
    return flag;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [JGJQustionShowView removeQustionView];
    // set indicator frame
    CGRect frame = self.indicatorBgView.frame;
    CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
    if (isnan(percent)) {
        percent = 0;
    }
    frame.origin.x = scrollView.frame.size.width * percent;
    self.indicatorBgView.frame = frame;
    NSInteger index = roundf(percent * self.viewControllers.count);
    if (index >= 0 && index < self.viewControllers.count) {
        
        [self setSelectedIndex:index];
    }
}



#pragma mark - Action
- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated {
    
    [self.slideView setContentSize:CGSizeMake(TYGetUIScreenWidth * self.typeArrays.count, 0)];
    CGRect rect = self.slideView.bounds;
    rect.origin.x = rect.size.width * index;
    [self.slideView setContentOffset:CGPointMake(rect.origin.x, rect.origin.y) animated:animated];
    
}

- (void)reset {
    
    _selectedIndex = NSNotFound;
    [self setSelectedIndex:0];
    [self scrollToViewWithIndex:0 animated:NO];
    [self.segmentBar reloadData];
}

- (void)justRealName {
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                
            };
            
            customVc.customVcCancelButtonBlock = ^(id response) {
                
                [self.maskingView removeFromSuperview];
                [[NSUserDefaults standardUserDefaults] setBool:@YES forKey:@"SlideSegementOpenMaskingView"];
                [weakself.navigationController popViewControllerAnimated:YES];
            };
            
        }
        
    }
    
}

- (BOOL)checkIsRealName {
    
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}

@end


@implementation JYSlideSegmentModel

@end
