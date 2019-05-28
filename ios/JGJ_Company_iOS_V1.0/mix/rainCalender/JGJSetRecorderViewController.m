//
//  JGJSetRecorderViewController.m
//  mix
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSetRecorderViewController.h"
#import "JGJSetRecordPeopleTableViewCell.h"
#import "JGJTopTitleView.h"
#import "JGJAddRecorderVIew.h"
#import "JGJAddressBookTool.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75
@interface JGJSetRecorderViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
ClickAddRecorderButtonDelegate,
DSectionIndexViewDelegate,
DSectionIndexViewDataSource
>
@property (strong, nonatomic) IBOutlet UITableView *Tableview;

@property (strong, nonatomic) JGJTopTitleView *Topview;

@property (strong, nonatomic) NSMutableArray <JGJSynBillingModel*>*dataArr;

@property (strong, nonatomic) NSMutableArray <JGJSynBillingModel*>*dataSourceArr;

@property (strong, nonatomic) JGJAddRecorderVIew *addView;

@property (assign, nonatomic) BOOL saveAPI;

@property (strong, nonatomic) JGJSetRainWorkerModel *JGJSetRainModel;

@property (strong, nonatomic) JGJSynBillingModel *SynBillingModel;

@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;//存储排序后信息

@property (nonatomic, strong) NSMutableArray <JGJSynBillingModel *>*principalModels;//存储排序后信息

@property (strong, nonatomic) DSectionIndexView *sectionIndexView;

@property (strong, nonatomic) UILabel *showLable;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation JGJSetRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _Tableview.delegate = self;
    _Tableview.dataSource = self;
    _Tableview.allowsMultipleSelection = YES;
    _Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"设置记录员";
    _Tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.bootmBaseView addSubview:self.addView];
    self.addView.delegate = self;
    [self getRecorderList];
    [TYNotificationCenter addObserver:self selector:@selector(reciveRainerOK) name:JLGSetRainer object:nil];
    
    [self.warningView addSubview:self.Topview];
    
    [self initIndexView];
    [self.view addSubview:self.showLable];
    
}
-(NSMutableArray<JGJSynBillingModel *> *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray<JGJSynBillingModel *> *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
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
-(JGJAddRecorderVIew *)addView
{
    if (!_addView) {
        _addView = [[JGJAddRecorderVIew alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 63)];
        _addView.backgroundColor = AppFontf1f1f1Color;
        
    }
    return _addView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 35;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJSetRecordPeopleTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSetRecordPeopleTableViewCell" owner:nil options:nil] firstObject];
    
    NSMutableArray <JGJSynBillingModel *>*synBillingModelA = [[NSMutableArray alloc]init];
    
    synBillingModelA = [self.sortContactsModel.sortContacts[indexPath.section] findResult];
    
    if ([[synBillingModelA[indexPath.row] is_report]?:@"0" intValue]) {
        
     [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        if (![self.dataArr containsObject:synBillingModelA[indexPath.row]]) {
            
            [self.dataArr addObject:synBillingModelA[indexPath.row]];
        }
    }
    
    
    [_addView setSelectPeopleNum:[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArr.count?:0]];

    cell.model = synBillingModelA[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (JGJTopTitleView *)Topview
{
    if (!_Topview) {
        
        _Topview = [[JGJTopTitleView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 50)];
    }
    return _Topview;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count) {
        
    NSMutableArray <JGJSynBillingModel *>*synBillingModelA = [[NSMutableArray alloc]init];
        
    synBillingModelA = [self.sortContactsModel.sortContacts[indexPath.section] findResult];
        
    [self.dataArr removeObject:synBillingModelA[indexPath.row]];
#pragma mark - 取消记录员选中
        NSMutableArray <JGJSynBillingModel *>*synBillingModelArr = [[NSMutableArray alloc]init];
        
        synBillingModelArr = [self.sortContactsModel.sortContacts[indexPath.section] findResult];
        
        JGJSynBillingModel * model = synBillingModelArr[indexPath.row];
        
        model.is_report = @"0";
        
    }
    [self.addView setSelectPeopleNum:[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArr.count ]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray <JGJSynBillingModel *>*synBillingModelA = [[NSMutableArray alloc]init];
    
    synBillingModelA = [self.sortContactsModel.sortContacts[indexPath.section] findResult];
    
    if (![[synBillingModelA[indexPath.row] is_active] intValue]) {

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [TYShowMessage showPlaint:@"该用户还未注册，不能选择"];
        
        return;
    }
 
    [self.dataArr addObject:synBillingModelA[indexPath.row]];
    
    _addView.hidden = NO;
    
    [_addView setSelectPeopleNum:[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArr.count ]];
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}
#pragma mark - 确认添加按钮
-(void)clickAddRecorderButton
{
    
    
}
-(void)setWorkCicleProListModel:(JGJMyWorkCircleProListModel *)WorkCicleProListModel
{
    if (!_WorkCicleProListModel) {
        _WorkCicleProListModel = [JGJMyWorkCircleProListModel new];
    }
    _WorkCicleProListModel = WorkCicleProListModel;
}
-(void)getRecorderList
{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    
    [parmDic setObject:@"Chat" forKey:@"ctrl"];
    
    [parmDic setObject:@"getChatMembers" forKey:@"action"];
    
    [parmDic setObject:_WorkCicleProListModel.class_type forKey:@"class_type"];
    
    if ([_WorkCicleProListModel.class_type isEqualToString:@"team"]) {
        
        [parmDic setObject:_WorkCicleProListModel.team_id?:@"" forKey:@"group_id"];
    }else{
        
        [parmDic setObject:_WorkCicleProListModel.group_id?:@"" forKey:@"group_id"];
    }
    [parmDic setObject:@"0" forKey:@"is_active"];
    
  __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetMembersListURL parameters:parmDic success:^(id responseObject) {
        
        weakSelf.principalModels = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:_principalModels];
        
        [_Tableview reloadData];
        
        [self.sectionIndexView reloadItemViews];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}
-(void)reciveRainerOK
{
    if (_saveAPI) {
        return;
    }
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:_WorkCicleProListModel.class_type?:@"" forKey:@"class_type"];
    NSString *uid;
        for (int i = 0; i < _dataArr.count; i++) {
            if (![NSString isEmpty: uid ]) {
                uid = [NSString stringWithFormat:@"%@,%@",uid,[_dataArr[i] uid]];
            }else{
                uid  = [NSString stringWithFormat:@"%@",[_dataArr[i] uid]];
            }
        }
    _saveAPI = YES;
    [parmDic setObject:uid?:@"" forKey:@"uid"];//记录员的uid
    if (_dataArr) {
    [parmDic setObject:_dataArr.count==0?@"1":@"0" forKey:@"is_del"];//全部删除为1，否则为0
    }
    [parmDic setObject:_WorkCicleProListModel.group_id?:@"" forKey:@"group_id"];
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/weather/setReport" parameters:parmDic success:^(id responseObject) {
        
        if (responseObject) {
            
            [TYShowMessage showSuccess:@"设置成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        }else{
            
            [TYShowMessage showSuccess:@"设置失败"];
            
        }
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
       
        [TYLoadingHub hideLoadingView];

    }];
    
}
- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section
{
    return [self.sortContactsModel.contactsLetters objectAtIndex:section];
}
- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section
{
    [self.Tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
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
