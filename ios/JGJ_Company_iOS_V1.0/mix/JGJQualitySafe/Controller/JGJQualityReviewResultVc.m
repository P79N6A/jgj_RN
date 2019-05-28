//
//  JGJQualityReviewResultVc.m
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityReviewResultVc.h"

#import "JGJPushContentCell.h"

#import "JGJCustomLable.h"

#import "JLGAddProExperienceTableViewCell.h"

#import "JGJQualityReviewResultCell.h"

#import "CustomAlertView.h"

#import "JGJChatListQualityVc.h"

@interface JGJQualityReviewResultVc () <

UITableViewDelegate,

UITableViewDataSource,

JLGMYProExperienceTableViewCellDelegate

>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJQualityReplyRequestModel *requestModel;

@end

@implementation JGJQualityReviewResultVc

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"复查结果";
    self.isShowEditeBtn = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    
    [self initialSubView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    
    switch (indexPath.section) {
        
        case 0:{
            
            cell = [self registerReviewResultTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            
            break;
        
        case 1:{
            
            JGJPushContentCell *contentCell = [JGJPushContentCell cellWithTableView:tableView];
            
            contentCell.placeholderText = @"请输入复查说明(选填)";
            
            contentCell.maxContentWords = 400;
            
            contentCell.pushContentCellBlock = ^(YYTextView *textView) {
                
                    weakSelf.requestModel.reply_text = textView.text;
            };
            
            cell = contentCell;
        }
            
            break;
        case 2:{
            
            cell = [self registerPushImageTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 100.0;
    
    switch (indexPath.section) {
        case 0:{
            
            height = 60.0;
        }
            
            break;
            
        case 1:{
            
            height = 110;
        }
            
            break;
            
        case 2:{
            
            JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell new];
            
            height =  [cell getHeightWithImagesArray:self.imagesArray];
        }
            
            break;
        default:
            break;
    }
    
    return  height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJCustomLable *headerLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(12, 0, TYGetUIScreenWidth, 36)];
    
    headerLable.textInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    
    headerLable.textColor = AppFont333333Color;
    
    headerLable.font = [UIFont systemFontOfSize:AppFont24Size];
    
    switch (section) {
        
        case 0:{
            
            headerLable.text = @"复查结果";
            
        }
            
            break;
            
        case 1:{
            
            headerLable.text = @"复查说明";
            
        }
            
            break;
            
        case 2:{
            
            headerLable.text = @"添加图片";
            
        }
            
            break;
            
        default:
            break;
    }
    
    headerLable.backgroundColor = AppFontf1f1f1Color;
    
    return headerLable;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 36.0;
}

- (UITableViewCell *)registerReviewResultTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self) weakSelf = self;
    
    JGJQualityReviewResultCell *cell = [JGJQualityReviewResultCell cellWithTableView:tableView];
    
    cell.handleQualityReviewResultBlock = ^(JGJQualityReviewResultType reviewResultType) {
        
    
        weakSelf.requestModel.is_rect = [NSString stringWithFormat:@"%@", @(reviewResultType)];
    };
    
    cell.qualityDetailModel = self.qualityDetailModel;
    
    return cell;
}

- (UITableViewCell *)registerPushImageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JLGAddProExperienceTableViewCell *returnCell = [JLGAddProExperienceTableViewCell cellWithTableView:tableView];
    
    returnCell.delegate = self;
    
    returnCell.imagesArray = self.imagesArray.mutableCopy;
    
    __weak typeof(self) weakSelf = self;
    returnCell.deleteCallBack = ^(JLGPhoneCollection *collectionCell, NSInteger index){
        [weakSelf removeImageAtIndex:index];
        
        //取出url
        __block NSMutableArray *deleteUrlArray = [NSMutableArray array];
        [collectionCell.deleteImgsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [deleteUrlArray addObject:obj];
            }
        }];
        
        [weakSelf.deleteImgsArray addObjectsFromArray:deleteUrlArray];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    return  returnCell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}

#pragma mark - 确认按钮按下

- (void)rightItemPressed:(UIBarButtonItem *)item {

    self.requestModel.group_id = self.qualityDetailModel.group_id;
    
    self.requestModel.class_type = self.qualityDetailModel.class_type;
    
    self.requestModel.statu = @"3";
    
    self.requestModel.msg_id = self.qualityDetailModel.msg_id;
    
    self.requestModel.reply_type = self.qualityDetailModel.msg_type;
    
    self.requestModel.bill_id = self.qualityDetailModel.bill_id;
    
    self.requestModel.msg_type = self.qualityDetailModel.msg_type;
    
    NSDictionary *parameters = [self.requestModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN uploadImagesWithApi:@"v2/quality/replyMessage" parameters:parameters imagearray:self.imagesArray success:^(id responseObject) {
        
        TYLog(@"responseObject ==== %@", responseObject);
        
        [self freshQualityList];
        
        [TYLoadingHub hideLoadingView];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 刷新质量列表
- (void)freshQualityList {
    
    [self modifyDetailInfoFreshList];
    
}

#pragma mark - 是否修改详情信息,刷新列表
- (void)modifyDetailInfoFreshList {
    
    [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof JGJChatListQualityVc * _Nonnull quaListVc, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([quaListVc isKindOfClass:NSClassFromString(@"JGJChatListQualityVc")]) {
            
            quaListVc.isFreshTabView = YES;
            
            *stop = YES;
        }
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

- (void)initialSubView {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(self.view);
        
    }];
    
}

- (JGJQualityReplyRequestModel *)requestModel {

    if (!_requestModel) {
        
        _requestModel = [JGJQualityReplyRequestModel new];
    }

    return _requestModel;
}

@end
