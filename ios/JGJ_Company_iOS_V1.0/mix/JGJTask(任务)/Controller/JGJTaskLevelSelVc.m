//
//  JGJTaskLevelSelVc.m
//  mix
//
//  Created by yj on 2017/6/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskLevelSelVc.h"

#import "JGJTaskLevelSelCell.h"

#import "JGJPublishTaskVc.h"

#import "JGJQualityRecordVc.h"

#import "JGJQualityFilterVc.h"

#import "JGJQualitySafeCheckFiliterVc.h"

@interface JGJTaskLevelSelVc ()<
UITableViewDelegate,
UITableViewDataSource

>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JGJTaskLevelSelVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.levelSelType) {
        case JGJTaskLevelSelUrgeType:
            self.title = @"紧急程度";
            break;
        case JGJTaskLevelFilterSeriousType:
        case JGJTaskLevelSelSeriousType:
            self.title = @"隐患级别";
            break;
        case JGJTaskLevelStatusType:
            self.title = @"问题状态";
            break;
        case JGJTaskLevelTimelyModifyType:
            self.title = @"整改状态";
            break;
        case JGJTaskLevelCheckStatusType:
            self.title = @"检查状态";
            break;
            
        case JGJTaskLevelRectMsgTypeType:
            self.title = @"整改类型";
            break;
            
        default:
            break;
    }
    
    [self initialSubView];
    
    
    [self.dataSource enumerateObjectsUsingBlock:^(JGJTaskLevelSelModel *selModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        if (idx == 0) {
            
            selModel.iSLevelSel = YES;
        }
        
        if ([selModel.levelName isEqualToString:self.selLevel]) {
            
            indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            
            selModel.iSLevelSel = YES;
            
        }else {
            
            selModel.iSLevelSel = NO;
            
        }
        
        self.lastIndexPath = indexPath;
        
    }];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJTaskLevelSelCell *cell = [JGJTaskLevelSelCell cellWithTableView:tableView];
    
    cell.taskLevelSelModel = self.dataSource[indexPath.row];
    
    cell.lineView.hidden = self.dataSource.count - 1 == indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *temp = self.lastIndexPath;
    if(temp && temp != indexPath) {
        
        JGJTaskLevelSelModel *lastTaskLevelSelModel = self.dataSource[self.lastIndexPath.row];
        
        lastTaskLevelSelModel.iSLevelSel = NO;//修改之前选中的cell的数据为不选中
        
        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationNone];
    }
    //选中的修改为当前行
    
    JGJTaskLevelSelModel *taskLevelSelModel = self.dataSource[indexPath.row];
    
    self.lastIndexPath = indexPath;
    
    taskLevelSelModel.iSLevelSel = YES;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    if (self.levelSelType == JGJTaskLevelSelUrgeType) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJPublishTaskVc class]]) {
                
                JGJPublishTaskVc *publishTaskVc = (JGJPublishTaskVc *)vc;
                
                JGJCreatTeamModel *taskModel = publishTaskVc.taskTimeLevelModels[1];
                
                taskModel.detailTitle = taskLevelSelModel.levelName;
                
                taskModel.detailTitlePid = taskLevelSelModel.levelUid;
                
                publishTaskVc.taskLevelModels = self.dataSource;
                
                publishTaskVc.lastLevelIndexPath = indexPath;
                
                [publishTaskVc freshIndexSection:3 row:1];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            }
        }
        
    }else if (self.levelSelType == JGJTaskLevelSelSeriousType) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJQualityRecordVc class]]) {
                
                JGJQualityRecordVc *qualityRecordVc = (JGJQualityRecordVc *)vc;
                
                JGJCreatTeamModel *levelModel = qualityRecordVc.locaLevelInfos[1];
                
                levelModel.detailTitle = taskLevelSelModel.levelName;
                
                levelModel.detailTitlePid = taskLevelSelModel.levelUid;
                
                qualityRecordVc.qualityLevelModels = self.dataSource;
                
                qualityRecordVc.lastLevelIndexPath = indexPath;
                
                [qualityRecordVc freshIndexSection:2 row:1];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(taskLevelSelVc: selectedIndexPath: selectedModel:)]) {
            
            [self.delegate taskLevelSelVc:self selectedIndexPath:indexPath selectedModel:taskLevelSelModel];
        }
        
        
    }else if (self.levelSelType == JGJTaskLevelFilterSeriousType) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJQualityFilterVc class]]) {
                
                JGJQualityFilterVc *filterVc = (JGJQualityFilterVc *)vc;
                
                JGJCreatTeamModel *levelModel = filterVc.firstSectionInfos[1];
                
                levelModel.detailTitle = taskLevelSelModel.levelName;
                
                levelModel.detailTitlePid = taskLevelSelModel.levelUid;
                
                filterVc.qualityLevelModels = self.dataSource;
                
                filterVc.lastIndexPath = indexPath;
                
                [filterVc freshIndexSection:0 row:1];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            }
        }
        
        
    }else if (self.levelSelType == JGJTaskLevelStatusType) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJQualityFilterVc class]]) {
                
                JGJQualityFilterVc *filterVc = (JGJQualityFilterVc *)vc;
                
                JGJCreatTeamModel *levelModel = filterVc.firstSectionInfos[0];
                
                levelModel.detailTitle = taskLevelSelModel.levelName;
                
                levelModel.detailTitlePid = taskLevelSelModel.levelUid;
                
                filterVc.qualityStatusModels = self.dataSource;
                
                filterVc.lastIndexPath = indexPath;
                
                [filterVc freshIndexSection:0 row:0];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            }
        }
        
    }else if (self.levelSelType == JGJTaskLevelTimelyModifyType) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJQualityFilterVc class]]) {
                
                JGJQualityFilterVc *filterVc = (JGJQualityFilterVc *)vc;
                
                JGJCreatTeamModel *levelModel = filterVc.fourSectionInfos[0];
                
                levelModel.detailTitle = taskLevelSelModel.levelName;
                
                levelModel.detailTitlePid = taskLevelSelModel.levelUid;
                
                filterVc.qualityLevelModels = self.dataSource;
                
                filterVc.lastIndexPath = indexPath;
                
                [filterVc freshIndexSection:3 row:0];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            }
        }
        
    }else if (self.levelSelType == JGJTaskLevelCheckStatusType) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJQualitySafeCheckFiliterVc class]]) {
                
                JGJQualitySafeCheckFiliterVc *filterVc = (JGJQualitySafeCheckFiliterVc *)vc;
                
                JGJCreatTeamModel *levelModel = filterVc.firstSectionInfos[0];
                
                levelModel.detailTitle = taskLevelSelModel.levelName;
                
                levelModel.detailTitlePid = taskLevelSelModel.levelUid;
                
                filterVc.qualityStatusModels = self.dataSource;
                
                filterVc.lastIndexPath = indexPath;
                
                [filterVc freshIndexSection:0 row:0];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            }
        }
        
    }else {
        
        if ([self.delegate respondsToSelector:@selector(taskLevelSelVc: selectedIndexPath: selectedModel:)]) {
            
            [self.delegate taskLevelSelVc:self selectedIndexPath:indexPath selectedModel:taskLevelSelModel];
        }
        
    }
    
}

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        
        NSArray *levels = [NSMutableArray new];
        
        NSMutableArray *levelModels = [NSMutableArray new];
        
        _dataSource = @[@"一般",@"紧急",@"非常紧急"];
        
        switch (_levelSelType) {
                
            case JGJTaskLevelSelUrgeType:{
                
                _dataSource = @[@"一般",@"紧急",@"非常紧急"];
                
                levels = _dataSource;
            }
                break;
                
            case JGJTaskLevelFilterSeriousType:{
                
                _dataSource = @[@"不限", @"一般",@"较大",@"重大",@"特大"];
                
                levels = _dataSource;
            }
                break;
            case JGJTaskLevelSelSeriousType:{
                
                _dataSource = @[@"一般",@"较大",@"重大",@"特大"];
                
                levels = _dataSource;
            }
                break;
                
            case JGJTaskLevelStatusType:{
                
                _dataSource = @[@"不限",@"待整改", @"待复查", @"已完结"];
                
                levels = _dataSource;
            }
                
                break;
                
            case JGJTaskLevelTimelyModifyType:{
                
                _dataSource = @[@"不限",@"[红灯] 逾期未完成整改",@"[黄灯] 临近整改期限", @"[绿灯] 整改时间充足", @"[黄灯] 逾期完成整改", @"[绿灯] 按时完成整改"];
                
                levels = _dataSource;
            }
                
                break;
                
            case JGJTaskLevelCheckStatusType:{
                
                _dataSource = @[@"不限",@"待检查",@"已完成"];
                
                levels = _dataSource;
                
            }
                break;
                
            case JGJTaskLevelRectMsgTypeType:{

                _dataSource = @[@"质量",@"安全",@"任务"];
                
                levels = _dataSource;
                
            }
                
                break;
                
            default:
                break;
        }
        
        
        for (NSInteger index = 0; index < levels.count; index ++) {
            
            JGJTaskLevelSelModel *selModel = [JGJTaskLevelSelModel new];
            
            selModel.levelName = levels[index];
            
            //从1开始
            if (self.levelSelType == JGJTaskLevelSelUrgeType || self.levelSelType == JGJTaskLevelSelSeriousType) {
                
                selModel.levelUid = [NSString stringWithFormat:@"%@", @(index + 1)];
            }else {
                
                selModel.levelUid = index == 0 ? nil : [NSString stringWithFormat:@"%@", @(index)];
                
            }
            
            if (self.levelSelType == JGJTaskLevelSelSeriousType || self.levelSelType == JGJTaskLevelSelUrgeType || self.levelSelType == JGJTaskLevelStatusType || self.levelSelType == JGJTaskLevelTimelyModifyType || self.levelSelType == JGJTaskLevelCheckStatusType) {
                
                //                selModel.iSLevelSel = index == 0; //首次进入一般标记选中
                
                if (index == 0) {
                    
                    self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                }
            }
            
            [levelModels addObject:selModel];
        }
        
        _dataSource = levelModels.copy;
        
    }
    
    return _dataSource;
    
}


- (void)initialSubView {
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(self.view);
        
        make.height.mas_equalTo(TYGetUIScreenHeight - 127);
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

@end

