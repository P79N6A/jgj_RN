//
//  JGJQuaSafeCheckResultVc.m
//  JGJCompany
//
//  Created by yj on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckResultVc.h"

#import "JGJPushContentCell.h"

#import "JGJCustomLable.h"

#import "JLGAddProExperienceTableViewCell.h"

#import "CustomAlertView.h"


@interface JGJQuaSafeCheckResultVc ()<

    UITableViewDelegate,

    UITableViewDataSource,

    JLGMYProExperienceTableViewCellDelegate

>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJQuaSafeCheckRecordRequestModel *requestModel;

@property (nonatomic, strong) JGJQuaSafeRectNotifyRequset *unRectRequestModel;
@end

@implementation JGJQuaSafeCheckResultVc

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"检查结果";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    
    [self initialSubView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    UITableViewCell *cell = [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:{
            
            JGJPushContentCell *contentCell = [JGJPushContentCell cellWithTableView:tableView];
            
            contentCell.placeholderText = @"检查说明(选填)";
            
            contentCell.maxContentWords = 400;
            
            contentCell.pushContentCellBlock = ^(YYTextView *textView) {
                
                weakSelf.unRectRequestModel.comment = textView.text;
            };
            
            cell = contentCell;
        }
            
            break;
        case 1:{
            
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
    
    CGFloat height = 110.0;
    
    if (indexPath.section == 1) {
        
        JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell new];
        
        height =  [cell getHeightWithImagesArray:self.imagesArray];
        
    }
    
    return  height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 36.0;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
    
    headerView.backgroundColor = AppFontf1f1f1Color;
    
    JGJCustomLable *headerLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(12, 0, TYGetUIScreenWidth, height)];
    
    [headerView addSubview:headerLable];
    
    JGJCustomLable *headerStausLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(TYGetUIScreenWidth - 100, 0, 88, height)];
    
    [headerView addSubview:headerStausLable];
    
    headerStausLable.textAlignment = NSTextAlignmentRight;
    
    headerLable.textColor = AppFont333333Color;
    
    headerLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    headerStausLable.textColor = AppFont333333Color;
    
    headerStausLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    switch (section) {
            
        case 0:{
            
            headerLable.text = @"检查结果";
            
            JGJInspectPlanProInfoDotReplyModel *replyModel = nil;
            
            if (self.dotListModel.dot_status_list.count > 0) {
                
                replyModel = self.dotListModel.dot_status_list.firstObject;
                
            }

            if (self.buttonType == JGJCheckModifyResultViewUnCheckButtontype) {
                
                 headerStausLable.text = [NSString stringWithFormat:@"[%@]", @"不用检查"];
                
                headerStausLable.textColor = AppFont999999Color;
                
            }else if (self.buttonType == JGJCheckModifyResultViewPassButtontype) {
            
                headerStausLable.text = [NSString stringWithFormat:@"[%@]", @"通过"];
                
                headerStausLable.textColor = AppFont83C76EColor;
            }
        
        }
            
            break;
            
        case 1:{
            
            headerLable.text = @"添加图片";
            
            headerStausLable.text = @"";
        }
            
            break;
            
        default:
            break;
    }
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 36.0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}

#pragma mark - 确认按钮按下

- (void)rightItemPressed:(UIBarButtonItem *)item {
    
    NSDictionary *parameters = [self.unRectRequestModel mj_keyValues];
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN uploadImagesWithApi:@"v2/inspect/handleInspectDotStatus" parameters:parameters imagearray:self.imagesArray success:^(id responseObject) {
        
        TYLog(@"responseObject ==== %@", responseObject);
        
        [TYLoadingHub hideLoadingView];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
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
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    return  returnCell;
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

- (JGJQuaSafeRectNotifyRequset *)unRectRequestModel {
    
    if (!_unRectRequestModel) {
        
        _unRectRequestModel = [JGJQuaSafeRectNotifyRequset new];
        
        _unRectRequestModel.pro_id = self.proInfoModel.pro_id;
        
        _unRectRequestModel.plan_id = self.proInfoModel.plan_id;
        
        _unRectRequestModel.content_id = self.dotListModel.content_id;
        
        _unRectRequestModel.dot_id = self.dotListModel.dot_id;
        
        _unRectRequestModel.status = [NSString stringWithFormat:@"%@", @(self.buttonType)];
    }
    
    return _unRectRequestModel;
}

@end
