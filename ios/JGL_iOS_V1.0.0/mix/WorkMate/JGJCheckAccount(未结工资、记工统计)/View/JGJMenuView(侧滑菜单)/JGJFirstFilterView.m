//
//  JGJFirstFilterView.m
//  mix
//
//  Created by yj on 2018/5/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJFirstFilterView.h"

#import "JGJRefreshTableView.h"

#import "JGJFilterBottomButtonView.h"

#import "JGJMemberImpressTagCell.h"

#import "JGJCusNavBar.h"

#import "JGJRecordStaSearchTool.h"

#import "JGJFilterTabHeaderView.h"

#import "NSDate+Extend.h"

#define Tag_list @[@"点工",@"包工记账",@"借支",@"结算",@"包工记工天"]

#define MemberDes (JLGisLeaderBool ? @"全部工人" : @"全部班组长")

#define AllProName @"全部项目"

@interface JGJFirstFilterView () <UITableViewDelegate, UITableViewDataSource, JGJMemberImpressTagCellDelegate>

@property (nonatomic, strong) JGJRefreshTableView *tableView;

@property (nonatomic, strong) JGJFilterBottomButtonView *buttonView;

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) JGJMemberImpressTagView *tagView;

@property (nonatomic, strong) JGJMemberImpressTagView *remarkTagView;

@property (nonatomic, strong) JGJMemberImpressTagView *agencyTagView;

//拷贝一份重置信息
@property (nonatomic, strong) NSMutableArray *backupsDesInfos;

@property (nonatomic, strong) JGJCusNavBar *cusNavBar;

//首次选中的模型
@property (nonatomic, strong) NSMutableArray *fir_sel_tagModels;

//选择时间模型
@property (nonatomic, strong) JGJComTitleDesInfoModel *selTimeInfoModel;

//头部时间选择

@property (nonatomic, strong) JGJFilterTabHeaderView *header;

@end

@implementation JGJFirstFilterView

@synthesize proListModel = _proListModel;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (void)commonSet {
    
    [self addSubview:self.buttonView];
    
    [self addSubview:self.cusNavBar];
    
    [self addSubview:self.tableView];
    
    [self buttonPressed];
    
    //头部是时间
    JGJFilterTabHeaderView *header = [[JGJFilterTabHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];
    
    self.header = header;
    
    header.timeInfoModel = self.selTimeInfoModel;
    
    self.tableView.tableHeaderView = header;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 50;
    
    CGFloat firRowHeight = 37;
    
    switch (indexPath.section) {
        case 0:
        case 1:
            
            height = 50;
            
            break;
            
        case 2:{
            
            if (indexPath.row == 0) {
                
                height = 50;
                
            }else {
                
                height = [self tagViewHeightWithTagNames:[self tag_names]];
            }

        }
            break;
            
        case 3:{
            
            if (indexPath.row == 0) {
                
                height = firRowHeight;
                
            }else {
                
                height = 70;
            }
            
        }
            break;
            
        case 4:{
            
            if (indexPath.row == 0) {
                
                height = firRowHeight;
                
            }else {
                
                height = 70;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger count = 1;
    
    if (section == 2 || section == 3 || section == 4) {
        
        count = 2;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
            
        case 0:
        
        case 1:{
            
            cell = [self registerComDesCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            
            break;
            
        case 2:{
            
            if (indexPath.row == 0) {
                
                cell = [self registerComDesCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                
            }else {
            
                cell = [self registerRecordTypeCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                
            }
            
        }
            
            break;
            
        case 3:{
            
            if (indexPath.row == 0) {
                
                cell = [self registerComDesCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                
            }else {
                
                cell = [self registerRemarkCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                
            }
    }
            
            break;
            
        case 4:{
            
            if (indexPath.row == 0) {
                
                cell = [self registerComDesCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                
            }else {
                
                cell = [self registerAgencyCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                
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
    
    CGFloat height = section == 0 ? 10 :CGFLOAT_MIN;
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = nil;
    
    if (section == 0) {
        
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    }
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //记工变更进入记工流水不能点击一个项目
    if (indexPath.section == 0 && indexPath.row == 0 && self.staModel.is_change_date) {
        
        return;
    }
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        
        JGJSynBillingModel *memberModel = nil;
        
        JGJRecordWorkPointFilterModel *proMode = nil;
        
        if (indexPath.section == 0) {
            
            JGJComTitleDesInfoModel *desInfoModel = self.desInfos[0];
            
            memberModel.name = desInfoModel.des;
            
            memberModel.uid = desInfoModel.typeId;
        }
        
        if (indexPath.section == 1) {
            
            JGJComTitleDesInfoModel *desInfoModel = self.desInfos[1];
            
            proMode.proname = desInfoModel.des;
            
            proMode.uid = desInfoModel.typeId;
        }
        
        
        JGJFirstFilterViewType type = indexPath.section == 0 ? JGJFirstFilterProType : JGJFirstFilterMemberType;
        
        if ([self.delegate respondsToSelector:@selector(filterView:filterViewType:memberModel:proModel:)]) {
            
            [self.delegate filterView:self filterViewType:type memberModel:memberModel proModel:proMode];
            
        }
    }
    
}

#pragma mark - 选择项目、选择班组长、记工分类、有无备注
- (UITableViewCell *)registerComDesCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJComTitleDesCell *cell = [JGJComTitleDesCell cellWithTableView:tableView];
    
    JGJComTitleDesInfoModel *infoModel = self.desInfos[indexPath.section];
    
    cell.infoModel = infoModel;
    
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

#pragma mark - 选择备注
- (UITableViewCell *)registerRemarkCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberImpressTagCell *cell = [JGJMemberImpressTagCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    cell.topView.hidden = YES;
    
    cell.tagViewType = JGJMemberImpressRemarkselTagViewType;
    
    cell.tagModels = [self remark_tag_names];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

#pragma mark - 选择备注
- (UITableViewCell *)registerAgencyCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberImpressTagCell *cell = [JGJMemberImpressTagCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    cell.topView.hidden = YES;
    
    cell.tagViewType = JGJMemberImpressAgencyselTagViewType;
    
    cell.tagModels = [self agency_tag_names];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

#pragma mark - JGJMemberImpressTagCellDelegate 标签按钮按下改变状态

- (void)impressTagCell:(JGJMemberImpressTagCell *)cell tagView:(JGJMemberImpressTagView *)tagView sender:(JGJCusButton *)sender {
    
    switch (tagView.tagViewType) {
        case JGJMemberImpressComselTagViewType:{
            
            self.tagView = tagView;
            
            if (!sender && self.selrecordTtags.count > 0) {
                
                JGJComTitleDesInfoModel *desInfoModel = self.desInfos[2];
                
                self.tagView.selTagModels = self.selrecordTtags.mutableCopy;
                
                desInfoModel.des = [self selTagModels:tagView.selTagModels];
            }
            
            if (self.desInfos.count > 3) {
                
                JGJComTitleDesInfoModel *desInfoModel = self.desInfos[2];
                
                //按钮有值标识当前选择了
                if (sender) {
                    
                    desInfoModel.des = [self selTagModels:tagView.selTagModels];
                }
                
            }
            
        }
            
            break;
            
        case JGJMemberImpressRemarkselTagViewType:{
            
            self.remarkTagView = tagView;
            
            if (!sender && self.selnotetags.count > 0) {
                
                self.remarkTagView.selTagModels = self.selnotetags.mutableCopy;
            }
            
            if (self.desInfos.count > 3) {
                
                JGJComTitleDesInfoModel *desInfoModel = self.desInfos[3];
                
                //按钮有值标识当前选择了
                if (sender) {
                    
                    desInfoModel.des = [self selTagModels:tagView.selTagModels];
                }
            }
        }
            
            break;
            
        case JGJMemberImpressAgencyselTagViewType:{
            
            self.agencyTagView = tagView;
            
            if (!sender && self.agencytags.count > 0) {

                self.agencyTagView.selTagModels = self.selAgentags.mutableCopy;
            }
            
            if (self.desInfos.count > 3) {
                
                JGJComTitleDesInfoModel *desInfoModel = self.desInfos[4];
                
                //按钮有值标识当前选择了
                if (sender) {
                    
                    desInfoModel.des = [self selTagModels:tagView.selTagModels];
                    
                }
            }
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

#pragma mark - ButtonAction

#pragma mark - 底部按钮按下
- (void)buttonPressed {
    
    TYWeakSelf(self);
    
    self.buttonView.bottomButtonBlock = ^(JGJFilterBottomButtonType buttonType) {
        
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

- (void)resetButtonPressed {
    
    //复位顶部选择项目、选择成员
    _desInfos = self.backupsDesInfos.mutableCopy;
    
    //颜色和结局初始化。这里没有copy
    for (NSInteger index = 0; index < _desInfos.count; index++) {
        
        [self setDesInfo:_desInfos[index] index:index];
    }
    
    //复位标签

    [self.tagView.selTagModels removeAllObjects];

    [self.remarkTagView.selTagModels removeAllObjects];
    
    [self.agencyTagView.selTagModels removeAllObjects];
    
    
    //复位数据状态消除闪烁
    [self.remarkTagView resetTagView];
    
    [self.tagView resetTagView];
    
    [self.agencyTagView resetTagView];
    
//    //清除保存的数据
//    
//    [self.proInfos removeAllObjects];
    
    if (self.desInfos.count > 3) {
        
        JGJComTitleDesInfoModel *proInfoModel = self.desInfos[0];
        
        JGJComTitleDesInfoModel *memberInfoModel = self.desInfos[1];
        
        JGJComTitleDesInfoModel *recordInfoModel = self.desInfos[2];
        
        JGJComTitleDesInfoModel *remarkInfoModel = self.desInfos[3];
        
        //项目是全部项目
        
        proInfoModel.des = AllProName;
        
        proInfoModel.typeId = @"0";
        
        memberInfoModel.des = MemberDes;
        
        memberInfoModel.typeId = @"";
        
        //记工变更进入重置为当前的姓名
        if (self.staModel.is_change_date) {
            
            proInfoModel.des = self.staModel.proName;
            
            memberInfoModel.des = @"全部工人";
        }
        
        self.selMemberModel.name = MemberDes;
        
        if (![NSString isEmpty:self.proListModel.group_id]) {
            
           self.selMemberModel.name = AgencyDes;
        }
        
        self.selMemberModel.class_type_id = nil;
        
        self.selProModel.proname = AllProName;
        
        self.selProModel.class_type_id = @"0";
        
        //记工分类清除
        recordInfoModel.des = @"";
        
        //备注清除
        remarkInfoModel.des = @"";
        
    }
    
    if (self.desInfos.count > 4) {
        
        JGJComTitleDesInfoModel *agencyInfoModel = self.desInfos[4];
        
        agencyInfoModel.des = @"";
    }
    
    //初始化时间3.4.2添加
    
    if (!self.staModel.is_change_date) {
        
        self.staModel.date = [self initialDate];
        
        self.header.staModel = self.staModel;
    }
    
    [self.tableView reloadData];
    
    //主要返回顶部之前保存项目和人员信息
    
    if (self.filterViewBlock) {
        
        self.filterViewBlock(nil, nil, self.tagView.tags, self.remarkTagView.tags, nil, YES, self.tagView.selTagModels, self.remarkTagView.selTagModels, self.agencyTagView.tags, self.agencyTagView.selTagModels);
    }
    
}

- (void)confirmButtonPressed {
    
    if (!self.staModel.is_change_date) {
        
        self.staModel.date = self.header.selDate;
        
    }
    
    if (self.filterViewBlock) {
        
        self.filterViewBlock(self.selMemberModel, self.selProModel, self.tagView.tags, self.remarkTagView.tags, self.desInfos, NO, self.tagView.selTagModels, self.remarkTagView.selTagModels, self.agencyTagView.tags, self.agencyTagView.selTagModels);
    }
    
}

#pragma mark - 确定筛选
- (void)confirmFilter {
    
    [self confirmButtonPressed];
}

#pragma mark -setter

- (void)setSelProModel:(JGJRecordWorkPointFilterModel *)selProModel {
    
    _selProModel = selProModel;
    
    JGJComTitleDesInfoModel *proInfoModel = self.desInfos[0];
    
    proInfoModel.des = selProModel.name;
    
    proInfoModel.typeId = selProModel.class_type_id;
    
    [self.tableView reloadData];
    
    if (!self.backupsDesInfos) {
        
        _backupsDesInfos = [NSMutableArray array];
        
        for (JGJComTitleDesInfoModel *proInfoModel in self.desInfos) {
            
            [_backupsDesInfos addObject:proInfoModel.mutableCopy];
        }
        
    }
    
}

- (void)setSelMemberModel:(JGJSynBillingModel *)selMemberModel {
    
    _selMemberModel = selMemberModel;
    
    JGJComTitleDesInfoModel *memberInfoModel = self.desInfos[1];
    
    memberInfoModel.des = _selMemberModel.name;
    
    memberInfoModel.typeId = _selMemberModel.class_type_id;
    
    [self.tableView reloadData];

}

- (void)setStaModel:(JGJRecordWorkStaListModel *)staModel {
    
    _staModel = staModel;
    
    self.header.staModel = _staModel;
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

- (JGJFilterBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        CGFloat height = (TYIST_IPHONE_X ? JGJ_IphoneX_BarHeight : 0) + 60;
        
        _buttonView = [[JGJFilterBottomButtonView alloc] initWithFrame:CGRectMake(0, self.height - height, self.width, height)];
    }
    
    return _buttonView;
}

- (CGFloat)tagViewHeightWithTagNames:(NSArray *)tagModels {
    
    JGJMemberImpressTagView *tagView = [[JGJMemberImpressTagView alloc] init];
    
    tagView = [tagView tagViewWithTags:tagModels tagViewType:JGJMemberImpressComselTagViewType];
    
    return tagView.height;
}

- (NSMutableArray *)desInfos {
    
    if (self.proInfos.count > 3) {
        
        return self.proInfos;
    }
    
    NSString *role = JLGisLeaderBool ? @"选择工人" : @"选班组长";
    
    if (![NSString isEmpty:self.proModel.group_id]) {
        
        role = @"选择工人";
    }
    
    NSString *lineDes = @"(可多选)";
    NSString *recordType = [NSString stringWithFormat:@"记工分类\n%@", lineDes];
    NSArray *titles = @[@"选择项目", role, recordType, @"其他", @"有代班长"];
    
    if (!_desInfos) {
        
        _desInfos = [NSMutableArray array];
        
        for (NSInteger index = 0; index < titles.count; index++) {
            
            JGJComTitleDesInfoModel *desInfoModel = [[JGJComTitleDesInfoModel alloc] init];
            
            desInfoModel.title = titles[index];
            
            desInfoModel = [self setDesInfo:desInfoModel index:index];
            
            desInfoModel.lineDes = index == 2 ? lineDes : @"";
            
            //初始化最开始的值
            if (self.staModel && index == 1) {
                
                desInfoModel.des = self.selMemberModel.name;
                
                desInfoModel.typeId = self.selMemberModel.class_type_id;
            }
            
            if (self.staModel && index == 0) {
                
                desInfoModel.des = self.selProModel.proname;
                
                desInfoModel.des = self.selProModel.name;
                
                desInfoModel.typeId = self.selProModel.class_type_id;
            }
            
            desInfoModel.desColor = AppFontEB4E4EColor;
            
            if (index == 2 || index == 3 || index == 4) {
                
                desInfoModel.desTrail = 10;
            }
        
            [_desInfos addObject:desInfoModel];
        }
        
    }
    
    return _desInfos;
}

- (JGJComTitleDesInfoModel *)setDesInfo:(JGJComTitleDesInfoModel *)desInfoModel index:(NSInteger)index {
    
    desInfoModel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    desInfoModel.desColor = AppFontEB4E4EColor;
    
    if (index == 2 || index == 3 || index == 4) {
        
        CGFloat top = index == 2 ? 12 : 22;
        
        desInfoModel.textInsets = UIEdgeInsetsMake(top, 0, 0, 0);
        
        desInfoModel.isHiddenBottomLine = YES;
        
        desInfoModel.isHiddenArrow = YES;
    }
    
    //记工变更到记工流水不能点击隐藏箭头
    if (index == 0 && self.staModel.is_change_date) {
        
        desInfoModel.isHiddenArrow = YES;
    }
    
    return desInfoModel;
}

- (NSMutableArray *)tag_names {
    
    if (self.recordTags.count > 0) {
        
        return self.recordTags;
    }
    
    NSArray *tag_list = Tag_list;
    
    NSMutableArray *tagModels = [NSMutableArray array];
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
    
    //记账类型带入的初始类型
    NSString *accounts_types = staInitialModel.sel_account_types;
    
    for (NSInteger index = 0; index < tag_list.count; index++) {
        
        JGJMemberImpressTagViewModel *tagModel = [JGJMemberImpressTagViewModel new];
        
        tagModel.tag_name = tag_list[index];
        
        tagModel.tagId = [NSString stringWithFormat:@"%@", @(index+1)];
        
        if ([accounts_types containsString:tagModel.tagId]) {

            tagModel.selected = YES;

        }
        
        [tagModels addObject:tagModel];
        
    }
    
    return tagModels;
}

- (NSMutableArray *)remark_tag_names {
    
    if (self.notetags.count > 0) {
        
        return self.notetags;
    }
    
    NSArray *tag_list = @[@"有备注", @"有代班长"];
    
    NSMutableArray *tagModels = [NSMutableArray array];
    
    for (NSInteger index = 0; index < tag_list.count; index++) {
        
        JGJMemberImpressTagViewModel *tagModel = [JGJMemberImpressTagViewModel new];
        
        tagModel.tag_name = tag_list[index];
        
        tagModel.tagId = [NSString stringWithFormat:@"%@", @(index+1)];
        
        [tagModels addObject:tagModel];
    }
    
    return tagModels;
}

- (NSMutableArray *)agency_tag_names {
    
    if (self.agencytags.count > 0) {

        return self.agencytags;
    }
    
    NSArray *tag_list = @[@"有代班长"];
    
    NSMutableArray *tagModels = [NSMutableArray array];
    
    for (NSInteger index = 0; index < tag_list.count; index++) {
        
        JGJMemberImpressTagViewModel *tagModel = [JGJMemberImpressTagViewModel new];
        
        tagModel.tag_name = tag_list[index];
        
        tagModel.tagId = [NSString stringWithFormat:@"%@", @(index+1)];
        
        [tagModels addObject:tagModel];
    }
    
    return tagModels;
}

- (JGJCusNavBar *)cusNavBar {
    
    if (!_cusNavBar) {
        
        _cusNavBar = [[JGJCusNavBar alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth - 40, JGJ_NAV_HEIGHT)];
        
        _cusNavBar.title.text = @"搜索条件";
        
        TYWeakSelf(self);
        
        //返回按钮按下
        _cusNavBar.backBlock = ^{
        
            [weakself confirmButtonPressed];
        };
        
    }
    
    return _cusNavBar;
}

- (JGJComTitleDesInfoModel *)selTimeInfoModel {
    
    if (!_selTimeInfoModel) {
        
        _selTimeInfoModel = [[JGJComTitleDesInfoModel alloc] init];
        
        _selTimeInfoModel.title = @"选择月份";
    
        _selTimeInfoModel.des = [self initialDate];
        
    }
    
    return _selTimeInfoModel;
}

- (NSString *)initialDate {
    
    NSDate *seldate = [NSDate date];
    
    NSString *month = [NSString stringWithFormat:@"%@",  @(seldate.components.month)];
    
    if (seldate.components.month < 10) {
        
        month = [NSString stringWithFormat:@"%.1ld",  seldate.components.month];
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%@年%@月", @(seldate.components.year), month];
    
    return dateStr;
}

@end
