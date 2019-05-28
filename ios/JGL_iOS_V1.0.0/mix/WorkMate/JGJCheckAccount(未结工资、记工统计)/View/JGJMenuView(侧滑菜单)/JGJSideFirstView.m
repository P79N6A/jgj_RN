//
//  JGJSideFirstView.m
//  mix
//
//  Created by yj on 2018/9/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSideFirstView.h"

#import "JGJRefreshTableView.h"

#import "JGJFilterBottomButtonView.h"

#import "JGJMemberImpressTagCell.h"

#import "JGJCusNavBar.h"

#import "ATDatePicker.h"

#import "NSDate+Extend.h"

#import "JGJMemberFilterView.h"

#import "JGJProFilterView.h"

#import "JGJRecordHeader.h"

#define Tag_list @[@"点工",@"包工记账",@"借支",@"结算",@"包工记工天"]

@interface JGJSideFirstView()<UITableViewDelegate, UITableViewDataSource, JGJMemberImpressTagCellDelegate>{
    
    BOOL _isReset;
}

@property (nonatomic, strong) JGJRefreshTableView *tableView;

@property (nonatomic, strong) JGJFilterBottomButtonView *buttonView;

@property (nonatomic, strong) JGJCusNavBar *cusNavBar;

//传入之前筛选的模型
@property (nonatomic, strong) NSMutableArray *desInfos;

@property (nonatomic, strong) JGJMemberImpressTagView *tagView;

@property (strong, nonatomic) JGJProFilterView *proSelView;

@property (strong, nonatomic) JGJMemberFilterView *memberSelView;

//标签模型
@property (nonatomic, strong) NSMutableArray *tag_names;

//首次选中的模型
@property (nonatomic, strong) NSMutableArray *fir_sel_tagModels;

@end

@implementation JGJSideFirstView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (void)commonSet {
    
    [self buttonPressed];
    
}

- (void)setContainViews:(NSMutableArray *)containViews {
    
    _containViews = containViews;
    
    [self addSubview:self.buttonView];
    
    [self addSubview:self.cusNavBar];
    
    [self addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.desInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 50;
    
    if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            height = 50;
            
        }else {
            
            height = [self tagViewHeightWithTagNames:[self tag_names]];
        }
    
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = self.desInfos[section];
    
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
            
        case 0:{
            
            cell = [self registerComDesCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
        
            break;
        case 1:
        
        case 2:{
            
            cell = [self registerComDesCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            
            break;
            
        case 3:{
            
            if (indexPath.row == 0) {
                
                cell = [self registerComDesCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                
            }else {
                
                cell = [self registerRecordTypeCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                
            }
            
        }
            
            break;

            
        default:
            break;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return  [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            
            if (indexPath.row == 0) {
                
                [self selStartTime];
                
            }else if (indexPath.row == 1) {
                
                [self selEndTime];
            }
            
        }
            
            break;
            
        case 1:{
            
            JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
            
            JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
            
            //锁定项目不能选择
            
            if (staInitialModel.is_lock_proname) {
                
                return;
            }
            
            NSArray *infos = self.desInfos[1];
            
            JGJRecordWorkPointFilterModel *proModel = [[JGJRecordWorkPointFilterModel alloc] init];
            
            JGJComTitleDesInfoModel *memberInfoModel = infos[0];
            
            proModel.class_type_id = memberInfoModel.typeId;
            
            proModel.name = memberInfoModel.des;
            
            JGJProFilterView *proFilterView = self.containViews[1];
            
            proFilterView.selProModel = proModel;
                        
            [self.sideView addQueueWithSubView:proFilterView];
        }
            break;
            
        case 2:{
            
            JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
            
            JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
            
            //锁定人员不能选择
            if (staInitialModel.is_lock_name) {
                
                return;
            }
            
            NSArray *infos = self.desInfos[2];
            
            JGJSynBillingModel *selMemberModel = [[JGJSynBillingModel alloc] init];
            
            JGJComTitleDesInfoModel *memberInfoModel = infos[0];
            
            selMemberModel.class_type_id = memberInfoModel.typeId;
            
            selMemberModel.name = memberInfoModel.des;
            
            JGJMemberFilterView *memberFilterView = self.containViews[2];
            
            memberFilterView.selMemberModel = selMemberModel;
            
            [self.sideView addQueueWithSubView:memberFilterView];
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 选择项目、选择班组长、记工分类、有无备注
- (UITableViewCell *)registerComDesCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJComTitleDesCell *cell = [JGJComTitleDesCell cellWithTableView:tableView];
    
    //第一段要显示农历
    cell.is_show_lunar = indexPath.section == 0;
    
    NSArray *infoModels = self.desInfos[indexPath.section];
    
    cell.infoModel = infoModels[indexPath.row];
    
    return cell;
    
}

#pragma mark - 选择记工分类
- (UITableViewCell *)registerRecordTypeCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberImpressTagCell *cell = [JGJMemberImpressTagCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    cell.tagViewType = JGJMemberImpressComselTagViewType;
    
    cell.topView.hidden = YES;
    
    cell.tagModels = [self tag_names];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

#pragma mark - JGJMemberImpressTagCellDelegate 标签按钮按下改变状态

- (void)impressTagCell:(JGJMemberImpressTagCell *)cell tagView:(JGJMemberImpressTagView *)tagView sender:(JGJCusButton *)sender {

    switch (tagView.tagViewType) {
        case JGJMemberImpressComselTagViewType:{

            self.tagView = tagView;
            
            NSArray *thirds = self.desInfos[3];
            
            JGJComTitleDesInfoModel *desInfoModel = thirds[0];

            if (!sender && self.fir_sel_tagModels.count > 0) {

                self.tagView.selTagModels = self.fir_sel_tagModels.mutableCopy;
                
            }

            desInfoModel.des = [self selTagModels:tagView.selTagModels];
        }

            break;

        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (NSString *)selTagModels:(NSArray *)tagModels {
    
    NSMutableString *selTags = [NSMutableString string];
    
    NSMutableArray *selRemarkTags = [NSMutableArray new];
    
    for (JGJMemberImpressTagViewModel *tagModel in tagModels) {
        
        if (tagModel.selected) {
            
//            [selTags appendFormat:@"%@ ", tagModel.tag_name];
            
            [selRemarkTags addObject:tagModel];
        }
        
    }
    
    if (selRemarkTags.count == Tag_list.count) {
        
        selTags = @"已选全部".mutableCopy;
        
    }
    
    return selTags;
}

- (NSMutableArray *)tag_names {
    
    NSMutableArray *sel_tagModels = nil;

    if (!_tag_names || _isReset) {
        
        NSArray *tag_list = Tag_list;
        
        _tag_names = [NSMutableArray array];
        
        JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
        
        JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
        
        //记账类型带入的初始类型
        NSString *accounts_types = staInitialModel.sel_account_types;
        
        self.fir_sel_tagModels = [NSMutableArray array];
        
        for (NSInteger index = 0; index < tag_list.count; index++) {
            
            JGJMemberImpressTagViewModel *tagModel = [JGJMemberImpressTagViewModel new];
            
            tagModel.tag_name = tag_list[index];
            
            tagModel.tagId = [NSString stringWithFormat:@"%@", @(index+1)];
            
            if ([accounts_types containsString:tagModel.tagId]) {
                
                tagModel.selected = YES;
                
                [self.fir_sel_tagModels addObject:tagModel];
            }
            
            [_tag_names addObject:tagModel];
        }
        
    }
    
    return _tag_names;
}

#pragma mark - buttonAction

#pragma mark - 底部按钮按下
- (void)buttonPressed {
    
    TYWeakSelf(self);
    
    self.buttonView.bottomButtonBlock = ^(JGJFilterBottomButtonType buttonType) {
        
        TYLog(@"buttonType ==== %@", @(buttonType));
        
        switch (buttonType) {
                
            case JGJFilterBottomResetButtonype:{
                
                [weakself resetButtonPressed];
            }
                
                break;
                
                
            case JGJFilterBottomConfirmButtonType:{
                
                [weakself confirmButtonPressed];
            }
                
                break;
                
            default:
                break;
        }
    };
    
}

#pragma mark - 重置
- (void)resetButtonPressed {
    
    _isReset = YES;
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
    
    //重置选择的记工类型清除和初始值一样
    staInitialModel.sel_account_types = staInitialModel.account_types;
    
//    设置初始时间
    NSString *format = @"yyyy-MM-dd";
    
    NSDate *date = [NSDate date];
    
    NSString *start_time = [NSDate convertSolaDateWithDate:[NSString stringWithFormat:@"%@-%@-%@", @(date.components.year), @"01", @"01"]];
    
    NSDate *start_Date = [NSDate dateFromString:start_time withDateFormat:format];
    
    start_time = [NSDate stringFromDate:start_Date format:format];
    
    NSString *end_time = [NSString stringWithFormat:@"%@-%@-%@", @(date.components.year), @(date.components.month), @(date.components.day)];
    
    NSDate *end_date = [NSDate dateFromString:end_time withDateFormat:format];
    
    end_time = [NSDate stringFromDate:end_date format:format];
    
    //判断时间问题
    NSInteger stYear = start_Date.components.year;
    
    NSInteger stMonth = start_Date.components.month;
    
    NSInteger stDay = start_Date.components.day;
    
    
    NSInteger enYear = end_date.components.year;
    
    NSInteger enMonth = end_date.components.month;
    
    NSInteger enDay = end_date.components.day;
    
    BOOL is_cover = (stYear > enYear) || (stYear <= enYear && stMonth > enMonth) || (stYear <= enYear && stMonth <= enMonth && stDay > enDay);
    
    if (stYear > enYear) {
        
        is_cover = YES;
        
    }else if (stYear == enYear && stMonth > enMonth) {
        
        is_cover = YES;
        
    }else if (stYear == enYear && stMonth == enMonth && stDay > enDay) {
        
        is_cover = YES;
        
    }else {
        
        is_cover = NO;
        
    }
    
    if (is_cover) {
        
        NSInteger minYear = enYear-1;
        
        start_time = [NSDate convertSolaDateWithDate:[NSString stringWithFormat:@"%@-%@-%@", @(minYear), @"01", @"01"]];
        
        if (![NSString isEmpty:start_time]) {
            
            start_Date = [NSDate dateFromString:start_time withDateFormat:format];
            
            start_time = [NSDate stringFromDate:start_Date format:format];
        }
        
    }
    
    staInitialModel.stTime = start_time;
    
    staInitialModel.endTime = end_time;
    
    staInitialModel.sel_stTime = start_time;
    
    staInitialModel.sel_endTime = end_time;
    
    //重置标签
    [self.tagView resetTagView];
    
    NSArray *staMainVc = staInitialModel.subVcs[0];
    
    [staInitialModel.subVcs removeAllObjects];
    
    [staInitialModel.subVcs addObject:staMainVc];
    
    [self.tableView reloadData];
    
}

#pragma mark - 确定
- (void)confirmButtonPressed {
    
    _isReset = NO;
    
    if (self.filterBlock) {
        
        self.filterBlock(self.desInfos, self.tagView);
    }
    
    [self.sideView removeAllView];
}

- (NSMutableArray *)desInfos {
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
    
    NSString *role = JLGisLeaderBool ? @"选择工人" : @"选班组长";
    
    NSString *lineDes = @"(可多选)";
    
    NSString *recordType = [NSString stringWithFormat:@"记工分类\n%@", lineDes];
    
    NSArray *titles = @[@[@"开始时间", @"截止时间"],@[@"选择项目"], @[role],@[recordType, @""]];
    
    NSString *st_time = [NSString stringWithFormat:@"%@",!_isReset ? staInitialModel.sel_stTime:staInitialModel.stTime];
    
    //防止异常
    if (!_isReset) {
        
        if (![NSString isEmpty:staInitialModel.stTime] && [NSString isEmpty:staInitialModel.sel_stTime]) {
            
            staInitialModel.sel_stTime = staInitialModel.stTime;
            
            st_time = staInitialModel.stTime;
        }
    }
    
    NSString *en_time = [NSString stringWithFormat:@"%@",!_isReset ?staInitialModel.sel_endTime:staInitialModel.endTime];
    
    //防止异常
    if (!_isReset) {

        if (![NSString isEmpty:staInitialModel.endTime] && [NSString isEmpty:staInitialModel.sel_endTime]) {

            staInitialModel.sel_endTime = staInitialModel.endTime;

            en_time = staInitialModel.endTime;

        }
    }
    
    NSString *proname = AllProName;
    
    if (![NSString isEmpty:staInitialModel.sel_proName] && !_isReset) {
        
        proname = staInitialModel.sel_proName;
    }
    
    NSString *proid = @"0";
    
    if (![NSString isEmpty:staInitialModel.sel_proId] && !_isReset) {
        
        proid = staInitialModel.sel_proId;
    }
    
    NSString *name = MemberDes;
    
    if (![NSString isEmpty:staInitialModel.sel_memberName] && !_isReset) {
        
        name = staInitialModel.sel_memberName;
    }
    
    NSString *uid = @"";
    
    if (![NSString isEmpty:staInitialModel.sel_memberUid] && !_isReset) {
        
        uid = staInitialModel.sel_memberUid;
    }
    
    NSString *accounts_type = @"";
    
    if (![NSString isEmpty:staInitialModel.sel_account_types] && !_isReset) {
        
        accounts_type = staInitialModel.sel_account_types;
    }
    
    NSArray *des = @[@[st_time, en_time],@[proname], @[name],@[@"", @""]];
    
    NSArray *tyIds = @[@[st_time, en_time],@[proid], @[uid],@[@"", accounts_type]];

    //重置重新添加数据
    if (!_desInfos || _isReset) {
        
        //3.4.1默认是否锁定项目、用户名字
        JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
        
        JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
        
        _desInfos = [NSMutableArray array];
        
        for (NSInteger index = 0; index < titles.count; index++) {
            
            NSArray *subTitles = titles[index];
            
            NSArray *subDes = des[index];
            
            NSArray *subTyIds = tyIds[index];
            
            NSMutableArray *subArr = [NSMutableArray array];
            
            for (NSInteger subIndex = 0; subIndex < subTitles.count; subIndex++) {
                
                JGJComTitleDesInfoModel *desInfoModel = [[JGJComTitleDesInfoModel alloc] init];
                
                desInfoModel.title = subTitles[subIndex];
                
                desInfoModel.des = subDes[subIndex];
                
                desInfoModel.typeId = subTyIds[subIndex];
                
                desInfoModel = [self setDesInfo:desInfoModel index:index];
                
                desInfoModel.lineDes = index == 3 ? lineDes : @"";
                
                desInfoModel.desColor = AppFontEB4E4EColor;
                
                if (index == 3) {
                    
                    desInfoModel.desTrail = 10;
                }
                
                //锁定项目
                if (staInitialModel.is_lock_proname && index == 1) {
                    
                    desInfoModel.isHiddenArrow = YES;
                }
                
                //锁定名字
                
                if (staInitialModel.is_lock_name && index == 2) {
                    
                    desInfoModel.isHiddenArrow = YES;
                }
                
                [subArr addObject:desInfoModel];
            }
            
            [_desInfos addObject:subArr];
        }
        
    }
    
    return _desInfos;
}

- (JGJComTitleDesInfoModel *)setDesInfo:(JGJComTitleDesInfoModel *)desInfoModel index:(NSInteger)index {
    
    desInfoModel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    desInfoModel.desColor = AppFontEB4E4EColor;
    
    if (index == 3) {

        CGFloat top = index == 3 ? 12 : 22;

        desInfoModel.textInsets = UIEdgeInsetsMake(top, 0, 0, 0);

        desInfoModel.isHiddenBottomLine = YES;

        desInfoModel.isHiddenArrow = YES;
    }

    return desInfoModel;
}

- (CGFloat)tagViewHeightWithTagNames:(NSArray *)tagModels {
    
    JGJMemberImpressTagView *tagView = [[JGJMemberImpressTagView alloc] init];
    
    tagView = [tagView tagViewWithTags:tagModels tagViewType:JGJMemberImpressComselTagViewType];
    
    return tagView.height;
}

#pragma mark - getter
- (JGJRefreshTableView *)tableView {

    if (!_tableView) {

        CGRect rect = CGRectMake(0, self.cusNavBar.height, self.width, self.height - self.buttonView.height - self.cusNavBar.height);

        _tableView = [[JGJRefreshTableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableView.dataSource = self;

        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    
    }
    
    return _tableView;
}

- (JGJCusNavBar *)cusNavBar {
    
    if (!_cusNavBar) {
        
        _cusNavBar = [[JGJCusNavBar alloc] initWithFrame:CGRectMake(0, 0, JGJSideWidth, JGJ_NAV_HEIGHT)];
        
        _cusNavBar.title.text = @"搜索条件";
        
        TYWeakSelf(self);
        
        //返回按钮按下
        _cusNavBar.backBlock = ^{
            
            
        };
        
    }
    
    return _cusNavBar;
}

- (void)selStartTime{
    
    TYWeakSelf(self);
    
    NSArray *times = weakself.desInfos[0];
    
    JGJComTitleDesInfoModel *enInfoModel = times[1];
    
    JGJComTitleDesInfoModel *stInfoModel = times[0];
    
    ATDatePicker *startDatePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate  ATDatePickerType:ATDatePickerResetBtnType DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
    
        stInfoModel.des = dateString;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [weakself setDecCellWithIndexPath:indexPath desInfoModel:nil];
        
        TYLog(@"======== %@", dateString);
        
    }];
    
    startDatePicker.cusBtnFinishBlock = ^(NSString *dateString) {
        

    };
    
    if (![stInfoModel.des isEqualToString:EndTime]) {
        
        startDatePicker.maximumDate = [NSDate dateFromString:enInfoModel.des withDateFormat:@"yyyy-MM-dd"];
    }
    
    if (![stInfoModel.des isEqualToString:StartTime]) {
        
        startDatePicker.date = [NSDate dateFromString:stInfoModel.des withDateFormat:@"yyyy-MM-dd"];
    }

    
    [startDatePicker show];
    
}


- (void)selEndTime {
    
    TYWeakSelf(self);
    
    NSArray *times = weakself.desInfos[0];
    
    JGJComTitleDesInfoModel *enInfoModel = times[1];
    
    JGJComTitleDesInfoModel *stInfoModel = times[0];
    
    ATDatePicker *endDatePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate  ATDatePickerType:ATDatePickerResetBtnType DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
        
        enInfoModel.des = dateString;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        
        [weakself setDecCellWithIndexPath:indexPath desInfoModel:nil];
    }];
    
    if (![stInfoModel.des isEqualToString:StartTime]) {
        
        endDatePicker.minimumDate = [NSDate dateFromString:stInfoModel.des withDateFormat:@"yyyy-MM-dd"];
    }
    
    if (![enInfoModel.des isEqualToString:EndTime]) {
        
        endDatePicker.date = [NSDate dateFromString:enInfoModel.des withDateFormat:@"yyyy-MM-dd"];
    }
    
    [endDatePicker show];
    
}

- (void)setDecCellWithIndexPath:(NSIndexPath *)indexpath desInfoModel:(JGJComTitleDesInfoModel *)desInfoModel{
    
    JGJComTitleDesCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    
    NSArray *infos = self.desInfos[indexpath.section];
    
    JGJComTitleDesInfoModel *infoModel = infos[indexpath.row];
    
    if (desInfoModel) {
        
        infoModel.des = desInfoModel.des;
        
        infoModel.typeId = desInfoModel.typeId;
    }
    
    cell.infoModel = infoModel;
    
}

- (JGJFilterBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        CGFloat height = (TYIST_IPHONE_X ? JGJ_IphoneX_BarHeight : 0) + 60;
        
        _buttonView = [[JGJFilterBottomButtonView alloc] initWithFrame:CGRectMake(0, self.height - height, self.width, height)];
    }
    
    return _buttonView;
}

@end
