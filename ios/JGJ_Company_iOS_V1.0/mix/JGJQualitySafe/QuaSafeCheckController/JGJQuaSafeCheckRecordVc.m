//
//  JGJQuaSafeCheckRecordVc.m
//  JGJCompany
//
//  Created by yj on 2017/7/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckRecordVc.h"

#import "JGJQuaSafeCheckRecordCell.h"

#import "JGJQuaSafeCheckUnDealRecordCell.h"

#import "JGJQuaSafeCheckResultVc.h"

#import "JGJQuaCheckRecordHeaderView.h"

#import "JGJQualityRecordVc.h"

#import "NSString+Extend.h"

#import "JGJQualityDetailVc.h"

#import "HJPhotoBrowser.h"

#import "JGJCheckPhotoTool.h"

#import "JGJCustomPopView.h"

@interface JGJQuaSafeCheckRecordVc () <

    UITableViewDelegate,

    UITableViewDataSource,

    JGJQuaSafeCheckRecordCellDelegate,

    JGJQuaSafeCheckUnDealRecordCellDelegate,

    HJPhotoBrowserDelegate

>

@property (nonatomic, strong) JGJQuaSafeCheckRecordRequestModel *requestModel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJQuaSafeCheckRecordModel *recordModel;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@property (nonatomic, strong) JGJQuaCheckRecordHeaderView *headerView;

//记录处理了的分项记录
@property (nonatomic, strong) JGJQuaSafeCheckRecordListModel *expandRecordListModel;

@property (nonatomic, strong) NSArray *imageUrls;

@end

@implementation JGJQuaSafeCheckRecordVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"检查记录";
    
    [self initialSubView];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self loadNetData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.recordModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
     JGJQuaSafeCheckRecordListModel *listModel = self.recordModel.list[indexPath.row];
    
    JGJQuaSafeCheckRecordReplyModel *replyModel = nil;
    
    //处理的内容
    if (listModel.reply_list.count > 0) {
        
        replyModel = [listModel.reply_list firstObject];
    }
    
    if (![NSString isEmpty:replyModel.uid]) {
        
        JGJQuaSafeCheckRecordCell *recordCell = [JGJQuaSafeCheckRecordCell cellWithTableView:tableView];
        
        recordCell.delegate = self;
        
//        recordCell.listModel = listModel;
        
//        recordCell.lineView.hidden = self.recordModel.list.count - 1 == indexPath.row;
        
        cell = recordCell;
        
    }else {
    
        JGJQuaSafeCheckUnDealRecordCell *unDealRecordCell = [JGJQuaSafeCheckUnDealRecordCell cellWithTableView:tableView];
        
        unDealRecordCell.delegate = self;
        
//        unDealRecordCell.listModel = listModel;
        
//        unDealRecordCell.lineView.hidden = self.recordModel.list.count - 1 == indexPath.row;
        
        cell = unDealRecordCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJQuaSafeCheckRecordListModel *listModel = self.recordModel.list[indexPath.row];
    
    TYLog(@"heightForRow === %@", @(listModel.cellHeight));
    
    CGFloat height = listModel.isExPand ? listModel.cellHeight : listModel.shrinkHeight;
        
    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - JGJQuaSafeCheckRecordCellDelegate

- (void)quaSafeCheckRecordCell:(JGJQuaSafeCheckRecordCell *)cell selectedListModel:(JGJQuaSafeCheckRecordListModel *)listModel buttonType:(QuaSafeDealResultViewButtonType)buttonType{

    //记录点击的模型用于返回展开用
    self.expandRecordListModel = listModel;
    
    switch (buttonType) {
        case QuaSafeDealedResultViewcheckDetailButtonType:{
            
            JGJQualityDetailVc *detailVc = [[JGJQualityDetailVc alloc] init];
            
            JGJQualitySafeListModel *detailListModel = [JGJQualitySafeListModel new];
            
            JGJQuaSafeCheckRecordReplyModel *replyModel = nil;
            
            if (listModel.reply_list.count > 0) {
                
                replyModel = [listModel.reply_list firstObject];
            }
            
            detailVc.proListModel = self.proListModel;
            
            detailListModel.msg_id = replyModel.quality_id;
            
            detailListModel.msg_type = self.commonModel.msg_type;
            
            detailVc.listModel = detailListModel;
            
            [self.navigationController pushViewController:detailVc animated:YES];
        }
            
            break;
        case QuaSafeDealedResultViewModifyResultButtonType:{
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            desModel.popDetail = @"你确定要删除该检查结果吗？";
            desModel.leftTilte = @"取消";
            desModel.rightTilte = @"确定";
            desModel.lineSapcing = 5.0;
            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            alertView.messageLable.textAlignment = NSTextAlignmentCenter;
            __weak typeof(self) weakSelf = self;
            alertView.onOkBlock = ^{

                [weakSelf handelCheckRecordModel:listModel];
            };
            
        }
            
            break;
        default:
            break;
    }
    
}

- (void)handelCheckRecordModel:(JGJQuaSafeCheckRecordListModel *)listModel {
    
    JGJQuaSafeCheckRecordReplyModel *replyModel = nil;
    
    if (listModel.reply_list.count > 0) {
        
        replyModel = [listModel.reply_list firstObject];
    }
    
    NSDictionary *parameters = @{@"reply_id" : replyModel.replyId?:@""};
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/delReplayInspectInfo" parameters:parameters success:^(id responseObject) {
        
        
//        for (UIViewController *vc in self.navigationController.viewControllers) {
//
//            if ([vc isKindOfClass:NSClassFromString(@"JGJChatListQualityVc")]) {
//
//                [self.navigationController popToViewController:vc animated:YES];
//
//                break;
//            }
//
//        }
        
        [self loadNetData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)quaSafeCheckRecordCell:(JGJQuaSafeCheckRecordCell *)cell {

    [self freshIndexPathCell:cell];
}

#pragma mark - JGJQuaSafeCheckUnDealRecordCellDelegate
- (void)quaSafeCheckUnDealRecordCell:(JGJQuaSafeCheckUnDealRecordCell *)cell selectedListModel:(JGJQuaSafeCheckRecordListModel *)listModel buttonType:(QuaSafeUnDealedResultViewButtonType)buttonType {

    //记录点击的模型用于返回展开用
    self.expandRecordListModel = listModel;
    
    switch (buttonType) {
        case QuaSafeUnDealedResultViewUnRelationButtonType:{
            
            JGJQuaSafeCheckResultVc *checkResultVc = [JGJQuaSafeCheckResultVc new];
            
            listModel.buttonType = buttonType;
            
//            checkResultVc.listModel = listModel;
            
            [self.navigationController pushViewController:checkResultVc animated:YES];
        }
            
            break;
        case QuaSafeUnDealedResultViewModifyButtonType:{
            
            JGJQualityRecordVc *recordVc = [[JGJQualityRecordVc alloc] init];
            
            recordVc.commonModel = self.commonModel;
            
            recordVc.proListModel = self.proListModel;
            
            listModel.inspect_name = self.recordModel.inspect_name;
            
            recordVc.listModel = listModel;
            
            [self.navigationController pushViewController:recordVc animated:YES];
            
        }
            break;
        case QuaSafeUnDealedResultViewPassButtonType:{
            
            JGJQuaSafeCheckResultVc *checkResultVc = [JGJQuaSafeCheckResultVc new];
            
            listModel.buttonType = buttonType;
        
//            checkResultVc.listModel = listModel;
            
            [self.navigationController pushViewController:checkResultVc animated:YES];
        }
            
            break;
        default:
            break;
    }
    
}

#pragma mark - JGJDetailThumbnailCellDelegate

- (void)detailThumbnailCell:(JGJQuaSafeCheckRecordCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index {
//    JGJQuaSafeCheckRecordReplyModel *replyModel = nil;
//    
//    if (cell.listModel.reply_list.count > 0) {
//        
//        replyModel = [cell.listModel.reply_list firstObject];
//        
//        [JGJCheckPhotoTool browsePhotoImageView:replyModel.msg_src selImageViews:imageViews didSelPhotoIndex:index];
//    }
    
//    self.imageUrls  = replyModel.msg_src;
//    
//    NSInteger count = imageViews.count;
//    HJPhotoBrowser *browser = [[HJPhotoBrowser alloc] init];
//    browser.sourceImagesContainerView = cell;
//    browser.imageCount = count;
//    browser.currentImageIndex = index;
//    browser.delegate = self;
//    browser.subImageViews = imageViews;
//    [browser show];
    
}

- (NSURL *)photoBrowser:(HJPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,self.imageUrls[index]];
    
    return [NSURL URLWithString:baseUrl];
}

- (void)quaSafeCheckUnDealRecordCell:(JGJQuaSafeCheckUnDealRecordCell *)cell {
    
    [self freshIndexPathCell:cell];
}

- (void)freshIndexPathCell:(UITableViewCell *)cell {

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSIndexPath *temp = self.lastIndexPath;
    
    if(temp && temp != indexPath) {
        
        JGJQuaSafeCheckRecordListModel *lastListModel = self.recordModel.list[self.lastIndexPath.row];
        
        lastListModel.isExPand = NO;
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];
    }
    //选中的修改为当前行
    
    self.lastIndexPath = indexPath;
    
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];

}

- (void)loadNetData {

//    self.requestModel.principal_uid = self.planModel.principal_uid;
    
    self.requestModel.pu_inpsid = self.planModel.pu_inpsid;
    
    self.requestModel.class_type = self.proListModel.class_type;
    
    self.requestModel.msg_type = self.commonModel.msg_type;
    
    self.requestModel.insp_id = self.planModel.insp_id;
    
    self.requestModel.group_id = self.proListModel.group_id;
    
    NSDictionary *parameters = [self.requestModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getChildInspectList" parameters:parameters success:^(id responseObject) {
        
        JGJQuaSafeCheckRecordModel *recordModel = [JGJQuaSafeCheckRecordModel mj_objectWithKeyValues:responseObject];
        
        self.recordModel = recordModel;
        
        [TYLoadingHub hideLoadingView];
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];

}

- (void)setRecordModel:(JGJQuaSafeCheckRecordModel *)recordModel {

    _recordModel = recordModel;

    self.headerView.recordModel = _recordModel;
    
    if (![NSString isEmpty:self.expandRecordListModel.insp_id]) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@==insp_id", self.expandRecordListModel.insp_id];
        
        JGJQuaSafeCheckRecordListModel *inspRecordModel = [_recordModel.list filteredArrayUsingPredicate:predicate].firstObject;
        
        inspRecordModel.isExPand = YES;
    }
    
    self.headerView.height = [self.headerView quaCheckRecordHeaderViewHeight];
    
    self.tableView.tableHeaderView = [self headerView];
    
    [self.tableView reloadData];
}

- (JGJQuaSafeCheckRecordRequestModel *)requestModel {

    if (!_requestModel) {
        
        _requestModel = [JGJQuaSafeCheckRecordRequestModel new];
    }

    return _requestModel;
}

- (void)initialSubView {
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(self.view);
        
    }];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

- (JGJQuaCheckRecordHeaderView *)headerView {

    if (!_headerView) {
        
        _headerView = [[JGJQuaCheckRecordHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 55)];
    }
    
    return _headerView;

}

@end
