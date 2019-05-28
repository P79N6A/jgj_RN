//
//  JGJModifyBillListViewController.m
//  mix
//
//  Created by Tony on 2017/9/26.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJModifyBillListViewController.h"

#import "JGJModifyBillListTableViewCell.h"

#import "YZGAudioAndPicTableViewCell.h"

#import "JGJPoorBillPhotoTableViewCell.h"

#import "JGJRemarkModifyBillsTableViewCell.h"

#import "YZGAddContactsTableViewCell.h"

#import "YZGAddForemanAndMateViewController.h"

#import "YZGMateSalaryTemplateViewController.h"

#import "JLGDatePickerView.h"

#import "NSDate+Extend.h"

#import "IDJCalendar.h"

#import "JGJWorkTypeCollectionView.h"

#import "JLGPickerView.h"

#import "YZGOnlyAddProjectViewController.h"

#import "JGJBrrowOrTotalTableViewCell.h"

#import "JGJAccountingMemberVC.h"

#import "JGJBillEditProNameViewController.h"

#import "JGJMarkBillTinyTableViewCell.h"

#import "JGJMarkBillTextFileTableViewCell.h"

#import "JGJTime.h"

#import "IDJCalendar.h"

#import "NSDate+Extend.h"

#import "YZGAddForemanAndMateViewController.h"

#import "JGJAccountingMemberVC.h"

#import "JGJManHourPickerView.h"

#import "JGJWageLevelViewController.h"

#import "JGJWaringSuggustTableViewCell.h"

#import "UILabel+GNUtil.h"

#import "JGJCloseAccountTwoImageTableViewCell.h"

#import "JGJCloseAccountMoreTableViewCell.h"

#import "JGJCloseAccountOpenTableViewCell.h"

#import "JGJQustionShowView.h"

#import "JGJUnWagesShortWorkVc.h"

#import "JGJLableSize.h"

#import "UILabel+JGJCopyLable.h"

#import "JGJMarkBillModifyRemarkTableViewCell.h"

#import "JGJPackNumViewController.h"

#import "JGJRecordWorkpointsVc.h"

#import "JGJWorkMatesRecordsViewController.h"

#import "JGJLeaderRecordsViewController.h"

#import "JGJContractorListAttendanceTemplateController.h"

#import "JGJCloseAnAccountInfoAlertView.h"

#import "JGJMarkBillViewController.h"
#import "JGJNewMarkBillChoiceProjectViewController.h"
#import "JGJCloseAccountBillController.h"
#import "JYSlideSegmentController.h"
#import "JGJContractorBillDetailTopTypeView.h"
#import "JGJMakeAccountChoiceSubentryTemplateController.h"
#import "JGJContractorMakeAccountInputCountAndUnitsCell.h"
#import "JGJWeatherPickerview.h"
#import "JGJSurePoorbillViewController.h"
#import "JGJUnWagesVc.h"
#import "NSString+Extend.h"
#import "JGJCustomPopView.h"
@interface JGJModifyBillListViewController ()
<
UITableViewDelegate,

UITableViewDataSource,

UIActionSheetDelegate,

UIImagePickerControllerDelegate,

PoorBillPhotoTableViewCelldelegate,

JGJBrrowOrTotalTableViewCellDelegate,

JGJModifyBillImageCollectionViewDlegate,

JGJRemarkModifyBillsTableViewCellDelegate,

UIScrollViewDelegate,

JLGDatePickerViewDelegate,

JLGPickerViewDelegate,

JGJManHourPickerViewDelegate,

JGJMarkBillTextFileTableViewCellDelegate,

JGJWaringSuggustTableViewCellDelegate,

YZGOnlyAddProjectViewControllerDelegate,
JGJNewMarkBillChoiceProjectViewControllerDelgate,
JGJContractorMakeAccountInputCountAndUnitsCellDelegate,
didselectweaterindexpath
>
{
    JGJPoorBillPhotoTableViewCell *modeifyImageCell ;
    NSString *_work_time;
    NSString *_over_time;
    
    BOOL _isHaveChangedParameters;// 是否修改过数据，修改过走修改接口，没有点击保存直接返回,试随便点击选择框为修改
    CGFloat _markEditeMoney;
    
    NSString *_selectedUnits;
}
@property (nonatomic,strong) UIButton *delButton;//删除的按钮

@property (nonatomic, strong) UIView *containSaveButtonView; //容纳保存按钮容器

@property (nonatomic,strong) UIButton *EditesaveButton;//保存的按钮

@property (nonatomic,strong) NSArray *titleArr;//保存的按钮

@property (nonatomic, strong) NSMutableArray *saveProArr;

@property (nonatomic,strong) NSMutableArray *imageArr;//保存的按钮

@property (nonatomic,strong) JLGDatePickerView *jlgDatePickerView;

@property (nonatomic, strong) IDJCalendar *calendar;

@property (nonatomic ,strong)JLGPickerView *jlgPickerView;

@property (nonatomic,strong) NSMutableArray *proNameArray;

@property (nonatomic,assign) BOOL isLeader;//是不是工头

@property (nonatomic,strong) NSMutableArray *deleteUrlImgArr;

@property (nonatomic,strong) NSMutableArray *NewImageArr;//保存的按钮

@property (nonatomic,assign) BOOL startedite;//是不是工头

@property (nonatomic,strong) NSArray *titleArrs;//保存的按钮

@property (nonatomic, strong)NSArray *openTitleArr;

@property (nonatomic, strong)NSArray *openImageArr;

@property (nonatomic, strong)NSArray *imageArrs;
@property (nonatomic, strong) NSMutableArray *theImageUrlArray;// 原始的图片地址
@property (nonatomic, strong) NSString *theLeftImageUrl;// 图片地址，3.2.0包工记工天图片处理，是传剩余的图片拼接地址
@property (nonatomic, strong)NSArray *nowTitleArr;

@property (nonatomic, strong)NSArray *nowImageArr;

@property(nonatomic ,strong)NSArray *subTitleArr;

@property(nonatomic ,strong)NSArray *nowSubTitleArr;

@property(nonatomic ,strong)NSArray *openSubTitleArr;

@property (nonatomic,assign) float remarkHeight;//是不是工头

@property (nonatomic, assign) BOOL isClearEditMoney;// 是否清空本次实收金额
@end

@implementation JGJModifyBillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _isHaveChangedParameters = NO;
    _isLeader = !JLGisMateBool;
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [UIView new];
    [headerView setFrame:CGRectMake(0, 0, TYGetUIScreenWidth , 10)];
    headerView.backgroundColor = AppFontf1f1f1Color;
    _tableview.tableHeaderView = headerView;
    [self initView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:AppFont3A3F4EColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppFontffffffColor}];
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [leftButton setImage:[UIImage imageNamed:@"barButtonItem_back_white"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"barButtonItem_back_white"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.yzgGetBillModel.manhour = [_work_time floatValue];
    self.yzgGetBillModel.overtime = [_over_time floatValue];
}

-(void)setNavStatus
{
    [self.navigationController.navigationBar setBarTintColor:AppFontffffffColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppFont333333Color}];
    [self.navigationController.navigationBar setShadowImage:nil];//恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [JGJQustionShowView removeQustionView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:AppFontffffffColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppFont333333Color}];
    [self.navigationController.navigationBar setShadowImage:nil];//恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [JGJQustionShowView removeQustionView];

}
-(void)backButtonPressed
{
    [self setNavStatus];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [JGJQustionShowView removeQustionView];   
}

- (void)setMateWorkitemsItems:(MateWorkitemsItems *)mateWorkitemsItems
{
    _isLeader = !JLGisMateBool;

    if (!_mateWorkitemsItems) {
        _mateWorkitemsItems = [[MateWorkitemsItems alloc]init];
    }
    _mateWorkitemsItems = mateWorkitemsItems;
    [self JLGHttpRequest];
    
}

-(NSMutableArray *)deleteUrlImgArr
{

    if (!_deleteUrlImgArr) {
        _deleteUrlImgArr = [NSMutableArray array];
    }
    return _deleteUrlImgArr;
}
-(NSMutableArray *)NewImageArr
{
    if (!_NewImageArr) {
        _NewImageArr = [NSMutableArray array];
    }
    return _NewImageArr;
}
-(NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc]init];
    }
    return _imageArr;
}
-(NSMutableArray *)proNameArray
{
    if (!_proNameArray) {
        _proNameArray = [[NSMutableArray alloc]init];
    }
    return _proNameArray;
}

- (NSMutableArray *)theImageUrlArray {
    
    if (!_theImageUrlArray) {
        
        _theImageUrlArray = [[NSMutableArray alloc] init];
    }
    return _theImageUrlArray;
}

- (void)initView
{
    [self.buttomView addSubview:self.containSaveButtonView];
    [self.navigationController.navigationBar setBarTintColor:AppFont3A3F4EColor];
    self.remarkHeight = 105;
    
    BOOL isAgentMonitor = ![NSString isEmpty:self.mateWorkitemsItems.agency_uid];
    if (self.mateWorkitemsItems.accounts_type.code == 1) {
        
        self.titleArrs = @[@[(JLGisLeaderBool || isAgentMonitor)?@"工人":@"班组长",@"日期"],@[@"工资标准",@"上班时长",@"加班时长",@"点工工钱"],@[@"所在项目"],@[@"备注",@""]];
        self.imageArrs = @[@[@"lederHeadImage",@"markCalender"],@[@"openSalary",@"workNormalTime",@"overTimeNormal",@"residueSalary"],@[@"SitPro"],@[@"markBillremark",@""]];
        self.title = @"修改点工";

    }else if (self.mateWorkitemsItems.accounts_type.code == 2) {
        
        self.imageArrs = @[@[@"SitPro",@"lederHeadImage",@"markCalender"],@[@"subProTitle",@"openSalary",@"writeNumber",@"residueSalary"],@[@"markBillremark",@"",@""],@[@"",@""]];
        self.title = @"修改包工记账";
        self.remarkHeight = 75;

    }else if (self.mateWorkitemsItems.accounts_type.code == 3) {
        
        self.titleArrs = @[@[(JLGisLeaderBool || isAgentMonitor)?@"工人":@"班组长",@"日期"],@[@"填写金额"],@[@"所在项目"],@[@"备注",@""]];

        self.imageArrs = @[@[@"lederHeadImage",@"markCalender"],@[@"openSalary"],@[@"SitPro"],@[@"markBillremark",@""]];
        self.title = @"修改借支";

    }else if (self.mateWorkitemsItems.accounts_type.code == 4) {
        
        self.title = @"修改结算";
        self.titleArrs = @[@[(JLGisLeaderBool || isAgentMonitor)?@"工人":@"班组长",@"日期"],
                          @[@"未结工资",@""],
                          @[@"补贴 、奖励 、罚款"],
                          @[JLGisLeaderBool?@"本次实付金额":@"本次实收金额",@"抹零金额",@"本次结算金额"],
                           @[@"剩余未结金额"],@[@"所在项目"],@[@"备注",@""]];

        self.openTitleArr = @[@[(JLGisLeaderBool || isAgentMonitor)?@"工人":@"班组长",@"日期"],
                              @[@"未结工资",@[@""]],
                              @[@"补贴 、奖励 、罚款",@"补贴金额(+)",@"奖励金额(+)",@"罚款金额(-)"],
                              @[(JLGisLeaderBool || isAgentMonitor)?@"本次实付金额":@"本次实收金额",@"抹零金额",@"本次结算金额"],
                              @[@"剩余未结金额"],
                              @[@"所在项目"],@[@"备注",@""]];
        
        self.subTitleArr = @[@[(JLGisLeaderBool || isAgentMonitor)?@"请选择要记账的工人":@"请选择要记账的班组长/工头",[self getWeekDaysString:[NSDate date]]],
                             @[@"0.00",@""],
                             @[@"0.00"],
                             @[@"",@"",@""],
                             @[@""],
                             @[@"例如:万科魅力之城"],@[@"可填写备注信息",@""]];

        self.openSubTitleArr = @[@[(JLGisLeaderBool || isAgentMonitor)?@"请选择要记账的工人":@"请选择要记账的班组长/工头",[self getWeekDaysString:[NSDate date]]],
                                 @[@"0.00",@""],
                                 @[@"0.00",@"请输入金额(可不填)",@"请输入金额(可不填)",@"请输入金额(可不填)"],
                                 @[@"",@"",@""],
                                 @[@""],
                                 @[@"例如:万科魅力之城"],@[@"可填写备注信息",@""]];

        self.imageArrs = @[@[@"lederHeadImage",@"markCalender"],
                          @[@"openSalary",@"garyPlaint"],
                          @[@"fine"],
                          @[@"nowPaySalary",@"countSmall",@"monyImage"],
                          @[@"residueSalary"],
                          @[@"SitPro"],@[@"markBillremark",@""]];
        
        self.openImageArr = @[@[@"lederHeadImage",@"markCalender"], @[@"openSalary",@"garyPlaint"],@[@"fine",@"",@"",@""],@[@"nowPaySalary",@"countSmall",@"monyImage"],@[@"residueSalary"],@[@"SitPro"],@[@"markBillremark"]];

        
        // 结算类型 一进来就展开补贴,奖励,罚款列表
        self.nowTitleArr = [[NSArray alloc]initWithArray:self.openTitleArr];
        self.nowImageArr = [[NSArray alloc]initWithArray:self.openImageArr];
        self.nowSubTitleArr = [[NSArray alloc]initWithArray:self.openSubTitleArr];
        
    }else if (self.mateWorkitemsItems.accounts_type.code == 5) {
        
        self.titleArrs = @[@[(JLGisLeaderBool || isAgentMonitor)?@"工人":@"班组长",@"日期"],@[@"考勤模板",@"上班时长",@"加班时长"],@[@"所在项目"],@[@"备注",@""]];
       
        self.imageArrs = @[@[@"lederHeadImage",@"markCalender"],@[@"openSalary",@"workNormalTime",@"overTimeNormal"],@[@"SitPro"],@[@"markBillremark",@""]];
        self.title = @"修改包工记工天";
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    if (self.mateWorkitemsItems.accounts_type.code == 1 || self.mateWorkitemsItems.accounts_type.code == 5) {
        
        cell = [self loadTinyTbaleviewFromIndexpath:indexPath];
        
    }else if (self.mateWorkitemsItems.accounts_type.code == 2){
        
        cell = [self loadContractTbaleviewFromIndexpath:indexPath];

    }else if (self.mateWorkitemsItems.accounts_type.code == 3){
        
        cell = [self loadBrrowTbaleviewFromIndexpath:indexPath];

    }else if (self.mateWorkitemsItems.accounts_type.code == 4){
        
        cell = [self loadCloseAmountTbaleviewFromIndexpath:indexPath];
    }

    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.mateWorkitemsItems.accounts_type.code == 4) {
      
        return  [self.nowTitleArr[section] count];
    }
    return [self.titleArrs[section] count];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.mateWorkitemsItems.accounts_type.code == 4) {
       return self.nowTitleArr.count;
    }
    return self.titleArrs.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mateWorkitemsItems.accounts_type.code == 1 || self.mateWorkitemsItems.accounts_type.code == 5) {
        if (indexPath.section == self.titleArrs.count - 1) {
            if (indexPath.row == 0) {
                
                return self.remarkHeight;

            }
            return (TYGetUIScreenWidth - 50)/4 + 20 ; //90
        }else if (indexPath.section == 1 && indexPath.row == 0) {
            
            if (self.yzgGetBillModel.set_tpl.hour_type == 0) {
                
                if (self.yzgGetBillModel.set_tpl.s_tpl > 0) {
                    
                    return 95;
                }else {
                    
                    return 55;
                }
                
            }else {
                
                return 80;
            }
        }
        return 55;
    }else if (self.mateWorkitemsItems.accounts_type.code == 2){
        if (indexPath.section == self.titleArrs.count - 1) {
            if (indexPath.row == 0) {

                return self.remarkHeight;

            }
            return (TYGetUIScreenWidth - 50)/4 + 20;//90
        }
        return 55;
        
    }else if (self.mateWorkitemsItems.accounts_type.code == 3){
        if (indexPath.section == self.titleArrs.count - 1) {
            if (indexPath.row == 0) {

                return self.remarkHeight;

            }
            return (TYGetUIScreenWidth - 50)/4 + 20;//90
        }
        return 55;
        
    }else if (self.mateWorkitemsItems.accounts_type.code == 4){
        
        if (indexPath.section == 1 && indexPath.row == 1) {
            if ([NSString isEmpty:self.yzgGetBillModel.name] || [self.yzgGetBillModel.un_salary_tpl?:@"0" floatValue] <= 0) {
                return 0;
            }
            return 36;
            
        }else if (indexPath.section == self.nowTitleArr.count - 1) {
            if (indexPath.row == 0) {

                return self.remarkHeight;
            }
            return (TYGetUIScreenWidth - 50)/4 + 20;//90
            
        }else if ((indexPath.section == 3 && indexPath.row == 2) || (indexPath.section == 4 && indexPath.row == 0)) {
            
            return 0;
        }

        return 55;
        
    }

    return 0;

}


- (void)showProjectPickerByIndexPath:(NSIndexPath *)indexPath{

    __weak typeof(self) weakSelf = self;
    [self querypro:^{
        
//        [weakSelf showJLGPickerView:indexPath];
        JGJNewMarkBillChoiceProjectViewController *projectVC = [[JGJNewMarkBillChoiceProjectViewController alloc] init];
        projectVC.isMarkSingleBillComeIn = YES;
        projectVC.projectListVCDelegate = weakSelf;
        projectVC.billModel = weakSelf.yzgGetBillModel;
        [self.navigationController pushViewController:projectVC animated:YES];
        
    }];
}

#pragma mark - JGJNewMarkBillChoiceProjectViewControllerDelagate
- (void)selectedProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.yzgGetBillModel.proname = projectModel.pro_name;
    self.yzgGetBillModel.pid     = [projectModel.pro_id intValue];
    [self.tableview reloadData];
    
}

- (JLGPickerView *)jlgPickerView
{
    if (!_jlgPickerView) {
        _jlgPickerView = [[JLGPickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgPickerView.delegate = self;
    }
    return _jlgPickerView;
}

- (void)showJLGPickerView:(NSIndexPath *)indexPath {
    
    [self.jlgPickerView.leftButton setTitle:@"新增" forState:UIControlStateNormal];
    [self.jlgPickerView.leftButton setImage:[UIImage imageNamed:@"RecordWorkpoints_BtnAdd"] forState:UIControlStateNormal];
    self.jlgPickerView.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.jlgPickerView.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
    [self.jlgPickerView setAllSelectedComponents:nil];
    self.jlgPickerView.isShowEditButton = YES;//显示编辑按钮
    
    NSDictionary *dic = @{
                          @"name":_yzgGetBillModel.proname?:@"",
                          @"id":[NSString stringWithFormat:@"%ld",(long)_yzgGetBillModel.pid]?:@"0"
                          };
    _saveProArr = [[NSMutableArray alloc]init];
    [_saveProArr addObject:dic];
    [self.jlgPickerView showPickerByrow:indexPath dataArray:self.proNameArray title:@"所在项目" isMulti:NO andArr:_saveProArr];
    
}


-(void)querypro:(JGJMarkBillQueryproBlock )queryproBlock{
    
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querypro" parameters:nil success:^(NSArray * responseObject) {
        if (responseObject.count == 0) {
            [TYLoadingHub hideLoadingView];

            YZGOnlyAddProjectViewController *onlyAddProVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
            onlyAddProVc.superViewIsGroup = NO;
            [weakSelf.navigationController pushViewController:onlyAddProVc animated:YES];
            
        }else{
            
            [weakSelf.proNameArray removeAllObjects];
            [responseObject enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *proDic = @{@"id":obj[@"pid"],@"name":obj[@"pro_name"]};
                [weakSelf.proNameArray addObject:proDic];
                
                //如果是选中的项目，更新项目名字
                if (weakSelf.yzgGetBillModel.pid == [obj[@"pid"] integerValue]) {
                    weakSelf.yzgGetBillModel.proname = obj[@"pro_name"];
                    weakSelf.yzgGetBillModel.pid     = [obj[@"pid"] integerValue];
                }
            }];
            
            if (queryproBlock) {
                queryproBlock();
            }
        }
        //
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

- (UIButton *)delButton {
    
    if (!_delButton) {
        _delButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, TYGetUIScreenWidth /2 - 15 , 45)];
        _delButton.backgroundColor = [UIColor whiteColor];
        [_delButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
        _delButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_delButton setTitle:@"删除" forState:UIControlStateNormal];
        [_delButton addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _delButton.layer.masksToBounds = YES;
        _delButton.layer.cornerRadius = 5;
        _delButton.layer.borderWidth = .5;
        _delButton.layer.borderColor = AppFont666666Color.CGColor;

    }
    return _delButton;
}
-(UIButton *)EditesaveButton
{
    if (!_EditesaveButton) {
        _EditesaveButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 8, TYGetUIScreenWidth - 10, 45)];
        _EditesaveButton.backgroundColor = AppFontEB4E4EColor;
        _EditesaveButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_EditesaveButton setTitleColor:AppFontffffffColor forState:UIControlStateNormal];
        [_EditesaveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_EditesaveButton addTarget:self action:@selector(saveRaincalenderApi) forControlEvents:UIControlEventTouchUpInside];
        _EditesaveButton.layer.masksToBounds = YES;
        _EditesaveButton.layer.cornerRadius = 5;
        _EditesaveButton.layer.borderWidth = .5;
        _EditesaveButton.layer.borderColor = AppFontEB4E4EColor.CGColor;
        
    }
    return _EditesaveButton;
}
-(UIView *)containSaveButtonView
{
    if (!_containSaveButtonView) {
        _containSaveButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];

        _containSaveButtonView.backgroundColor = [UIColor whiteColor];

        [_containSaveButtonView addSubview:self.EditesaveButton];
//        [_containSaveButtonView addSubview:self.delButton];

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
        line.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:line];
    }
    return _containSaveButtonView;
}
- (void)initSheetImagePicker{
    //不使用懒加载，主要先初始化，避免速度慢
    if (!self.sheet) {
        //设置拍照的点击
        self.sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    }
    
    if (!self.imagePickerController) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
    }
}
- (void)ClickPoorBillPhotoBtn
{
    [self.view endEditing:YES];
    [self.sheet showInView:self.view];

}
//删除图片
-(void)deleteImageAndImageArr:(NSMutableArray *)imageArr andDeletedIndex:(NSInteger)index
{
    _isHaveChangedParameters = YES;
    NSMutableArray *origImgArr = [[NSMutableArray alloc] init];
    [origImgArr addObjectsFromArray:self.theImageUrlArray];
    [origImgArr addObjectsFromArray:self.NewImageArr];
    
    
    if (origImgArr.count > 0) {
        
        if ([origImgArr[index] isKindOfClass:[NSString class]]) {
            
            [self.theImageUrlArray removeObject:origImgArr[index]];
            self.theLeftImageUrl = [self.theImageUrlArray componentsJoinedByString:@";"];
            
        }else if ([origImgArr[index] isKindOfClass:[UIImage class]]) {
            
            if ([self.NewImageArr containsObject:origImgArr[index]]) {
                
                [self.NewImageArr removeObject:origImgArr[index]];
                
            }
            
            if ([self.imagesArray containsObject:origImgArr[index]]) {
                
                [self.imagesArray removeObject:origImgArr[index]];
                
            }
        }
    }
    if (self.imageArr.count > index) {
        
        [self.imageArr removeObjectAtIndex:index];
        
    }
    
    if (self.yzgGetBillModel.notes_img.count > index) {
        
        if ([self.yzgGetBillModel.notes_img[index] isKindOfClass:[NSString class]] && [self.yzgGetBillModel.notes_img containsObject:self.yzgGetBillModel.notes_img[index]]) {
            
            [self.deleteUrlImgArr  addObject: self.yzgGetBillModel.notes_img[index]];
            for (int index = 0; index < self.deleteUrlImgArr.count; index ++) {
                self.yzgGetBillModel.deleteImageURL = [[self.yzgGetBillModel.deleteImageURL ?:@"" stringByAppendingString:self.yzgGetBillModel.deleteImageURL ?@";":@"" ] stringByAppendingString:self.deleteUrlImgArr[index]];
            }
  
        }
        
    }

}
#pragma mark - 添加玩图片
- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr
{
    _isHaveChangedParameters = YES;
    NSMutableArray *filtrationArr = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < imagesArr.count; index ++) {
        
        if (![_imageArr containsObject:imagesArr[index]]) {
            
            [filtrationArr addObject:imagesArr[index]];
        }
    }
    if (_imageArr.count + filtrationArr.count > 4) {
        
        for (UIImage *imag in filtrationArr) {
            
            [self.imagesArray removeObject:imag];
        }
        [TYShowMessage showPlaint:@"最多上传四张图片"];
        return;
    }

    for (int index = 0; index < filtrationArr.count; index ++) {
        
        if (![_imageArr containsObject:filtrationArr[index]]) {
            
            [self.NewImageArr addObject:filtrationArr[index]];
            [self.imageArr addObject:filtrationArr[index]];
        }
    }
    
    
    modeifyImageCell.imageArr = _imageArr;

}
#pragma mark - 备注图片
-(void)downEidteImageUrlArr:(NSArray *)imageArr
{
    
    self.imageArr = [NSMutableArray array];
    dispatch_group_t group  = dispatch_group_create();
    dispatch_queue_t queue  = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i<imageArr.count; i++) {
        dispatch_group_async(group, queue, ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,imageArr[i]]]]];
            if (image) {
                [self.imageArr addObject:image];
            }
        });
    }
    typeof(self)weakSelf = self;
    dispatch_group_notify(group, queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            modeifyImageCell.imageArr = weakSelf.imageArr;
//            [weakSelf.tableview reloadData];
 
        });
    });
    
}

#pragma mark - 跳转到增加人的界面
- (void)handleAddForemanAdnMateVcWithModel:(YZGGetBillModel *)billModel{
    
    self.addForemanModel.name = billModel.name;
    self.addForemanModel.telph = billModel.phone_num;
    self.addForemanModel.uid = billModel.uid;
    YZGAddForemanAndMateViewController *addForemanAndMateVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"addForemanAndMate"];
    addForemanAndMateVc.modifySelect = YES;
    if (_mateWorkitemsItems.accounts_type.code == 1) {
        addForemanAndMateVc.recordType = @"1";//表示点工
    }else{
        addForemanAndMateVc.recordType = @"0";
    }
    if (![NSString isEmpty:self.addForemanModel.name]) {
        addForemanAndMateVc.addForemanModel = self.addForemanModel;
        //回传数据三个页面全部选中有人时,会有人员丢失
    }

    
    
    //2.3.2yj添加
    JGJAccountingMemberVC *accountingMemberVC = [JGJAccountingMemberVC new];
    
    //传入模型参数，标记已选中
    JGJSynBillingModel *seledAccountMember = [JGJSynBillingModel new];
    
    seledAccountMember.name = billModel.name;
    seledAccountMember.telph = billModel.phone_num;
    seledAccountMember.uid = [NSString stringWithFormat:@"%@", @(billModel.uid)];
    
    accountingMemberVC.seledAccountMember = seledAccountMember;
    
    //返回的时候用
    accountingMemberVC.targetVc = self;
    
    [self.navigationController pushViewController:accountingMemberVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    //选中的回调人员
    accountingMemberVC.accountingMemberVCSelectedMemberBlock = ^(JGJSynBillingModel *accoumtMember) {
        self.yzgGetBillModel.editerecord = YES;//识别是否编辑过人
        
        YZGAddForemanModel *addForemanModel = [YZGAddForemanModel new];
        
        addForemanModel.uid = [accoumtMember.uid integerValue];
        
        addForemanModel.telph = accoumtMember.telph;
        
        addForemanModel.name = accoumtMember.name;
        addForemanModel.head_pic = accoumtMember.head_pic;

        weakSelf.addForemanModel = addForemanModel;
        
        _addForemanModel = addForemanModel;
        _yzgGetBillModel.name = accoumtMember.name;
        _yzgGetBillModel.uid = [accoumtMember.uid integerValue];
        _yzgGetBillModel.phone_num = accoumtMember.telph;

        _yzgGetBillModel.head_pic = accoumtMember.head_pic;
        [self JLGHttpRequest_QueryTplWithUid:[NSString stringWithFormat:@"%ld", (long)addForemanModel.uid ]];
        [self.tableview reloadData];
    };
    
}
#pragma mark - 薪资模板
-(void)jumpMoneyJPL
{
    if (_mateWorkitemsItems.accounts_type.code == 1) {
        
        JGJWageLevelViewController *WageLevelVc =[[UIStoryboard storyboardWithName:@"JGJWageLevelVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJWageLevelVC"];
        
        WageLevelVc.isModifyTinyAmountBillComeIn = YES;
        if (_is_surePoorBill_ComeIn) {
            
            WageLevelVc.isChoiceOtherPartyTemplate = YES;
        }
        WageLevelVc.yzgGetBillModel = self.yzgGetBillModel;
        [self.navigationController pushViewController:WageLevelVc animated:YES];
        
    }else if (_mateWorkitemsItems.accounts_type.code == 5) {
        
        __weak typeof(self) weakSelf = self;
        __strong typeof(self) strongSelf = self;
        JGJContractorListAttendanceTemplateController *templateVC = [[JGJContractorListAttendanceTemplateController alloc] init];
        
        GetBill_UnitQuanTpl *u_tpl = [[GetBill_UnitQuanTpl alloc] init];
        u_tpl.w_h_tpl = self.yzgGetBillModel.set_tpl.w_h_tpl;
        u_tpl.o_h_tpl = self.yzgGetBillModel.set_tpl.o_h_tpl;
        self.yzgGetBillModel.unit_quan_tpl = u_tpl;
        templateVC.yzgGetBillModel = self.yzgGetBillModel;
        [self.navigationController pushViewController:templateVC animated:YES];
        
        // 设置考勤模板回调
        templateVC.attendanceTemplate = ^(YZGGetBillModel *yzgGetBillModel) {
            
            weakSelf.yzgGetBillModel.set_tpl.w_h_tpl = yzgGetBillModel.unit_quan_tpl.w_h_tpl;
            weakSelf.yzgGetBillModel.set_tpl.o_h_tpl = yzgGetBillModel.unit_quan_tpl.o_h_tpl;
            NSString *workTimeStr = strongSelf -> _work_time;
            NSString *overTimeStr = strongSelf -> _over_time;
            weakSelf.yzgGetBillModel.manhour = [workTimeStr floatValue];
            weakSelf.yzgGetBillModel.overtime = [overTimeStr floatValue];
            [weakSelf.tableview reloadData];
        };
    }
    
    
}

-(void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel
{
    _yzgGetBillModel = [YZGGetBillModel new];
    
    _yzgGetBillModel = yzgGetBillModel;
    
    self.theImageUrlArray = [_yzgGetBillModel.notes_img mutableCopy];
    self.theLeftImageUrl = [self.theImageUrlArray componentsJoinedByString:@";"];
    [self getSalary];
    [self.tableview reloadData];
    
}

- (void)setOriginalWorkTime:(CGFloat)workTime overTime:(CGFloat)overTime {
    
    _work_time = [[NSString stringWithFormat:@"%.1f",workTime] stringByReplacingOccurrencesOfString:@".0" withString:@""];
    _over_time = [[NSString stringWithFormat:@"%.1f",overTime] stringByReplacingOccurrencesOfString:@".0" withString:@""];

}

#pragma mark - 选择时间
- (void)choiceTimeandIndexpath:(NSIndexPath *)indexpath{
    if (self.jlgDatePickerView) {
        
        self.jlgDatePickerView.isShowMoreDayButton = YES;
    }
    [self showDatePickerByIndexPath:indexpath];
    self.jlgDatePickerView.isShowMoreDayButton = YES;


}
- (void)showDatePickerByIndexPath:(NSIndexPath *)indexPath{

    self.yzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];
    NSString *dateFormat = [NSString getNumOlnyByString:self.yzgGetBillModel.date?:@""];
    NSDate *date = [NSDate dateFromString:dateFormat withDateFormat:@"yyyyMMdd"];
    self.jlgDatePickerView.datePicker.date = date;
    self.jlgDatePickerView.showMoreButton = @"show";
    //设置最大和最小时间
    [self.jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:[NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"]];
    
    [self.jlgDatePickerView showDatePickerByIndexPath:indexPath];
    
}
- (NSString *)getWeekDaysString:(NSDate *)date{
    if (!date) {
        return @"";
    }
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"", @"", @"", @"", @"", @"", @"", nil];
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",[NSDate stringFromDate:date format:@"yyyy-MM-dd"],[weekdays objectAtIndex:[NSDate weekdayStringFromDate:date]]];
    NSDate *curDate = [NSDate dateFromString:dateString withDateFormat:@"yyyy-MM-dd"];
    self.calendar.year = [NSString stringWithFormat:@"%@", @(curDate.components.year)];
    self.calendar.month = [NSString stringWithFormat:@"%@", @(curDate.components.month)];
    self.calendar.day = [NSString stringWithFormat:@"%@", @(curDate.components.day)];
    //如果是今天要显示
    if ([date isToday]) {
        dateString = [dateString stringByAppendingString:@"(今天)"];
    }
    
    return dateString;
}
- (IDJCalendar *)calendar {
    if (!_calendar) {
        _calendar = [IDJCalendar new];
    }
    return _calendar;
}
- (JLGDatePickerView *)jlgDatePickerView
{
    if (!_jlgDatePickerView) {
        _jlgDatePickerView = [[JLGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgDatePickerView.delegate = self;
        //显示记更多天按钮
        [_jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:@"2099-12-31"];
    }
    return _jlgDatePickerView;
}

#pragma mark - 弹出上班时间选择
- (void)showManHourPicker:(NSIndexPath *)indexPath{
    BOOL isNoHour = self.yzgGetBillModel.set_tpl.w_h_tpl <= 0 && self.yzgGetBillModel.set_tpl.o_h_tpl <= 0;
    if (isNoHour) {
        [TYShowMessage showPlaint:@"请设置工资标准"];
        return;
    }
    NSInteger workHour = self.yzgGetBillModel.set_tpl.w_h_tpl;
    JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
    timeModel.titleStr = @"选择上班时长";
    
    timeModel.limitTime = workHour;
    timeModel.endTime = 12.0;
    
    timeModel.currentTime = self.yzgGetBillModel.manhour; ////传入当前的时间作为选中标记
    
    JGJWorkTypeCollectionView *timeCollectionView = [[JGJWorkTypeCollectionView alloc] initWithFrame:TYGetUIScreenRect timeModel:timeModel SelectedTimeType:NormalWorkTimeType isOnlyShowHeaderView:YES blockSelectedTime:^(JGJShowTimeModel *timeModel) {
        self.yzgGetBillModel.manhour = timeModel.time;
        
        self.yzgGetBillModel.manhourTimeStr = [timeModel.timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [self getSalary];
        [self.tableview reloadData];

    }];
    [[UIApplication sharedApplication].keyWindow addSubview:timeCollectionView];
}


- (void)showOverHourPicker:(NSIndexPath *)indexPath{
    if (self.yzgGetBillModel.set_tpl.o_h_tpl < 0  || self.yzgGetBillModel.set_tpl.w_h_tpl <= 0) {
        [TYShowMessage showPlaint:@"请设置工资标准"];
        return;
    }
    
    NSInteger overHour = self.yzgGetBillModel.set_tpl.o_h_tpl;
    JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
    timeModel.titleStr = @"选择加班时长";
    timeModel.limitTime = overHour;
    //    timeModel.isShowZero = YES;
    timeModel.endTime = 12.0;//2.0加班时长的选项,增至12小时(与日薪模板里的最大值无关)
    timeModel.currentTime = self.yzgGetBillModel.overtime; //传入当前的时间作为选中标记
    JGJWorkTypeCollectionView *timeCollectionView = [[JGJWorkTypeCollectionView alloc] initWithFrame:TYGetUIScreenRect timeModel:timeModel SelectedTimeType:OverWorkTimeType isOnlyShowHeaderView:YES blockSelectedTime:^(JGJShowTimeModel *timeModel) {
        self.yzgGetBillModel.overtime = timeModel.time;
        self.yzgGetBillModel.overhourTimeStr = [timeModel.timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [self getSalary];
        [self.tableview reloadData];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:timeCollectionView];
}
- (CGFloat)getSalary{
    
    if (_mateWorkitemsItems.accounts_type.code == 1) {//点工
        
        if (self.yzgGetBillModel.set_tpl.hour_type == 0) {
            
            self.yzgGetBillModel.salary = self.yzgGetBillModel.set_tpl.s_tpl*self.yzgGetBillModel.manhour/self.yzgGetBillModel.set_tpl.w_h_tpl + self.yzgGetBillModel.set_tpl.s_tpl*self.yzgGetBillModel.overtime/self.yzgGetBillModel.set_tpl.o_h_tpl;
            
        }else {
            
            self.yzgGetBillModel.salary = self.yzgGetBillModel.set_tpl.s_tpl*self.yzgGetBillModel.manhour/self.yzgGetBillModel.set_tpl.w_h_tpl + self.yzgGetBillModel.set_tpl.o_s_tpl * self.yzgGetBillModel.overtime;
        }
        
        
        self.yzgGetBillModel.salary = [[NSString decimalwithFormat:@"0.00" doubleV:self.yzgGetBillModel.salary] doubleValue];
        
        if (self.yzgGetBillModel.set_tpl.hour_type == 0) {
            
            self.yzgGetBillModel.amounts = self.yzgGetBillModel.set_tpl.s_tpl*self.yzgGetBillModel.manhour/self.yzgGetBillModel.set_tpl.w_h_tpl + self.yzgGetBillModel.set_tpl.s_tpl*self.yzgGetBillModel.overtime/self.yzgGetBillModel.set_tpl.o_h_tpl;
            
        }else {
            
            self.yzgGetBillModel.amounts =self.yzgGetBillModel.set_tpl.s_tpl*self.yzgGetBillModel.manhour/self.yzgGetBillModel.set_tpl.w_h_tpl + self.yzgGetBillModel.set_tpl.o_s_tpl * self.yzgGetBillModel.overtime;
        }
        
        
        self.yzgGetBillModel.amounts = [[NSString decimalwithFormat:@"0.00" doubleV:self.yzgGetBillModel.amounts] doubleValue];

        if (isnan(self.yzgGetBillModel.salary)) {
            self.yzgGetBillModel.salary = 0.f;
        }
    }else if(_mateWorkitemsItems.accounts_type.code == 2){//包工
        
        self.yzgGetBillModel.amounts = self.yzgGetBillModel.unitprice * self.yzgGetBillModel.quantities;
        self.yzgGetBillModel.amounts = [NSString roundFloat:self.yzgGetBillModel.amounts];
    }else if (_mateWorkitemsItems.accounts_type.code == 4) {
        
        self.yzgGetBillModel.salary = self.yzgGetBillModel.pay_amount;
    }
    return self.yzgGetBillModel.salary;
}

- (NSString *) decimalwithFormat:(NSString *)format  floatV:(double)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithDouble:floatV]];
}  

#pragma mark - 修改记账人
- (void)setAddForemanModel:(YZGAddForemanModel *)addForemanModel {
    
    _addForemanModel = addForemanModel;
    _yzgGetBillModel.set_tpl = self.addForemanModel.tpl;
    _yzgGetBillModel.name = self.addForemanModel.name;
    _yzgGetBillModel.uid = self.addForemanModel.uid;
    _yzgGetBillModel.phone_num = addForemanModel.telph;
    _yzgGetBillModel.manhour = self.addForemanModel.tpl.w_h_tpl;
    _yzgGetBillModel.salary  = self.addForemanModel.tpl.s_tpl;
    _yzgGetBillModel.head_pic = self.addForemanModel.head_pic;
    [self JLGHttpRequest_QueryTplWithUid:[NSString stringWithFormat:@"%ld", (long)addForemanModel.uid ]];
    [self.tableview reloadData];
    
}
//选择时间
- (void)JLGDatePickerSelect:(NSDate *)date byIndexPath:(NSIndexPath *)indexPath{
    
    NSString *dateCurrentStr =[NSDate stringFromDate:date format:@"yyyyMMdd"];

    if (indexPath.row == 1) {
        if (![NSString isEmpty:self.yzgGetBillModel.p_e_time]) {
            if ([dateCurrentStr compare:self.yzgGetBillModel.p_e_time] ==    NSOrderedDescending) {
                [TYShowMessage showPlaint:@"所选时间必须大于开工时间"];
                return;
            }
        }
    }else if(indexPath.row == 2){
        if ([dateCurrentStr compare:self.yzgGetBillModel.p_s_time] == NSOrderedAscending) {
            [TYShowMessage showPlaint:@"所选时间必须大于开工时间"];
            return;
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [formatter stringFromDate:date];

    if (indexPath.row == 1) {
        self.yzgGetBillModel.p_s_time = dateStr;
    }else{
        self.yzgGetBillModel.p_e_time = dateStr;

    }
    [self.tableview reloadData];
}
-(void)JLGHttpRequest_QueryTplWithUid:(NSString *)uid
{
    [TYLoadingHub showLoadingWithMessage:@""];
    NSMutableDictionary *parmDicdic = [NSMutableDictionary dictionary];
    [parmDicdic setObject:uid forKey:@"uid"];
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querytpl" parameters:parmDicdic success:^(id responseObject) {
        GetBillSet_Tpl *bill_Tpl = [[GetBillSet_Tpl alloc] init];
        [bill_Tpl mj_setKeyValues:responseObject];
        self.yzgGetBillModel.set_tpl = bill_Tpl;
        self.yzgGetBillModel.manhour = self.yzgGetBillModel.set_tpl.w_h_tpl;//默认的情况下，工作是长就是模板的时间
        self.yzgGetBillModel.overtime = 0;
        //self.yzgGetBillModel.accounts_type = self.mateWorkitemsItems.accounts_type;
        
        [self getSalary];
        
//        [self.tableview reloadData];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
    
}

-(void)JLGPickerViewSelect:(NSArray *)finishArray
{
    _saveProArr = [[NSMutableArray alloc]initWithArray:finishArray];;
    
    if (finishArray.count) {
        _yzgGetBillModel.proname = finishArray[0][@"name"];
        _yzgGetBillModel.pid     = [finishArray[0][@"id"] intValue];
       [self.tableview reloadData];
    }
    
    if (finishArray.count) {
        if ([finishArray.lastObject isEqual:@"取消"]) {
            
            YZGOnlyAddProjectViewController *onlyAddProVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
            
            BOOL superViewIsGroup;//上个界面是不是组合界面，YES:是，NO，不是
            
            onlyAddProVc.superViewIsGroup = superViewIsGroup;
            onlyAddProVc.isPopUpVc = YES;
            onlyAddProVc.delegate = self;
            [self.navigationController pushViewController:onlyAddProVc animated:YES];
            
        }
    }
}

#pragma mark - YZGOnlyAddProjectViewControllerDelegate
- (void)addMemberSuccessWithResponse:(NSMutableDictionary *)proDic {
    
    self.yzgGetBillModel.proname = proDic[@"pro_name"];
    self.yzgGetBillModel.pid     = [proDic[@"pid"] intValue];
    [self.tableview reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self showProjectPickerByIndexPath:indexPath];
}
#pragma mark - 编辑借支和结算的输入框编辑文字
-(void)JGJBrrowOrTotalTextfiledEdite:(NSString *)text andtextTag:(NSInteger)tag
{
    if (_mateWorkitemsItems.accounts_type.code == 2) {
        
 
    if (tag == 110) {
        
        self.yzgGetBillModel.unitprice = [text floatValue];
        
#pragma mark - 修改时编辑单价价格要变动
        
        [self getSalary];
        
        
        }else if (tag == 109){
            
            self.yzgGetBillModel.sub_proname = text;
            
            self.yzgGetBillModel.sub_pro_name = text;
            
        }
    }else{
        
    self.yzgGetBillModel.salary = [text floatValue];
        
    }
}
#pragma mark - 备注文字编辑
-(void)RemarkModifyBillsTextfiledEting:(NSString *)text
{
    _isHaveChangedParameters = YES;
    self.yzgGetBillModel.notes_txt = text?:@"";

}

- (void)delBtnClick
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(self.mateWorkitemsItems.id) forKey:@"id"];
    if (![NSString isEmpty:self.mateWorkitemsItems.agency_uid]) {
        
        [dic setObject:self.mateWorkitemsItems.group_id forKey:@"group_id"];
    }
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/delinfo" parameters:@{@"id":@(self.mateWorkitemsItems.id)} success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        
        NSString *sourceType = @"0";
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *sources = (NSArray *)responseObject;
            NSDictionary *sourceDic = sources.firstObject;
            if ([sourceDic isKindOfClass:[NSDictionary class]]) {
                sourceType = sourceDic[@"source"];
            }
        }
        
        NSInteger source = [sourceType integerValue];
        
        if (source == 1) {
            
            [TYShowMessage showSuccess:@"记账删除成功\n和他工账有差异,请及时核对"];
            
        }else {
            
            [TYShowMessage showSuccess:@"删除成功"];
        }
        
        // 删除账成功刷新首页数据
        [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
        if (_delshowViewBool) {
            
           
            for (UIViewController *vc in self.navigationController.viewControllers) {
                
                if ([vc isKindOfClass:[JGJLeaderRecordsViewController class]]) {
                    
                    JGJLeaderRecordsViewController *lederVC = (JGJLeaderRecordsViewController*)vc;
                    [self setNavStatus];
                    [self JGJModifyOrDelMarkBill];
                    [weakSelf.navigationController popToViewController:lederVC animated:YES];
           
                    break;
                }else if ([vc isKindOfClass:[JGJWorkMatesRecordsViewController class]]){
           
                    JGJWorkMatesRecordsViewController *workVC = (JGJWorkMatesRecordsViewController*)vc;
           
                    [self setNavStatus];
           
                    [self JGJModifyOrDelMarkBill];
          
                    [weakSelf.navigationController popToViewController:workVC animated:YES];

                    break;
                }
                
            }
        }else{
            NSInteger index;
            
            if (_billModify) {
                
                index = self.navigationController.viewControllers.count - 2;
                
            }else{
                index = self.navigationController.viewControllers.count - 3;
                
            }
            UIViewController *nav = self.navigationController.viewControllers[index];
            [self setNavStatus];
            [self JGJModifyOrDelMarkBill];
            [weakSelf.navigationController popToViewController:nav animated:YES];

        }
       
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];

}

- (void)setIsNotNeedJudgeHaveChangedParameters:(BOOL)isNotNeedJudgeHaveChangedParameters {
    
    _isNotNeedJudgeHaveChangedParameters = isNotNeedJudgeHaveChangedParameters;
}

#pragma mark - 提交数据到服务器
- (void)saveRaincalenderApi {
    
    // 是否需要判断参数有没有修改,默认(NO)需要
    if (!_isNotNeedJudgeHaveChangedParameters) {
        
        // 参数是否修改，修改过才走接口，默认没有修改(NO)
        if (!_isHaveChangedParameters) {
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    if ([self.yzgGetBillModel.subsidy_amount?:@"0" floatValue] <= 0
        &&[self.yzgGetBillModel.reward_amount?:@"0" floatValue] <= 0
        && [self.yzgGetBillModel.penalty_amount?:@"0"  floatValue] <= 0
        && self.yzgGetBillModel.salary == 0 && self.mateWorkitemsItems.accounts_type.code == 4){
        
        [TYShowMessage showPlaint:@"补贴、奖励、罚款金额和本次实付（收）金额不能同时为0"];
        return;
    }
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(self.mateWorkitemsItems.id) forKey:@"id"];
    [paramDic setObject:@(self.yzgGetBillModel.pid) forKey:@"pid"];
    
    [paramDic setObject:self.yzgGetBillModel.proname?:@"" forKey:@"pro_name"];
    [paramDic setObject:self.yzgGetBillModel.notes_txt?:@"" forKey:@"text"];
    if (self.theLeftImageUrl.length != 0) {
        
        [paramDic setObject:self.theLeftImageUrl forKey:@"imgs"];
    }
    [paramDic setObject:@"" forKey:@"my_role_type"];
    [paramDic setObject:@"" forKey:@"gpid"];
    [paramDic setObject:self.yzgGetBillModel.name?:@"" forKey:@"name"];
    [paramDic setObject:self.yzgGetBillModel.date?:@"" forKey:@"date"];
    [paramDic setObject:self.mateWorkitemsItems.record_id?:@"" forKey:@"record_id"];
    [paramDic setObject:@(self.yzgGetBillModel.uid) forKey:@"uid"];
    
    // 如果是从本次确认的账进入账详情
    if (_is_currentSureBill_ComeIn) {
        
        self.recordPointModel.pid = [NSString stringWithFormat:@"%ld",self.yzgGetBillModel.pid];
        self.recordPointModel.proname = self.yzgGetBillModel.proname?:@"";
        
        if (self.yzgGetBillModel.notes_txt.length > 0 || self.theLeftImageUrl.length != 0 || self.imagesArray.count != 0) {
            
            self.recordPointModel.is_notes = YES;
            
        }else {
            
            self.recordPointModel.is_notes = NO;
        }
    }
    
    if (self.mateWorkitemsItems.accounts_type.code == 1) {
        
        paramDic[@"accounts_type"] = @1;
        [paramDic setObject:@(self.yzgGetBillModel.manhour) forKey:@"work_time"];
        [paramDic setObject:@(self.yzgGetBillModel.overtime) forKey:@"over_time"];
        [paramDic setObject:@(self.yzgGetBillModel.set_tpl.s_tpl) forKey:@"salary_tpl"];
        [paramDic setObject:@(self.yzgGetBillModel.set_tpl.w_h_tpl) forKey:@"work_hour_tpl"];
        [paramDic setObject:@(self.yzgGetBillModel.set_tpl.o_h_tpl) forKey:@"overtime_hour_tpl"];
        [paramDic setObject:@(self.yzgGetBillModel.set_tpl.o_s_tpl) forKey:@"overtime_salary_tpl"];
        [paramDic setObject:@(self.yzgGetBillModel.set_tpl.hour_type) forKey:@"hour_type"];
        if (_is_currentSureBill_ComeIn) {
            
            self.recordPointModel.manhour = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.manhour];
            self.recordPointModel.working_hours = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.manhour / self.yzgGetBillModel.set_tpl.w_h_tpl];
            
            self.recordPointModel.overtime = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.overtime];
            self.recordPointModel.overtime_hours = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.overtime / self.yzgGetBillModel.set_tpl.o_h_tpl];
            
            self.recordPointModel.amounts = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.set_tpl.s_tpl * (self.yzgGetBillModel.manhour / self.yzgGetBillModel.set_tpl.w_h_tpl) + self.yzgGetBillModel.set_tpl.s_tpl * (self.yzgGetBillModel.overtime / self.yzgGetBillModel.set_tpl.o_h_tpl)];
            
            self.recordPointModel.set_my_amounts_tpl = self.yzgGetBillModel.set_tpl.s_tpl;
        }
        
        
    }else if (self.mateWorkitemsItems.accounts_type.code == 2){
        
        paramDic[@"accounts_type"] = @2;
        [paramDic setObject:@(self.yzgGetBillModel.quantities) forKey:@"quantity"];
        [paramDic setObject:@(self.yzgGetBillModel.unitprice) forKey:@"unit_price"];
        [paramDic setObject:self.yzgGetBillModel.units forKey:@"units"];
        NSString *startTime;
        NSString *endTime;
        if (![NSString isEmpty: self.yzgGetBillModel.p_s_time]) {
            
            startTime = [self.yzgGetBillModel.p_s_time stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        
        if (![NSString isEmpty: self.yzgGetBillModel.p_s_time]) {
            
            endTime = [self.yzgGetBillModel.p_e_time stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        [paramDic setObject:startTime?:@"" forKey:@"p_s_time"];
        [paramDic setObject:endTime?:@"" forKey:@"p_e_time"];
        
        [paramDic setObject:self.yzgGetBillModel.sub_proname?:@"" forKey:@"sub_pro_name"];
        if ([NSString isEmpty:self.yzgGetBillModel.tpl_id]) {
            
            self.yzgGetBillModel.tpl_id = @"0";
        }
        [paramDic setObject:self.yzgGetBillModel.tpl_id  forKey:@"tpl_id"];
        
        if (self.is_currentSureBill_ComeIn) {
            
            self.recordPointModel.amounts = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.amounts];
        }
        
    }else if (self.mateWorkitemsItems.accounts_type.code == 3){
        
        paramDic[@"accounts_type"] = @3;
        [paramDic setObject:@(self.yzgGetBillModel.amounts?:0) forKey:@"salary"];
        
        if (self.is_currentSureBill_ComeIn) {
            
            self.recordPointModel.amounts = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.amounts];
        }
        
    }else if (self.mateWorkitemsItems.accounts_type.code == 4){
        
        paramDic[@"accounts_type"] = @4;
        paramDic[@"salary"] = @(self.yzgGetBillModel.salary?:0);
        paramDic[@"balance_amount"] = self.yzgGetBillModel.balance_amount?:@"0";//未结
        paramDic[@"subsidy_amount"] = self.yzgGetBillModel.subsidy_amount?:@"0";//补贴
        paramDic[@"reward_amount"] = self.yzgGetBillModel.reward_amount?:@"0";// 奖金
        paramDic[@"penalty_amount"] = self.yzgGetBillModel.penalty_amount?:@"0";//惩罚
        paramDic[@"deduct_amount"] = self.yzgGetBillModel.deduct_amount?:@"0";//抹零
        
        if (self.is_currentSureBill_ComeIn) {
            
            self.recordPointModel.amounts = self.yzgGetBillModel.settlementAmount;
        }
        
    }else {
        
        paramDic[@"accounts_type"] = @5;
        paramDic[@"work_time"] = _work_time;
        paramDic[@"over_time"] = _over_time;
        paramDic[@"work_hour_tpl"] = @(self.yzgGetBillModel.set_tpl.w_h_tpl);
        paramDic[@"overtime_hour_tpl"] = @(self.yzgGetBillModel.set_tpl.o_h_tpl);
        paramDic[@"salary_tpl"] = @(0);
        
        if (_is_currentSureBill_ComeIn) {
            
            self.recordPointModel.manhour = _work_time;
            self.recordPointModel.working_hours = [NSString stringWithFormat:@"%.2f",[_work_time floatValue] / self.yzgGetBillModel.set_tpl.w_h_tpl];
            
            self.recordPointModel.overtime = _over_time;
            self.recordPointModel.overtime_hours = [NSString stringWithFormat:@"%.2f",[_over_time floatValue] / self.yzgGetBillModel.set_tpl.o_h_tpl];
            
            
            self.recordPointModel.amounts = @"0.0";
        }
    }
    
    // 是修改结算,先弹出修改信息，点击确定在确定走不走接口
    if (self.mateWorkitemsItems.accounts_type.code == 4) {
        
        __weak typeof(self) weakSelf = self;
        JGJCloseAnAccountInfoAlertView *accountInfoAlertView = [[JGJCloseAnAccountInfoAlertView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        
        [accountInfoAlertView setCurrentCloseAnCountMoney:weakSelf.yzgGetBillModel.settlementAmount leftMoney:weakSelf.yzgGetBillModel.remainingAmount];
        [accountInfoAlertView show];
        
        // 修改
        accountInfoAlertView.modify = ^{
            
            return;
        };
        
        accountInfoAlertView.submit = ^{
            
            [weakSelf submitDateToServerWithParametersDicRelase:paramDic];
            
        };
        
    }else {
        
        [self submitDateToServerWithParametersDicRelase:paramDic];
    }

}

- (void)submitDateToServerWithParametersDicRelase:(NSDictionary *)parametersDicRelase {
    
    NSMutableArray *selectedArr = [[NSMutableArray alloc] initWithObjects:parametersDicRelase, nil];
    
    NSMutableDictionary *parames = [[NSMutableDictionary alloc] init];
    [parames setObject:[selectedArr mj_JSONString] forKey:@"info"];
    
    if (![NSString isEmpty:self.mateWorkitemsItems.agency_uid]) {
        
        [parames setObject:self.mateWorkitemsItems.agency_uid forKey:@"agency_uid"];
    }
    
    if (![NSString isEmpty:self.mateWorkitemsItems.group_id]) {
        
        [parames setObject:self.mateWorkitemsItems.group_id forKey:@"group_id"];
    }
    
    if (self.mateWorkitemsItems.accounts_type.code == 2) {// 包工 多传一个 承包 还是分包类型给服务器
        
        [parames setObject:@(self.yzgGetBillModel.contractor_type) forKey:@"contractor_type"];
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"workday/modify-relase" parameters:parames imagearray:self.NewImageArr otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [TYShowMessage showSuccess:@"修改记账成功\n及时对账，避免纠纷！"];
        });
        
        // 修改账成功刷新首页数据
        [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
        
        [self JGJModifyOrDelMarkBill];
        
        if (self.ModifyBillSuccessToCurrentSureBillVCWithModel) {
            
            _ModifyBillSuccessToCurrentSureBillVCWithModel(self.recordPointModel);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordBillChangeSuccess" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

#pragma mark - 获取先写的单位
-(void)setFillOutModel:(JGJFilloutNumModel *)fillOutModel
{
    if (fillOutModel.Num &&fillOutModel.priceNum) {
        _fillOutModel = [JGJFilloutNumModel new];
        _fillOutModel = fillOutModel;
        _yzgGetBillModel.quantities = [[NSString stringWithFormat:@"%@",fillOutModel.Num] floatValue];
        _yzgGetBillModel.units = fillOutModel.priceNum;
        _yzgGetBillModel.salary = _yzgGetBillModel.quantities * _yzgGetBillModel.unitprice;
        _yzgGetBillModel.amounts = _yzgGetBillModel.quantities * _yzgGetBillModel.unitprice;

        [self.tableview reloadData];
    }
}

- (void)JGJModifyBillImageCollectionViewDeleteImageAndIndex:(NSInteger)index
{

}


- (void)setIsNeedRoleType:(BOOL)isNeedRoleType {
    
    _isNeedRoleType = isNeedRoleType;
}
#pragma mark - 获取正常账单
- (void)JLGHttpRequest {
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(self.mateWorkitemsItems.id) forKey:@"record_id"];
    
    [parameters setObject:@(self.mateWorkitemsItems.accounts_type.code) forKey:@"accounts_type"];
    
    BOOL isAgentMonitor = ![NSString isEmpty:self.mateWorkitemsItems.agency_uid];
    // 是否是代班人 记得工
    if (isAgentMonitor) {
        
        [parameters setObject:self.mateWorkitemsItems.group_id forKey:@"group_id"];
    }
    
    if (_isNeedRoleType) {
        
        [parameters setObject:@((JLGisLeaderBool || isAgentMonitor) ? 2 : 1) forKey:@"role"];
    }
    
    if (_is_surePoorBill_ComeIn) {
        
        [parameters setObject:@(1) forKey:@"is_confirm"];
    }
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/work-detail" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if (dic.allKeys.count == 0 && [responseObject isKindOfClass:[NSDictionary class]]) {// 代表改记账已删除，无数据
            
            [TYShowMessage showPlaint:@"该记账已经被删除"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return ;
        }
        
        YZGGetBillModel *yzgGetBillModel = [[YZGGetBillModel alloc] init];
        [yzgGetBillModel mj_setKeyValues:responseObject];
        
        self.yzgGetBillModel = yzgGetBillModel;
        
        _selectedUnits = self.yzgGetBillModel.units;
        if (self.mateWorkitemsItems.accounts_type.code == 5) {// 包工记工天 把set_tpl转化成 unit_quan_tpl
            
            GetBill_UnitQuanTpl *unit_quan_tpl = [[GetBill_UnitQuanTpl alloc] init];
            unit_quan_tpl.w_h_tpl = self.yzgGetBillModel.set_tpl.w_h_tpl;
            unit_quan_tpl.o_h_tpl = self.yzgGetBillModel.set_tpl.o_h_tpl;
            
            self.yzgGetBillModel.unit_quan_tpl = unit_quan_tpl;
        }
        
        _work_time = [[NSString stringWithFormat:@"%.1f",self.yzgGetBillModel.manhour] stringByReplacingOccurrencesOfString:@".0" withString:@""];
        _over_time = [[NSString stringWithFormat:@"%.1f",self.yzgGetBillModel.overtime] stringByReplacingOccurrencesOfString:@".0" withString:@""];
        
//3.0.0修改be_booked_user_name这个字段后台取得有问题，始终是反的
        self.yzgGetBillModel.name = (JLGisLeaderBool || isAgentMonitor) ? yzgGetBillModel.worker_name : yzgGetBillModel.foreman_name;
        self.yzgGetBillModel.uid = (JLGisLeaderBool || isAgentMonitor) ? [yzgGetBillModel.wuid integerValue] : [yzgGetBillModel.fuid integerValue];
        
        self.yzgGetBillModel.accounts_type = self.mateWorkitemsItems.accounts_type;
#pragma mark - 排除无
        if (![NSString isEmpty:self.yzgGetBillModel.notes_txt ]) {
            if ([self.yzgGetBillModel.notes_txt isEqualToString:@"无"]) {
                self.yzgGetBillModel.notes_txt = @"";
            }
        }
        self.imageArr = [self.yzgGetBillModel.notes_img mutableCopy];

        [self getSalary];
        [self CalculationAmount];
        if (_mateWorkitemsItems.accounts_type.code == 2) {
            
            if (self.yzgGetBillModel.contractor_type == 1) {
                
                self.titleArrs = @[@[@"所在项目",(JLGisLeaderBool || isAgentMonitor)?@"承包对象":@"班组长",@"日期"],@[@"分项名称",@"填写单价",@"填写数量",@"包工工钱"],@[@"备注",@"选择开工时间",@"选择完工时间",],@[@"",@""]];
            }else {
                
                self.titleArrs = @[@[@"所在项目",(JLGisLeaderBool || isAgentMonitor)?@"工人":@"班组长",@"日期"],@[@"分项名称",@"填写单价",@"填写数量",@"包工工钱"],@[@"备注",@"选择开工时间",@"选择完工时间",],@[@"",@""]];
            }
        }
        [self.tableview reloadData];
        [self downEidteImageUrlArr:yzgGetBillModel.notes_img];
        
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

-(void)CalculationAmount
{

    double totalCalculation = [self.yzgGetBillModel.subsidy_amount doubleValue] + [self.yzgGetBillModel.reward_amount doubleValue] - [self.yzgGetBillModel.penalty_amount doubleValue];
    self.yzgGetBillModel.totalCalculation = [NSString stringWithFormat:@"%.2f",totalCalculation];
    
    self.yzgGetBillModel.settlementAmount =  [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.salary + [self.yzgGetBillModel.deduct_amount doubleValue] + [self.yzgGetBillModel.penalty_amount doubleValue] - [self.yzgGetBillModel.subsidy_amount doubleValue] -[self.yzgGetBillModel.reward_amount doubleValue]];
    
    self.yzgGetBillModel.remainingAmount = [NSString stringWithFormat:@"%.2f",[self.yzgGetBillModel.balance_amount doubleValue] +[self.yzgGetBillModel.subsidy_amount doubleValue] + [self.yzgGetBillModel.reward_amount doubleValue] - [self.yzgGetBillModel.penalty_amount doubleValue]-self.yzgGetBillModel.salary - [self.yzgGetBillModel.deduct_amount                                                                                                                                                                                                                                                                        doubleValue]];

    
}
#pragma mark - 编辑按钮
-(void)JGJPickViewEditButtonPressed:(NSArray *)dataArray
{
    JGJBillEditProNameViewController *editProNameVC = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJBillEditProNameViewController"];
    
    editProNameVC.dataArray = dataArray;
    
    [self.navigationController pushViewController:editProNameVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    editProNameVC.modifyThePorjectNameSuccess = ^(NSIndexPath *indexPath,NSString *changedName) {
        
        NSDictionary *projectDic = dataArray[indexPath.row];
        weakSelf.yzgGetBillModel.proname = changedName;
        weakSelf.yzgGetBillModel.pid     = [projectDic[@"id"] intValue];
        
        [weakSelf.tableview reloadData];
        [weakSelf showProjectPickerByIndexPath:indexPath];
    };

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    view.backgroundColor = AppFontf1f1f1Color;

    if (self.mateWorkitemsItems.accounts_type.code == 2) {
        
        if (section == 0) {
            
            // 班组长身份
            if (JLGisLeaderBool) {
                
                view.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 64);
                JGJContractorBillDetailTopTypeView *headerView = [[JGJContractorBillDetailTopTypeView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 64)];
                headerView.subentryType = self.yzgGetBillModel.contractor_type;
                headerView.backgroundColor = AppFontffffffColor;
                [view addSubview:headerView];
                
            }else {
                
                view.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 10);
            }
            
            
        }else {
            
            view.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 10);
        }
        
    }else {
        
        view.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 10);
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.mateWorkitemsItems.accounts_type.code == 1 || self.mateWorkitemsItems.accounts_type.code == 5) {
        if ( section == 1 || section == 2 ) {
            return 10;
        }
        return 0.01;
    }else if (self.mateWorkitemsItems.accounts_type.code == 2){
        if ( section == 1 || section == 2 ) {
            return 10;
        }else if (section == 0) {
            if (JLGisLeaderBool) {
                
                return 74;
                
            }else {
                
                return 0.01;
            }
            
        }
        return 0.01;
    }else if (self.mateWorkitemsItems.accounts_type.code == 3){
        if ( section == 1 || section == 2 ) {
            return 10;
        }
        return 0.01;
    }else if (self.mateWorkitemsItems.accounts_type.code == 4){
        if ( section == 1 || section == 2 || section == 5) {
            return 10;
        }
        return 0.01;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}
#pragma mark - 点击点工
- (void)didSelectTinyFromTableView:(UITableView *)tableView FromIndexpath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            [self jumpMoneyJPL];
            
        }else if (indexPath.row == 1){
            
            if (_mateWorkitemsItems.accounts_type.code == 1) {
                
                [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:YES noShowRest:NO andBillModel:self.yzgGetBillModel isShowHalfOrOneSelectedView:YES];
                
            }else if (_mateWorkitemsItems.accounts_type.code == 5) {
                
                [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:YES noShowRest:NO andBillModel:self.yzgGetBillModel isContractType:YES isShowHalfOrOneSelectedView:YES];
            }
            
            
        }else if (indexPath.row == 2){
            
            if (_mateWorkitemsItems.accounts_type.code == 1) {
                
                [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:NO noShowRest:NO andBillModel:self.yzgGetBillModel isShowHalfOrOneSelectedView:self.yzgGetBillModel.set_tpl.hour_type == 1 ? NO : YES];
                
            }else if (_mateWorkitemsItems.accounts_type.code == 5) {
                
                [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:NO noShowRest:NO andBillModel:self.yzgGetBillModel isContractType:YES isShowHalfOrOneSelectedView:YES];
                
            }
            
            
        }else if (indexPath.row == 3){
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            
            desModel.popDetail = @"点工工钱：是根据工资标准和上班加班时长计算的\n\n需要修改工资标准吗？";
            
            desModel.leftTilte = @"不修改";
            
            desModel.rightTilte = @"修改";
            
            desModel.lineSapcing = 5;
            
            desModel.messageFont = [UIFont systemFontOfSize:AppFont30Size];

            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            
            alertView.messageLable.textAlignment = NSTextAlignmentLeft;
            alertView.contentViewHeight.constant = 190;
            alertView.backgroundColor = [AppFont000000Color colorWithAlphaComponent:0.75];
            __weak typeof(self) weakSelf = self;
            
            alertView.onOkBlock = ^{
                
                [weakSelf jumpMoneyJPL];
            };
            
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            
            [self showProjectPickerByIndexPath:indexPath];
            
        }
    }
}
#pragma mark - 点击包工
- (void)didSelectContrctFromTableView:(UITableView *)tableView FromIndexpath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [self showProjectPickerByIndexPath:indexPath];
            
        }
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            JGJMakeAccountChoiceSubentryTemplateController *subentryListVC = [[JGJMakeAccountChoiceSubentryTemplateController alloc] init];
            subentryListVC.cellTag = indexPath.section * 10 + indexPath.row;
            [self.navigationController pushViewController:subentryListVC animated:YES];
            // 分项名称输入确定回调
            TYWeakSelf(self);
            TYStrongSelf(self);
            subentryListVC.sureSubenTryInput = ^(NSInteger cellTag, NSString *subentryName) {
                
                NSInteger section = cellTag / 10;
                NSInteger row = cellTag % 10;
                weakself.yzgGetBillModel.sub_proname = subentryName;
                weakself.yzgGetBillModel.tpl_id = @"0";
                [weakself.tableview reloadData];
                
            };
            
            subentryListVC.selectedSubentryModel = ^(NSInteger cellTag, JGJSubentryListModel *subentryModel) {
                
                NSInteger section = cellTag / 10;
                NSInteger row = cellTag % 10;
                // 分项名称
                weakself.yzgGetBillModel.sub_proname = subentryModel.sub_pro_name;
                
                // 分项单价
                weakself.yzgGetBillModel.unitprice = [subentryModel.set_unitprice floatValue];
                
                // 分项单位
                weakself.yzgGetBillModel.units = subentryModel.units;
                strongself -> _selectedUnits = subentryModel.units;
                weakself.yzgGetBillModel.tpl_id = subentryModel.tpl_id;
                [weakself.tableview reloadData];
            };
            
        }else if (indexPath.row == 2) {
            
            JGJPackNumViewController *changeToVc = [[UIStoryboard storyboardWithName:@"packStroyBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"PackNumVC"];
            JGJFilloutNumModel *model = [[JGJFilloutNumModel alloc]init];
            
            model.priceNum = self.yzgGetBillModel.units?:@"";
            model.Num = [NSString stringWithFormat:@"%.2f", self.yzgGetBillModel.quantities?:0.00];
            
            changeToVc.filloutmodel = model;
            [self.navigationController pushViewController:changeToVc animated:YES];
        }
        
    }else if (indexPath.section == 2){
        
        
        if (indexPath.row == 1 || indexPath.row == 2){
            
            NSString *dateString = indexPath.row == 2?self.yzgGetBillModel.p_s_time:self.yzgGetBillModel.p_e_time;
            BOOL dateStringIsNotExist = [dateString isEqualToString:@"0"]||[NSString isEmpty:dateString];
            if (![NSString isEmpty:dateString]) {
                if (dateString.length < 8) {
                    dateStringIsNotExist = YES;
                }
            }
            self.jlgDatePickerView.datePicker.date = dateStringIsNotExist?[NSDate date]:[NSDate dateFromString:dateString withDateFormat:@"yyyyMMdd"];
            [self.jlgDatePickerView showDatePickerByIndexPath:indexPath];
        }
    }
    
}
#pragma mark - 点击结算
- (void)didSelectCloseAccountFromTableView:(UITableView *)tableView FromIndexpath:(NSIndexPath *)indexPath
{
    [JGJQustionShowView removeQustionView];

    if (indexPath.section == 2 && indexPath.row == 0) {
        JGJCloseAccountOpenTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
        if ([cell.subImageView.image isEqual:[UIImage imageNamed:@"arrowDown"]]) {
            self.nowTitleArr = [[NSArray alloc]initWithArray:self.openTitleArr];
            self.nowImageArr = [[NSArray alloc]initWithArray:self.openImageArr];
            self.nowSubTitleArr = [[NSArray alloc]initWithArray:self.openSubTitleArr];
            
        }else{
            
            self.nowTitleArr = [[NSArray alloc]initWithArray:self.titleArrs];
            self.nowImageArr = [[NSArray alloc]initWithArray:self.imageArrs];
            self.nowSubTitleArr = [[NSArray alloc]initWithArray:self.subTitleArr];
            
        }
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:2];
        [self.tableview reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];
        
    }else if (indexPath.section == 5){
        if (indexPath.row == 0) {
            [self showProjectPickerByIndexPath:indexPath];
        }
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isHaveChangedParameters = YES;
    if (_mateWorkitemsItems.accounts_type.code == 1 || _mateWorkitemsItems.accounts_type.code == 5) {
        
        [self didSelectTinyFromTableView:tableView FromIndexpath:indexPath];
    }else if (_mateWorkitemsItems.accounts_type.code == 2){
       
        [self didSelectContrctFromTableView:tableView FromIndexpath:indexPath];
    }else if (_mateWorkitemsItems.accounts_type.code == 3){
       
        if (indexPath.section == 2) {
            
            [self showProjectPickerByIndexPath:indexPath];
        }
    }else{
        
        [self didSelectCloseAccountFromTableView:tableView FromIndexpath:indexPath];
    }
    [self.view endEditing:YES];
}

#pragma mark - 选择上班时间
- (void)selectManHourTime:(NSString *)Manhour
{

    if ([Manhour?:@"0.00" floatValue] == (int)[Manhour floatValue]) {
        self.yzgGetBillModel.manhour =  [[NSString stringWithFormat:@"%.0f",[Manhour?:@"0" doubleValue]]doubleValue];
        
    }else{
        self.yzgGetBillModel.manhour =  [[NSString stringWithFormat:@"%.1f",[Manhour?:@"0" doubleValue]]doubleValue];
        
    }
    _work_time = Manhour;
    [self getSalary];
    [self.tableview reloadData];

}
#pragma mark - 选择加班时间
- (void)selectOverHour:(NSString *)overTime
{
    if ([overTime?:@"0.00" floatValue] == (int)[overTime floatValue]) {
        self.yzgGetBillModel.overtime =  [[NSString stringWithFormat:@"%.0f",[overTime doubleValue]]doubleValue];

    }else{
        self.yzgGetBillModel.overtime =  [[NSString stringWithFormat:@"%.1f",[overTime doubleValue]]doubleValue];

    }
    _over_time = overTime;
    [self getSalary];
    [self.tableview reloadData];
}

#pragma mark - 快捷选择上班 加班时长
- (void)manHourViewSelectedHalfOrOneTimeWithTimeStr:(NSString *)timeSelected isManHourTime:(BOOL)isManHourTime {
    
    if (isManHourTime) {// 选择上班时长
        
        if ([timeSelected?:@"0.00" floatValue] == (int)[timeSelected floatValue]) {
            self.yzgGetBillModel.manhour =  [[NSString stringWithFormat:@"%.0f",[timeSelected?:@"0" doubleValue]]doubleValue];
            
        }else{
            self.yzgGetBillModel.manhour =  [[NSString stringWithFormat:@"%.1f",[timeSelected?:@"0" doubleValue]]doubleValue];
            
        }
        _work_time = timeSelected;
        
    }else {// 选择加班时长
        
        if ([timeSelected?:@"0.00" floatValue] == (int)[timeSelected floatValue]) {
            
            self.yzgGetBillModel.overtime =  [[NSString stringWithFormat:@"%.0f",[timeSelected doubleValue]]doubleValue];
            
        }else{
            
            self.yzgGetBillModel.overtime =  [[NSString stringWithFormat:@"%.1f",[timeSelected doubleValue]]doubleValue];
            
        }
        _over_time = timeSelected;

    }
    [self getSalary];
    [self.tableview reloadData];
}

#pragma mark - 初始化点工
- (UITableViewCell *)loadTinyTbaleviewFromIndexpath:(NSIndexPath *)indexpath
{
    if (indexpath.section == 1 && indexpath.row == 3) {
        
        JGJMarkBillTextFileTableViewCell *cell = [JGJMarkBillTextFileTableViewCell cellWithTableView:self.tableview];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLable.text = self.titleArrs[indexpath.section][indexpath.row];
        
        cell.textfiled.userInteractionEnabled = NO;
        
        cell.headImageView.image = [UIImage imageNamed:self.imageArrs[indexpath.section][indexpath.row]];
    
        if (self.yzgGetBillModel.set_tpl.s_tpl <= 0) {
       
            cell.textfiled.text = @"-";

        }else{
        
            cell.textfiled.text = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.salary];
        }
        
        cell.textfiled.font = [UIFont boldSystemFontOfSize:17];

        cell.lineView.hidden = YES;
        return cell;
        
    }else if (indexpath.section == self.titleArrs.count - 1){//备注
        if (indexpath.row == 0) {
            JGJRemarkModifyBillsTableViewCell *modeifyCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRemarkModifyBillsTableViewCell" owner:nil options:nil]firstObject];
            modeifyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            modeifyCell.textView.text = self.yzgGetBillModel.notes_txt;
            if (![NSString isEmpty:self.yzgGetBillModel.notes_txt]) {
                modeifyCell.placeLable.hidden = YES;
            }else{
                modeifyCell.placeLable.hidden = NO;
            }

            modeifyCell.delegate = self;
            
            return modeifyCell;
            
        }else{
            
            modeifyImageCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJPoorBillPhotoTableViewCell" owner:nil options:nil]firstObject];
            
            modeifyImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            modeifyImageCell.delegate = self;
            
            modeifyImageCell.imageArr = _imageArr;
            
            return modeifyImageCell;
        }
    }else{
        
        JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:self.tableview];
        
        cell.contentLable.textColor = AppFont333333Color;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLable.text = self.titleArrs[indexpath.section][indexpath.row];
        
        cell.headImageView.image = [UIImage imageNamed:self.imageArrs[indexpath.section][indexpath.row]];
        
        
        if (indexpath.section == 0) {
            if (indexpath.row == 0) {
                
                cell.contentLable.text = self.yzgGetBillModel.name?:@"";
            }else{
               
                cell.contentLable.text = self.yzgGetBillModel.date?:@"";
            }
            cell.arrowImageView.hidden = YES;
            cell.rightConstance.constant = 0;
            cell.contentLable.textColor = AppFont999999Color;
            
            if (indexpath.row == 1) {
                
                cell.lineView.hidden = YES;
            }

        }else if (indexpath.section == 1){
            
            if (indexpath.row == 0) {
                NSString *manHourStr;
                NSString *overTimeStr;
                NSString *salaryStr;
                NSString *oneHourMoneyStr;
                
                if (self.yzgGetBillModel.set_tpl.hour_type == 0) {
                    
                    manHourStr = [[NSString stringWithFormat:@"上班%.1f小时算1个工",self.yzgGetBillModel.set_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    overTimeStr = [[NSString stringWithFormat:@"加班%.1f小时算1个工",self.yzgGetBillModel.set_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    if (self.yzgGetBillModel.set_tpl.s_tpl <= 0) {
                        
                        cell.contentLable.text = [NSString stringWithFormat:@"%@\n%@",manHourStr,overTimeStr];
                        
                    }else {
                        
                        salaryStr = [NSString stringWithFormat:@"%.2f元/个工(上班)",self.yzgGetBillModel.set_tpl.s_tpl];
                        if (self.yzgGetBillModel.set_tpl.o_h_tpl > 0) {
                            
                            oneHourMoneyStr = [NSString stringWithFormat:@"%.2f元/小时(加班)",[NSString roundFloat:self.yzgGetBillModel.set_tpl.s_tpl / self.yzgGetBillModel.set_tpl.o_h_tpl]];

                        }
                        
                        cell.contentLable.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",manHourStr,overTimeStr,salaryStr,oneHourMoneyStr];
                    }
                    
                    cell.contentLable.numberOfLines = 0;
                    
                }else {
                    
                    manHourStr = [[NSString stringWithFormat:@"上班%.1f小时算1个工",self.yzgGetBillModel.set_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    
                    salaryStr = [NSString stringWithFormat:@"%.2f元/个工(上班)",self.yzgGetBillModel.set_tpl.s_tpl];
                    
                    oneHourMoneyStr = [NSString stringWithFormat:@"%.2f元/小时(加班)",self.yzgGetBillModel.set_tpl.o_s_tpl];
                    
                    cell.contentLable.numberOfLines = 0;
                    
                    cell.contentLable.text = [NSString stringWithFormat:@"%@\n%@\n%@",manHourStr,salaryStr,oneHourMoneyStr];
                    
                }
                
                
                [cell.contentLable SetLinDepart:5];
                
                cell.contentLable.textAlignment = NSTextAlignmentRight;

            }else if (indexpath.row == 1) {
                
                if ([_work_time floatValue] <= 0) {
                    
                    cell.contentLable.text = @"休息";
                    
                }else{
                    
                    NSString *contentStr;
                    if ([_work_time floatValue] == _yzgGetBillModel.set_tpl.w_h_tpl) {
                        
                        contentStr = [NSString stringWithFormat:@"%.1f小时(1个工)", [_work_time floatValue]];
                        
                    }else if ([_work_time floatValue] == _yzgGetBillModel.set_tpl.w_h_tpl / 2) {
                        
                        contentStr = [NSString stringWithFormat:@"%.1f小时(半个工)", [_work_time floatValue]];
                        
                    }else {
                        
                        contentStr = [NSString stringWithFormat:@"%.1f小时", [_work_time floatValue]];
                    }
                    
                    cell.contentLable.text = [contentStr stringByReplacingOccurrencesOfString:@".0" withString:@""];

                }
            }else if (indexpath.row == 2) {
                
                if ([_over_time floatValue] <= 0) {
                    
                    cell.contentLable.text = @"无加班";
                    
                }else{
                    
                    NSString *contentStr;
                    if ([_over_time floatValue] == _yzgGetBillModel.set_tpl.o_h_tpl) {
                        
                        contentStr = [NSString stringWithFormat:@"%.1f小时(1个工)", [_over_time floatValue]];
                        
                    }else if ([_over_time floatValue] == _yzgGetBillModel.set_tpl.o_h_tpl / 2) {
                        
                        contentStr = [NSString stringWithFormat:@"%.1f小时(半个工)", [_over_time floatValue]];
                        
                    }else {
                        
                        contentStr = [NSString stringWithFormat:@"%.1f小时", [_over_time floatValue]];
                    }
                    
                    cell.contentLable.text = [contentStr stringByReplacingOccurrencesOfString:@".0" withString:@""];

                }
            }else{
                
                cell.contentLable.text =[NSString stringWithFormat:@"%.2f", self.yzgGetBillModel.salary?:0.00];
                cell.lineView.hidden = YES;

            }
        }else if (indexpath.section == 2){
            if (indexpath.row == 0) {
                
                cell.contentLable.text = self.yzgGetBillModel.proname?:@"";
                if (self.yzgGetBillModel.pid == 0 && ![self.yzgGetBillModel.proname isEqualToString:@"无"]) {
                    
                    cell.contentLable.text = @"";
                }
                // 代班长进来不能修改项目
                if (![NSString isEmpty:self.mateWorkitemsItems.agency_uid]) {
                    
                    cell.contentLable.textColor = AppFont666666Color;
                    cell.userInteractionEnabled = NO;
                    cell.arrowImageView.hidden = YES;
                }
            }
        }else{
            
        }
        return cell;
    }
    
}
#pragma mark - 包公等输入框
- (void)JGJMarkBillTextFileEditingText:(NSString *)text WithTag:(NSInteger)tag
{
    _isHaveChangedParameters = YES;
    if (tag == JGJTextFildContractSubProType) {//分项
        self.yzgGetBillModel.sub_proname = text?:@"";
    }else if (tag == JGJTextFildContractUnitePrice){//单价
        self.yzgGetBillModel.unitprice = [[NSString stringWithFormat:@"%.2f",[text?text:@"0" doubleValue]]doubleValue];
    }else if (tag == JGJTextFildContractNum){//数量
        self.yzgGetBillModel.browNum = text?text:@"";
    }else if (tag == JGJTextFildContracAccount){//工钱
        self.yzgGetBillModel.amounts =  [[NSString stringWithFormat:@"%.2f",[text?text:@"0" doubleValue]]doubleValue];
    }else if (tag == JGJTextFildBrrowAccount){
        self.yzgGetBillModel.amounts =  [[NSString stringWithFormat:@"%.2f",[text?text:@"0" doubleValue]]doubleValue];
    }else if (tag == 21) {
        self.yzgGetBillModel.subsidy_amount = text?text:@"";
    }else if (tag == 22){
        self.yzgGetBillModel.reward_amount = text?text:@"";
    }else if (tag == 23){
        self.yzgGetBillModel.penalty_amount = text?text:@"";
    }else if (tag == 40){//本次实收/付金额
        
//        self.yzgGetBillModel.salary = [[NSString stringWithFormat:@"%.2f",[text?text:@"0" doubleValue]]doubleValue];
        if ([NSString isEmpty:text]) {
            
            self.yzgGetBillModel.salary = 0.00;
            _isClearEditMoney = YES;
            
        }else{
            
            self.yzgGetBillModel.salary = [text doubleValue];
        }
        _markEditeMoney = self.yzgGetBillModel.salary;
        
    }else if (tag == 41){//抹零金额
        if ([NSString isEmpty:text]) {
            
            self.yzgGetBillModel.deduct_amount = @"0.00";
        }else{
            self.yzgGetBillModel.deduct_amount = text;
        }
    }
    if (self.mateWorkitemsItems.accounts_type.code == 4) {
        [self CalculationAmount];

    }else{
   
        [self getSalary];
    }
}
#pragma mark - 初始化包工
- (UITableViewCell *)loadContractTbaleviewFromIndexpath:(NSIndexPath *)indexpath
{
    if (indexpath.section == 2 && indexpath.row == 0) {//记工备注显示这一栏
        
        JGJMarkBillModifyRemarkTableViewCell  *cell = [JGJMarkBillModifyRemarkTableViewCell cellWithTableView:self.tableview];
        return cell;
        
    }else if (indexpath.section == 1  && indexpath.row == 1) {// 包工单价
        
        JGJMarkBillTextFileTableViewCell  *cell = [JGJMarkBillTextFileTableViewCell cellWithTableView:self.tableview];
        cell.delegate = self;
        cell.maxLength = 15;
        cell.numberType = JGJNumberKeyBoardType;
        cell.textfiled.tag = indexpath.row;
        cell.titleLable.text = self.titleArrs[indexpath.section][indexpath.row];
        cell.headImageView.image = [UIImage imageNamed:self.imageArrs[indexpath.section][indexpath.row]];

        cell.textfiled.text = [NSString stringWithFormat:@"%.2f", self.yzgGetBillModel.unitprice?:0.00];
        
        cell.textfiled.textColor = AppFontEB4E4EColor;
        
        cell.textfiled.font = [UIFont boldSystemFontOfSize:15];
       
        return cell;
    }else if (indexpath.section == self.titleArrs.count - 1){//备注
        
        if (indexpath.row == 0) {
            JGJRemarkModifyBillsTableViewCell *Cell = [JGJRemarkModifyBillsTableViewCell cellWithTableView:self.tableview];
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            Cell.textView.text = self.yzgGetBillModel.notes_txt;
            if (![NSString isEmpty:self.yzgGetBillModel.notes_txt]) {
                
                Cell.placeLable.hidden = YES;
            }else{
                
                Cell.placeLable.hidden = NO;
                
            }
//这里时候面更改需求  需要吧顶部的那个去掉
            Cell.topConstance.constant = -21;
            Cell.titleLable.hidden = YES;
            Cell.headImageView.hidden = YES;
            Cell.delegate = self;

            return Cell;
        }else{
            
            modeifyImageCell = [JGJPoorBillPhotoTableViewCell cellWithTableView:self.tableview];
            
            modeifyImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            modeifyImageCell.delegate = self;
            
            modeifyImageCell.imageArr = _imageArr;
            
            return modeifyImageCell;
        }
    }else{
        
        JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:self.tableview];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.contentLable.textColor = AppFont333333Color;
        
        cell.titleLable.text = self.titleArrs[indexpath.section][indexpath.row];
        
        cell.headImageView.image = [UIImage imageNamed:self.imageArrs[indexpath.section][indexpath.row]];
        if (indexpath.section == 0) {
        
            if (indexpath.row == 0) {
                
                
                cell.contentLable.text = self.yzgGetBillModel.proname?:@"";
                cell.leftLineConstance.constant = 0;
                cell.rightLineConstance.constant = 0;
                
                // 代班长进来不能修改项目
                if (![NSString isEmpty:self.mateWorkitemsItems.agency_uid]) {
                    
                    cell.contentLable.textColor = AppFont666666Color;
                    cell.userInteractionEnabled = NO;
                    cell.arrowImageView.hidden = YES;
                }
                
            }else if (indexpath.row == 1) {
           
                if (JLGisLeaderBool && self.yzgGetBillModel.contractor_type == 1) {// 工头 承包
                    
                    cell.contentLable.text = self.yzgGetBillModel.foreman_name?:@"";
                    
                }else {
                    
                    cell.contentLable.text = self.yzgGetBillModel.name?:@"";
                }
                
                cell.arrowImageView.hidden = YES;
                cell.rightConstance.constant = 0;
                cell.contentLable.textColor = AppFont999999Color;
                
            }else{
          
                cell.contentLable.text = self.yzgGetBillModel.date?:@"";
                
                cell.arrowImageView.hidden = YES;
                cell.rightConstance.constant = 0;
                cell.contentLable.textColor = AppFont999999Color;
            }
            

            if (indexpath.row == 2) {
                
                cell.lineView.hidden = YES;
            }
        }else if (indexpath.section == 1 && indexpath.row == 0) {
            
            if ([NSString isEmpty:self.yzgGetBillModel.sub_proname]) {
                
                cell.contentLable.text = @"包柱子/挂窗帘";
                cell.contentLable.textColor = AppFont999999Color;
                
            }else {
                
                cell.contentLable.text = self.yzgGetBillModel.sub_proname;
                cell.contentLable.textColor = AppFont333333Color;
            }
            
        }
        else if (indexpath.section == 1 && indexpath.row == 2){//包工填写数量

            JGJContractorMakeAccountInputCountAndUnitsCell *_inputCountAndUnitsCell = [JGJContractorMakeAccountInputCountAndUnitsCell cellWithTableViewNotXib:self.tableview];
            _inputCountAndUnitsCell.delegate = self;
            _inputCountAndUnitsCell.cellTag = indexpath.section * 10 + indexpath.row;
            _inputCountAndUnitsCell.yzgGetBillModel = self.yzgGetBillModel;
            
            return _inputCountAndUnitsCell;

            
        }else if (indexpath.section == 1 && indexpath.row == 3) {
            
            cell.contentLable.text = [NSString stringWithFormat:@"%.2f", self.yzgGetBillModel.amounts?:0.00];
            
            cell.contentLable.userInteractionEnabled = NO;
            
            cell.contentLable.textColor = AppFontEB4E4EColor;
            
            cell.contentLable.font = [UIFont boldSystemFontOfSize:15];
            
            cell.lineView.hidden = YES;
            
            cell.arrowImageView.hidden = YES;
            cell.rightConstance.constant = 0;
        }
        else if (indexpath.section == 2){
            
            if (indexpath.row == 1)//开工时间后期添加的 选择开工时间
            {
                cell.leftConstance.constant = -18;
                cell.titleLable.font = [UIFont systemFontOfSize:15];
                cell.titleWidth.constant = 95;
                if ([NSString isEmpty: self.yzgGetBillModel.p_s_time ]) {
                    cell.contentLable.text = @"请选择开工时间";
                    cell.contentLable.textColor = AppFont999999Color;
                }else{
                    cell.contentLable.text = [NSString stringDateFrom: self.yzgGetBillModel.p_s_time ];
                    cell.contentLable.textColor = AppFont333333Color;
                }
                
            }else if (indexpath.row == 2) {//完成时间后期添加的 选择完工时间
                
                cell.titleLable.font = [UIFont systemFontOfSize:15];
                cell.leftConstance.constant = -18;
                cell.titleWidth.constant = 95;

                if ([NSString isEmpty: self.yzgGetBillModel.p_e_time ]) {
                    
                    cell.contentLable.text = @"请选择完工时间";
                    cell.contentLable.textColor = AppFont999999Color;
                    
                }else{
                    
                    cell.contentLable.text =  [NSString stringDateFrom: self.yzgGetBillModel.p_e_time];;
                    cell.contentLable.textColor = AppFont333333Color;
                }
            }
        }
        
        return cell;
    }
}

#pragma mark - JGJContractorMakeAccountInputCountAndUnitsCellDelegate
- (void)inputCountTextFieldEndEditing {
    
    [self.tableview reloadData];
}

- (void)JGJContractorMakeAttendanceInputCountTextFileEditingText:(NSString *)text cellTag:(NSInteger)cellTag {
    
    _isHaveChangedParameters = YES;
    
    // 数量
    self.yzgGetBillModel.quantities = [text doubleValue];
    self.yzgGetBillModel.amounts = self.yzgGetBillModel.unitprice * self.yzgGetBillModel.quantities;    
    
}

// 选择单位
- (void)inputCountAndUnitsCellChoiceUnitsWithCellTag:(NSInteger)cellTag {
    
    [self.view endEditing:YES];
    _isHaveChangedParameters = YES;
    
    JGJWeatherPickerview *picker = [[JGJWeatherPickerview alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 265, TYGetUIScreenWidth, 265)];
    picker.delegate = self;
    picker.topname = @"选择单位";
    
    [picker showWeatherPickerView];
    picker.classmodel = JGJPacknumPickermodel;
    picker.selectedUnits = _selectedUnits;
    picker.titlearray = [NSMutableArray arrayWithObjects:@"平方米",@"立方米",@"吨",@"米",@"个",@"次",@"天",@"块",@"组",@"台",@"捆",@"宗",@"项",@"株",nil];
    [picker setLeftButtonTitle:@"" rightButtonTitle:@"关闭"];
}

- (void)didselectweaterevent:(NSIndexPath *)indexpath andstr:(NSString *)content
{
    self.yzgGetBillModel.units = content;
    _selectedUnits = content;
    
    [self.tableview reloadData];
}

#pragma mark - 初始化借支
- (UITableViewCell *)loadBrrowTbaleviewFromIndexpath:(NSIndexPath *)indexpath
{
    if (indexpath.section == 1) {
        
        JGJMarkBillTextFileTableViewCell  *cell = [JGJMarkBillTextFileTableViewCell cellWithTableView:self.tableview];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLable.text = self.titleArrs[indexpath.section][indexpath.row];
        
        cell.textfiled.tag = 10;
        
        cell.delegate = self;
        
        cell.maxLength = 6;
        
        cell.numberType = JGJNumberKeyBoardType;
        
        cell.textfiled.textColor = AppFont83C76EColor;
        
        cell.headImageView.image = [UIImage imageNamed:self.imageArrs[indexpath.section][indexpath.row]];
        
        cell.textfiled.text = [NSString stringWithFormat:@"%.2f", self.yzgGetBillModel.amounts?:0.00];
        cell.textfiled.font = [UIFont boldSystemFontOfSize:15];
        cell.lineView.hidden = YES;
        return cell;
        
    }else if (indexpath.section == self.titleArrs.count - 1){
        if (indexpath.row == 0) {
            JGJRemarkModifyBillsTableViewCell *modeifyCell = [JGJRemarkModifyBillsTableViewCell cellWithTableView:self.tableview];
            modeifyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            modeifyCell.textView.text = self.yzgGetBillModel.notes_txt;
            if (![NSString isEmpty:self.yzgGetBillModel.notes_txt]) {
                modeifyCell.placeLable.hidden = YES;
            }else{
                modeifyCell.placeLable.hidden = NO;
                
            }
            modeifyCell.delegate = self;

            return modeifyCell;
        }else{
            
            modeifyImageCell = [JGJPoorBillPhotoTableViewCell cellWithTableView:self.tableview];
            modeifyImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            modeifyImageCell.delegate = self;
            
            modeifyImageCell.imageArr = _imageArr;
            
            return modeifyImageCell;
        }
    }else{
        
        JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:self.tableview];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLable.text = self.titleArrs[indexpath.section][indexpath.row];
        
        cell.contentLable.textColor = AppFont333333Color;
        
        cell.headImageView.image = [UIImage imageNamed:self.imageArrs[indexpath.section][indexpath.row]];
        if (indexpath.section == 0) {
            if (indexpath.row == 0) {
                cell.contentLable.text = self.yzgGetBillModel.name?:@"";
            }else{
                cell.contentLable.text = self.yzgGetBillModel.date?:@"";
                cell.lineView.hidden = YES;
            }
            cell.arrowImageView.hidden = YES;
            cell.rightConstance.constant = 0;
            cell.contentLable.textColor = AppFont999999Color;
        }else if(indexpath.section == 2 && indexpath.row == 0){
            if (![NSString isEmpty: self.yzgGetBillModel.proname]) {
                cell.contentLable.text = self.yzgGetBillModel.proname?:@"";
            }
            
            // 代班长进来不能修改项目
            if (![NSString isEmpty:self.mateWorkitemsItems.agency_uid]) {
                
                cell.contentLable.textColor = AppFont666666Color;
                cell.userInteractionEnabled = NO;
                cell.arrowImageView.hidden = YES;
            }
        }


        return cell;
    }
    
}
#pragma mark - 初始化结算

- (UITableViewCell *)loadCloseAmountTbaleviewFromIndexpath:(NSIndexPath *)indexpath
{
    if (indexpath.section == self.nowTitleArr.count - 1) {//备注
        if (indexpath.row == 0) {
            JGJRemarkModifyBillsTableViewCell *modeifyCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRemarkModifyBillsTableViewCell" owner:nil options:nil]firstObject];
            modeifyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            modeifyCell.textView.text = self.yzgGetBillModel.notes_txt;
            if (![NSString isEmpty:self.yzgGetBillModel.notes_txt]) {
                modeifyCell.placeLable.hidden = YES;
            }else{
                modeifyCell.placeLable.hidden = NO;
                
            }
            modeifyCell.delegate = self;

            return modeifyCell;
        }else{
            modeifyImageCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJPoorBillPhotoTableViewCell" owner:nil options:nil]firstObject];
            modeifyImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            modeifyImageCell.delegate = self;
            
            modeifyImageCell.imageArr = _imageArr;
            
            
            return modeifyImageCell;
        }
    }else if (indexpath.section == 1 && indexpath.row == 1) {
        
        JGJWaringSuggustTableViewCell  *cell = [JGJWaringSuggustTableViewCell cellWithTableView:self.tableview];
        
        cell.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([NSString isEmpty:self.yzgGetBillModel.name]|| [self.yzgGetBillModel.un_salary_tpl?:@"0" floatValue] <= 0) {
            cell.contentView.hidden = YES;
        }else{
            cell.contentView.hidden = NO;;
            
            cell.contentLable.text = [NSString stringWithFormat:@"你还有 %@笔  点工的工资模板中未设置金额",self.yzgGetBillModel.un_salary_tpl?:@"0"];
            [cell.contentLable markText:[NSString stringWithFormat:@"%@笔",self.yzgGetBillModel.un_salary_tpl?:@"0"] withColor:AppFontEB4E4EColor];
        }
        return cell;
    }else if ((indexpath.section == 1 && indexpath.row == 0) || (indexpath.section == 3 && indexpath.row == 2 )|| (indexpath.section == 4 && indexpath.row == 0)){
        JGJCloseAccountTwoImageTableViewCell  *cell = [JGJCloseAccountTwoImageTableViewCell cellWithTableView:self.tableview];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self loadCloseAccountHaveQuestionMarkFromindexpath:indexpath fromtableviewCell:cell];

        return cell;
        
    }else if (indexpath.section == 2){
        if (indexpath.row == 0) {
            JGJCloseAccountOpenTableViewCell *cell = [JGJCloseAccountOpenTableViewCell cellWithTableView:self.tableview];
            
            [self loadTwoImageTextfiledCellFromindexpath:indexpath fromTableViewCell:cell];

            return cell;
        }else{
            
            JGJMarkBillTextFileTableViewCell *cell = [JGJMarkBillTextFileTableViewCell cellWithTableView:self.tableview];
            
            cell.headImageView.hidden = YES;
            
            cell.textfiled.tag = 20 + indexpath.row;
            
            cell.textfiledRightConstance.constant = 50;
            
            cell.titleWidth.constant = 80;
            
            if (indexpath.row == 1 || indexpath.row == 2 ) {
                cell.leftLineConstance.constant = 50;
                
//                cell.rightLineConstance.constant = 50;
            }
            
            [self loadCloseAccountSalaryTextfiledfromIndexpath:indexpath FromTableviewcell:cell];

            return cell;
        }        
        
    }else if (indexpath.section == 3|| indexpath.section == 4){
        
        
        if ((indexpath.section == 3 && indexpath.row == 0 )||( indexpath.section == 3 && indexpath.row == 1)) {
            JGJMarkBillTextFileTableViewCell *cell = [JGJMarkBillTextFileTableViewCell cellWithTableView:self.tableview];
            
            cell.textfiled.tag = 40 + indexpath.row;
            
            [self loadCloseAccountMainSalaryTextfiledfromIndexpath:indexpath FromTableviewcell:cell];

            return cell;
        }else{
            JGJCloseAccountMoreTableViewCell *cell = [JGJCloseAccountMoreTableViewCell cellWithTableView:self.tableview];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titleLable.text = self.nowTitleArr[indexpath.section][indexpath.row];
            
//            cell.contentLable.text = self.nowSubTitleArr[indexpath.section][indexpath.row];
            
            cell.headImageView.image = [UIImage imageNamed:self.nowImageArr[indexpath.section][indexpath.row]];
            
            [self loadCloseMoreDataCellFromindexpath:indexpath fromTableViewCell:cell];

            return cell;
        }
        
    }else{
        
        JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:self.tableview];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLable.text = self.nowTitleArr[indexpath.section][indexpath.row];
        
        cell.headImageView.image = [UIImage imageNamed:self.nowImageArr[indexpath.section][indexpath.row]];
        
        [self loadDataContentCellFromindexpath:indexpath fromTableViewCell:cell];

        return cell;
    }
}
#pragma mark - 常规显示
- (void)loadDataContentCellFromindexpath:(NSIndexPath *)indexpath fromTableViewCell:(JGJMarkBillTinyTableViewCell *)cell
{
    cell.contentLable.text = self.nowSubTitleArr[indexpath.section][indexpath.row];
    if (indexpath.section == 0) {
        if (indexpath.row == 0) {
            cell.arrowImageView.hidden = YES;
            cell.rightConstance.constant = 0;
            if (![NSString isEmpty:self.yzgGetBillModel.name]) {
                cell.contentLable.text = self.yzgGetBillModel.name;
                cell.contentLable.textColor = AppFont999999Color;
                
            }
        }else if (indexpath.row == 1) {
            cell.arrowImageView.hidden = YES;
            cell.rightConstance.constant = 0;

            cell.contentLable.textColor = AppFont999999Color;
            cell.lineView.hidden = YES;
            
            if (![NSString isEmpty:self.yzgGetBillModel.date]) {
                cell.contentLable.text = self.yzgGetBillModel.date?:@"";
                
            }
        }
    }else if (indexpath.section == 1){
        if (indexpath.row == 0) {
            cell.arrowImageView.hidden = YES;
            cell.rightConstance.constant = 0;
            cell.lineView.hidden = YES;
        }
    }else if(indexpath.section == 5){
        if (indexpath.row == 0) {
            if (![NSString isEmpty:self.yzgGetBillModel.proname]) {
                cell.contentLable.text = self.yzgGetBillModel.proname;
                cell.contentLable.textColor = AppFont333333Color;
            }
            
            // 代班长进来不能修改项目
            if (![NSString isEmpty:self.mateWorkitemsItems.agency_uid]) {
                
                cell.contentLable.textColor = AppFont666666Color;
                cell.userInteractionEnabled = NO;
                cell.arrowImageView.hidden = YES;
            }
        }else{
            if (![NSString isEmpty:self.yzgGetBillModel.notes_txt]) {
                cell.contentLable.text = self.yzgGetBillModel.notes_txt;
                cell.contentLable.textColor = AppFont333333Color;
            }
            
        }
    }
    
}
#pragma mark 展开收拢
- (void)loadTwoImageTextfiledCellFromindexpath:(NSIndexPath *)indexpath fromTableViewCell:(JGJCloseAccountOpenTableViewCell *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLable.text = self.nowTitleArr[indexpath.section][indexpath.row];
    
    cell.contentLable.text = self.nowSubTitleArr[indexpath.section][indexpath.row];
    
    cell.headImageView.image = [UIImage imageNamed:self.nowImageArr[indexpath.section][indexpath.row]];
    if (![NSString isEmpty:self.yzgGetBillModel.totalCalculation]) {
        cell.contentLable.text = self.yzgGetBillModel.totalCalculation;
        
    }
    if (indexpath.row != 0) {
        cell.subImageView.hidden = YES;
        cell.titleLable.font = [UIFont systemFontOfSize:15];
        
    }else{
        cell.subImageView.hidden = NO;
        cell.contentLable.textColor =AppFont999999Color;
        if ([self.nowTitleArr[indexpath.section] count] >1) {
            
            cell.subImageView.image = [UIImage imageNamed:@"arrowUp"];
            
        }else{
            cell.subImageView.image = [UIImage imageNamed:@"arrowDown"];
            
            
        }
        
    }
    
}
#pragma mark -标题比较长的
- (void)loadCloseMoreDataCellFromindexpath:(NSIndexPath *)indexpath fromTableViewCell:(JGJCloseAccountMoreTableViewCell *)cell
{
    
    
}
#pragma mark - 补贴奖励罚款输入框
- (void)loadCloseAccountSalaryTextfiledfromIndexpath:(NSIndexPath *)indexpath FromTableviewcell:(JGJMarkBillTextFileTableViewCell *)cell
{
    cell.titleLable.text = self.nowTitleArr[indexpath.section][indexpath.row];
    cell.textfiled.placeholder = self.nowSubTitleArr[indexpath.section][indexpath.row];
    cell.titleLable.font = [UIFont systemFontOfSize:14];
    cell.textfiled.font = [UIFont systemFontOfSize:14];
    cell.maxLength = 8;
    cell.numberType = JGJNumberKeyBoardType;
    cell.delegate = self;
    cell.titleLable.textColor = AppFont333333Color;;
    cell.textfiled.textColor = AppFont333333Color;;
    cell.leftConstance.constant = 15;
    if (indexpath.row == 1) {
        if (![NSString isEmpty: self.yzgGetBillModel.subsidy_amount ]) {
            cell.textfiled.text = self.yzgGetBillModel.subsidy_amount;
        }
    }else if(indexpath.row == 2){
        
        if (![NSString isEmpty: self.yzgGetBillModel.reward_amount ]) {
            cell.textfiled.text = self.yzgGetBillModel.reward_amount;
        }
    }else if(indexpath.row == 3){
        
        if (![NSString isEmpty: self.yzgGetBillModel.penalty_amount ]) {
            cell.textfiled.text = self.yzgGetBillModel.penalty_amount;
        }
    }
    
}
#pragma mark - 初始化有问号的cell
- (void)loadCloseAccountHaveQuestionMarkFromindexpath:(NSIndexPath *)indexpath fromtableviewCell:(JGJCloseAccountTwoImageTableViewCell *)cell{
    
    //最后一行时隐藏那条分割线
    if (indexpath.row == [self.nowTitleArr[indexpath.section] count] - 1 || (indexpath.section == 1 && indexpath.row == 0) || (indexpath.section == 3 && indexpath.row == 1)) {
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
        
    }
    
    cell.titleLable.text =self.nowTitleArr[indexpath.section][indexpath.row];
    
    cell.contentLable.text = self.nowSubTitleArr[indexpath.section][indexpath.row];
    
    cell.headImageView.image = [UIImage imageNamed:self.nowImageArr[indexpath.section][indexpath.row]];
    
    if (indexpath.section == 1) {
        cell.questionBtn.tag = 0;
    }else if (indexpath.section == 3){
        cell.questionBtn.tag = 1;
    }else if (indexpath.section == 4){
        cell.questionBtn.tag = 2;
    }
    [cell.questionBtn addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    if (indexpath.row == 0 && indexpath.section == 1) {
        
        cell.contentLable.textColor = AppFont999999Color;
        cell.contentLable.text = self.yzgGetBillModel.balance_amount?:@"0.00";
        cell.lineView.hidden = YES;
    }else if (indexpath.section == 3 && indexpath.row == 2){
        
        cell.contentView.hidden = YES;
        cell.contentLable.text = self.yzgGetBillModel.settlementAmount;
        cell.contentLable.textColor = AppFont999999Color;
        cell.contentLable.font = [UIFont systemFontOfSize:15];
        cell.lineView.hidden = YES;
        
    }else if (indexpath.section == 4 && indexpath.row == 0){
        
        cell.contentView.hidden = YES;
#pragma mark - 剩余未结金额
        cell.contentLable.text = self.yzgGetBillModel.remainingAmount;
        
        cell.lineView.hidden = YES;
        cell.contentLable.textColor = AppFont999999Color;

        
    }
    
    
}
-(void)btnClick:(id)sender event:(id)event{
    NSSet *touches=[event allTouches];
    UITouch *touch=[touches anyObject];
    CGPoint cureentTouchPosition=[touch locationInView:self.tableview];
    cureentTouchPosition.y = cureentTouchPosition.y + 64 - self.tableview.contentOffset.y ;;
    UIButton *btn = (UIButton *)sender;
    CGPoint cureentTouchBtn=[touch locationInView:btn];
    cureentTouchPosition.x = cureentTouchPosition.x + (11.5 - cureentTouchBtn.x);
    cureentTouchPosition.y = cureentTouchPosition.y + (11.5 - cureentTouchBtn.y);
    JGJQuestionShowtype type;
    
    if (btn.tag == 0) {
        type = JGJBalanceAmountType;
    }else if(btn.tag == 1){
        type = JGJNowPayAmountType;
    }else{
        type = JGJRemaingAmountType;
    }
    //得到cell中的IndexPath
    //    NSIndexPath *indexPath=[self.tableView indexPathForRowAtPoint:cureentTouchPosition];
    [JGJQustionShowView showQustionFromPoint:cureentTouchPosition FromShowType:type];
    
}
#pragma mark - 本次结算金额 抹零金额
- (void)loadCloseAccountMainSalaryTextfiledfromIndexpath:(NSIndexPath *)indexpath FromTableviewcell:(JGJMarkBillTextFileTableViewCell *)cell
{
    cell.titleLable.text = self.nowTitleArr[indexpath.section][indexpath.row];
    cell.textfiled.placeholder = self.nowSubTitleArr[indexpath.section][indexpath.row];
    cell.headImageView.image = [UIImage imageNamed:self.nowImageArr[indexpath.section][indexpath.row]];
    cell.titleLable.font = [UIFont boldSystemFontOfSize:15];
    cell.maxLength = 8;
    cell.numberType = JGJNumberKeyBoardType;
    cell.delegate = self;
    if (indexpath.section == 3) {
        if (indexpath.row == 0) {
            cell.textfiled.text = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.pay_amount?:0.00];
            cell.textfiled.textColor = AppFontEB4E4EColor;
            cell.textfiled.font = [UIFont boldSystemFontOfSize:17];
            cell.editeMoney = _markEditeMoney;
            
        }else if (indexpath.row == 1){
            cell.textfiled.textColor = AppFont666666Color;
            cell.textfiled.font = [UIFont systemFontOfSize:14];
            cell.textfiled.text = self.yzgGetBillModel.deduct_amount?:@"0.00";
            cell.lineView.hidden = YES;
        }
    }
    
}
#pragma mark -  查看未设置金额点工
-(void)clickLookforDetailBtn
{
    JGJUnWagesShortWorkVc *shortWorkVc = [JGJUnWagesShortWorkVc new];
    
    shortWorkVc.uid = [NSString stringWithFormat:@"%ld", (long)self.yzgGetBillModel.uid];
    
    [self.navigationController pushViewController:shortWorkVc animated:YES];
}
-(void)JGJMarkBillTextFilEndEditing
{
    _isHaveChangedParameters = YES;
    [self.tableview reloadData];
}

#pragma mark - 修改和删除后都要走这里
- (void)JGJModifyOrDelMarkBill
{
    for (UIViewController *curVc in self.navigationController.viewControllers) {
        
        if ([curVc isKindOfClass:NSClassFromString(@"JGJRecordWorkpointsVc")]) {
            
            JGJRecordWorkpointsVc *pointVc = (JGJRecordWorkpointsVc *)curVc;
            
            pointVc.isFresh = YES;
            
            break;
        }
        
        if ([curVc isKindOfClass:NSClassFromString(@"JYSlideSegmentController")]) {
            
            JYSlideSegmentController *slideVc = (JYSlideSegmentController *)curVc;
            
            [slideVc refreshGetOutstandingAmount];
            
            break;
        }
        
        if ([curVc isKindOfClass:NSClassFromString(@"JGJUnWagesVc")]) {
            
            JGJUnWagesVc *unWagesVc = (JGJUnWagesVc *)curVc;
            
            [unWagesVc refreshUnWagesData];
            
            break;
        }
        
        
        if ([curVc isKindOfClass:NSClassFromString(@"JGJSurePoorbillViewController")]) {
            
            JGJSurePoorbillViewController *surecBillVc = (JGJSurePoorbillViewController *)curVc;
            
            if (!_is_currentSureBill_ComeIn) {
                
                [surecBillVc beginRefreshSureBillListWithIndexPath:self.indexPath];
            }
            
            
            break;
        }
        
    }
    
}


@end
