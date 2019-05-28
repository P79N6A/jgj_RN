//
//  JGJWorkReportViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWorkReportViewController.h"
#import "JGJWorkReprotProTableViewCell.h"
#import "JGJWorkReprotMustTableViewCell.h"
#import "JGJWorkReportSelectedTableViewCell.h"
#import "JGJWorkReportTomarrowTableViewCell.h"
#import "JGJWorkReprotTextFiledTableViewCell.h"
#import "JLGAddProExperienceTableViewCell.h"
#import "JGJSummarizeToTableViewCell.h"
#import "JGJHeaderView.h"
#import "JGJSetRecorderViewController.h"
#import "CustomAlertView.h"
#import "NSString+Extend.h"
#import "JGJChatListBaseVc.h"
@interface JGJWorkReportViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
JLGMYProExperienceTableViewCellDelegate,
selectedCollectionViewdelegate,
todayReportDelegate,
thisWeekWorkSummarydelegate,
tomorrowWorkPlandelegate,
needCoordinateWorkdelegate

>
{
    JLGAddProExperienceTableViewCell *returnCell;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *bottomButton;
@property (strong, nonatomic) JGJHeaderView *headerView;
@end

@implementation JGJWorkReportViewController

- (void)viewDidLoad {
//    if (!_JGJWorkReportModel) {
//        _JGJWorkReportModel = [JGJWorkReportSendModel new];
//        _JGJWorkReportModel.report_type = @"today";
//
//    }
    [super viewDidLoad];
    [self loadNextView];
    
}
-(void)loadNextView
{
    self.view.backgroundColor = AppFontf1f1f1Color;
    [self.view addSubview:self.WorkREportView];
    _tableview.dataSource = self;
    _tableview.delegate = self;
//    [self.view addSubview:self.WorkTableview];
    
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [TYNotificationCenter addObserver:self
                             selector:@selector(reloaDataTableview) name:@"freashImage" object:nil];
    [TYNotificationCenter addObserver:self
                             selector:@selector(tapTopButtonWithTag:) name:@"clickWorkReportType" object:nil];
    self.title = @"发工作汇报";
    _bottomButton.layer.masksToBounds = YES;
    _bottomButton.layer.cornerRadius  = 5;
}
-(void)reloaDataTableview
{
    [_tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];

//    [_tableview reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if (_workReportType==JGJWorkReportTypemonth||_workReportType == JGJWorkReportTypeWeek) {
                return 3;
            }
            return 2;

            break;
          case 1:
            
            return 3;

            break;
            case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0&&indexPath.section == 0) {
        return 40;
    }else{
        if (indexPath.section == 1 &&indexPath.row == 2) {
        return 100 * ((self.imagesArray.count +1) /3 +1);
        }else{
        return 110;
        }
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        JGJWorkReprotProTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJWorkReprotProTableViewCell" owner:nil options:nil]firstObject];
      
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1 && indexPath.section == 0){
        JGJWorkReprotTextFiledTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJWorkReprotTextFiledTableViewCell" owner:nil options:nil]firstObject];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_workReportType == JGJWorkReportTypeWeek) {
            cell.titleLbale.text = @" 本周已完成工作";
            cell.placeLable.text = @" 请输入本周已完成工作";

        }else if (_workReportType == JGJWorkReportTypemonth){
            cell.titleLbale.text = @" 本月已完成工作";
            cell.placeLable.text = @" 请输入本月已完成工作";

        }else{
            cell.titleLbale.text = @" 今日已完成工作";
            cell.placeLable.text = @" 请输入今日已完成工作";
        }
        return cell;

    }else if (indexPath.row == 2 && indexPath.section == 0){
        JGJSummarizeToTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSummarizeToTableViewCell" owner:nil options:nil]firstObject];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_workReportType == JGJWorkReportTypeWeek) {
            cell.titleLable.text = @" 本周工作总结";
            cell.placeLable.text = @" 请输入本周工作总结";

        }else if (_workReportType == JGJWorkReportTypemonth){
            cell.titleLable.text = @" 本月工作总结";
            cell.placeLable.text = @" 请输入本月工作总结";

        }else{
            cell.titleLable.text = @"";

        }
        return cell;
    
    }else if (indexPath.row == 0 && indexPath.section == 1){
        JGJWorkReportTomarrowTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJWorkReportTomarrowTableViewCell" owner:nil options:nil]firstObject];
        cell.delegate = self;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_workReportType == JGJWorkReportTypeWeek) {
            cell.titleLable.text = @" 请输入下周工作计划";

        }else if (_workReportType == JGJWorkReportTypemonth){
            cell.titleLable.text = @" 请输入下月工作计划";

        }else{
            cell.titleLable.text = @" 请输入明日工作计划";

        }
        return cell;
    }else if (indexPath.row == 1 && indexPath.section == 1){
        JGJWorkReprotMustTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJWorkReprotMustTableViewCell" owner:nil options:nil]firstObject];
        cell.delegate = self;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else if (indexPath.row == 2 && indexPath.section == 1){
       returnCell = [JLGAddProExperienceTableViewCell cellWithTableView:tableView];
        
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
            [weakSelf.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        return  returnCell;

    }else{
        JGJWorkReportSelectedTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJWorkReportSelectedTableViewCell" owner:nil options:nil]firstObject];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    
    }

}
-(JGJWorkReportTypeView *)WorkREportView
{
    if (!_WorkREportView) {
        _WorkREportView = [[JGJWorkReportTypeView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 40)];
        
    }
    return _WorkREportView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{


    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 30;

    }else
        return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (JGJHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JGJHeaderView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 30)];
    }
    return _headerView;
}


-(void)tapTopButtonWithTag:(NSNotification *)object
{
    if ( returnCell.imagesArray.count) {
        [returnCell.imagesArray removeAllObjects];
    }
    if ([object.object isEqual:@"1"]) {
        self.JGJWorkReportModel.report_type = @"today";
        _workReportType = JGJWorkReportTypeDay;
        
    }else if ([object.object isEqual:@"2"]){
        _workReportType = JGJWorkReportTypeWeek;
        self.JGJWorkReportModel.report_type = @"week";

    }else if ([object.object isEqual:@"3"]){
        _workReportType = JGJWorkReportTypemonth;
        self.JGJWorkReportModel.report_type = @"month";
    }
    
    [_tableview reloadData];


}
-(void)selectedCollectionViewItem
{
    JGJSetRecorderViewController *SetRecordVC = [[UIStoryboard storyboardWithName:@"JGJSetRecorderViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSetRecorderVC"];
    [self.navigationController pushViewController:SetRecordVC animated:YES];
}
-(JGJWorkReportSendModel *)JGJWorkReportModel
{

    if (!_JGJWorkReportModel) {
        _JGJWorkReportModel = [JGJWorkReportSendModel new];
    }
    return _JGJWorkReportModel;
}
//需要协调工作
-(void)endeditingneedCoordinateWork:(NSString *)text
{
    self.JGJWorkReportModel.coordinate_work = text;
}
//明日工作计划
-(void)endeditingtomorrowWorkPlan:(NSString *)text
{
    self.JGJWorkReportModel.next_plant = text;
}
//本周工作总结
-(void)endeditingthisWeekWorkSummary:(NSString *)text
{
    self.JGJWorkReportModel.summarize = text;

}
//编辑今天完成的工作
-(void)endEditingTodaycompleteWork:(NSString *)text
{
    self.JGJWorkReportModel.finish_plant = text;

}
-(void)setWorkCicleProListModel:(JGJMyWorkCircleProListModel *)WorkCicleProListModel
{
    if (!_WorkCicleProListModel) {
        _WorkCicleProListModel = [JGJMyWorkCircleProListModel new];
    }
    _WorkCicleProListModel = WorkCicleProListModel;

}
-(UITableView *)WorkTableview
{
    if (!_WorkTableview) {
        _WorkTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, TYGetUIScreenWidth, TYGetUIScreenHeight - 163)];
        _WorkTableview.delegate = self;
        _WorkTableview.dataSource = self;
    }
    return _WorkTableview;
}

//点击发布按钮
- (IBAction)clickSendButton:(id)sender {
    [self saveBuilderDiary];
}
-(void)saveBuilderDiary
{
    if ([NSString isEmpty:_sendDailyModel.msg_text] && [NSString isEmpty:_sendDailyModel.techno_quali_log] && !self.imagesArray.count) {
        [TYShowMessage showError:@"记录、图片至少填写一项"];
        return;
    }
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:@"message" forKey:@"ctrl"];
    [parmDic setObject:@"handleWorkReports" forKey:@"action"];
//    [parmDic setObject:JGJSHA1Sign forKey:@"sign"];
    [parmDic setObject:@"manage" forKey:@"client_type"];
    [parmDic setObject:[TYUserDefaults objectForKey:JLGUserUid] forKey:@"report_uid"];
    [parmDic setObject:@"I" forKey:@"os"];
    [parmDic setObject:[TYUserDefaults objectForKey:JLGToken] forKey:@"token"];
    [parmDic setObject:_WorkCicleProListModel.team_id?:@"0" forKey:@"group_id"];
    [parmDic setObject:_JGJWorkReportModel.report_type?:@"today" forKey:@"report_type"];//	发布汇报类型：today：今天；week：周；month：月
    [parmDic setObject:@"team" forKey:@"class_type"];//	班组：group；项目组：team
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [parmDic setObject:app_Version forKey:@"ver"];
    
    [parmDic setObject:_JGJWorkReportModel.finish_plant?:@"" forKey:@"finish_plant"];//	今天/今周/今月的完成内容
    [parmDic setObject:_JGJWorkReportModel.next_plant?:@"" forKey:@"next_plant"];//	明天/下周/下月的工作计划
    [parmDic setObject:_JGJWorkReportModel.coordinate_work?:@"" forKey:@"coordinate_work"];//	汇报协调工作
    [parmDic setObject:_JGJWorkReportModel.summarize?:@"" forKey:@"summarize"];//	周/月总结
    [parmDic setObject:_JGJWorkReportModel.receive_uids?:@"" forKey:@"receive_uids"];//	接受者的uid，以逗号隔开
    
    //    UIViewController *chatRootVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
    [alertView showProgressImageView:@"正在发布..."];
    if (self.imagesArray.count >0) {
        [JLGHttpRequest_AFN uploadImagesWithApi:@"jlupload/upload" parameters:parmDic imagearray:self.imagesArray otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
            NSLog(@"succese = %@",responseObject);
            [parmDic setObject:responseObject forKey:@"report_imgs"];
            [self sendSockertWithParam:parmDic];
            [alertView dismissWithBlcok:nil];
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithBlcok:nil];
            [self sendSockertWithParam:parmDic];
        });
    }
    
    
}

-(void)sendSockertWithParam:(NSMutableDictionary *)paramDic
{
    
    __weak typeof(self) weakSelf = self;
    
    [JGJSocketRequest WebSocketWithParameters:paramDic success:^(id responseObject) {
        
        [weakSelf freshDataList];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        [TYShowMessage showSuccess:@"发布成功!"];
        
    } failure:^(NSError *error, id values) {
        
        [TYShowMessage showSuccess:@"发布失败"];
        
    }];
}

- (void)freshDataList {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJChatListBaseVc class]]) {
            
            JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)vc;
            
            if (![self isKindOfClass:NSClassFromString(@"JGJChatListAllVc")]) {
                
                [baseVc.tableView.mj_header beginRefreshing];
                
                break;
            }
            
        }
        
    }
    
}

@end
