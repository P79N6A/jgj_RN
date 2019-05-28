//
//  JGJCheckPlanViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/11/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckPlanViewController.h"

#import "UILabel+GNUtil.h"

#import "JGJCheckPlanNameTableViewCell.h"

#import "JGJCheckPlanTimeTableViewCell.h"

#import "JGJCheckPlanPeopleTableViewCell.h"

#import "JGJCheckPlanHeadImagTableViewCell.h"

#import "JGJCheckContentFooterView.h"

#import "JGJEditeCheacContentTableViewCell.h"

#import "JGJCheacContentTableViewCell.h"

#import "JLGDatePickerView.h"

#import "NSDate+Extend.h"

#import "JGJTime.h"

#import "JGJDateLogPickerview.h"

#import "JGJTeamMemberCell.h"

#import "JGJTaskTracerVc.h"

#import "JGJAddCheckItemPlanViewController.h"

#import "JGJNewCreatCheckItemAddView.h"

#import "JGJNewCreteCheckItemViewController.h"

#import "JGJCheckItemNoDoatTableViewCell.h"

#import "JGJQuaSafeCheckListVc.h"
@interface JGJCheckPlanViewController ()
<

UITableViewDelegate,

UITableViewDataSource,

JGJCheckContentFooterViewdelegate,

JGJCheacContentTableViewCellDelegate,

JGJEditeCheacContentTableViewCellDelegate,

JLGDatePickerViewDelegate,

JGJTeamMemberCellDelegate,

JGJTaskTracerVcDelegate,

UIScrollViewDelegate
>
@property (strong ,nonatomic)JGJCheckContentFooterView *footerView;

@property (nonatomic,strong) JLGDatePickerView *jlgDatePickerView;

@property (nonatomic ,assign)datePickerModelType datePickerType;

@property (nonatomic ,strong) NSMutableArray *membersArr;

@property (strong, nonatomic) IBOutlet UIView *bootmBaseView;

@property (nonatomic, strong) NSMutableArray *joinMembers;

@property (nonatomic, strong) JGJAddCheckItemModel *checkModel;

@property (strong ,nonatomic)JGJNewCreatCheckItemAddView *addBottomView;

@property (strong ,nonatomic)JGJCheckItemMainListModel *listModel;//检查想和检查内容mg列表

@property (strong, nonatomic)UIView *bottomView;

@end

@implementation JGJCheckPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tabelView.tableFooterView = self.footerView;
    
    NSString *buttonTitle;

    if (self.CheckPlanType == JGJEditeCheckPlanType) {
        
    self.title = @"修改计划";
        
    buttonTitle = @"保存";

        
    }else{
        
    self.title = @"新建检查计划";
        
    buttonTitle = @"发布";


    }
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:buttonTitle?:@"" style:UIBarButtonItemStylePlain target:self action:@selector(savePlanHttpRequst)];
    self.navigationItem.rightBarButtonItem = button;
    [self.bootmBaseView addSubview:self.bottomView];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.tabelView.backgroundColor = AppFontf1f1f1Color;

    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    });

}
- (void)savePlanHttpRequst
{
    if (self.CheckPlanType == JGJEditeCheckPlanType) {
        
        [self saveEditeHttpRequst];
        
    }else{
        [self saveHttpRequst];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.CheckPlanType == JGJEditeCheckPlanType) {
        
        if (self.checkModel.pro_list.count <=  0) {
            
            [self JGJEditeHttpRequst];
  
        }
    }else{
        [self JGJHttpRequest];

    }
    
    JGJSynBillingModel *addModel = nil;
    
    if (self.membersArr.count > 0) {
        
        addModel = self.membersArr.lastObject;
        
    }

    //数据为空或者最后一个不是添加符号。加上添加符号
    if (self.membersArr.count == 0 || !addModel.isAddModel) {
        
        NSArray *addModels = [JGJTeamMemberCell accordTypeGetMangerModels:ShowAddTeamMemberFlagType];
        
        [self.membersArr addObjectsFromArray:addModels];
        
        [self.tabelView reloadData];
    }
    
}

-(void)initBottomDefultView
{
    
    typeof(self)weakSelf = self;
    self.addBottomView = [JGJNewCreatCheckItemAddView showView:self.view andBlock:^(NSString *title) {

        JGJNewCreteCheckItemViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJNewCreteCheckItemViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJNewCreteCheckItemVC"];
        WorkReportVC.WorkproListModel = self.WorkproListModel;
        
        [weakSelf.navigationController pushViewController:WorkReportVC animated:YES];
        
    }];
    
    self.tabelView.tableFooterView = self.addBottomView;
    
//    if (self.bottomView) {
//        self.bottomView.hidden = YES;
//    }
    
}
-(JGJCheckContentFooterView *)footerView
{
    _footerView = [[JGJCheckContentFooterView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 64)];
    
    _footerView.delegate = self;
    
    [_footerView buttonTitle:@"选择检查项"];
    
    return _footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JGJCheacContentTableViewCell *cell = [JGJCheacContentTableViewCell cellWithTableView:tableView];
            
            cell.nameLable.text = @"计划名称";
            
            cell.textFiled.placeholder = @"请输入计划名称";
            
            cell.delegate = self;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textFiled.maxLength = 15;
            if (![NSString isEmpty:self.checkModel.plan_name]) {
                cell.textFiled.text = self.checkModel.plan_name;
            }
            
            return cell;
        }else if (indexPath.row == 1){
        
            JGJCheckPlanTimeTableViewCell *cell = [JGJCheckPlanTimeTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![NSString isEmpty:self.checkModel.execute_time]) {
                
                cell.timeLable.text = self.checkModel.execute_time;
                cell.timeLable.textColor = AppFont333333Color;;

            }else{
                
                cell.timeLable.text = @"选择执行时间";

                cell.timeLable.textColor = AppFontccccccColor;
            }

            return cell;
        }else if (indexPath.row == 2){
            
            JGJCheckPlanPeopleTableViewCell *cell = [JGJCheckPlanPeopleTableViewCell cellWithTableView:tableView];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }else if (indexPath.row == 3){
            JGJTeamMemberCell *cell =(JGJTeamMemberCell *)[self registerExecuMemberTableView:tableView didSelectRowAtIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        
        }
    }else{
        
//        if (self.checkModel.pro_list.count <= 0) {
//            JGJCheckItemNoDoatTableViewCell *cell = [JGJCheckItemNoDoatTableViewCell cellWithTableView:tableView];
//            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            cell.Content = @"暂无检查项";
//            
//            
//            return cell;
// 
//        }else{
        JGJEditeCheacContentTableViewCell *cell = [JGJEditeCheacContentTableViewCell cellWithTableView:tableView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        cell.deleteButton.tag = indexPath.row;
        
        if (![NSString isEmpty: [self.checkModel.pro_list[indexPath.row] pro_name]]) {
            cell.textView.text = [self.checkModel.pro_list[indexPath.row] pro_name];
            cell.placeLable.text = @"";
            
        }
#pragma mark - 修改状态不能编辑
        if (self.CheckPlanType == JGJEditeCheckPlanType) {
            cell.textView.userInteractionEnabled = NO;
        }else{
            cell.textView.userInteractionEnabled = YES;

            
        }
        return cell;
//        }
    
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 4;
    }
    
    return self.checkModel.pro_list.count/*<=0?1:self.checkModel.pro_list.count*/;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2) {
        
        return 36;
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
    
      return [JGJTeamMemberCell calculateCollectiveViewHeight:self.membersArr headerHeight:CheckPlanHeaderHegiht];
    }
//    if (self.checkModel.pro_list.count <= 0 && indexPath.section == 1) {
//        
//        return CGRectGetHeight(self.view.frame) - 64 - 182 - [JGJTeamMemberCell calculateCollectiveViewHeight:self.membersArr headerHeight:CheckPlanHeaderHegiht];
//    }
    return 50;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    
    
    CGFloat height;
    
    UIView *view = [[UIView alloc]init];
    
    if (self.checkModel.pro_list.count <= 0 && section == 1) {
        
        height =   CGRectGetHeight(self.view.frame) - 64 - 132 - [JGJTeamMemberCell calculateCollectiveViewHeight:self.membersArr headerHeight:CheckPlanHeaderHegiht];
        
        [view setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
        
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, TYGetUIScreenWidth, 38)];
        
        lable.text = @"暂无检查项";
        
        lable.textColor = AppFont999999Color;
        
        lable.textAlignment = NSTextAlignmentCenter;
        
        lable.font = [UIFont systemFontOfSize:17];
        
        [view addSubview:lable];

    }else{
        
        height = 38;
        
        [view setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
        
        view.backgroundColor = AppFontf1f1f1Color;


    
    }
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 38)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 38)];
    lable.backgroundColor = AppFontf1f1f1Color;
    lable.text = @"   检查项";
    lable.textColor = AppFont333333Color;
    lable.font = [UIFont systemFontOfSize:15];
    [view addSubview:lable];
    
    return view;

}
- (UITableViewCell *)registerExecuMemberTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJTeamMemberCell *cell  = [JGJTeamMemberCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    cell.isCheckPlanHeader = YES; //使用当前页面的头部高度，内部只做顶部间隔调整
    
    cell.memberFlagType = ShowAddTeamMemberFlagType;
    
    cell.teamMemberModels = self.membersArr;
        
    return cell;
}
- (NSMutableArray *)membersArr
{
    if (!_membersArr) {
        
        _membersArr = [NSMutableArray array];
        
        
        NSArray *addModels = [JGJTeamMemberCell accordTypeGetMangerModels:ShowAddTeamMemberFlagType];
        
        [_membersArr addObjectsFromArray:addModels];
    }
    
    return _membersArr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    if (self.checkModel.pro_list.count <= 0 && section == 1) {
    
        
        if (CGRectGetHeight(self.view.frame) - 64 - 132 - [JGJTeamMemberCell calculateCollectiveViewHeight:self.membersArr headerHeight:CheckPlanHeaderHegiht] < 160) {
            return 160;
        }
         return CGRectGetHeight(self.view.frame) - 64 - 132 - [JGJTeamMemberCell calculateCollectiveViewHeight:self.membersArr headerHeight:CheckPlanHeaderHegiht];
    }
    return 36;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.view endEditing:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self showDatePicker];
    }
    

}
-(void)setWorkproListModel:(JGJMyWorkCircleProListModel *)WorkproListModel
{
    if (!_WorkproListModel) {
        _WorkproListModel = [JGJMyWorkCircleProListModel new];
    }
    _WorkproListModel = WorkproListModel;
}
#pragma mark - 点击底部添加检查项
- (void)JGJCheckContentClickBtn
{
    JGJAddCheckItemPlanViewController *AddVC = [[UIStoryboard storyboardWithName:@"JGJAddCheckItemPlanViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddCheckItemPlanVC"];
    
    AddVC.hadMutlArr = self.checkModel.pro_list;
    
    AddVC.WorkproListModel = self.WorkproListModel;
    
//    [self jugeBottomViewHidden];
    
    [self.navigationController pushViewController:AddVC animated:YES];

}
-(void)setSelectArr:(NSMutableArray<JGJCheckContentListModel *> *)selectArr
{

    if (self.checkModel.pro_list.count) {
        
        [self.checkModel.pro_list removeAllObjects];
        
    }
    
    [self.checkModel.pro_list addObjectsFromArray:selectArr];
    
    [self.tabelView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];


}
-(JGJAddCheckItemModel *)checkModel
{
    if (!_checkModel) {
        _checkModel = [JGJAddCheckItemModel new];
    }
    return _checkModel;
}

-(void)setInspectListDetailModel:(JGJInspectListDetailModel *)inspectListDetailModel
{
    if (!_inspectListDetailModel) {
        _inspectListDetailModel = [JGJInspectListDetailModel new];
    }
    _inspectListDetailModel = inspectListDetailModel;

}
#pragma mark - 编辑计划名称
- (void)JGJCheckContentTextfiledEdite:(NSString *)text
{
    self.checkModel.plan_name = text;
}

- (void)JGJCheckContentTextfiledEdite:(NSString *)text andTag:(NSInteger)indexRow
{


}
- (void)JGJEditeCheacContentTextviewEdite:(NSString *)text andTag:(NSInteger)indexpathRow
{

}
#pragma mark - 删除按钮
- (void)JGJEditeCheacContentClickDeleteButtonWithTag:(NSInteger)indexpathRow
{

    [self.checkModel.pro_list removeObjectAtIndex:indexpathRow];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexpathRow inSection:1];

    [self.tabelView beginUpdates];
    
    [self.tabelView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tabelView endUpdates];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    [self.tabelView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    });

//    [self.tabelView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];


}

- (void)showDatePicker
{
    typeof(self) weakSelf = self;
    
    _datePickerType = year_month_week_day_hourmodel;

    [JGJDateLogPickerview showDatePickerAndSelfview:self.view anddatePickertype:_datePickerType andblock:^(NSDate *date) {
        
        if ([[weakSelf getWeekDaysString:date] compare:[weakSelf getWeekDaysString:[NSDate date]]] == NSOrderedAscending && ![[weakSelf getWeekDaysString:date] isEqual:[weakSelf getWeekDaysString:[NSDate date]]]) {
            
            [TYShowMessage showPlaint:@"选择时间不能小于当前时间"];
            
            return ;
        }
        
        
        weakSelf.checkModel.execute_time = [weakSelf getWeekDaysString:date];
        
        [weakSelf.tabelView reloadData];
    }];
}

- (NSString *)getWeekDaysString:(NSDate *)date{
    if (!date) {
        
        return @"";
        
    }
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"", @"", @"", @"", @"", @"", @"", nil];
    NSString *format ;

        format = @"yyyy-MM-dd HH:mm";//
        
       NSString *dateString = [NSString stringWithFormat:@"%@ %@",[NSDate stringFromDate:date format:format],[weekdays objectAtIndex:[NSDate weekdayStringFromDate:date]]];
    
//        if ([date isToday]) {
//            dateString = [dateString stringByAppendingString:@"(今天)"];
//        }
    
    return dateString;
    
}




#pragma mark - JGJTeamMemberCellDelegate 点击头像

- (void)handleJGJTeamMemberCellRemoveIndividualTeamMember:(JGJSynBillingModel *)teamMemberModel {
    
    if (self.membersArr.count > 0 && !teamMemberModel.isMangerModel) {
        
        //加人换成下面的语句是因为后台会返相同的手机号码人员
        
        NSPredicate *existPredicate = [NSPredicate predicateWithFormat:@"telephone=%@", teamMemberModel.telephone];
        
        NSArray *existMembers = [self.membersArr filteredArrayUsingPredicate:existPredicate];
        
        if (existMembers.count > 0) {
            
            for (JGJSynBillingModel *memberModel in existMembers) {
                
                if ([memberModel isKindOfClass:[JGJSynBillingModel class]]) {
                    
                    memberModel.isSelected = NO;
                }
                
            }
        }
        
        NSInteger index = [self.membersArr indexOfObject:teamMemberModel];
        
        [self.membersArr removeObjectAtIndex:index];
        
        if ([self.joinMembers containsObject:teamMemberModel]) {
            
            teamMemberModel.isSelected = NO;
        }
        
        TYLog(@"del-------%@", teamMemberModel.real_name);
        
        [self.tabelView reloadData];
    }
}


- (void)handleJGJTeamMemberCellAddMember:(JGJTeamMemberCommonModel *)commonModel {
    
    JGJTaskTracerVc *taskTracerVc = [[UIStoryboard storyboardWithName:@"JGJTask" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJTaskTracerVc"];
    
    taskTracerVc.taskTracerType = JGJTaskExecutorTracerType;
    
    taskTracerVc.delegate = self;
    
    if (self.membersArr.count > 0) {
        
        JGJSynBillingModel *addModel = self.membersArr.lastObject;
        
        if (addModel.isMangerModel) {
            
            [self.membersArr removeLastObject];
        }
        
    }
    
    taskTracerVc.proListModel = self.WorkproListModel;
    
    taskTracerVc.existedMembers = self.membersArr;
    
    taskTracerVc.taskTracerModels = self.joinMembers;
    
    [self.navigationController pushViewController:taskTracerVc animated:YES];
}

- (void)taskTracerVc:(JGJTaskTracerVc *)principalVc didSelelctedMembers:(NSArray *)members {
    
    self.joinMembers = principalVc.taskTracerModels;
    
    [self.membersArr removeAllObjects];
    
    [self.membersArr addObjectsFromArray:members];
    
    self.checkModel.member_list = self.membersArr;
    //得到最后一个添加模型
    NSArray *addModels = [JGJTeamMemberCell accordTypeGetMangerModels:ShowAddTeamMemberFlagType];
    
    [self.membersArr addObjectsFromArray:addModels];
    
    [self.tabelView reloadData];
}

#pragma mark -保存

- (void)saveHttpRequst
{

    
    if ([NSString isEmpty: self.checkModel.plan_name ] ) {
        
        [TYShowMessage showPlaint:@"请填写计划名称"];
        
        return;
    }else if ([NSString isEmpty: self.checkModel.execute_time ]){
    
        [TYShowMessage showPlaint:@"请选择执行时间"];
        
        return;

    }else  if (self.checkModel.member_list.count <= 0) {
        
        [TYShowMessage showPlaint:@"请选择执行人"];
        
        return;
    }else if (self.checkModel.pro_list.count <= 0){
    
        [TYShowMessage showPlaint:@"请选择检查项"];
        
        return;
    }
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    NSMutableArray *uidArr = [[NSMutableArray alloc]init];
    NSMutableArray *proIdArr = [[NSMutableArray alloc]init];
    NSString *uidStr;
    NSString *proidStr;
    for (int index = 0; index < self.checkModel.member_list.count; index ++) {
        
        if (![self.checkModel.member_list[index] isAddModel]) {
            [uidArr addObject:[self.checkModel.member_list[index] uid]];
   
        }
    }
    for (int index = 0; index < self.checkModel.pro_list.count; index ++) {

        [proIdArr addObject:[self.checkModel.pro_list[index] pro_id]];
        
    }
    
   uidStr = [uidArr componentsJoinedByString:@","];
    
    proidStr = [proIdArr componentsJoinedByString:@","];

    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:uidStr?:@"" forKey:@"uids"];
    
    [paramDic setObject:proidStr?:@"" forKey:@"pro_ids"];
    
    [paramDic setObject:self.checkModel.plan_name?:@"" forKey:@"plan_name"];

    [paramDic setObject:self.checkModel.execute_time?:@"" forKey:@"execute_time"];

    
    typeof(self)weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/addInspectPlan" parameters:paramDic success:^(id responseObject) {
       
        [TYLoadingHub hideLoadingView];
        
        [TYShowMessage showSuccess:@"发布成功"];
        
//        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        JGJQuaSafeCheckListVc *checkListVc = [JGJQuaSafeCheckListVc new];
        
        checkListVc.proListModel = weakSelf.WorkproListModel;
        
        checkListVc.selType = JGJQuaSafeCheckSelMyCreatType;
        
        checkListVc.title = @"我创建的";
        
        [self.navigationController pushViewController:checkListVc animated:YES];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
 
    }];

}

- (void)JGJHttpRequest
{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:@"pro" forKey:@"type"];
    
    typeof(self) weakSelf = self;
    
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectProOrContent" parameters:paramDic success:^(id responseObject) {
        
        
        weakSelf.listModel = [JGJCheckItemMainListModel mj_objectWithKeyValues:responseObject];
        
        if (weakSelf.listModel.list.count <= 0) {
            
            [weakSelf initBottomDefultView];
            
        }else{
            
            
//            [self jugeBottomViewHidden];
        }
        
        [TYLoadingHub hideLoadingView];
        
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}
-(void)jugeBottomViewHidden
{
    

    
//    [self.view addSubview:self.bottomView];

    
    if (self.tabelView.contentSize.height > TYGetUIScreenHeight - 64 ) {
        
        self.bottomView.hidden = NO;
        
    }else{
        
        self.bottomView.hidden = YES;
        
    }
    if (self.bottomView.hidden) {
        
        self.tabelView.tableFooterView = self.footerView;
        
        [UIView animateWithDuration:.1 animations:^{
            
            self.bottomConstance.constant = 0;
            
        }];
    }else{
        
        self.tabelView.tableFooterView = nil;
        
        [UIView animateWithDuration:.1 animations:^{
            
            self.bottomConstance.constant = 64;
            
            
        }];
    }
    


}
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 64)];
        _bottomView.backgroundColor = AppFontfafafaColor;
        [_bottomView addSubview:self.footerView];
    }
    return _bottomView;
}

#pragma mark - iu该检查计划时

- (void)JGJEditeHttpRequst
{

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.inspectListDetailModel.plan_id?:@"" forKey:@"plan_id"];
    
    
    typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectPlanInfo" parameters:paramDic success:^(id responseObject) {
        
        
        weakSelf.checkModel = [JGJAddCheckItemModel mj_objectWithKeyValues:responseObject];
        
        weakSelf.membersArr = weakSelf.checkModel.member_list;

      //---这里添加加号
        NSArray *addModels = [JGJTeamMemberCell accordTypeGetMangerModels:ShowAddTeamMemberFlagType];
        if (![weakSelf.membersArr containsObject:addModels]) {
            [_membersArr addObjectsFromArray:addModels];
 
        }
      //---
        [weakSelf.tabelView reloadData];
        
        [TYLoadingHub hideLoadingView];
        
//        [self jugeBottomViewHidden];

        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    


}

#pragma mark -保存

- (void)saveEditeHttpRequst
{
    
    if ([NSString isEmpty: self.checkModel.plan_name ] ) {
        
        [TYShowMessage showPlaint:@"请填写计划名称"];
        
        return;
    }else if ([NSString isEmpty: self.checkModel.execute_time ]){
        
        [TYShowMessage showPlaint:@"请选择执行时间"];
        
        return;
        
    }else  if (self.checkModel.member_list.count <= 0) {
        
        [TYShowMessage showPlaint:@"请选择执行人"];
        
        return;
    }else if (self.checkModel.pro_list.count <= 0){
        
        [TYShowMessage showPlaint:@"请选择检查项"];
        
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    NSMutableArray *uidArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *proIdArr = [[NSMutableArray alloc]init];
    NSString *uidStr;
    NSString *proidStr;
    for (int index = 0; index < self.checkModel.member_list.count; index ++) {
        
        if (![self.checkModel.member_list[index] isAddModel]) {
            [uidArr addObject:[self.checkModel.member_list[index] uid]];
        }
    }
    if (!uidArr.count) {
        [TYShowMessage showPlaint:@"请选择执行人"];
        
        return;
    }
    for (int index = 0; index < self.checkModel.pro_list.count; index ++) {
        
        [proIdArr addObject:[self.checkModel.pro_list[index] pro_id]];
        
    }
    uidStr = [uidArr componentsJoinedByString:@","];
    proidStr = [proIdArr componentsJoinedByString:@","];
    
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:uidStr?:@"" forKey:@"uids"];
    
    [paramDic setObject:proidStr?:@"" forKey:@"pro_ids"];
    
    [paramDic setObject:self.checkModel.plan_name?:@"" forKey:@"plan_name"];
    
    [paramDic setObject:self.checkModel.execute_time?:@"" forKey:@"execute_time"];
    
    [paramDic setObject:self.inspectListDetailModel.plan_id?:@"" forKey:@"plan_id"];

    typeof(self)weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/updateInspectPlan" parameters:paramDic success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showSuccess:@"修改成功!"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
        
    }];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [self.view endEditing:YES];
}
@end
