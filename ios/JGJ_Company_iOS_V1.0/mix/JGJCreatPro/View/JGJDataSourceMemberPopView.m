//
//  JGJDataSourceMemberPopVIew.m
//  JGJCompany
//
//  Created by YJ on 16/11/9.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJDataSourceMemberPopView.h"
#import "JGJSourceSynedProCell.h"
#import "TYPhone.h"
@interface JGJDataSourceMemberPopView ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIView *containDetailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *selectedProlist;
@property (strong, nonatomic) JGJSynBillingModel *teamMemberModel;
@property (weak, nonatomic) IBOutlet UIButton *telephoneButton;
@property (strong, nonatomic) JGJSourceSynProFirstModel *prolistModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewH;
@property (weak, nonatomic) IBOutlet UIView *containCalView;
@property (strong, nonatomic) NSArray *syncPros;//同步的项目
@property (weak, nonatomic) IBOutlet UIButton *demandSynButton;
@end

@implementation JGJDataSourceMemberPopView
#pragma mark - 常用设置

- (instancetype)initWithFrame:(CGRect)frame teamMemberModel:(JGJSynBillingModel *)teamMemberModel {
    
    if (self = [super initWithFrame:frame]) {
        [self commonSet];
        self.teamMemberModel = teamMemberModel;
        [self loadProList];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    [[[NSBundle mainBundle] loadNibNamed:@"JGJDataSourceMemberPopView" owner:self options:nil] lastObject];
    self.containView.frame = self.bounds;
    self.containView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.containDetailView.layer setLayerCornerRadius:JGJCornerRadius];
    [self.tableView.layer setLayerCornerRadius:JGJCornerRadius];
    [self.containCalView.layer setLayerBorderWithColor:AppFont666666Color width:1.0 radius:TYGetViewH(self.containCalView) / 2.0];
    [self.telephoneButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.frame = window.bounds;
    [window addSubview:self];
    [self addSubview:self.containView];
    [self setTableHeaderView];
}

- (void)setTableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetViewW(self.tableView), 40)];
    headerView.backgroundColor = AppFontf5f5f5Color;
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = @"以下是他同步给你的项目:";
    titleLable.font = [UIFont systemFontOfSize:AppFont24Size];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.textColor = AppFont999999Color;
    [headerView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView).mas_offset(16);
        make.center.mas_equalTo(headerView);
        make.height.equalTo(@25);
        make.right.mas_equalTo(headerView).mas_offset(-24);
    }];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.prolistModel.list.count == 0 || self.prolistModel.list == nil) {
        return 0;
    }
    JGJSourceSynProSeclistModel *syncModel = self.prolistModel.list[section];
    return syncModel.sync_unsource.list.count;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJSourceSynedProCell *synedProCell = [JGJSourceSynedProCell cellWithTableView:tableView];
    JGJSourceSynProSeclistModel *syncSecProModel = self.prolistModel.list[indexPath.section];
    synedProCell.prolistModel = syncSecProModel.sync_unsource.list[indexPath.row];
    return synedProCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJSourceSynProSeclistModel *syncSecProModel = self.prolistModel.list[indexPath.section];
    JGJSyncProlistModel *prolistModel = syncSecProModel.sync_unsource.list[indexPath.row];
    prolistModel.isSelected = !prolistModel.isSelected;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -通知他同步更多
- (IBAction)handleNotifySynMoreProButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.teamMemberModel.is_demand = [NSString stringWithFormat:@"%@", @(sender.selected)];
}

#pragma mark - 删除此人
- (IBAction)handleRemoveMemberButtonPressedAction:(UIButton *)sender {
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(JGJDataSourceMemberPopViewRemoveMember:)]) {
        [self.delegate JGJDataSourceMemberPopViewRemoveMember:self.teamMemberModel];
    }
}

#pragma mark - 确认按钮按下
- (IBAction)handleConfirmButtonPressedAction:(UIButton *)sender {
    NSMutableString *mergeSourceProId = [NSMutableString string];
    for (JGJSourceSynProSeclistModel *proSeclistModel in self.prolistModel.list) {
        for (JGJSyncProlistModel *prolistModel in proSeclistModel.sync_unsource.list) {
            if (prolistModel.isSelected) {
                [mergeSourceProId appendFormat:@"%@,",prolistModel.pid];
            }
        }
    }
    //    删除末尾的分号
    if (mergeSourceProId.length > 0 && mergeSourceProId != nil) {
        [mergeSourceProId deleteCharactersInRange:NSMakeRange(mergeSourceProId.length - 1, 1)];
    }
    self.teamMemberModel.source_pro_id = mergeSourceProId; //改变当前选中的项目id
    if ([self.delegate respondsToSelector:@selector(JGJDataSourceMemberPopViewConfirmTeamMemberModel:)]) {
        [self.delegate JGJDataSourceMemberPopViewConfirmTeamMemberModel:self];
    }
    [self dismiss];
}

- (IBAction)handleCallButtonPressed:(UIButton *)sender {
    [TYPhone callPhoneByNum:self.teamMemberModel.telphone view:self];
}

- (IBAction)handleCancelButtonPressed:(UIButton *)sender {
    [self dismiss];
}
#pragma mark - 获取同步项目列表
- (void)loadProList {
    [TYLoadingHub showLoadingWithMessage:nil];
    NSDictionary *parameters = @{
                                 @"ctrl" : @"team",
                                 @"action": @"syncProFromSourceList",
                                 @"uid" : self.teamMemberModel.uid?:[NSNull null]
                                 };
    __weak typeof(self) weakSelf = self;
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        weakSelf.prolistModel = [JGJSourceSynProFirstModel mj_objectWithKeyValues:responseObject];
        [TYLoadingHub hideLoadingView];
    } failure:nil];
}

- (void)setProlistModel:(JGJSourceSynProFirstModel *)prolistModel {
    _prolistModel = prolistModel;
    NSArray *sourceProIDs = [self.teamMemberModel.source_pro_id componentsSeparatedByString:@","];
    if (sourceProIDs.count > 0) {
        [sourceProIDs enumerateObjectsUsingBlock:^(NSString   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid contains %@", obj];
            JGJSourceSynProSeclistModel *synProSeclistModel = [JGJSourceSynProSeclistModel new];
            if (self.prolistModel.list.count > 0) {
                synProSeclistModel = self.prolistModel.list[0];
            }
            JGJSyncProlistModel *prolistModel = [synProSeclistModel.sync_unsource.list filteredArrayUsingPredicate:predicate].lastObject;
            if ([prolistModel.pid isEqualToString:obj]) {
                prolistModel.isSelected = YES;
            }
        }];
    }
    
    //之前不是大于0刷新闪退，
    [self.tableView reloadData];
}

- (void)setTeamMemberModel:(JGJSynBillingModel *)teamMemberModel {
    _teamMemberModel = teamMemberModel;
    self.nameLable.text = teamMemberModel.real_name;
    [self.telephoneButton setTitle:teamMemberModel.telph forState:UIControlStateNormal];
    self.demandSynButton.selected = [_teamMemberModel.is_demand boolValue];
}

- (NSMutableArray *)selectedProlist {
    if (!_selectedProlist) {
        _selectedProlist = [NSMutableArray array];
    }
    return _selectedProlist;
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.transform = CGAffineTransformScale(self.transform,0.9,0.9);
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


@end
