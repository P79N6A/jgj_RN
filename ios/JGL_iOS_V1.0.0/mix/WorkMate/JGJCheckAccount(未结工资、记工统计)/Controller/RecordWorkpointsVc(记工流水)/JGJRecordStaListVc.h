//
//  JGJRecordStaListVc.h
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJRecordHeader.h"

#import "JGJContractorTypeChoiceHeaderView.h"

#import "JGJRecordStaFilterView.h"

@interface JGJRecordStaListVc : UIViewController

//从记工流水进入开始时间需要将结束时间，设置成当月最后一天
@property (nonatomic, copy) NSString *stTime;

@property (nonatomic, copy) NSString *endTime;

//代理班组长
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

//全部的项目
@property (nonatomic, strong) NSArray *allPros;

//全部的班组长
@property (nonatomic, strong) NSArray *allMembers;

@property (strong, nonatomic) JGJRecordWorkStaRequestModel *request;

@property (weak, nonatomic, readonly) IBOutlet UITableView *tableView;

//统计类型
@property (nonatomic, assign) JGJRecordStaType staType;

//第一层统计类型
@property (nonatomic, assign) JGJRecordStaType firStaType;

//统计搜索类型
@property (nonatomic, assign) JGJRecordStaSearchType searchType;

//初始化数据
@property (nonatomic, strong) NSMutableArray *oriDesInfos;

@property (nonatomic, strong, readonly) JGJContractorTypeChoiceHeaderView *headerView;

@property (weak, nonatomic, readonly) IBOutlet JGJRecordStaFilterView *filterView;

//不能显示查看按钮，其他页面进入隐藏未结工资
@property (nonatomic, assign) BOOL is_hidden_searchBtn;

//锁定人员名字
@property (nonatomic, assign) BOOL is_lock_name;

//锁定项目名字
@property (nonatomic, assign) BOOL is_lock_proname;

//是否禁止跳转到记工流水页面(同步给我的记工查看的时候)
@property (assign, nonatomic) BOOL isForbidSkipWorkpoints;

@property (strong, nonatomic) JGJRecordWorkStaModel *recordWorkStaModel;

//尾部的最大距离
@property (nonatomic, assign) CGFloat maxTrail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterViewH;


//刷新网络数据
-(void)freshTableView;

// 筛选条件改变颜色
- (void)setFilterButtonStatus:(BOOL)isNormal;

//子类调用
- (void)registerStaDetailWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat;

// 是否显示缺省页面
- (void)showDefaultNodataArray:(NSArray *)dataArray;

//根据搜搜类型发起请求，第一层搜索使用

- (void)handleSearchTypeRequest;
@end
