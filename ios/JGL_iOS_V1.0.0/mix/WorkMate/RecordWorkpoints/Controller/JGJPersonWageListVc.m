//
//  JGJPersonWageListVc.m
//  mix
//
//  Created by Tony on 2016/7/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJPersonWageListVc.h"
#import "JGJPersonWageListCell.h"
#import "JGJPersonWageListTopView.h"
#import "JGJPersonWageListTitleView.h"
#import "JGJPersonWageListTotalView.h"
static const CGFloat kPWLTableTitleViewHeight = 150.f;
static const CGFloat kPWLTableShadowHeight = 30.f;//阴影的高度，随意估计的
#define kPWLTableTopViewHeight (TYIS_IPHONE_5_OR_LESS?83.f:85.f)
@interface JGJPersonWageListVc ()
@property (nonatomic,   weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JGJPersonWageListModel *jgjPersonWageListModel;
@property (nonatomic, strong) JGJPersonWageListTopView *jgjPersonWageListTopView;
@end
@implementation JGJPersonWageListVc
- (void)viewDidLoad {
    [super viewDidLoad];
    [self JLGHttpRequest];
    if ([self.dataDic[@"class_type"] isEqualToString:@"person"]) {
        self.title = [self.dataDic[@"name"] stringByAppendingString:@"工资清单"];

    }else{
        self.title = self.dataDic[@"name"];
    
    }
    [TYNotificationCenter addObserver:self selector:@selector(JLGHttpRequest) name:JGJModifyBillSuccess object:nil];
}

- (void)dealloc{
    [TYNotificationCenter removeObserver:self];
}

- (void)JLGHttpRequest{
//    [JLGHttpRequest_AFN PostWithApi:@"jlworkstream/personannualbilllist" parameters:@{@"uid":self.dataDic[@"uid"]} success:^(NSDictionary *responseObject) {
    NSInteger  timeStamp =  [[NSDate date] timeIntervalSince1970];
    NSDictionary *paramDic = @{@"class_type":self.dataDic[@"class_type"],
                               @"target_id":self.dataDic[@"uid"],
                               @"timestamp":[NSString stringWithFormat:@"%ld",(long)timeStamp],
                               @"sign":@""
                               };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/Workdaystream/perAndProAllBillList" parameters:paramDic success:^(NSDictionary *responseObject) {

        self.jgjPersonWageListModel = [JGJPersonWageListModel mj_objectWithKeyValues:responseObject];

        if (self.jgjPersonWageListModel.list.count) {
            [self.tableView reloadData];
            
            JGJPersonWageListTitleView *tableHeaderView = [[JGJPersonWageListTitleView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, kPWLTableTitleViewHeight)];
            
            tableHeaderView.jgjPersonWageListModel = self.jgjPersonWageListModel;
            self.tableView.tableHeaderView = tableHeaderView;
        }
    } failure:nil];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.jgjPersonWageListModel.list.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PersonWageListList *personWageListList = self.jgjPersonWageListModel.list[section];
    return personWageListList.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}


// 定义头标题的视图，添加点击事件
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *kTableViewHeaderViewID  = @"JGJPersonWageListTotalView";
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableViewHeaderViewID];
    
    JGJPersonWageListTotalView *cellHeaderView;
    if(!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kTableViewHeaderViewID];
        headerView.frame = TYSetRect(0, 0, TYGetUIScreenWidth, 35);
        

//        [headerView addSubview:cellHeaderView];
        cellHeaderView = [[JGJPersonWageListTotalView alloc] initWithFrame:headerView.bounds];
        [headerView addSubview:cellHeaderView];
    }
    PersonWageListList *personWageListList = self.jgjPersonWageListModel.list[section];
    
    cellHeaderView.yearStr = [NSString stringWithFormat:@"%@年",@(personWageListList.year)];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    JGJPersonWageListCell *cell = [JGJPersonWageListCell cellWithTableView:self.tableView];
    PersonWageListList *personWageListList = self.jgjPersonWageListModel.list[indexPath.section];
    PersonWageListListList *personWageListListList = personWageListList.list[indexPath.row];
    //因为后台改了字段  造成了一个UIbug 
    cell.jgjPersonWageListModel = _jgjPersonWageListModel;
    
    cell.personWageListListList = personWageListListList;
    
    return cell;
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGRect changeToFrame = self.jgjPersonWageListTopView.frame;
//
//    if (scrollView.contentOffset.y > kPWLTableTitleViewHeight) {
//        if (changeToFrame.origin.y == 0) {
//            return;
//        }
//        
//        changeToFrame.origin.y = 0;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.jgjPersonWageListTopView.frame =  changeToFrame;
//        }];
//    }else{
//        if (changeToFrame.origin.y == -(kPWLTableTopViewHeight + kPWLTableShadowHeight)) {
//            return;
//        }
//        
//        changeToFrame.origin.y = -(kPWLTableTopViewHeight + kPWLTableShadowHeight);
//        [UIView animateWithDuration:0.25 animations:^{
//            self.jgjPersonWageListTopView.frame =  changeToFrame;
//        }];
//    }
//    
//
//}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonWageListList *personWageListList = self.jgjPersonWageListModel.list[indexPath.section];
    PersonWageListListList *personWageListListList = personWageListList.list[indexPath.row];
    
    //拼接时间
    NSString *dateStr = [NSString stringWithFormat:@"%@%@",@(personWageListList.year),personWageListListList.month];
    
    
    //设置参数
    NSMutableDictionary *dataDic = [self.dataDic mutableCopy];
    [dataDic setObject:dateStr forKey:@"month"];
    
    UIViewController *personDetailWageListVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints_WageList" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPersonDetailWageListVc"];
    
    [personDetailWageListVc setValue:[dataDic mutableCopy] forKey:@"dataDic"];
    [self.navigationController pushViewController:personDetailWageListVc animated:YES];
}


#pragma mark - getter
- (JGJPersonWageListTopView *)jgjPersonWageListTopView{
    if (!_jgjPersonWageListTopView) {
        _jgjPersonWageListTopView = [[JGJPersonWageListTopView alloc] initWithFrame:CGRectMake(0, -(kPWLTableTopViewHeight + kPWLTableShadowHeight), TYGetUIScreenWidth, kPWLTableTopViewHeight)];
        _jgjPersonWageListTopView.jgjPersonWageListModel = self.jgjPersonWageListModel;
        
        [self.view addSubview:_jgjPersonWageListTopView];
        
    }
    return _jgjPersonWageListTopView;
}

@end
