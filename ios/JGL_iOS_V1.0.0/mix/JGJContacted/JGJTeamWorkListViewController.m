//
//  JGJTeamWorkListViewController.m
//  mix
//
//  Created by Tony on 2017/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTeamWorkListViewController.h"
#import "JGJTeamListTableViewCell.h"
#import "JGJMorePeopleViewController.h"
#import "JGJNoTeamDefultTableViewCell.h"
#import "JGJCreatTeamVC.h"
#import "JLGCustomViewController.h"
#import "JGJGroupChatSelelctedMembersVc.h"
#import "TYTextField.h"

#import "JGJCommonButton.h"
#import "JGJCusBottomButtonView.h"
#import "JGJWebAllSubViewController.h"
static NSString *cellid = @"listCellIndentifer";

#define SearchbarHeight 48

@interface JGJTeamWorkListViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
JGJNoTeamDefultTableViewCellDelegate,
UITextFieldDelegate
>
@property(nonatomic ,strong)UITableView *ListTableView;
@property(nonatomic ,strong)NSArray <JgjRecordlistModel*>*dataArr;
@property(nonatomic ,strong)JgjRecordlistModel *historyModel;

@property (nonatomic, strong) JGJCustomSearchBar *searchbar;

@property(nonatomic ,strong)NSMutableArray <JgjRecordlistModel*>*backUpdataArr;

@property (nonatomic, copy) NSString *searchValue;

@property (nonatomic, strong) JGJCusBottomButtonView *buttonView;
@end

@implementation JGJTeamWorkListViewController

- (void)viewDidLoad {
    
    self.title = @"选择班组";
    [super viewDidLoad];
    [self.view addSubview:self.searchbar];
    [self.view addSubview:self.buttonView];
    [self.view addSubview:self.ListTableView];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    TYWeakSelf(self);
    self.buttonView.handleCusBottomButtonViewBlock = ^(JGJCusBottomButtonView *buttonView) {
        
        [weakself justRealName];
    };
    
}

-(UITableView *)ListTableView
{
    if (!_ListTableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetMinY(_buttonView.frame) - SearchbarHeight);
        
        _ListTableView = [[UITableView alloc]initWithFrame:rect];
        _ListTableView.dataSource = self;
        _ListTableView.delegate   = self;
        _ListTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];;
        _ListTableView.backgroundColor = AppFontf1f1f1Color;
    }
    return _ListTableView;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMypro];


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.dataArr.count) {
        
        JGJNoTeamDefultTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJNoTeamDefultTableViewCell" owner:nil options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        NSString *des = @"你还未创建任何班组";
        
        if (self.backUpdataArr.count == 0 && self.dataArr.count == 0) {
            
            des = @"你还未创建任何班组";
            
            cell.createButton.hidden = NO;
            
        }else if (self.backUpdataArr.count > 0 && self.dataArr.count == 0) {
            
            des = @"未搜索到相关内容";
            
            cell.createButton.hidden = YES;
            
        }
        
        cell.des.text = des;
        
        tableView.separatorStyle = NO;
        return cell;
        
    }else{
        
        JGJTeamListTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJTeamListTableViewCell" owner:nil options:nil]firstObject];
        cell.searchValue = self.searchValue;
        cell.modellist = self.dataArr[indexPath.row] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = NO;
        return cell;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.dataArr.count) {
        
        return 1;
    }
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArr.count) {
        return CGRectGetHeight(self.view.frame);
    }
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArr.count) {
       
        return;
    }
    
    //记录单个人员
    if (self.isRecordSingleMember) {
        
        JgjRecordlistModel *recordSelectPro = self.dataArr[indexPath.row];
        _historyModel =[[JgjRecordlistModel alloc]init];
        _historyModel = self.dataArr[indexPath.row];
        _historyModel.isProSelected = YES;
        [self recordAccountSingleMemberSelectedVc:recordSelectPro];
        
    }else {
        
        if (_isRecordMorePeople) {
            
            for (UIViewController *VC in self.navigationController.viewControllers) {
                if ([VC isKindOfClass:[JGJMorePeopleViewController class]]) {
                    
                    JGJMorePeopleViewController *moreVC = (JGJMorePeopleViewController *)VC;
                    moreVC.recordSelectPro = self.dataArr[indexPath.row];
                    _historyModel =[[JgjRecordlistModel alloc]init];
                    _historyModel = self.dataArr[indexPath.row];
                    _historyModel.isProSelected = YES;
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    break;
                }
            }
            
            
        }else{
        
            JGJMorePeopleViewController *morePeople = [JGJMorePeopleViewController new];
            morePeople.recordSelectPro = self.dataArr[indexPath.row];
            morePeople.isMinGroup = NO;
            _historyModel =[[JgjRecordlistModel alloc]init];
            _historyModel = self.dataArr[indexPath.row];
            _historyModel.isProSelected = YES;
            [self.navigationController pushViewController:morePeople animated:YES];
            
        }
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (void)getMypro{
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    [JLGHttpRequest_AFN PostWithNapi:@"group/forman-group-list" parameters:nil success:^(NSArray * responseObject) {
        
        self.buttonView.hidden = NO;
//       _dataArr = responseObject;
        self.dataArr = [JgjRecordlistModel mj_objectArrayWithKeyValuesArray:responseObject];
        if (_historyModel) {
            for (int index = 0; index < _dataArr.count; index ++) {
                if ([[self.dataArr[index] group_id]?:@"" isEqualToString:_historyModel.group_id?:@""] &&[[self.dataArr[index] pro_id]?:@"" isEqualToString:_historyModel.pro_id?:@""] ) {
                    JgjRecordlistModel *model = [[JgjRecordlistModel alloc]init];
                    model = self.dataArr[index];
                    model.isProSelected = YES;
                    break;
                }
            }
        }
        
        //拷贝一份数据搜索用
        self.backUpdataArr = self.dataArr.mutableCopy;
        
        //搜索框显示隐藏
        [self setDefaultWithDataArray:self.dataArr];

        [self.ListTableView reloadData];

        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}


-(void)JGJNoTeamDefultTableViewClickCreateTeamButton
{
    [self justRealName];

}

// 点击用户案例
- (void)JGJNoTeamDefultTableViewClickUserCaseTeamButton {
    
    TYLog(@"点击用户案例");
    
    NSString *webUrl = [NSString stringWithFormat:@"%@help/hpDetail?id=%@", JGJWebDiscoverURL,@"-2"];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
    
    [self.navigationController pushViewController:webVc animated:YES];
    
    
}

#pragma mark - 进入选择人员界面
- (void)recordAccountSingleMemberSelectedVc:(JgjRecordlistModel *)recordlistModel {
    
    JGJMyWorkCircleProListModel *proListModel = [JGJMyWorkCircleProListModel new];
    
    proListModel.group_name = recordlistModel.pro_name;
    
    proListModel.members_num = recordlistModel.members_num;
    
    JGJGroupChatSelelctedMembersVc *membersVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatSelelctedMembersVc"];
    
    membersVc.chatType = JGJSingleChatType;
    
    proListModel.group_id = recordlistModel.group_id; //获取从群添加人员的id 类型
    
    proListModel.class_type = @"group";
    
    membersVc.groupListModel = proListModel;
    
    membersVc.contactedAddressBookVcType = JGJContactedAddressBookAddDefaultType;
    
    [self.navigationController pushViewController:membersVc animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    membersVc.selelctedMembersVcBlock = ^(JGJSynBillingModel *accoountMember) {
      
        if (weakSelf.selelctedMembersVcBlock) {
            
            weakSelf.selelctedMembersVcBlock(accoountMember);
        }
    };
    
//    //项目详情升级人数2.3.0
//    membersVc.teamInfo = self.teamInfo;
//
//    __weak typeof(self) weakSelf = self;
//    [self loadGroupChatMemberList:groupListModel];
//    self.handleLoadGroupChatMemberListBlock = ^(NSArray *groupChatMemberList){
//        if (groupChatMemberList.count > 0) {
//            [weakSelf.navigationController pushViewController:membersVc animated:YES];
//        }else {
//            [TYShowMessage showPlaint:@"该项目其他成员还未加入吉工家，不能参与群聊"];
//        }
//    };
}
- (void)justRealName
{
    
    if (![self checkIsRealName]) {
        
//        TYWeakSelf(self);
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
            
                JGJCreatTeamVC *creatTeamVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatTeamVC"];
                creatTeamVC.isPopVc = YES;
                [self.navigationController pushViewController:creatTeamVC animated:YES];
                
            };
            
            customVc.customVcCancelButtonBlock = ^(id response) {
                
//                [weakself.navigationController popViewControllerAnimated:YES];
            };
            
        }
        
    }else{
        
      
        JGJCreatTeamVC *creatTeamVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatTeamVC"];
        creatTeamVC.isPopVc = YES;
        [self.navigationController pushViewController:creatTeamVC animated:YES];
    }
    
}
-(BOOL)checkIsRealName{
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}

- (void)searchWithValue:(NSString *)value {
    
    NSString *lowerSearchText = value.lowercaseString;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pro_name contains %@", lowerSearchText];
    
    NSArray *dataSource = [self.backUpdataArr  filteredArrayUsingPredicate:predicate].mutableCopy;
    
    if (![NSString isEmpty:value]) {

        self.dataArr = dataSource;

    } else {

        [self.view endEditing:YES];
        
        self.dataArr = self.backUpdataArr;

    }
    
    self.searchValue = value;
    
    [self.ListTableView reloadData];
}

- (void)setDefaultWithDataArray:(NSArray *)dataArray {
    
    _searchbar.hidden = dataArray.count == 0;
    self.buttonView.hidden = dataArray.count == 0;
    CGRect rect = CGRectMake(0, SearchbarHeight, TYGetUIScreenWidth, CGRectGetMinY(_buttonView.frame) - SearchbarHeight);
    
    if (dataArray.count == 0) {
        
        rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
    }
    
    self.ListTableView.frame = rect;
}

- (JGJCustomSearchBar *)searchbar {
    
    if (!_searchbar) {
        
        _searchbar = [JGJCustomSearchBar new];
        
        _searchbar.searchBarTF.placeholder = @"快速搜索关键字";
        
        _searchbar.searchBarTF.delegate = self;
        
        _searchbar.hidden = YES;
        
        _searchbar.searchBarTF.clearButtonMode = UITextFieldViewModeAlways;
        
        _searchbar.searchBarTF.returnKeyType = UIReturnKeyDone;
        
        _searchbar.searchBarTF.maxLength = 30;
        
        __weak typeof(self) weakSelf = self;
        
        _searchbar.searchBarTF.valueDidChange = ^(NSString *value){
            
            [weakSelf searchWithValue:value];
            
        };
        
        _searchbar.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_searchbar];
        
        [_searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.right.equalTo(self.view);
            
            make.height.mas_equalTo(SearchbarHeight);
            
        }];
        
    }
    
    return _searchbar;
    
}


- (JGJCusBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        
        CGFloat height = [JGJCusBottomButtonView cusBottomButtonViewHeight];
        
        CGFloat buttonViewY = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - height - JGJ_IphoneX_BarHeight;
        
        _buttonView = [[JGJCusBottomButtonView alloc] initWithFrame:CGRectMake(0, buttonViewY, TYGetUIScreenWidth, height)];
        
        _buttonView.hidden = YES;
        [_buttonView.actionButton setTitle:@"新建班组" forState:UIControlStateNormal];
        [_buttonView.actionButton setImage:IMAGE(@"createNewProjectAdd") forState:(UIControlStateNormal)];
    }
    return _buttonView;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

@end
