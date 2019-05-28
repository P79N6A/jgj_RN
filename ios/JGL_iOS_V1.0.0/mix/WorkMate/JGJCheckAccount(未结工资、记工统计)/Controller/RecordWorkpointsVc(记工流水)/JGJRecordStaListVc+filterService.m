//
//  JGJRecordStaListVc+filterService.m
//  mix
//
//  Created by yj on 2018/9/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordStaListVc+filterService.h"

#import "JGJFilterSideView.h"

#import "JGJSideFirstView.h"

#import "JGJProFilterView.h"

#import "JGJMemberFilterView.h"

#import "JGJRecordStaSearchTool.h"

#define JGJSideWidth  TYGetUIScreenWidth - 40

static JGJSideFirstView *containView = nil;

static JGJFilterSideView *sideView = nil;

static JGJProFilterView *proSelView = nil;

static JGJMemberFilterView *memberSelView = nil;

static JGJSynBillingModel *memberModel = nil;

static JGJRecordWorkPointFilterModel *proModel = nil;

@implementation JGJRecordStaListVc (filterService)

- (void)loadData {
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    NSArray *allMembers = searchTool.staInitialModel.members;
    
    NSArray *pros = searchTool.staInitialModel.pros;
    
    if (allMembers.count > 0) {
        
        self.allMembers = allMembers;
        
    }else {
        
        //加载班组人员
        [self loadFilterDataWithClassType:@"person"];
    }
    
    if (pros.count > 0) {
        
        self.allPros = pros;
        
    }else {
        
        //加载项目
        [self loadFilterDataWithClassType:@"project"];
    }
    
//    //加载项目
//    [self loadFilterDataWithClassType:@"project"];
//
//    //加载班组人员
//    [self loadFilterDataWithClassType:@"person"];
    
}

- (void)handleFilterAction {
    
    sideView = [[JGJFilterSideView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    
    NSMutableArray *containViews = [NSMutableArray array];
    
    JGJSideFirstView *firstView = [self containView];

    [containViews addObject:firstView];
    
    [containViews addObject:[self proFilterView]];
    
    [containViews addObject:[self memberFilterView]];
    
    firstView.sideView = sideView;
    
    firstView.containViews = containViews;
    
    sideView.containViews = containViews;
    
    [sideView pushView];
    
}

- (JGJSideFirstView *)containView {
    
    CGFloat limiWidth = TYGetUIScreenWidth - 40;
    
    containView = [[JGJSideFirstView alloc] initWithFrame:CGRectMake(limiWidth, 0, limiWidth, TYGetUIScreenHeight)];
    
    //初始化值
    containView.oriDesInfos = self.oriDesInfos;
    
    TYWeakSelf(self);
    
    __weak JGJSideFirstView *weakcontainView = containView;
    
    containView.cusNavBar.backBlock = ^{
      
        [sideView removeAllView];
    };
    
    containView.filterBlock = ^(NSArray *infos, JGJMemberImpressTagView *tagView) {
        
        NSArray *times = infos[0];
        
        NSArray *proModels = infos[1];
        
        NSArray *memberModels = infos[2];
        
        JGJComTitleDesInfoModel *st_time = times[0];
        
        JGJComTitleDesInfoModel *en_time = times[1];
        
        JGJComTitleDesInfoModel *proModel = proModels[0];
        
        JGJComTitleDesInfoModel *memberModel = memberModels[0];
        
        NSMutableArray *accounts_types = [NSMutableArray array];
        
        for (NSInteger index = 0; index < tagView.selTagModels.count; index++) {
            
            JGJMemberImpressTagViewModel *tagModel = tagView.selTagModels[index];
            
            if (tagModel.selected) {
                
                [accounts_types addObject:tagModel.tagId];
                
            }
            
        }
        
        NSString *accounts_type = [accounts_types componentsJoinedByString:@","];
        
        TYLog(@"st_time == %@,en_time == %@,proModel === %@,memberModel==%@,accounts_type === %@ ",st_time.des, en_time.des, proModel.typeId, memberModel.typeId,  accounts_type);
        
        //开始时间
        weakself.request.start_time = st_time.des;
        
        //结束时间
        weakself.request.end_time = en_time.des;
        
//        //记账类型
        weakself.request.accounts_type = accounts_type;
        
        
        JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
        
        JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
        
        //复制选择的数据
        
        staInitialModel.sel_stTime = st_time.des;
        
        staInitialModel.sel_endTime = en_time.des;
        
        
        staInitialModel.sel_proId = proModel.typeId;
        
        staInitialModel.sel_proName = proModel.des;
        
        
        staInitialModel.sel_memberUid = memberModel.typeId;
        
        staInitialModel.sel_memberName = memberModel.des;
        
        //记账类型
        staInitialModel.sel_account_types = accounts_type;
        
        //原始数据
        NSString *ori_st_time = searchTool.staInitialModel.stTime;
        
        NSString *ori_en_time = searchTool.staInitialModel.endTime;
        
        NSString *ori_pro_name = searchTool.staInitialModel.proName;
        
        NSString *ori_pro_Id = searchTool.staInitialModel.proId;
        
        NSString *ori_member_name = searchTool.staInitialModel.memberName;
        
        BOOL is_sel_time = NO;
        
        if (![ori_st_time isEqualToString:st_time.des]) {
            
            is_sel_time = YES;
        }
        
        if (![ori_en_time isEqualToString:en_time.des]) {
            
            is_sel_time = YES;
        }
        
        BOOL is_sel_pro = NO;
        
        if (![ori_pro_Id isEqualToString:proModel.typeId]) {
            
            is_sel_pro = YES;
        }
        
        BOOL is_sel_member = NO;
        
        //全部人员id是空
        if (![ori_member_name isEqualToString:memberModel.des] && ![NSString isEmpty:memberModel.typeId]) {
            
            is_sel_member = YES;
            
        }else if (![NSString isEmpty:memberModel.typeId]) {
            
            is_sel_member = YES;
            
        }
        
        weakself.filterView.startTimeStr = st_time.des;
        
        weakself.filterView.endTimeStr = en_time.des;
        
        weakself.request.start_time = st_time.des;
        
        weakself.request.end_time = en_time.des;
        
        JGJRecordWorkStaListModel *staListModel = [[JGJRecordWorkStaListModel alloc] init];
        
        BOOL is_SecVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")];
        
        if (!is_sel_pro && is_sel_member) {
            
            TYLog(@"记工统计-按工人查看2级页面-按月份统计");
            
            weakself.searchType = JGJRecordStaSearchSecCheckMemberType;
            
            staListModel.class_type = @"person";
            
            staListModel.class_type_id = memberModel.typeId;
            
            staListModel.name = memberModel.des;
            
            weakself.request.class_type = @"person";
            
            weakself.request.class_type_id = memberModel.typeId;
            
            JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
            
            if (!staInitialModel.is_lock_name && !staInitialModel.is_lock_proname) {
                
                //这里处理工头角色
                if (is_SecVc && JLGisLeaderBool) {
                    
//3.4.1去掉保存当前状态
//                    weakself.staType = JGJRecordStaProjectType;
                    
                }
                
                [weakself titles];
            }
            
        }else if (is_sel_pro && !is_sel_member) {
            
            TYLog(@"记工统计-按项目查看2级页面-按工人统计”");
            
            //工头角色
            
            if (JLGisLeaderBool) {
                
                weakself.searchType = JGJRecordStaSearchSecCheckProType;
                
            }else {
                
                 weakself.searchType = JGJRecordStaSearchMonthType;
            }
            
            BOOL is_SecVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")];
            
            //3.4.1添加，同步项目
            if (!staInitialModel.is_lock_name && !staInitialModel.is_lock_proname) {
                
                //这里处理工头角色选择了项目，就是按gong
                if (is_SecVc && JLGisLeaderBool) {
//3.4.1去掉保存当前状态
//                    weakself.staType = JGJRecordStaNormalWorkerType;
                    
                }
                
            }
            
            staListModel.class_type = @"project";
            
            staListModel.class_type_id = proModel.typeId;
            
            staListModel.name = memberModel.des;
            
            weakself.request.class_type = @"project";
            
            weakself.request.class_type_id = proModel.typeId;
            
            [weakself titles];
            
        }else if (is_sel_pro && is_sel_member) {
            
            TYLog(@"按月统计(可切换为按天统计)");
            
            weakself.request.class_type = @"person";
            
            weakself.request.class_type_id = memberModel.typeId;
            
            weakself.request.class_type_target_id = proModel.typeId;
            
            staListModel.class_type = @"person";
            
            staListModel.class_type_id = memberModel.typeId;
            
            staListModel.class_type_target_id = proModel.typeId;
            
            //都选中的时候注意name是项目id,target_name是项目ID
            staListModel.target_name = proModel.des;
            
            staListModel.name = memberModel.des;
            
            weakself.searchType = JGJRecordStaSearchMonthType;
            
        }else if (!is_sel_pro && !is_sel_member) {   // 还有一个只选择了[记工分类]
            
            TYLog(@"记工统计首页按项目查看界面；");
            
//            3.4.1修改
            if (![self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")]) {
                
                weakself.searchType = JGJRecordStaSearchMainType;
//                
//                weakself.request.class_type = @"project";
                
                [weakself handleSearchTypeRequest];
                
                weakself.request.class_type_id = proModel.typeId;
            }
            
            BOOL is_sel = ![NSString isEmpty:accounts_type] || is_sel_time || is_sel_pro || is_sel_member;
            
            if (staInitialModel.subVcs.count > 0) {
                
                JGJRecordStaListVc *staVc = staInitialModel.subVcs[0];
                
                //根据有无搜索条件更改搜索查看颜色
                [staVc setFilterButtonStatus:is_sel];
            }
            
        }else {
            
            weakself.searchType = JGJRecordStaSearchMainType;
            
            weakself.request.class_type = @"project";
            
            weakself.request.class_type_id = proModel.typeId;
            
            BOOL is_sel = ![NSString isEmpty:accounts_type] || is_sel_time || is_sel_pro || is_sel_member;
            
            if (staInitialModel.subVcs.count > 0) {
                
                JGJRecordStaListVc *staVc = staInitialModel.subVcs[0];
                
                //根据有无搜索条件更改搜索查看颜色
                [staVc setFilterButtonStatus:is_sel];
            }
            
        }
        
        [JGJRecordStaSearchTool skipVcWithVc:weakself staListModel:staListModel infos:infos  searchType:weakself.searchType staType:weakself.staType request:weakself.request];
        
        ;
        ;
        ;
        
    };
    
    return containView;
}

- (JGJProFilterView *)proFilterView {
    
    proSelView = [[JGJProFilterView alloc] initWithFrame:CGRectMake(JGJSideWidth, 0, JGJSideWidth, TYGetUIScreenHeight)];
    
    TYWeakSelf(self);
    
    __weak JGJProFilterView *weakproSelView = proSelView;
    
    proSelView.cusNavBar.backBlock = ^{
      
        [weakself removeSubView:weakproSelView];
    };
    
    proSelView.proFilterViewBlock = ^(JGJRecordWorkPointFilterModel *selProModel) {
      
        [weakself removeSubView:weakproSelView];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:1];
        
        JGJComTitleDesInfoModel *infoModel = [JGJComTitleDesInfoModel new];
        
        infoModel.des = selProModel.name;
        
        infoModel.typeId = selProModel.class_type_id;
        
        [containView setDecCellWithIndexPath:indexpath desInfoModel:infoModel];
    };
    
    proSelView.allPros = self.allPros;
    
    return proSelView;
}

- (JGJMemberFilterView *)memberFilterView {
    
    TYWeakSelf(self);
    
    memberSelView = [[JGJMemberFilterView alloc] initWithFrame:CGRectMake(JGJSideWidth, 0, JGJSideWidth, TYGetUIScreenHeight) proListModel:self.proListModel];
    
    __weak JGJMemberFilterView *weakMemberSelView = memberSelView;
    
    memberSelView.cusNavBar.backBlock = ^{
      
        [weakself removeSubView:weakMemberSelView];
    };
    
    memberSelView.memberFilterViewBlock = ^(JGJSynBillingModel *selMemberModel) {
      
         [weakself removeSubView:weakMemberSelView];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
        
        JGJComTitleDesInfoModel *infoModel = [JGJComTitleDesInfoModel new];
        
        infoModel.des = selMemberModel.name;
        
        infoModel.typeId = selMemberModel.class_type_id;
        
        [containView setDecCellWithIndexPath:indexpath desInfoModel:infoModel];
    };
    
    JGJSynBillingModel *selMemberModel = [[JGJSynBillingModel alloc] init];
    
    if (containView.desInfos.count > 0) {
        
        NSArray *infos = containView.desInfos[2];
        
        JGJComTitleDesInfoModel *memberInfoModel = infos[0];
        
        selMemberModel.class_type_id = memberInfoModel.typeId;
        
        selMemberModel.name = memberInfoModel.des;
        
        memberSelView.selMemberModel = selMemberModel;
        
    }
    
    memberSelView.allMembers = self.allMembers;
    
    return memberSelView;
}

- (void)removeSubView:(UIView *)subView {
    
    [sideView popView:subView animation:YES];
}

#pragma mark - 获取筛选数据项目、人员
- (void)loadFilterDataWithClassType:(NSString *)class_type {
    
    NSDictionary *parameters = @{@"class_type" : class_type?:@"person"};
    
    if (![NSString isEmpty:self.proListModel.group_id]) {
        
        parameters = @{
                       @"class_type" : class_type?:@"person",
                       
                       @"group_id":self.proListModel.group_id
                       
                       };
        
    }
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/getTargetNameList" parameters:parameters success:^(id responseObject) {
        
        if ([class_type isEqualToString:@"person"]) {
            
            self.allMembers = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
            
            JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
            
            searchTool.staInitialModel.members = self.allMembers;
            
        } else {
            
            self.allPros = [JGJRecordWorkPointFilterModel mj_objectArrayWithKeyValuesArray:responseObject];
            
            NSMutableArray *sortAllPro = [NSMutableArray new];
            
            if (self.allPros.count > 2) {
                
                sortAllPro = [JGJRecordWorkPointFilterModel sortProModels:[self.allPros subarrayWithRange:NSMakeRange(2, self.allPros.count-2)].mutableCopy];
                
                NSMutableArray *allPros = [self.allPros subarrayWithRange:NSMakeRange(0, 2)].mutableCopy;
                
                [allPros addObjectsFromArray:sortAllPro];
                
                self.allPros = allPros;
            }
            
            JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
            
            searchTool.staInitialModel.pros = self.allPros;
            
        }
        
    }failure:^(NSError *error) {
        
        
        
    }];
}

- (NSArray *)titles {
    
    NSArray *titles = @[@"按月份统计" ,@"按项目统计"];
    
    NSString *class_type = self.request.class_type;
    
    BOOL is_firVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")];
    
    if (is_firVc) {
        
//        titles = @[@"按项目查看" ,JLGisLeaderBool ? @"按工人查看" : @"按班组长查看"];
        
        titles = @[@"按项目查看" ,@"按姓名查看"];
        
    }else {
        
        //工人按项目不进入，当前页面
        
        if ([class_type isEqualToString:@"person"] && !JLGisLeaderBool) {
            
            titles = @[@"按月份统计",@"按项目统计"];
            
        }else if (JLGisLeaderBool && [class_type isEqualToString:@"project"]) {
            
//            titles = @[@"按月份统计",@"按工人统计"];
            
            titles = @[@"按月份统计",@"按姓名统计"];
        }else if ((JLGisLeaderBool && [class_type isEqualToString:@"person"])) {
            
            titles = @[@"按月份统计",@"按项目统计"];
        }
    }
    
    return titles;
}

@end
