//
//  JGJGetPeopleInfosViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJGetPeopleInfosViewController.h"
#import "JGJGetPeopleInfosTableViewCell.h"
#import "JGJLogFilterViewController.h"
#import "NSString+Extend.h"
#import "JGJAddressBookTool.h"
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75
@interface JGJGetPeopleInfosViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
DSectionIndexViewDelegate,
DSectionIndexViewDataSource
>
@property (strong, nonatomic) UILabel *showLable;

@property (strong ,nonatomic)NSMutableArray <JGJSetRainWorkerModel *>*dataArr;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation JGJGetPeopleInfosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"请选择提交人";
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getRecorderList];
    [self initIndexView];
    [self.view addSubview:self.showLable];

}
- (void)initIndexView
{
    
    _sectionIndexView = [[DSectionIndexView alloc] init];
    _sectionIndexView.frame = CGRectMake(TYGetUIScreenWidth - kSectionIndexWidth - IndexPadding, OffsetY, kSectionIndexWidth, TYGetUIScreenHeight - OffsetY * 3 - iphoneXheightscreen);
    [_sectionIndexView setBackgroundViewFrame];
    _sectionIndexView.backgroundColor = [UIColor whiteColor];
    _sectionIndexView.dataSource = self;
    _sectionIndexView.delegate = self;
    _sectionIndexView.isShowCallout = NO;
    _sectionIndexView.calloutViewType = CalloutViewTypeForUserDefined;
    _sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
    _sectionIndexView.calloutMargin = 100.f;
    [self.view addSubview:self.sectionIndexView];
}
- (UILabel *)showLable
{
    if (!_showLable) {
        _showLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _showLable.center = self.view.center;
        _showLable.layer.cornerRadius = 25;
        _showLable.layer.masksToBounds = YES;
        _showLable.font = [UIFont systemFontOfSize:17];
        _showLable.textAlignment = NSTextAlignmentCenter;
        _showLable.textColor = [UIColor whiteColor];
        _showLable.backgroundColor = AppFontEB4E4EColor;
        _showLable.hidden = YES;
    }
    return _showLable;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGJGetPeopleInfosTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJGetPeopleInfosTableViewCell" owner:nil options:nil]lastObject];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray <JGJSynBillingModel *>*synBillingModelA = [[NSMutableArray alloc]init];
    
    synBillingModelA = [self.sortContactsModel.sortContacts[indexPath.section] findResult];
    cell.model = synBillingModelA[indexPath.row];

    if (_peopleInfoModel) {
        if (![NSString isEmpty:_peopleInfoModel.uid]) {
            if ([self.peopleInfoModel.uid?:@"" isEqualToString:[synBillingModelA[indexPath.row] uid]]) {
                cell.hadSelectLable.hidden = NO;
            }else{
                cell.hadSelectLable.hidden = YES;
            }
         }
       }
        return cell;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sortContactsModel.sortContacts[section] findResult] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sortContactsModel.contactsLetters[section];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sortContactsModel.sortContacts.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = TYColorHex(0XF5F5F5);
    back.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = AppFontccccccColor;
    label.font = FONT(AppFont32Size);
    
    label.text = sectionTitle;
    [back addSubview:label];
    
    label.sd_layout.leftSpaceToView(back, 12).centerYEqualToView(back).widthIs(300).heightIs(22);
    return back;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    for (UIViewController *Vc in self.navigationController.viewControllers) {
        if ([Vc isKindOfClass:[JGJLogFilterViewController class]]) {
            JGJLogFilterViewController *viewControl = (JGJLogFilterViewController *)Vc;
            JGJSetRainWorkerModel *model = [[JGJSetRainWorkerModel alloc]init];
            NSMutableArray <JGJSynBillingModel *>*synBillingModelA = [[NSMutableArray alloc]init];
            
            synBillingModelA = [self.sortContactsModel.sortContacts[indexPath.section] findResult];
            JGJSynBillingModel *synBillingModel = synBillingModelA[indexPath.row];
            
            if (![synBillingModel.is_active isEqualToString:@"1"]) {
                
                [TYShowMessage showPlaint:@"该用户还未注册，不能选择"];
                
                return;
            }
            
            model.gender = synBillingModel.gender;
            model.head_pic = synBillingModel.head_pic;
            model.telphone = synBillingModel.telphone;
            model.is_active = synBillingModel.is_active;
            model.is_admin = synBillingModel.is_admin?@"1":@"0";
            model.is_creater = synBillingModel.is_creater;
            model.is_report = synBillingModel.is_report;
            model.nickname = synBillingModel.nickname;
            model.real_name = synBillingModel.real_name;
            model.uid = synBillingModel.uid;
            viewControl.peopleInfoModel = model;
        }
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setWorkCircleProListModel:(JGJMyWorkCircleProListModel *)WorkCircleProListModel
{
    _WorkCircleProListModel = [[JGJMyWorkCircleProListModel alloc]init];
    _WorkCircleProListModel = WorkCircleProListModel;

}
-(void)getRecorderList
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:_WorkCircleProListModel.class_type?:@"" forKey:@"class_type"];
    [parmDic setObject:_WorkCircleProListModel.group_id?:@"" forKey:@"group_id"];
//    [parmDic setObject:@"Chat" forKey:@"ctrl"];
//    [parmDic setObject:@"getChatMembers" forKey:@"action"];
//    [TYLoadingHub showLoadingWithMessage:nil];
//    [JGJSocketRequest WebSocketWithParameters:parmDic success:^(id responseObject) {
//
//        weakSelf.principalModels = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
//
//        self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:_principalModels];
//
//        [self.tableview reloadData];
//        [self.sectionIndexView reloadItemViews];
//
//        [TYLoadingHub hideLoadingView];
//    } failure:^(NSError *error, id values) {
//
//        [TYLoadingHub hideLoadingView];
//    }];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetMembersListURL parameters:parmDic success:^(id responseObject) {
        
        weakSelf.principalModels = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:_principalModels];
        
        [self.tableview reloadData];
        
        [self.sectionIndexView reloadItemViews];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}
-(void)setPeopleInfoModel:(JGJSetRainWorkerModel *)peopleInfoModel
{
    _peopleInfoModel = [JGJSetRainWorkerModel new];
    _peopleInfoModel = peopleInfoModel;

}
- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section
{
    return [self.sortContactsModel.contactsLetters objectAtIndex:section];
}
- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section
{
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.showLable.hidden = NO;
    
    self.showLable.text = self.sortContactsModel.contactsLetters[section]?:@"";
    
    _timer = nil;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(hiddenShowLable) userInfo:nil repeats:NO];
}

- (void)hiddenShowLable
{
    if (!self.showLable.hidden) {
        self.showLable.hidden = YES;
    }
    
}
#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.sortContactsModel.contactsLetters.count;
}


- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section
{
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    itemView.titleLabel.text = [self.sortContactsModel.contactsLetters objectAtIndex:section];
    itemView.titleLabel.font = [UIFont systemFontOfSize:12];
    itemView.titleLabel.textColor = AppFont999999Color;
    itemView.titleLabel.highlightedTextColor = AppFontd7252cColor;
    itemView.titleLabel.shadowColor = [UIColor whiteColor];
    itemView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    return itemView;
}

- (UIView *)sectionIndexView:(DSectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 80, 80);
    label.backgroundColor = [UIColor yellowColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:36];
    label.text = [self.sortContactsModel.contactsLetters objectAtIndex:section];
    label.textAlignment = NSTextAlignmentCenter;
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:3.0f];
    [label.layer setShadowColor:[UIColor blackColor].CGColor];
    [label.layer setShadowOpacity:0.8];
    [label.layer setShadowRadius:5.0];
    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    return label;
}
@end
