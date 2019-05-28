//
//  JGJTeamDetailSourcePopView.m
//  JGJCompany
//
//  Created by yj on 16/11/11.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTeamDetailSourcePopView.h"
#import "JGJTeamDetailSourceProCell.h"
#import "TYPhone.h"
@interface JGJTeamDetailSourcePopView ()
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
@end

@implementation JGJTeamDetailSourcePopView

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
    [self.containCalView.layer setLayerBorderWithColor:AppFont666666Color width:1 radius:TYGetViewH(self.containCalView) / 2.0];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.frame = window.bounds;
    [window addSubview:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.containView];
    [self setTableHeaderView];
}

- (void)setTableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetViewW(self.tableView), 40)];
    headerView.backgroundColor = TYColorHex(0xf5f5f5);
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = @"他同步给你以下项目:";
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
    JGJSourceSynProSeclistModel *synProSeclistModel = self.prolistModel.list[section];
    return synProSeclistModel.sync_unsource.list.count;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJTeamDetailSourceProCell *synedProCell = [JGJTeamDetailSourceProCell cellWithTableView:tableView];
    JGJSourceSynProSeclistModel *synProSeclistModel = self.prolistModel.list[indexPath.section];
    JGJSyncProlistModel *prolistModel = synProSeclistModel.sync_unsource.list[indexPath.row];
    synedProCell.prolistModel = prolistModel;
    return synedProCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJSourceSynProSeclistModel *synProSeclistModel = self.prolistModel.list[indexPath.section];
    JGJSyncProlistModel *prolistModel = synProSeclistModel.sync_unsource.list[indexPath.row];
    prolistModel.isSelected = !prolistModel.isSelected;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -通知他同步更多
- (IBAction)handleNotifySynMoreProButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.teamMemberModel.is_demand = [NSString stringWithFormat:@"%@", @(sender.selected)];
}

#pragma mark - 确认按钮按下
- (IBAction)handleConfirmButtonPressedAction:(UIButton *)sender {
    JGJCreatDiscussTeamRequest *teamRequest = [[JGJCreatDiscussTeamRequest alloc] init];
    NSMutableString *mergeSourceProId = [NSMutableString string];
    for (JGJSyncProlistModel *prolistModel in self.prolistModel.list) {
        if (prolistModel.isSelected) {
            [mergeSourceProId appendFormat:@"%@,",prolistModel.pid];
        }
    }
    //    删除末尾的分号
    if (mergeSourceProId.length > 0 && mergeSourceProId != nil) {
        [mergeSourceProId deleteCharactersInRange:NSMakeRange(mergeSourceProId.length - 1, 1)];
    }
    teamRequest.source_pro_id = mergeSourceProId;
//    self.teamRequest = teamRequest;
//    if ([self.delegate respondsToSelector:@selector(JGJDataSourceMemberPopViewConfirmTeamMemberModel:)]) {
//        [self.delegate JGJDataSourceMemberPopViewConfirmTeamMemberModel:self];
//    }
    [self dismiss];
}

- (IBAction)handleCallButtonPressed:(UIButton *)sender {
    [TYPhone callPhoneByNum:self.teamMemberModel.telphone view:self];
}

- (IBAction)handleCancelButtonPressed:(UIButton *)sender {
    [self dismiss];
}

- (IBAction)handleRelateProButtonPressed:(UIButton *)sender {
    
    
}

#pragma mark - 获取同步项目列表
- (void)loadProList {
    
    [TYLoadingHub showLoadingWithMessage:nil];
    NSDictionary *parameters = @{
                                 
                                 @"uid" : self.teamMemberModel.uid?:[NSNull null]
                                 };
    __weak typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGroupSyncproFromSourceListURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

- (void)setProlistModel:(JGJSourceSynProFirstModel *)prolistModel {
    _prolistModel = prolistModel;
    NSArray *sourceProIDs = [self.teamMemberModel.source_pro_id componentsSeparatedByString:@","];
    if (sourceProIDs.count > 0) {
        [sourceProIDs enumerateObjectsUsingBlock:^(NSString   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid contains %@", obj];
            JGJSourceSynProSeclistModel *proSeclistModel = self.prolistModel.list[idx];
            JGJSyncProlistModel *prolistModel = [proSeclistModel.sync_unsource.list filteredArrayUsingPredicate:predicate].lastObject;
            prolistModel.isSelected = YES;
        }];
    }
    [self.tableView reloadData];
}


- (void)setTeamMemberModel:(JGJSynBillingModel *)teamMemberModel {
    _teamMemberModel = teamMemberModel;
    self.nameLable.text = teamMemberModel.real_name;
    [self.telephoneButton setTitle:teamMemberModel.telph forState:UIControlStateNormal];
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
