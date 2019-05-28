//
//  JGJWorkerheaderDetailVC.m
//  mix
//
//  Created by celion on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkerheaderDetailVC.h"

#import "TYPhone.h"
#import "MJRefresh.h"
#import "JGJShowContactsVC.h"
#import "JLGDefaultTableViewCell.h"
#import "JGJWorkerHeaderDetailTopCell.h"
#import "JGJWorkerHeaderContactsCell.h"
#import "UITableViewCell+Extend.h"

//项目详情需要
#import "LGPhoto.h"
#import "JLGMYProExperienceTableViewCell.h"
#import "JGJCustomListView.h"

@interface JGJWorkerheaderDetailVC ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    LGPhotoPickerBrowserViewControllerDelegate,
    LGPhotoPickerBrowserViewControllerDataSource,
    JLGMYProExperienceTableViewCellDelegate
>
{
    NSInteger _tableViewRowCount;//table总得cell个数
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containtCallButtonView;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (nonatomic, strong) JGJWorkerHeaderDetailTopCell *topCell;

//项目经验需要的
@property (assign,nonatomic) NSUInteger pageNum;
@property (strong,nonatomic) NSMutableArray *projectsArray;
@property (strong,nonatomic) NSMutableDictionary *parametersDic;

@property (nonatomic,assign) NSInteger cellSelectedIndex;
@property (nonatomic,assign) NSInteger imageSelectedIndex;
@property (nonatomic, strong) FindResultModel *contactsFriendsResultModel;
@property (nonatomic, strong) NSArray *contacts;
@end

@implementation JGJWorkerheaderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    [self loadCommonContactsFriends];//加载共同的好友
     [self JLGHttpRequest_GetProExperience];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _tableViewRowCount  = 0;

    if (section == 0) {
        _tableViewRowCount = (self.jlgFHLeaderDetailModel.contacts.count > 0?2:1) + (self.projectsArray.count?:1);
    }
    return _tableViewRowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.jlgFHLeaderDetailModel) {
        return [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    }
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            JGJWorkerHeaderDetailTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:@"JGJWorkerHeaderDetailTopCell" forIndexPath:indexPath];
            topCell.jlgFHLeaderDetailModel = self.jlgFHLeaderDetailModel;
            cell = topCell;
        }else if (indexPath.row == 1) {
            if (self.jlgFHLeaderDetailModel.contacts.count > 0) {
                JGJWorkerHeaderContactsCell *middleCell = [tableView dequeueReusableCellWithIdentifier:@"JGJWorkerHeaderContactsCell" forIndexPath:indexPath];
                middleCell.jlgFHLeaderDetailModel = self.jlgFHLeaderDetailModel;
                cell = middleCell;
            }else{
                cell = [self showProExperienctCell:tableView IndexPath:indexPath];
            }
        }else{
                cell = [self showProExperienctCell:tableView IndexPath:indexPath];
        }
    }
    return cell;
}

- (UITableViewCell *)showProExperienctCell:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];

    if (self.projectsArray.count == 0) {
        JLGDefaultTableViewCell *defaultCell = [JLGDefaultTableViewCell cellWithTableView:tableView];
        defaultCell.tileLayoutCenterY.constant = -40;
        cell = defaultCell;
    }else{
        NSInteger addIndex = indexPath.row - (self.jlgFHLeaderDetailModel.contacts.count > 0?2:1);
        
        JLGMYProExperienceTableViewCell *procell = [JLGMYProExperienceTableViewCell cellWithTableView:tableView];
        procell.delegate = self;
        procell.tag = addIndex;
        procell.isGetCellHeight = NO;
        procell.hiddenEditButton = YES;
        procell.hiddenAddButton = YES;
        procell.hiddenTopLine = addIndex == 0;
        procell.jlgProjectModel = self.projectsArray[addIndex];
        procell.selectionStyle = UITableViewCellSelectionStyleNone;
        procell.showBottomPointView = addIndex == self.projectsArray.count - 1;

        cell = procell;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight  = 0;
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 120 + self.jlgFHLeaderDetailModel.worktypeViewH;
        }
        
        
        if (indexPath.row == 1 ) {
            if (self.jlgFHLeaderDetailModel.contacts.count > 0) {
                rowHeight = 52;
            }else{
                return [self getProCellHeight:tableView indexPath:indexPath];
            }
        }else{
            return [self getProCellHeight:tableView indexPath:indexPath];
        }
    }

    return rowHeight;
}

- (CGFloat )getProCellHeight:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    if (self.projectsArray.count  == 0) {
        rowHeight = TYGetViewH(tableView) - 135 + self.jlgFHLeaderDetailModel.worktypeViewH;
    }else{
        JLGProjectModel *jlgProjectModel = self.projectsArray[indexPath.row - (self.jlgFHLeaderDetailModel.contacts.count > 0?2:1)];
        JLGMYProExperienceTableViewCell *cell = [JLGMYProExperienceTableViewCell cellWithTableView:tableView];
        
        cell.isGetCellHeight = YES;
        cell.hiddenAddButton = YES;
        cell.jlgProjectModel = jlgProjectModel;
        
        if (indexPath.row + 1 == _tableViewRowCount) {
            rowHeight = cell.cellHeight + LastCellExtraHeight;
        }else{
            rowHeight = cell.cellHeight;
        }

    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UIStoryboard *contactsStoryboard = [UIStoryboard storyboardWithName:@"JGJContacts" bundle:nil] ;
            JGJShowContactsVC *contactsVC = [contactsStoryboard instantiateViewControllerWithIdentifier:@"JGJShowContactsVC"];
            self.jlgFHLeaderDetailModel.contacts = self.contacts;
            contactsVC.jlgFHLeaderDetailModel = self.jlgFHLeaderDetailModel;
            [self.navigationController pushViewController:contactsVC animated:YES];
        }
    }
}

- (void)loadNetData{
    
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [JLGHttpRequest_AFN PostWithApi:@"jlwork/searchworkerinfo" parameters:@{@"uid":@(weakSelf.jlgFHLeaderDetailModel.uid),@"roletype":weakSelf.roletype} success:^(NSDictionary *responseObject) {
            if (!weakSelf.jlgFHLeaderDetailModel) {
                weakSelf.jlgFHLeaderDetailModel= [[JLGFHLeaderDetailModel alloc] init];
            }
            //            添加换行最大宽度字段
            CGFloat lineMaxWidth = TYGetUIScreenWidth - 110;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            [dic setValue:@(lineMaxWidth) forKeyPath:@"lineMaxWidth"];
            [weakSelf.jlgFHLeaderDetailModel setValuesForKeysWithDictionary:dic];
            self.tableView.hidden = NO;
            [self JLGHttpRequest_GetProExperience];
        }failure:^(NSError *error) {
            [TYLoadingHub hideLoadingView];
        }];
    });
}

- (void)loadCommonContactsFriends {
    if (JLGisLoginBool) {
        [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [JLGHttpRequest_AFN PostWithApi:@"jlwork/friends" parameters:@{@"uid":@(weakSelf.jlgFHLeaderDetailModel.uid)?:[NSNull null]} success:^(NSDictionary *responseObject) {
                self.contacts = [FindResultModel mj_objectArrayWithKeyValuesArray:responseObject];
                self.jlgFHLeaderDetailModel.contacts = self.contacts;
               self.tableView.hidden = NO;
               [self.tableView reloadData];
                [TYLoadingHub hideLoadingView];
            }failure:^(NSError *error) {
                [TYLoadingHub hideLoadingView];
            }];
        });
    }
}

- (void)commonSet {
//有数据才显示
    self.tableView.hidden = YES;
    
    self.title = [self.roletype isEqualToString:@"1"]?@"工人详情":@"班组长详情";
    
    self.pageNum = 1;
    self.projectsArray = [[NSMutableArray alloc] init];
    self.parametersDic = [NSMutableDictionary dictionary];
    self.parametersDic[@"uid"] = @(self.jlgFHLeaderDetailModel.uid);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(JLGHttpRequest_GetProExperience)];
    
//    类型设置换行宽度
    self.jlgFHLeaderDetailModel.lineMaxWidth = TYGetUIScreenWidth - 110;
    JGJCustomListView *cuslistView = [[JGJCustomListView alloc] init];
    [cuslistView setCustomListViewDataSource:self.jlgFHLeaderDetailModel.main_filed lineMaxWidth:TYGetUIScreenWidth - 110];
    self.containtCallButtonView.backgroundColor = AppFontfafafaColor;
    [self.callButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
}

#pragma mark - 打电话
- (IBAction)callPhoneBtnClick:(id)sender {
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsLogin)) {
        return ;
    }
    
    SEL checkIsInfo = NSSelectorFromString(@"checkIsInfo");
    imp = [self.navigationController methodForSelector:checkIsInfo];
    if (!func(self.navigationController, checkIsInfo)) {
        return ;
    }
    [TYPhone callPhoneByNum:self.jlgFHLeaderDetailModel.telephone view:self.view];
}

#pragma mark - 加载分页数据
- (void)JLGHttpRequest_GetProExperience{
    self.parametersDic[@"pg"] = @(self.pageNum);
    
    [JLGHttpRequest_AFN PostWithApi:@"jlwork/getproexperience" parameters:self.parametersDic success:^(NSArray *responseObject) {
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            JLGProjectModel *jlgProjectModel = [[JLGProjectModel alloc] init];
            [jlgProjectModel setValuesForKeysWithDictionary:obj];
            
            [self.projectsArray addObject:jlgProjectModel];
        }];
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (responseObject.count > 0) {
            self.pageNum++;
        }
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 点击了图片
- (void )CollectionCellDidSelected:(NSUInteger )cellIndex imageIndex:(NSUInteger )imageIndex{
    self.cellSelectedIndex = cellIndex;
    self.imageSelectedIndex = imageIndex;
    
    [self pushPhotoBroswerWithStyle:LGShowImageTypeImageURL];
}

#pragma mark - 图片浏览器
- (void)pushPhotoBroswerWithStyle:(LGShowImageType)style{
    LGPhotoPickerBrowserViewController *broswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
    broswerVC.delegate = self;
    broswerVC.dataSource = self;
    broswerVC.showType = style;
    broswerVC.imageSelectedIndex = self.imageSelectedIndex;
    [self presentViewController:broswerVC animated:YES completion:nil];
}

- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    JLGProjectModel *jlgProjectModel = self.projectsArray[self.cellSelectedIndex];
    
    return jlgProjectModel.imgs.count;
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    
    JLGProjectModel *jlgProjectModel = self.projectsArray[self.cellSelectedIndex];
    
    NSMutableArray *LGPhotoPickerBrowserArray = [[NSMutableArray alloc] init];
    
    [jlgProjectModel.imgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
        
        NSString *finalPicUrl = [JLGHttpRequest_Public stringByAppendingString:obj];
        photo.photoURL = [NSURL URLWithString:finalPicUrl];
        
        [LGPhotoPickerBrowserArray addObject:photo];
    }];
    
    return [LGPhotoPickerBrowserArray objectAtIndex:indexPath.item];
}
@end
