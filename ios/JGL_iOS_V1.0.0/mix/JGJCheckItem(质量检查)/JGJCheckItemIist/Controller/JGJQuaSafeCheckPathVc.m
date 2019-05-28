//
//  JGJQuaSafeCheckPathVc.m
//  JGJCompany
//
//  Created by yj on 2017/11/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckPathVc.h"

#import "JGJCheckPlanCommonCell.h"

#import "JGJQuaSafeCheckRecordPathCell.h"

#import "JGJCheckPhotoTool.h"

@interface JGJQuaSafeCheckPathVc () <

    UITableViewDelegate,

    UITableViewDataSource,

    JGJQuaSafeCheckRecordPathCellDelegate

>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *headerCommonModels;

@property (nonatomic, strong) JGJInspectPlanRecordPathModel *recordPathReplyModel;

@end

@implementation JGJQuaSafeCheckPathVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"检查记录";
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(self.view);
        
        make.height.mas_equalTo(TYGetUIScreenHeight - 64);
    }];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNetData)];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [self loadNetData];
    
//    [JGJComTool showCloseProImageViewWithTargetView:self.view classtype:self.proListModel.class_type isClose:self.proListModel.isClosedTeamVc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 1;
    
    switch (section) {
        case 0:{
            
            count = self.headerCommonModels.count;
        }
            break;
            
        case 1:{
            
            count = self.recordPathReplyModel.log_list.count;
        }
            break;
            
        default:
            break;
    }
    
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        cell = [self registerHeaderTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }else {
        
        cell = [self registerCheckPathTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 50.0;
    
    if (indexPath.section == 0 && indexPath.row == self.headerCommonModels.count - 1) {
        
        JGJCheckPlanCommonCellModel *commonModel = self.headerCommonModels[self.headerCommonModels.count - 1];
        
        height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 69.5  content:commonModel.detailTitle font:AppFont30Size lineSpace:1] + 10;
        
        if (height < 36.0) {
            
            height = 36.0;
        }
        
    }else if (indexPath.section == 1) {
        
        JGJInspectPlanRecordPathReplyModel *listModel = self.recordPathReplyModel.log_list[indexPath.row];
        
        height = !listModel.isExpand ? 65 : listModel.cellHeight;
    }

    return height;
}

#pragma mark - 注册头部cell标题、位置
- (UITableViewCell *)registerHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCheckPlanCommonCell *headerCell = [JGJCheckPlanCommonCell cellWithTableView:tableView];
    
    headerCell.commonModel = self.headerCommonModels[indexPath.row];
    
    headerCell.lineView.hidden = indexPath.row == self.headerCommonModels.count - 1 || indexPath.row == self.headerCommonModels.count - 2 ;
    
    return headerCell;
}

#pragma mark - 注册检查内容
- (UITableViewCell *)registerCheckPathTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJQuaSafeCheckRecordPathCell *pathCell = [JGJQuaSafeCheckRecordPathCell cellWithTableView:tableView];
    
    pathCell.delegate = self;
    
    pathCell.listModel = self.recordPathReplyModel.log_list[indexPath.row];
    
    pathCell.rightTopLineView.hidden = indexPath.row == 0;
    
    pathCell.rightBottomLineView.hidden = indexPath.row == self.recordPathReplyModel.log_list.count - 1;
    
    return pathCell;
}

#pragma mark - JGJQuaSafeCheckRecordPathCellDelegate

- (void)JGJQuaSafeCheckRecordPathCell:(id)cell listModel:(JGJInspectPlanRecordPathReplyModel *)listModel {
    
    [self.tableView reloadData];
}

- (void)JGJQuaSafeCheckRecordPathCell:(JGJQuaSafeCheckRecordPathCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index {
    
    [JGJCheckPhotoTool browsePhotoImageView:cell.listModel.imgs selImageViews:imageViews didSelPhotoIndex:index];
}

- (void)loadNetData {
    
    JGJInspectPlanProInfoDotReplyModel *replyModel = nil;
    
    if (self.listModel.dot_status_list.count > 0) {
        
        replyModel = self.listModel.dot_status_list.firstObject;
    }
    
    NSDictionary *parameters = @{ @"pro_id": replyModel.pro_id?:@"",
                                  
                                  @"plan_id": replyModel.plan_id?:@"",
                                  
                                  @"content_id": replyModel.content_id?:@"",
                                  
                                  @"dot_id": replyModel.dot_id?:@"",
                                  
                                  };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectPlanLog" parameters:parameters success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        
        self.recordPathReplyModel = [JGJInspectPlanRecordPathModel mj_objectWithKeyValues:responseObject];
        
        [TYLoadingHub hideLoadingView];

    } failure:^(NSError *error) {

        [self.tableView.mj_header endRefreshing];

        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)setRecordPathReplyModel:(JGJInspectPlanRecordPathModel *)recordPathReplyModel {
    
    _recordPathReplyModel = recordPathReplyModel;
    
    [self setTopCheckItemWithRecordPathReplyModel:recordPathReplyModel];
    
    [self.tableView reloadData];
}

- (void)setTopCheckItemWithRecordPathReplyModel:(JGJInspectPlanRecordPathModel *)recordPathReplyModel {

    NSArray *titles = @[@"检查计划", @"检查项", @"检查内容", @"检查内容分项" , @"检查记录"];
    
    NSArray *detilTitles = @[recordPathReplyModel.plan_name?:@"", recordPathReplyModel.pro_name?:@"", recordPathReplyModel.content_name?:@"", recordPathReplyModel.dot_name?:@"", @""];

    NSInteger count = detilTitles.count;
    
    if (!_headerCommonModels) {
        
        _headerCommonModels = [NSMutableArray new];
        
        for (NSInteger index = 0; index < count; index++) {
            
            JGJCheckPlanCommonCellModel *commonModel = [JGJCheckPlanCommonCellModel new];
            
            commonModel.title = titles[index];
            
            commonModel.detailTitle = detilTitles[index];
            
            commonModel.contentViewBackColor = [UIColor whiteColor];
            
            if (index == count - 1) {
                
                commonModel.contentViewBackColor = AppFontf1f1f1Color;
            }
            
            [_headerCommonModels addObject:commonModel];
        }
        
    }
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
@end
