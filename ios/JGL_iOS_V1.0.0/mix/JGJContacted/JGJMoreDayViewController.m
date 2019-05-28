//
//  JGJMoreDayViewController.m
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMoreDayViewController.h"
#import "FSCalendar.h"
#import "JGJGetViewFrame.h"
#import <EventKit/EventKit.h>
#import "JGJTime.h"
#import "JLGPickerView.h"
#import "JGrecordWorkTimePickerview.h"
#import "NSString+Extend.h"
#import "NSDate+Extend.h"
#import "YZGDatePickerView.h"
#import "YZGOnlyAddProjectViewController.h"
#import "JGJTime.h"
#import "JGJBillEditProNameViewController.h"
#import "UIButton+JGJUIButton.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extend.h"
#import "JGJRecordRemindView.h"
#import "YZGGetIndexRecordViewController.h"
#import "JGJRecordWorkpointsVc.h"
#import "JGJOneLineTipView.h"
#import "UILabel+GNUtil.h"
#import "FDAlertView.h"
#import "JGJNewMarkBillChoiceProjectViewController.h"
#import "JGJLeaderRecordsViewController.h"
#import "JGJWorkMatesRecordsViewController.h"
#import "NSDate+Extend.h"
#import "JGJNewRecordRemindView.h"
#import "JGJWageLevelViewController.h"
#import "JGJMarkBillRemarkViewController.h"
#import "JGJMarkBillViewController.h"
#import "JYSlideSegmentController.h"
#import "JGJCalenderDateView.h"
#import "JGJContractorListAttendanceTemplateController.h"
#import "JGJMoreDaySelectedModel.h"
#import "JGJAccountingMemberVC.h"
#import "JGJWorkTplHaveDiffAlertView.h"
#import "MyCalendarObject.h"
#import "JLGCustomViewController.h"
#define leftArrow 110
#define rightArrow 100

#define is_iPhoneX_Later (JGJ_IphoneX_Or_Later ? 34 : 0)
@interface JGJMoreDayViewController ()
<
FSCalendarDataSource,
FSCalendarDelegate,
JLGPickerViewDelegate,
CancelButton,
YZGDatePickerViewDelegate,
FSCalendarHeaderDelegate,
FSCalendarDelegateAppearance,
YZGOnlyAddProjectViewControllerDelegate,
JGJNewMarkBillChoiceProjectViewControllerDelgate,
JGJMarkBillRemarkViewControllerDelegate,
JGJCalenderDateViewDelegate,
JGJContractorTypeChoiceHeaderViewDelegate

>
{

    UIImageView *image;
    UIView *view;
    UIView *_holdView;
    NSString *_remarkTxt;
    NSMutableArray *_remarkImages;
    
}

@property (nonatomic, strong) NSCalendar *holidayLunarCalendar;
@property (nonatomic, strong) NSCalendar *lunarCalendar;
@property (strong, nonatomic) IBOutlet UILabel *projectLable;


@property (strong, nonatomic) IBOutlet FSCalendar *MyClalender;

@property (strong, nonatomic) IBOutlet UILabel *peopleInfo;

@property (strong, nonatomic) UIButton *sureButon;

@property (strong, nonatomic) NSArray<EKEvent *> *events;

@property (strong, nonatomic) NSArray<NSString *> *lunarChars;

@property (strong, nonatomic) NSMutableArray *ModelArray;

@property (strong, nonatomic) JLGPickerView *jlgPickerView;

@property (nonatomic,strong) NSMutableArray *proNameArray;//项目名称

@property (nonatomic, strong) JGrecordWorkTimePickerview *workPicker;

@property (nonatomic, strong) NSString * workTime;

@property (nonatomic, strong) NSString * overTime;

@property (strong, nonatomic) IBOutlet UILabel *nameLable;

@property (strong, nonatomic) UILabel *nameisLable;

@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;

@property (nonatomic, strong) UIScrollView *ScrollView;

@property (nonatomic ,assign) BOOL hadRecord;

@property (nonatomic, strong) UIView *screenHoldView;

@property (nonatomic, strong) UIView *bottemHoldView;

@property (strong, nonatomic) JGJNewRecordRemindView *theNewRecordRemindView;//提示列表

// v3.4.2新增 工资标准
@property (weak, nonatomic) IBOutlet UILabel *payRateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *payRateLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payRateLabelConstraints;

@property (weak, nonatomic) IBOutlet UIView *topInfoBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topInfoBackViewConstraints;

@property (strong, nonatomic) JGJCalenderDateView *CalenderDateView;
@property (weak, nonatomic) IBOutlet JGJContractorTypeChoiceHeaderView *contractorTypeHeader;

@property (weak, nonatomic) IBOutlet UILabel *manegerOrWorkerLabel;
@property (weak, nonatomic) IBOutlet UIButton *choiceWorkOrManager;

@property (weak, nonatomic) IBOutlet UIButton *selMemArrowBtn;

@property (nonatomic, strong) JGJSynBillingModel *selectedAccoumtMember;

@end

@implementation JGJMoreDayViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self justRealName];
    
    
    self.contractorTypeHeader.delegate = self;
    self.contractorTypeHeader.backgroundColor = AppFontEBEBEBColor;
    self.contractorTypeHeader.btTileArr = @[@"点工",@"包工记工天"];
    
    if (self.is_Need_ChoiceType_Cache) {
        
        NSInteger last_record_type = [TYUserDefaults integerForKey:JGJMorePeopleSelectedTypeLocalCache];
        if (last_record_type == 1) {
            
            _selBtnType = JGJRecordSelLeftBtnType;
            
        }else if (last_record_type == 5) {
            
            _selBtnType = JGJRecordSelRightBtnType;
        }
    }
    [self updateSelBtnType];
    
    [self initsubView];
}

- (void)justRealName {
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                
            };
            
            customVc.customVcCancelButtonBlock = ^(id response) {
                
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

- (void)updateSelBtnType {
    
    self.contractorTypeHeader.selType = _selBtnType;
    if (_selBtnType == JGJRecordSelLeftBtnType) {
        
        self.MyClalender.contractorType = 0;
        
    }else if (_selBtnType == JGJRecordSelRightBtnType) {
        
        self.MyClalender.contractorType = 1;
    }
    // 点工进入记多天获取考勤模板
    if (_selBtnType == JGJRecordSelLeftBtnType) {
        
        if (!_JlgGetBillModel.uid) {
            
            return;
        }
        NSDictionary *param = @{
                                @"accounts_type":@"5",
                                @"uid":@(self.JlgGetBillModel.uid)
                                };
        [TYLoadingHub showLoadingWithMessage:nil];
        [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-tpl-by-uid" parameters:param success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            
            JGJGetWorkTplByUidModel *getWorkTplByUidModel = [JGJGetWorkTplByUidModel mj_objectWithKeyValues:responseObject];
            
            GetBill_UnitQuanTpl *quan_Tpl = [[GetBill_UnitQuanTpl alloc] init];
            quan_Tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
            quan_Tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
            self.JlgGetBillModel.unit_quan_tpl = quan_Tpl;
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
    }else if (_selBtnType == JGJRecordSelRightBtnType) {// 包工考勤进入记多天获取点工模板
        
        if (!_JlgGetBillModel.uid) {
            
            return;
        }
        NSDictionary *param = @{
                                @"accounts_type":@"1",
                                @"uid":@(self.JlgGetBillModel.uid)
                                };
        [TYLoadingHub showLoadingWithMessage:nil];
        [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-tpl-by-uid" parameters:param success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            
            JGJGetWorkTplByUidModel *getWorkTplByUidModel = [JGJGetWorkTplByUidModel mj_objectWithKeyValues:responseObject];
            
            GetBillSet_Tpl *set_tpl = [[GetBillSet_Tpl alloc] init];
            
            set_tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
            set_tpl.s_tpl = getWorkTplByUidModel.my_tpl.s_tpl;
            set_tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
            
            self.JlgGetBillModel.set_tpl = set_tpl;
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
    }
    
}
- (void)initsubView {
    
    self.title = @"批量记多天";
    self.view.backgroundColor = AppFontEBEBEBColor;
    _remarkImages = [NSMutableArray new];
    [self.view addSubview:self.bottemHoldView];
    [self.view addSubview:self.ScrollView];
    [self initCalendar];
    [self setCalender];
    
    [self.view addSubview:self.workPicker];
    
    [TYNotificationCenter addObserver:self selector:@selector(reciveNotification:) name:@"calendarHeadarSelect" object:nil];
    [TYNotificationCenter addObserver:self selector:@selector(reciveAddnewgroup:) name:@"addNewgroup" object:nil];
    [self setPersonInfo];
    
}

- (void)contractorHeaderSelectedWithType:(NSInteger)tag {
    
    if (tag == 0) {
        
        self.selBtnType = JGJRecordSelLeftBtnType;
        self.MyClalender.contractorType = 0;
        
        [TYUserDefaults setInteger:1 forKey:JGJMorePeopleSelectedTypeLocalCache];
        
    }else {
        
        self.selBtnType = JGJRecordSelRightBtnType;
        self.MyClalender.contractorType = 1;
        [TYUserDefaults setInteger:5 forKey:JGJMorePeopleSelectedTypeLocalCache];
    }
    
    [self setPayRate];
}

- (void)setPersonInfo {
    
    if (JLGisLeaderBool) {
        
        self.manegerOrWorkerLabel.text = @"工人";
        
    }else {
        
        self.manegerOrWorkerLabel.text = @"班组长";
    }
    
    if ([NSString isEmpty:_JlgGetBillModel.name]) {
        
        if (JLGisLeaderBool) {
            
            _nameLable.text = @"请选择工人";
            
        }else {
            
            _nameLable.text = @"请添加你的班组长/工头";
        }
        
        _nameLable.textColor = AppFont999999Color;
        
    }else {
        
        _nameLable.text = _JlgGetBillModel.name;
        // 班组内记账
        if (_chatType && JLGisMateBool) {
            
            _nameLable.textColor = AppFont666666Color;
            _choiceWorkOrManager.userInteractionEnabled = NO;
            _selMemArrowBtn.hidden = YES;
        }else {
            
            _choiceWorkOrManager.userInteractionEnabled = YES;
            _nameLable.textColor = AppFont333333Color;
            _selMemArrowBtn.hidden = NO;
            
        }
        
    }
    
    if (_JlgGetBillModel.proname) {
        
        _workPicker.proLable.text =_JlgGetBillModel.proname;
    }
    
    [self setPayRate];
}

- (void)setPayRate {
    
    if (_selBtnType == JGJRecordSelLeftBtnType) {
        
        if (_JlgGetBillModel.set_tpl.hour_type == 0) {
            
            if (_JlgGetBillModel.set_tpl.s_tpl > 0) {
                
                _topInfoBackViewConstraints.constant = 114 + 90;
                
            }else {
                
                _topInfoBackViewConstraints.constant = 114 + 50;
            }
            
        }else {
            
            _topInfoBackViewConstraints.constant = 114 + 75;
        }
        
        
    }else if(_selBtnType == JGJRecordSelRightBtnType) {
        
        _topInfoBackViewConstraints.constant = 114 + 50;
    }
    
    [_topInfoBackView updateLayout];
    _ScrollView.frame = CGRectMake(0, CGRectGetMaxY(_topInfoBackView.frame), TYGetUIScreenWidth, TYGetUIScreenHeight - 63 - CGRectGetHeight(_topInfoBackView.frame) - 64 - is_iPhoneX_Later);
    
    if (_selBtnType == JGJRecordSelLeftBtnType) {// 工资标准
        
        _payRateTitleLabel.text = @"工资标准";
        
        // 工资标准显示方式 0 - 按工天算加班显示b方式 1 - 按小时算加班显示方式
        if (_JlgGetBillModel.set_tpl.hour_type == 0) {
            
            if (_JlgGetBillModel.set_tpl.w_h_tpl > 0) {
                
                _payRateLabel.textColor = AppFont333333Color;
                if (_JlgGetBillModel.set_tpl.s_tpl <= 0) {
                    
                    NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", _JlgGetBillModel.set_tpl.w_h_tpl];
                    
                    w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    NSString *o_h_tpl = [NSString stringWithFormat:@"%.1f", _JlgGetBillModel.set_tpl.o_h_tpl];
                    o_h_tpl = [o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    _payRateLabel.text = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工", w_h_tpl,o_h_tpl];
                    
                }else{
                    
                    NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", _JlgGetBillModel.set_tpl.w_h_tpl];
                    
                    w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    NSString *o_h_tpl = [NSString stringWithFormat:@"%.1f", _JlgGetBillModel.set_tpl.o_h_tpl];
                    
                    o_h_tpl = [o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    NSString *o_s_tpl = @"";
                    if (_JlgGetBillModel.set_tpl.o_h_tpl > 0) {
                        
                        o_s_tpl = [NSString stringWithFormat:@"%.2f",[NSString roundFloat:_JlgGetBillModel.set_tpl.s_tpl / _JlgGetBillModel.set_tpl.o_h_tpl]];
                        
                    }
                    
                    
                    _payRateLabel.text = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,o_h_tpl,_JlgGetBillModel.set_tpl.s_tpl,o_s_tpl];
                }
            }else {
                
                _payRateLabel.text = @"这里设置工资标准";
                self.payRateLabel.textColor = AppFont999999Color;
            }
            
            
        }else {
            
            if (_JlgGetBillModel.set_tpl.w_h_tpl > 0) {
                
                _payRateLabel.textColor = AppFont333333Color;
                
                NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", _JlgGetBillModel.set_tpl.w_h_tpl];
                
                w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
                NSString *o_s_tpl = [NSString stringWithFormat:@"%.2f",_JlgGetBillModel.set_tpl.o_s_tpl];
                
                self.payRateLabel.text = [NSString stringWithFormat:@"上班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,_JlgGetBillModel.set_tpl.s_tpl,o_s_tpl];
                
            }else {
                
                _payRateLabel.text = @"这里设置工资标准";
                self.payRateLabel.textColor = AppFont999999Color;
            }
            
        }

    }else if (_selBtnType == JGJRecordSelRightBtnType) {// 考勤标准
        
        _payRateTitleLabel.text = @"考勤模板";
        if (_JlgGetBillModel.unit_quan_tpl.w_h_tpl > 0) {
            
            self.payRateLabel.textColor = AppFont0B0B0BColor;
            NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", _JlgGetBillModel.unit_quan_tpl.w_h_tpl];
            
            w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
            
            NSString *o_h_tpl = [NSString stringWithFormat:@"%.1f", _JlgGetBillModel.unit_quan_tpl.o_h_tpl];
            
            o_h_tpl = [o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
            self.payRateLabel.text = [NSString stringWithFormat:@"%@小时(上班)/%@小时(加班)", w_h_tpl,o_h_tpl];
            
        }else {
            
            _payRateLabel.text = @"这里设置考勤模板";
            self.payRateLabel.textColor = AppFont999999Color;
        }
    }
    
}

- (void)initCalendar {
    
    self.MyClalender = [[FSCalendar alloc]init];
    self.MyClalender.backgroundColor = [UIColor whiteColor];
    
    int height = 380;

    [self.MyClalender setFrame:CGRectMake(0, 10, TYGetUIScreenWidth, height)];
    _holdView = [[UIView alloc]init];
    [_ScrollView addSubview:self.theNewRecordRemindView];

    _theNewRecordRemindView.isHiddenShowDayWork = YES;
    [_holdView setFrame:CGRectMake(0, CGRectGetMaxY(self.theNewRecordRemindView.frame), TYGetUIScreenWidth, 10)];
    _holdView.backgroundColor = AppFontfafafaColor;
    
    [_ScrollView addSubview:self.MyClalender];
    
    [_ScrollView addSubview:self.CalenderDateView];
    [self loadCalendar];
    
    _CalenderDateView.leftBtnCenterY.constant = 0;
    _CalenderDateView.titleCenterY.constant = 0;
    _CalenderDateView.rightBtnCenterY.constant = 0;
}

#pragma mark - 选择工人或者班组长
- (IBAction)choiceManegerOrWorker:(UIButton *)sender {
    
    JGJAccountingMemberVC *accountingMemberVC = [JGJAccountingMemberVC new];
    //传入模型参数，标记已选中
    JGJSynBillingModel *seledAccountMember = [JGJSynBillingModel new];
    
    accountingMemberVC.isMarkBill = self.isMarkMoreBill;
    
    if (self.isAgentMonitor) {
        
        accountingMemberVC.agency_title = @"工人";
        accountingMemberVC.isAgentMonitor = self.isAgentMonitor;
    }
    
    seledAccountMember.name = _JlgGetBillModel.name;
    
    seledAccountMember.telph = _JlgGetBillModel.phone_num;
    
    seledAccountMember.uid = [NSString stringWithFormat:@"%@", @(_JlgGetBillModel.uid)];
    
    accountingMemberVC.seledAccountMember = seledAccountMember;
    
    //返回的时候用
    accountingMemberVC.isGroupMember = YES;
    
    accountingMemberVC.targetVc = self;
    
    accountingMemberVC.workProListModel = self.WorkCircleProListModel;
    
    [self.navigationController pushViewController:accountingMemberVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    //选中的回调人员,如果删除之后accoumtMember为nil
    accountingMemberVC.accountingMemberVCSelectedMemberBlock = ^(JGJSynBillingModel *accoumtMember) {
        
        weakSelf.selectedAccoumtMember = accoumtMember;
        
        if (accoumtMember.isDelMember) {
            
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            NSString *key = [NSString stringWithFormat:@"JLGLastRecordMateBillPeople_%@",JLGUserUid];
            parmDic = [TYUserDefaults objectForKey:key];
            YZGAddForemanModel *addForemanModel = [YZGAddForemanModel mj_objectWithKeyValues:parmDic];
            
            NSString *uid = [NSString stringWithFormat:@"%@", @(addForemanModel.uid)];
            
            if ([uid isEqualToString:accoumtMember.uid]) {
                
                [TYUserDefaults removeObjectForKey:key];
            }
            
            //删除人之后清除数据yj
            weakSelf.JlgGetBillModel.uid = 0;
            
            weakSelf.JlgGetBillModel.name = nil;
            
            [_MyClalender.contractorTypeSelectedArray removeAllObjects];
            _ModelArray = @[].mutableCopy;
            [_MyClalender reloadData];
            
            // v3.4.2现在这里 选中人后 通过接口获取新的工资模板
//            [weakSelf getWorkTplByUidWithUid:accoumtMember.uid];
            
            if (!weakSelf.isMarkMoreBill) {
                
                weakSelf.JlgGetBillModel = [[YZGGetBillModel alloc] init];
                [weakSelf setPersonInfo];
            }
        }else{
            
            [self.sureButon setTitle:@"请从以上日历中选择要记工的日期" forState:UIControlStateNormal];
            self.sureButon.backgroundColor = AppFontf18215Color;
            self.sureButon.userInteractionEnabled = NO;
            
            weakSelf.JlgGetBillModel.uid = [accoumtMember.uid integerValue];
            weakSelf.JlgGetBillModel.name = accoumtMember.name;
            // v3.4.2现在这里 选中人后 通过接口获取新的工资模板
            [weakSelf getWorkTplByUidWithUid:accoumtMember.uid];
            
            //获取最后一次这个人的项目
            [weakSelf JLGHttpRequest_LastproWithUid:[accoumtMember.uid integerValue]];
            
        }
        
        // 记多天更换对象后 外面跟着变
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:NSClassFromString(@"JYSlideSegmentController")]) {
                
                JYSlideSegmentController *segmentVC = (JYSlideSegmentController *)vc;
                
                if (weakSelf.tinyOrAttentComeIn == 1) {
                    
                    [segmentVC refreshTinyAmountVcAccountMemberWithJGJSynBillingModel:accoumtMember];
                    
                }else if (weakSelf.tinyOrAttentComeIn == 5) {
                    
                    [segmentVC refreshMakeAttendanceVcAccountMemberWithJGJSynBillingModel:accoumtMember];
                    
                }
                break;
            }
        }
    };
}

- (void)getWorkTplByUidWithUid:(NSString *)uid{
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-all-tpl-by-uid" parameters:@{@"uid":uid} success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJGetWorkAllTplByUidModel *getWorkTplByUidModel = [JGJGetWorkAllTplByUidModel mj_objectWithKeyValues:responseObject];
        
        GetBillSet_Tpl *set_tpl = [[GetBillSet_Tpl alloc] init];
        
        set_tpl.w_h_tpl = getWorkTplByUidModel.tpl.w_h_tpl;
        set_tpl.s_tpl = getWorkTplByUidModel.tpl.s_tpl;
        set_tpl.o_h_tpl = getWorkTplByUidModel.tpl.o_h_tpl;
        set_tpl.hour_type = getWorkTplByUidModel.tpl.hour_type;
        set_tpl.o_s_tpl = getWorkTplByUidModel.tpl.o_s_tpl;
        self.JlgGetBillModel.set_tpl = set_tpl;
        
        GetBill_UnitQuanTpl *quan_Tpl = [[GetBill_UnitQuanTpl alloc] init];
        quan_Tpl.w_h_tpl = getWorkTplByUidModel.unit_quan_tpl.w_h_tpl;
        quan_Tpl.o_h_tpl = getWorkTplByUidModel.unit_quan_tpl.o_h_tpl;
        self.JlgGetBillModel.unit_quan_tpl = quan_Tpl;
        
        [_MyClalender.contractorTypeSelectedArray removeAllObjects];
        self.JlgGetBillModel = _JlgGetBillModel;
        [self setPersonInfo];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
    
}

#pragma mark - 设置工资标准事件
- (IBAction)setPayRateBtnAction:(UIButton *)sender {
    
    if (!_JlgGetBillModel.uid) {

        [TYShowMessage showPlaint:@"请先选择记账对象"];
        return;
        

    }
    if (_selBtnType == JGJRecordSelLeftBtnType) {// 设置工资标准
        
        JGJWageLevelViewController *WageLevelVc = [[UIStoryboard storyboardWithName:@"JGJWageLevelVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWageLevelVC"];
        WageLevelVc.isAgentMonitor = self.isAgentMonitor;
        WageLevelVc.yzgGetBillModel = _JlgGetBillModel;
        [self.navigationController pushViewController:WageLevelVc animated:YES];
        
        TYWeakSelf(self);
        WageLevelVc.setWageLevelSuccessWithBillModel = ^(YZGGetBillModel *billModel) {
            
            [weakself setPayRate];
            
            // 记多天更换对象后 外面跟着变
            for (UIViewController *vc in weakself.navigationController.viewControllers) {
                
                if ([vc isKindOfClass:NSClassFromString(@"JYSlideSegmentController")]) {
                    
                    JYSlideSegmentController *segmentVC = (JYSlideSegmentController *)vc;
                    
                    if (weakself.tinyOrAttentComeIn == 1) {
                        
                        [segmentVC refreshTinyAmountVcAccountMemberWithJGJSynBillingModel:weakself.selectedAccoumtMember];
                        
                    }
                    break;
                }
            }
        };
        
    }else {// 设置考勤模板
        
        JGJContractorListAttendanceTemplateController *templateVC = [[JGJContractorListAttendanceTemplateController alloc] init];
        
        templateVC.yzgGetBillModel = self.JlgGetBillModel;
        [self.navigationController pushViewController:templateVC animated:YES];

        __weak typeof(self) weakSelf = self;
        __strong typeof(self) strongSelf = self;
        templateVC.attendanceTemplate = ^(YZGGetBillModel *yzgGetBillModel) {

            weakSelf.JlgGetBillModel.unit_quan_tpl.w_h_tpl = yzgGetBillModel.unit_quan_tpl.w_h_tpl;
            weakSelf.JlgGetBillModel.unit_quan_tpl.o_h_tpl = yzgGetBillModel.unit_quan_tpl.o_h_tpl;
            
            [weakSelf setPayRate];
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                
                if ([vc isKindOfClass:NSClassFromString(@"JYSlideSegmentController")]) {
                    
                    JYSlideSegmentController *segmentVC = (JYSlideSegmentController *)vc;
                    
                    if (weakSelf.tinyOrAttentComeIn == 5) {
                        
                        [segmentVC refreshMakeAttendanceVcAccountMemberWithJGJSynBillingModel:weakSelf.selectedAccoumtMember];
                        
                    }
                    break;
                }
            }
        };
        
    }
    
}


- (void)length:(int)lengh andlable:(UILabel *)lable andcolor:(UIColor *)color {
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:lable.text];
    

    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:NSMakeRange(0,lengh)];
    lable.attributedText = attrStr;

}

- (UIView *)screenHoldView {
    
    if (!_screenHoldView) {

        _screenHoldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 450 - 35 + (JGJ_IphoneX_Or_Later ? (88 - JGJ_IphoneX_BarHeight) : 64))];
        
        _screenHoldView.backgroundColor = [UIColor blackColor];
        _screenHoldView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreenView)];
        [_screenHoldView addGestureRecognizer:tap];
    }
    return _screenHoldView;
}

- (void)tapScreenView{
    
    if (_screenHoldView) {
        
        [_screenHoldView removeFromSuperview];
        _screenHoldView = nil;
    }
    [_workPicker dismissview];
}

- (UIScrollView *)ScrollView {
    
    if (!_ScrollView) {
        
        _ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topInfoBackView.frame), TYGetUIScreenWidth, TYGetUIScreenHeight - 63 - CGRectGetHeight(_topInfoBackView.frame) - 64 - is_iPhoneX_Later)];

        _ScrollView.backgroundColor = AppFontEBEBEBColor;
        _ScrollView.bounces = NO;
        _ScrollView.showsHorizontalScrollIndicator = NO;
        _ScrollView.showsVerticalScrollIndicator = NO;
        
    }
    return _ScrollView;
}

- (void)setCalender {
    
    _MyClalender.delegate   = self;
    _MyClalender.dataSource = self;
    _MyClalender.appearance.subtitleSelectionColor = [UIColor blackColor];
    _MyClalender.allowsMultipleSelection = YES;
    _MyClalender.appearance.borderSelectionColor = AppFontd7252cColor;

    _MyClalender.appearance.cellShape = FSCalendarCellShapeRectangle;//取消圆角显示
    _MyClalender.appearance.titleSelectionColor = AppFont333333Color;
    _MyClalender.appearance.titleTodayColor = AppFontd5252cColor;
    _MyClalender.appearance.titleDefaultColor = AppFont333333Color;
    _MyClalender.selectShow = YES;
    _MyClalender.header.delegate = self;
    _MyClalender.header.needSelectedTime = YES;
    _MyClalender.appearance.headerDateFormat = @"yyyy年MM";
    _MyClalender.appearance.titleFont = [UIFont systemFontOfSize:AppFont32Size];
    _MyClalender.appearance.weekdayTextColor = AppFont999999Color;
    _MyClalender.appearance.weekdayFont = [UIFont systemFontOfSize:AppFont20Size];
    _MyClalender.appearance.headerTitleColor = AppFont333333Color;
    _MyClalender.header.leftAndRightShow = YES;

    _MyClalender.appearance.todayColor = AppFontEB4E4EColor;
    _MyClalender.appearance.todaySelectionColor = AppFontEB4E4EColor;
    _MyClalender.appearance.selectionColor = AppFont333333Color;
    _MyClalender.appearance.headerTitleFont = [UIFont systemFontOfSize:AppFont30Size];
    _MyClalender.headerHeight = 52;
    _MyClalender.header.hidden = YES;
    _MyClalender.contractorType = 0;
    _MyClalender.moreDayCalendar = YES;
}

//顶部选择时间的
- (JGJCalenderDateView *)CalenderDateView
{
    if (!_CalenderDateView) {
        
        _CalenderDateView = [[JGJCalenderDateView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 40)];
        _CalenderDateView.backgroundColor = [UIColor whiteColor];
        _CalenderDateView.delegate = self;
        self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_MyClalender.currentPage?:[NSDate date]];
        _CalenderDateView.rightDateButton.hidden = YES;
        _CalenderDateView.lineView.hidden = YES;
    }
    return _CalenderDateView;
}

- (void)JGJCalenderDateViewClickrightButton {
    
    NSDate *currentMonth = _MyClalender.currentPage;
    NSDate *nextMonth = [_MyClalender dateByAddingMonths:1 toDate:currentMonth];
    [_MyClalender setCurrentPage:nextMonth animated:YES];
    
    self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_MyClalender.currentPage?:[NSDate date]];

    [self GetworkerMonthwith:self.MyClalender.currentPage];
    [self loadCalendar];
}

- (void)JGJCalenderDateViewClickLeftButton {
   
    NSDate *currentMonth = _MyClalender.currentPage;
    NSDate *previousMonth = [_MyClalender dateBySubstractingMonths:1 fromDate:currentMonth];
    [_MyClalender setCurrentPage:previousMonth animated:YES];
    self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_MyClalender.currentPage?:[NSDate date]];

    [self GetworkerMonthwith:self.MyClalender.currentPage];
    [self loadCalendar];
}

- (void)JGJCalenderDateViewtapdateLable {
    
    [self.yzgDatePickerView setDate:_MyClalender.currentPage ? :[NSDate date]];
    [self.yzgDatePickerView showDatePicker];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    _MyClalender.selectShow = NO;
}

- (void)setJlgGetBillModel:(YZGGetBillModel *)JlgGetBillModel {
    
    _JlgGetBillModel = [[YZGGetBillModel alloc]init];
    _JlgGetBillModel = JlgGetBillModel;
    
    self.selectedAccoumtMember.uid = [NSString stringWithFormat:@"%ld",_JlgGetBillModel.uid];
    self.selectedAccoumtMember.name = _JlgGetBillModel.name;
    [self GetworkerMonthwith:_MyClalender.currentPage];
    
    if (JlgGetBillModel.uid) {
    
        //更新名字
        _workPicker.proLable.text = _JlgGetBillModel.proname;
        _workPicker.proLable.textColor = AppFont333333Color;
    }
    
    
}

- (JGJSynBillingModel *)selectedAccoumtMember {
    
    if (!_selectedAccoumtMember) {
        
        _selectedAccoumtMember = [[JGJSynBillingModel alloc] init];
    }
    return _selectedAccoumtMember;
}

- (void)setSelBtnType:(JGJRecordSelBtnType)selBtnType {
    
    _selBtnType = selBtnType;
}


- (void)tapLableselectPro
{
    [self querypro];

}

- (UIButton *)sureButon
{
    if (!_sureButon) {
        _sureButon = [[UIButton alloc]initWithFrame:CGRectMake(10, 9, TYGetUIScreenWidth-20, 45)];
        
        _sureButon.backgroundColor = AppFontEB4E4EColor;
        [_sureButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButon.layer.masksToBounds = YES;
        _sureButon.layer.cornerRadius = JGJCornerRadius;
        
        [self.sureButon setTitle:@"请从以上日历中选择要记工的日期" forState:UIControlStateNormal];
        self.sureButon.userInteractionEnabled = NO;
        self.sureButon.backgroundColor = AppFontf18215Color;
        _sureButon.hidden = NO;
        [_sureButon addTarget:self action:@selector(SureRecord) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButon;
}
- (UIView *)bottemHoldView
{
    if (!_bottemHoldView) {
        
        _bottemHoldView  = [[UIView alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 63 - 64 + (JGJ_IphoneX_Or_Later ? -34 : 0), TYGetUIScreenWidth, 63)];
        _bottemHoldView.backgroundColor = AppFontfafafaColor;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 1)];
        line.backgroundColor = AppFontdbdbdbColor;
        [_bottemHoldView addSubview:line];
        [_bottemHoldView addSubview:self.sureButon];
    }
    return _bottemHoldView;
}
- (void)SureRecord
{
    [self initMoreDayPickerView];
}

- (void)initMoreDayPickerView{
    
    _workPicker.dayNum = (int)_MyClalender.selectedDates.count;

    _workPicker.isAgentMonitor = self.isAgentMonitor;
    if (self.isMarkMoreBill) {
        
        _workPicker.isAgentMonitor = YES;
    }
    [UIView animateWithDuration:.2 animations:^{
        
        _workPicker.detailStr = [NSString stringWithFormat:@"将以上选中的 %lu天 都按照以下时长记录",(unsigned long)_MyClalender.selectedDates.count];
        [_workPicker setFrame:CGRectMake(0, TYGetUIScreenHeight - 450 - 35 - JGJ_IphoneX_BarHeight, TYGetUIScreenWidth, 450 + 35)];
        
    }completion:^(BOOL finished) {
        
        [[[UIApplication sharedApplication]keyWindow ]addSubview:self.screenHoldView];
    }];
    
    if ([NSString isEmpty:_workTime]) {
        
        _workTime = @"8.0";
        _overTime = @"0.0";
        
    }
    
    
    if (_selBtnType == JGJRecordSelLeftBtnType) {
        
        [_workPicker SetdefaultTimeW_tpl:_workTime workTpl:[NSString stringWithFormat:@"%.1f", _JlgGetBillModel.set_tpl.w_h_tpl] andover_tpl:_overTime overTpl:[NSString stringWithFormat:@"%.1f", _JlgGetBillModel.set_tpl.o_h_tpl] andDefult:YES isMoreDayComming:YES];
        
    }else {
        [_workPicker SetdefaultTimeW_tpl:_workTime workTpl:[NSString stringWithFormat:@"%.1f", _JlgGetBillModel.unit_quan_tpl.w_h_tpl ] andover_tpl:_overTime overTpl:[NSString stringWithFormat:@"%.1f", _JlgGetBillModel.unit_quan_tpl.o_h_tpl] andDefult:YES isMoreDayComming:YES];
    }
    
    //更新项目明
    if (![NSString isEmpty:_JlgGetBillModel.proname]) {
        
        if ([_JlgGetBillModel.proname isEqualToString:@"无"]) {
            
            _workPicker.proLable.text = @"";
            
        }else if ([_JlgGetBillModel.proname isEqualToString:@"其他项目"]) {
            
            _workPicker.proLable.text = @"";
        }
        else {
            _workPicker.proLable.text = _JlgGetBillModel.proname;
            _workPicker.proLable.textColor = AppFont333333Color;
        }
        
    }else {
        
        _workPicker.proLable.text = @"例如：万科魅力城";
        _workPicker.proLable.textColor = AppFont999999Color;
    }
   
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    if (_selBtnType == JGJRecordSelLeftBtnType) {
        
        if (self.JlgGetBillModel.set_tpl.w_h_tpl <= 0 || self.JlgGetBillModel.set_tpl.o_h_tpl <= 0) {
            
            return;
        }
    }else {
        
        if (self.JlgGetBillModel.unit_quan_tpl.w_h_tpl <= 0 || self.JlgGetBillModel.unit_quan_tpl.o_h_tpl <= 0) {
            
            return;
        }
    }
    
    
    if (calendar.selectedDates.count) {
       
        [self.sureButon setTitle:@"记工时" forState:UIControlStateNormal];
        self.sureButon.backgroundColor = AppFontEB4E4EColor;
        self.sureButon.userInteractionEnabled = YES;
    }
    
    _workPicker.detailStr = [NSString stringWithFormat:@"将以上选中的%lu天 都按照以下时长记录",(unsigned long)_MyClalender.selectedDates.count];

}

- (jgjrecordMonthModel *)filtrateTheDateWithModel:(NSDate *)date {
    
    NSCalendar *newCalendar = [[NSCalendar alloc]
                               initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents *comp = [newCalendar components:unitFlags fromDate:date];
    jgjrecordMonthModel *monthModel = [[jgjrecordMonthModel alloc] init];
    for (jgjrecordMonthModel *model in _ModelArray) {
        
        if ([model.date integerValue] == comp.day) {
            
            monthModel = model;
        }
    }
    
    return monthModel;
}

-(void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date
{

    if (calendar.selectedDates.count) {
        [self.sureButon setTitle:@"记工时" forState:UIControlStateNormal];
        self.sureButon.backgroundColor = AppFontd7252cColor;
        self.sureButon.userInteractionEnabled = YES;
    }else{
        
        [self.sureButon setTitle:@"请从以上日历中选择要记工的日期" forState:UIControlStateNormal];
        self.sureButon.backgroundColor = AppFontf18215Color;
        self.sureButon.userInteractionEnabled = NO;

    }

}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{

    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    for (int i = 0; i<_ModelArray.count; i++) {
       
        jgjrecordMonthModel *recordMonthModel = (jgjrecordMonthModel *)_ModelArray[i];
        if ([recordMonthModel.date intValue] == index) {
            
            if (recordMonthModel.is_record_to_me == 1) {
                
                NSDateComponents *holidayComponents = [self.holidayLunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
                //判断是否是节日
                NSString *holiday = [MyCalendarObject getGregorianHolidayWith:holidayComponents];
                
                if (![holiday isEqualToString:@""]) {
                    
                    return holiday;
                    
                }else{
                    
                    NSDateComponents *lunarComponents = [self.lunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
                    NSDictionary *holidayDic = [MyCalendarObject getChineseCalendarWith:lunarComponents];
                    if (![holidayDic[@"holiday"] isEqualToString:@""]) {
                        
                        return holidayDic[@"holiday"];
                        
                    }else{
                        
                        return holidayDic[@"day"];
                    }
                }
                
            }else {
                
                // rwork_type 1:休息表示。 2:表示包工记账 0:表示记账(点工/包工考勤) 有备注 is_notes == 1   awork_type 3:表示借支； 4:结算  5:is_record_to_me 是否对我的记账（1-表示待确认的账 0-表示自己记得账）
                return [NSString stringWithFormat:@"%ld-%@-%@-%ld-%ld-%@-%@-%ld-%ld",recordMonthModel.awork_type,recordMonthModel.manhour,recordMonthModel.overtime,recordMonthModel.rwork_type,recordMonthModel.is_notes,recordMonthModel.working_hours, recordMonthModel.overtime_hours,recordMonthModel.is_record_to_me,recordMonthModel.is_record];
            }
            
        }
        
    }
    NSDateComponents *holidayComponents = [self.holidayLunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
    //判断是否是节日
    NSString *holiday = [MyCalendarObject getGregorianHolidayWith:holidayComponents];
    
    if (![holiday isEqualToString:@""]) {
        
        return holiday;
        
    }else{
        
        NSDateComponents *lunarComponents = [self.lunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
        NSDictionary *holidayDic = [MyCalendarObject getChineseCalendarWith:lunarComponents];
        if (![holidayDic[@"holiday"] isEqualToString:@""]) {
            
            return holidayDic[@"holiday"];
            
        }else{
            
            return holidayDic[@"day"];
        }
    }
}
- (NSArray<EKEvent *> *)eventsForDate:(NSDate *)date
{
    NSArray<EKEvent *> *filteredEvents = [self.events filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.occurrenceDate isEqualToDate:date];
    }]];
    return filteredEvents;
}
//设置右上角的查账图标
- (BOOL )calendar:(FSCalendar *)calendar subImageForDate:(NSDate *)date{
 
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    for (int i = 0; i<_ModelArray.count; i++) {
        if ([[(jgjrecordMonthModel *)_ModelArray[i] date] intValue] ==  index &&[[(jgjrecordMonthModel *)_ModelArray[i] amounts_diff] intValue] != 0) {
            
        return YES;
        }
    }

    return NO;
}

- (void)GetworkerMonthwith:(NSDate *)date {
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.JlgGetBillModel.uid] forKey:@"uid"];
    [dic setObject:[JGJTime yearAppendMonthfromstamp:date?:[NSDate date]] forKey:@"date"];

//这里每次查出来是当前人员全部的的数据。没需要传项目pid错误 #19362
//    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.JlgGetBillModel.pid]?:@"" forKey:@"pid"];
    // 是否为代班长进入
    if (self.isAgentMonitor) {
        
        [dic setObject:self.WorkCircleProListModel.group_id forKey:@"group_id"];
        [dic setObject:self.agency_uid forKey:@"agency_uid"];
    }
    
    [_ModelArray removeAllObjects];
    [_MyClalender reloadData];
    
    [JLGHttpRequest_AFN PostWithNApiReturnTask:@"workday/worker-month-total" parameters:dic success:^(id responseObject) {
    
        _workTime = @"";
        _overTime = @"";
        if (self.is_Need_ChoiceType_Cache) {
            
            NSInteger last_record_type = [TYUserDefaults integerForKey:JGJMorePeopleSelectedTypeLocalCache];
            if (last_record_type == 0) {
                
                if ([responseObject[@"last_accounts_type"] integerValue] == 1) {
                    
                    _selBtnType = JGJRecordSelLeftBtnType;
                    
                }else if ([responseObject[@"last_accounts_type"] integerValue] == 5) {
                    
                    _selBtnType = JGJRecordSelRightBtnType;
                }
                
                [self updateSelBtnType];
                [TYUserDefaults setInteger:[responseObject[@"last_accounts_type"] integerValue] forKey:JGJMorePeopleSelectedTypeLocalCache];
            }
        }
        
        _ModelArray = [jgjrecordMonthModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [_MyClalender reloadData];
        [TYLoadingHub hideLoadingView];
    
    }failure:^(NSError *error) {
       
        [TYLoadingHub hideLoadingView];
        [_MyClalender reloadData];
    }];
}

- (float)retrunWidth:(NSString *)str{

    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.width;


    return 0;
}
- (void)querypro{

    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querypro" parameters:nil success:^(NSArray * responseObject) {
            [weakSelf.proNameArray removeAllObjects];
            [responseObject enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *proDic = @{@"id":obj[@"pid"],@"name":obj[@"pro_name"]};
                [weakSelf.proNameArray addObject:proDic];
                
                //如果是选中的项目，更新项目名字
                if (weakSelf.JlgGetBillModel.pid == [obj[@"pid"] integerValue]) {
                    weakSelf.JlgGetBillModel.proname = obj[@"pro_name"];
                }
            }];
        if (weakSelf.proNameArray.count) {
          
            if (_editeProname) {
                
            }else{
       
                [self showPicker];
            }
        }else{
            
            YZGOnlyAddProjectViewController *onlyAddProVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
            
            BOOL superViewIsGroup;//上个界面是不是组合界面，YES:是，NO，不是
            onlyAddProVc.superViewIsGroup = superViewIsGroup;
            onlyAddProVc.isPopUpVc = YES;
            
            [self.navigationController pushViewController:onlyAddProVc animated:YES];
        }
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}
- (void)showPicker{

    [self.jlgPickerView.leftButton setTitle:@"新增" forState:UIControlStateNormal];
    [self.jlgPickerView.leftButton setImage:[UIImage imageNamed:@"RecordWorkpoints_BtnAdd"] forState:UIControlStateNormal];
    self.jlgPickerView.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.jlgPickerView.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
    [self.jlgPickerView setAllSelectedComponents:nil];
    self.jlgPickerView.isShowEditButton = YES;//显示编辑按钮
    NSIndexPath *indexPath = 0;
    [self.jlgPickerView showPickerByIndexPath:indexPath dataArray:self.proNameArray title:@"所在项目" isMulti:NO];

}
- (JLGPickerView *)jlgPickerView
{
    if (!_jlgPickerView) {
        _jlgPickerView = [[JLGPickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgPickerView.delegate = self;
    }
    return _jlgPickerView;
}



- (NSMutableArray *)proNameArray
{
    if (!_proNameArray) {
        _proNameArray = [[NSMutableArray alloc] init];
    }
    return _proNameArray;
}

//选择项目
- (void)JLGPickerViewSelect:(NSArray *)finishArray;
{
    _bottemHoldView.hidden = NO;
    if (finishArray.count) {
       
        if ([finishArray.firstObject isKindOfClass:[NSIndexPath class]]) {

        }else{
   
            _JlgGetBillModel.proname = finishArray.firstObject[@"name"];
            _JlgGetBillModel.pid     = [finishArray.firstObject[@"id"] intValue];
            _workPicker.proLable.text = finishArray.firstObject[@"name"];

        }
    }
    if (finishArray.count) {
    
        if ([finishArray.lastObject isEqual:@"取消"]) {
    
            YZGOnlyAddProjectViewController *onlyAddProVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
   
            BOOL superViewIsGroup;//上个界面是不是组合界面，YES:是，NO，不是
            onlyAddProVc.superViewIsGroup = superViewIsGroup;
            onlyAddProVc.isPopUpVc = YES;
            onlyAddProVc.delegate = self;
   
            _editeProname = YES;
            [self.navigationController pushViewController:onlyAddProVc animated:YES];
            //添加一个标志  用于判断是否有编辑项目
        }
    }
   
    [self GetworkerMonthwith:_MyClalender.currentPage];

}
- (void)addMemberSuccessWithResponse:(NSMutableDictionary *)proDic {
    
    _JlgGetBillModel.proname = proDic[@"pro_name"];
    _JlgGetBillModel.pid     = [proDic[@"pid"] intValue];
    _workPicker.proLable.text =proDic[@"pro_name"];

}
- (void)reciveAddnewgroup:(NSNotification *)obj {

    NSMutableDictionary *dic = obj.object;
    _JlgGetBillModel.proname = dic[@"pro_name"];
    _JlgGetBillModel.pid     = [dic[@"pid"] intValue];
    _workPicker.proLable.text = dic[@"pro_name"];

}

- (void)setJgjAddproModel:(JGJAddProModel *)jgjAddproModel {


}
//点击项目编辑按钮跳转页面
-(void)JGJPickViewEditButtonPressed:(NSArray *)dataArray
{
    JGJBillEditProNameViewController *editProNameVC = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJBillEditProNameViewController"];
    
    editProNameVC.dataArray = dataArray;
    [self.navigationController pushViewController:editProNameVC animated:YES];
    editProNameVC.modifyThePorjectNameSuccess = ^(NSIndexPath *indexPath, NSString *changedName) {
        
    };
}

//点击记多天按钮
- (JGrecordWorkTimePickerview *)workPicker
{
    if (!_workPicker) {

        _workPicker = [[JGrecordWorkTimePickerview alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth,450 + 35)];
        _workPicker.isHideDeleteBtn = YES;
        NSMutableArray *workArr = [[NSMutableArray alloc]init];
        NSMutableArray *overArr = [[NSMutableArray alloc]init];
        for (int i = 0; i <= 48; i++) {
            NSString *workStr;
            NSString *overStr;
            if (i == 0) {
                workStr = @"休息";
                overStr = @"无加班";
            }else{
                if ((i*0.5) == (int)(i *0.5)) {
                    workStr = [NSString stringWithFormat:@"%.0f小时", (i * 0.5 )];
                    overStr = [NSString stringWithFormat:@"%.0f小时", (i * 0.5 )];
                }else{
                    workStr = [NSString stringWithFormat:@"%.1f小时", (i * 0.5 )];
                    overStr = [NSString stringWithFormat:@"%.1f小时", (i * 0.5 )];
                }
                
            }
            [workArr addObject:workStr];
            [overArr addObject:overStr];
            
        }
          
        _workPicker.workTimeArr = [[NSMutableArray alloc]initWithArray:workArr];
        _workPicker.overTimeArr = [[NSMutableArray alloc]initWithArray:overArr];

        _workPicker.delegate =self;
        
    }
    return _workPicker;
    
}

#pragma mark - 一人记多天 点击备注
- (void)clickWorkTimePickerviewRemarkTxtWithJgjRecordMorePeoplelistModel:(JgjRecordMorePeoplelistModel *)recorderPeopleModel {
    
    [self tapScreenView];
    JGJMarkBillRemarkViewController *otherInfoVc = [[UIStoryboard storyboardWithName:@"JGJMarkBillRemarkVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillRemarkVC"];

    YZGGetBillModel *yzgGetBillModel = [[YZGGetBillModel alloc] init];
    yzgGetBillModel.notes_txt = _remarkTxt;
    otherInfoVc.yzgGetBillModel = yzgGetBillModel;
    otherInfoVc.imagesArray = _remarkImages;

    otherInfoVc.markBillRemarkDelegate = self;
    [self.navigationController pushViewController:otherInfoVc animated:YES];
}

#pragma mark - 记多人选择备注回调，JGJMarkBillRemarkViewControllerDelegate
- (void)makeRemarkWithImages:(NSMutableArray *)images text:(NSString *)remarkText {

    _remarkImages = images;
    _remarkTxt = remarkText;

    if (![NSString isEmpty:_remarkTxt]) {
    
        if (_remarkImages.count) {
            
            if (_remarkTxt.length > 10) {
                
                _workPicker.remarkView.remarkedTxt = [NSString stringWithFormat:@"%@... [图片]",[_remarkTxt substringToIndex:10]];
            }else {
                
                _workPicker.remarkView.remarkedTxt = [NSString stringWithFormat:@"%@ [图片]",_remarkTxt];
            }
            
            
        }else {
            
            if (_remarkTxt.length > 10) {
                
                _workPicker.remarkView.remarkedTxt = [NSString stringWithFormat:@"%@...",[_remarkTxt substringToIndex:10]];
                
            }else {
                
                _workPicker.remarkView.remarkedTxt = _remarkTxt;
            }
            
        }
    }else if([NSString isEmpty:_remarkTxt] && _remarkImages.count != 0) {
        
        _workPicker.remarkView.remarkedTxt = @"[图片]";
    }
    [self initMoreDayPickerView];
}

//点击时间选择器确定按钮
- (void)ClickLeftButton
{
    if (_screenHoldView) {
        [_screenHoldView removeFromSuperview];
        _screenHoldView = nil;
    }
    _workPicker.detailStr = [NSString stringWithFormat:@"将以上选中的%lu天 都按照以下时长记录",(unsigned long)_MyClalender.selectedDates.count];
    [_workPicker dismissview];

}
-(void)clickrightbutton:(jgjrecordselectedModel *)selectedModel
{
    if (_screenHoldView) {
        [_screenHoldView removeFromSuperview];
        _screenHoldView = nil;
    }
    [_workPicker dismissview];
    [self RecordMoneyList];
}
- (NSDictionary *)paramDic
{

    if (![NSString isEmpty:_workTime]) {
    
        if ([_workTime containsString:@"休息"]) {
       
            _workTime = @"0";
        }else{
       
            if ([_workTime containsString:@"个工"]) {
            
                _workTime = [_workTime substringWithRange:NSMakeRange(0, _workTime.length - 5)];
       
            }
        }
    }else{
    
        _workTime = [NSString stringWithFormat:@"%.0f",_JlgGetBillModel.set_tpl.w_h_tpl];
    }
    
    if (![NSString isEmpty:_overTime]) {
        if ([_overTime containsString:@"无加班"]) {
            _overTime = @"0";
        }else{
            if ([_overTime containsString:@"个工"]) {
                _overTime = [_overTime substringWithRange:NSMakeRange(0, _overTime.length - 5)];
            }
        }
    }else{
        _overTime = @"0";
    }
    NSString *pro_name;
    if ( [NSString isEmpty:self.JlgGetBillModel.proname] ) {
        pro_name = @"";
    }else{
        pro_name = self.JlgGetBillModel.proname;
    }
    //重新计算薪资总额
    self.JlgGetBillModel.salary = [_workTime floatValue]/_JlgGetBillModel.set_tpl.w_h_tpl * _JlgGetBillModel.set_tpl.s_tpl + [_overTime floatValue]/_JlgGetBillModel.set_tpl.o_h_tpl * _JlgGetBillModel.set_tpl.s_tpl;
    
    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < _MyClalender.contractorTypeSelectedArray.count; i ++) {
        
        NSDictionary *body;
        JGJMoreDaySelectedModel *selectedModel = [[JGJMoreDaySelectedModel alloc] init];
        selectedModel = _MyClalender.contractorTypeSelectedArray[i];
        
        NSString *TimeStamp = [JGJTime yearAppendMonthanddayfromstamp:selectedModel.date];
        if (selectedModel.type == 0) {// 点工类型
            
            body = @{
                     @"accounts_type": @(1),
                     @"name": self.JlgGetBillModel.name,
                     @"uid" : [NSString stringWithFormat:@"%ld",(long)self.JlgGetBillModel.uid],
                     @"date":TimeStamp,
                     @"salary": [NSString stringWithFormat:@"%.1f",self.JlgGetBillModel.salary]?:@"",
                     @"work_time":_workTime,
                     @"over_time":_overTime,
                     @"pid": [NSString stringWithFormat:@"%ld",(long)self.JlgGetBillModel.pid]?:@"",
                     @"pro_name": self.JlgGetBillModel.proname?:@"",
                     @"salary_tpl": [NSString stringWithFormat:@"%.1f",self.JlgGetBillModel.set_tpl.s_tpl],
                     @"work_hour_tpl":[NSString stringWithFormat:@"%.1f",self.JlgGetBillModel.set_tpl.w_h_tpl],
                     @"overtime_hour_tpl":[NSString stringWithFormat:@"%.1f",self.JlgGetBillModel.set_tpl.o_h_tpl],
                     @"overtime_salary_tpl":[NSString stringWithFormat:@"%.1f",self.JlgGetBillModel.set_tpl.o_s_tpl],
                     @"hour_type":@(self.JlgGetBillModel.set_tpl.hour_type)

                     };
            
        }else if (selectedModel.type == 1) {// 包工考勤
            
            body = @{
                     @"accounts_type": @(5),
                     @"name": self.JlgGetBillModel.name,
                     @"uid" : [NSString stringWithFormat:@"%ld",(long)self.JlgGetBillModel.uid],
                     @"date":TimeStamp,
                     @"salary": [NSString stringWithFormat:@"%.1f",self.JlgGetBillModel.salary]?:@"",
                     @"work_time":_workTime,
                     @"over_time":_overTime,
                     @"pid": [NSString stringWithFormat:@"%ld",(long)self.JlgGetBillModel.pid]?:@"",
                     @"pro_name": self.JlgGetBillModel.proname?:@"",
                     @"salary_tpl": @"0",
                     @"work_hour_tpl":[NSString stringWithFormat:@"%.1f",self.JlgGetBillModel.unit_quan_tpl.w_h_tpl],
                     @"overtime_hour_tpl":[NSString stringWithFormat:@"%.1f",self.JlgGetBillModel.unit_quan_tpl.o_h_tpl],
                     };
        }
        
        [selectedArr addObject:body];
    }
    NSDictionary *parames = @{
                              @"info":[selectedArr mj_JSONString],
                              @"text": _remarkTxt ? :@"",
                              @"is_days":@"1"
                              };
    
    return parames;
}
//工人批量记账
- (void)RecordMoneyList{
    
    NSMutableDictionary *body;
    body = [[NSMutableDictionary alloc]initWithDictionary:[self paramDic]];
    
    if (_chatType || self.isAgentMonitor) {
        
        [body setObject:self.WorkCircleProListModel.group_id forKey:@"group_id"];
        if (self.isAgentMonitor) {
            
            [body setObject:self.agency_uid forKey:@"agency_uid"];
        }
    }
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"workday/relase" parameters:body imagearray:_remarkImages otherDataArray:nil dataNameArray:nil success:^(id responseObject) {

        _remarkTxt = @"";
        [_remarkImages removeAllObjects];
        _workPicker.remarkView.remarkedTxt = @"";
        _workTime = @"";
        _overTime = @"";
        
        [_MyClalender.contractorTypeSelectedArray removeAllObjects];
        [self.sureButon setTitle:@"请从以上日历中选择要记工的日期" forState:UIControlStateNormal];
        self.sureButon.backgroundColor = AppFontf18215Color;
        self.sureButon.userInteractionEnabled = NO;
        
        if (self.recordBillSuccess) {
            
            _recordBillSuccess();
        }
        [TYShowMessage showSuccess:@"记账成功!\n永不丢失，随时查看"];
        // 记账成功刷新首页数据
        [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JYSlideSegmentController class]]) {
                
                JYSlideSegmentController *slideSegmentBillVC = (JYSlideSegmentController *)vc;
                if (_chatType && JLGisMateBool) {
                    
                }else {
                
//                    [slideSegmentBillVC markBillMoreDaySuccessComeBack];
                }
                
                
            }
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

           
            [self GetworkerMonthwith:_MyClalender.currentPage];
            
        });
     
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)clearOriginalState {
    
    
}

- (void)gotoNextActWorkReleaseWithDic:(NSMutableDictionary *)dic {
    
    
}

- (void)setChatType:(BOOL)chatType {
    
    _chatType = chatType;
}

- (void)pushVC{
    
    JGJRecordWorkpointsVc *recordWorkpointsVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordWorkpointsVc"];
    
    recordWorkpointsVc.isMarkBillMoreDay = YES;
    
    JGJRecordWorkStaDetailListModel *staDetailListModel = [JGJRecordWorkStaDetailListModel new];
    
    staDetailListModel.name = self.JlgGetBillModel.name;
    
    staDetailListModel.class_type_id = [NSString stringWithFormat:@"%ld", (long)self.JlgGetBillModel.uid];
    
    staDetailListModel.date = [NSString stringFromDate:self.MyClalender.currentPage?:[NSDate date] withDateFormat:@"yyyy-MM"];
    
    staDetailListModel.proName = self.JlgGetBillModel.proname;
    
    staDetailListModel.pid = [NSString stringWithFormat:@"%@", @(self.JlgGetBillModel.pid)];
    
    //记工流水pid -1是未分项目，这里是0 ，只要项目名是空 就手动修改为-1这里手动改
    if (self.JlgGetBillModel.pid == 0) {
        
        staDetailListModel.proName = @"其他项目";
        
        staDetailListModel.pid = @"-1";
        
    }
    
    recordWorkpointsVc.staDetailListModel = staDetailListModel;
    
    [self.navigationController pushViewController:recordWorkpointsVc animated:YES];
}

- (void)pickerViewleft:(NSString *)norTime overTime:(NSString *)overtime {
    
    _workTime = [norTime stringByReplacingOccurrencesOfString:@"小时" withString:@""];
    _overTime = [overtime stringByReplacingOccurrencesOfString:@"小时" withString:@""];

}
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    
    if (calendar.selectedDates.count) {
        [self.sureButon setTitle:@"记工时" forState:UIControlStateNormal];
        self.sureButon.backgroundColor = AppFontd7252cColor;
        
        self.sureButon.userInteractionEnabled = YES;
    }else{
        [self.sureButon setTitle:@"请从以上日历中选择要记工的日期" forState:UIControlStateNormal];
        self.sureButon.backgroundColor = AppFontf18215Color;
        self.sureButon.userInteractionEnabled = NO;
        
    }
    [_MyClalender.contractorTypeSelectedArray removeAllObjects];
    [_MyClalender reloadData];
    
    [self GetworkerMonthwith:self.MyClalender.currentPage];
    [self loadCalendar];
    
    self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_MyClalender.currentPage?:[NSDate date]];
    
    _CalenderDateView.rightDateButton.hidden = _MyClalender.currentPage.components.month == [NSDate date].components.month && _MyClalender.currentPage.components.year == [NSDate date].components.year;
}
- (void)loadCalendar {

    if ([NSDate calculateCalendarRows:_MyClalender.currentPage] == 5) {
        
        CGFloat height = 70 + 62.00/375*TYGetUIScreenWidth * 5 + 10.00/375*TYGetUIScreenWidth;
        [self.MyClalender setFrame:CGRectMake(0, 10, TYGetUIScreenWidth, height)];
        
    }else {
        
        CGFloat height = 70 + 62.00/375*TYGetUIScreenWidth * 6 + 15.00/375*TYGetUIScreenWidth;
        
        [self.MyClalender setFrame:CGRectMake(0, 10, TYGetUIScreenWidth, height)];
    }
    
    [self.theNewRecordRemindView setFrame:CGRectMake(0, CGRectGetMaxY(self.MyClalender.frame), TYGetUIScreenWidth,  30)];
    [_ScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(_theNewRecordRemindView.frame))];
    
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    
    return [calendar dateWithYear:2014 month:1 day:1];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    
    return [NSDate getLastDayOfThisMonth];
}

- (void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated {

    [self.view layoutIfNeeded];
}

- (void)FSCalendarHeaderSelected:(FSCalendarHeader *)fsCalendarHeader {

    [self.yzgDatePickerView setDate:_MyClalender.currentPage ? :[NSDate date]];
    [self.yzgDatePickerView showDatePicker];

}

#pragma mark - 选择完时间以后
- (void)YZGDataPickerSelect:(NSDate *)date {
    
    [_MyClalender disChangeMonthDyDate:date];
}

- (YZGDatePickerView *)yzgDatePickerView {
    
    if (!_yzgDatePickerView) {
        
        _yzgDatePickerView = [[YZGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _yzgDatePickerView.delegate = self;
    }
    return _yzgDatePickerView;
}

- (void)viewWillAppear:(BOOL)animated {
    
    _MyClalender.selectShow = YES;

    _hadRecord = NO;
    _editeProname = NO;
    [super viewWillAppear:animated];
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(callModalList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

}

- (void)showMoreDayPickerView {
    
#pragma mark - 此处选择项目 回来后界面消失了
    if (_MyClalender.selectedDates.count > 0) {
        [self initMoreDayPickerView];
    }
}

- (void)callModalList {
    
    _remarkImages = [NSMutableArray new];
    _remarkTxt = @"";
    if (_hadRecord ) {
        if (self.navigationController.viewControllers.count < 3) {
       
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
       
            UIViewController *viewCtrol = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3];
       
            [self.navigationController popToViewController:viewCtrol animated:YES];
        }
    }else{

        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;
{
    
    UIColor *color;
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = AppFontd7252cColor;
    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){
        color = TYColorHex(0xafafaf);
    }else{

        color = AppFont333333Color;
    }
    
    return color;
}


- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date{
    UIColor *color;
    
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = AppFont333333Color;
    }else{
        color = AppFontd7252cColor;
    }
    
    return color;
}

//需求 #19361 选择工人/班组长后，所在项目需要带入该用户上一次记账选择的项目名称
- (void)JLGHttpRequest_LastproWithUid:(NSInteger )uid {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:@"1" forKey:@"accounts_type"];
    [dic setObject:@(uid) forKey:@"uid"];
    if (self.chatType || self.isAgentMonitor || self.isMarkMoreBill) {
        
        [dic setObject:self.WorkCircleProListModel.group_id forKey:@"group_id"];
    }
    [TYLoadingHub showLoadingWithMessage:nil];
    //@{@"uid":@(uid),@"accounts_type":@"1"
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/lastpro" parameters:dic success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        NSString *pid = [NSString stringWithFormat:@"%@", responseObject[@"pid"]];
        
        NSString *proname = [NSString stringWithFormat:@"%@", responseObject[@"pro_name"]];
        
        if ([pid isEqualToString:@"0"] && [NSString isEmpty:proname]) {
            
            proname = @"无";
            
        }
        
        self.JlgGetBillModel.pid = [responseObject[@"pid"] integerValue];
        
        self.JlgGetBillModel.proname = proname;
        
        //更新名字
        _workPicker.proLable.text = _JlgGetBillModel.proname;
        
        _workPicker.proLable.textColor = AppFont333333Color;
       
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)FSCalendarHeaderLeftandRIGHTSelected:(NSInteger)TAG {
    
    if (TAG == leftArrow) {
        NSDate *currentMonth = _MyClalender.currentPage;
        NSDate *previousMonth = [_MyClalender dateBySubstractingMonths:1 fromDate:currentMonth];
        [_MyClalender setCurrentPage:previousMonth animated:YES];
    }else{
        NSDate *currentMonth = _MyClalender.currentPage;
        NSDate *nextMonth = [_MyClalender dateByAddingMonths:1 toDate:currentMonth];
        [_MyClalender setCurrentPage:nextMonth animated:YES];
    }
}

- (void)reciveNotification:(NSNotification *)obj {
    
    if ([obj.object intValue] == leftArrow) {
        
        NSDate *currentMonth = _MyClalender.currentPage;
        NSDate *previousMonth = [_MyClalender dateBySubstractingMonths:1 fromDate:currentMonth];
        [_MyClalender setCurrentPage:previousMonth animated:YES];

    }else{
        
        NSDate *currentMonth = _MyClalender.currentPage;
        NSDate *nextMonth = [_MyClalender dateByAddingMonths:1 toDate:currentMonth];
        [_MyClalender setCurrentPage:nextMonth animated:YES];
    }
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{

    if (!_JlgGetBillModel.uid) {
        
        [TYShowMessage showPlaint:@"请先选择记账对象"];
        return NO;
        
    }
    
    if (_selBtnType == JGJRecordSelLeftBtnType) {// 当前选择为点工
        
        if (self.JlgGetBillModel.set_tpl.w_h_tpl <= 0 || self.JlgGetBillModel.set_tpl.o_h_tpl <= 0) {
            [TYShowMessage showPlaint:@"请先设置工资标准"];
            return NO;
        }
    }else if (_selBtnType == JGJRecordSelRightBtnType) {// 当前选择为包工
        
        if (self.JlgGetBillModel.unit_quan_tpl.w_h_tpl <= 0 || self.JlgGetBillModel.unit_quan_tpl.o_h_tpl <= 0) {
            [TYShowMessage showPlaint:@"请先设置考勤模板"];
            return NO;
        }
    }
    
    
    jgjrecordMonthModel *monthModel = [[jgjrecordMonthModel alloc] init];
    monthModel = [self filtrateTheDateWithModel:date];
    if (monthModel.is_double) {
        
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:monthModel.msg.msg_text delegate:nil buttonTitles:@"我知道了", nil];
        [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
        alert.isHiddenDeleteBtn = YES;
        [alert show];
        return NO;
        
    }else {
        
        NSInteger currentSelectedType = 1;
        
        if (self.MyClalender.contractorType == 0) {
            
            currentSelectedType = 1;
            
        }else if (self.MyClalender.contractorType == 1) {
            
            currentSelectedType = 5;
        }
        
        
        if (monthModel.is_record && monthModel.accounts_type != currentSelectedType) {
            
            FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:monthModel.msg.msg_text delegate:nil buttonTitles:@"我知道了", nil];
            [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
            alert.isHiddenDeleteBtn = YES;
            [alert show];
            return NO;
        }else if (monthModel.is_rest && monthModel.accounts_type != currentSelectedType) {
            
            FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:monthModel.msg.msg_text delegate:nil buttonTitles:@"我知道了", nil];
            [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
            alert.isHiddenDeleteBtn = YES;
            [alert show];
            return NO;
        }
    }
    
    if (monthModel.is_record_to_me == 1) {
        
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:monthModel.msg.msg_text delegate:nil buttonTitles:@"我知道了", nil];
        [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
        alert.isHiddenDeleteBtn = YES;
        [alert show];
        return NO;
    }
    
    // 是否为代班长记账，如果是，需要判断代班长的有效记录时间
    if (self.isAgentMonitor) {
        
        // 判断有无起始时间
        if (![NSString isEmpty:self.WorkCircleProListModel.agency_group_user.start_time]) {
            
            // 判断选择的时间是否小于起始时间
            NSDate *startDate = [NSDate dateFromString:self.WorkCircleProListModel.agency_group_user.start_time withDateFormat:@"yyyy-MM-dd"];
            NSComparisonResult result = [date compare:startDate];
            
            // 表示选择的时间 date小于 代班长起始的代班时间
            if (result == NSOrderedAscending) {
                
                NSString *startTime = [self.WorkCircleProListModel.agency_group_user.start_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                
                // 如果end_time不为空 则提示 区间短时间
                if (![NSString isEmpty:self.WorkCircleProListModel.agency_group_user.end_time]) {
                    
                    NSString *endTime = [self.WorkCircleProListModel.agency_group_user.end_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                    [TYShowMessage showPlaint:[NSString stringWithFormat:@"代班长只能在%@~%@时间段内记账",startTime,endTime]];
                }else {
                    
                    [TYShowMessage showPlaint:[NSString stringWithFormat:@"代班长不能记录%@以前的账",startTime]];
                    
                }
                return NO;
            }
        }
    }
    
    return !([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX);
    
}

#pragma mark - 点击
- (void)tapProNameLable {
    
    JGJNewMarkBillChoiceProjectViewController *projectVC = [[JGJNewMarkBillChoiceProjectViewController alloc] init];
    projectVC.isMarkSingleBillComeIn = YES;
    projectVC.projectListVCDelegate = self;
    projectVC.billModel = self.JlgGetBillModel;
    [self tapScreenView];
    [self.navigationController pushViewController:projectVC animated:YES];
    
}

- (void)selectedProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.JlgGetBillModel.proname = projectModel.pro_name;
    self.JlgGetBillModel.pid = [projectModel.pro_id integerValue];
}

- (JGJNewRecordRemindView *)theNewRecordRemindView {
    
    if (!_theNewRecordRemindView) {
        
        _theNewRecordRemindView = [[JGJNewRecordRemindView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 40)];
        _theNewRecordRemindView.backgroundColor = AppFontfafafaColor;
        
    }
    return _theNewRecordRemindView;
}

- (NSCalendar *)holidayLunarCalendar {
    
    if (!_holidayLunarCalendar) {
        
        _holidayLunarCalendar = [NSCalendar currentCalendar];
        _holidayLunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    }
    return _holidayLunarCalendar;
}

- (NSCalendar *)lunarCalendar {
    
    if (!_lunarCalendar) {
        
        _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    }
    return _lunarCalendar;
}

@end
