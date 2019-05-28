//
//  YZGAddForemanAndMateViewController.m
//  mix
//
//  Created by Tony on 16/3/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//
#import "YZGAddForemanAndMateViewController.h"
#import "TYAddressBook.h"
#import "NSString+Extend.h"
#import "TLCityHeaderView.h"
#import "YZGAddFmNoContactsView.h"
#import "YZGMateReleaseBillViewController.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
#import "JGJSynAddressBookVC.h"
#import "CustomAlertView.h"
#import "JGJMorePeopleViewController.h"
#import "JGJTeamWorkListViewController.h"
#import "JGJShowHubView.h"
#import "JGJCustomAlertView.h"
#import "JGJQRecordViewController.h"
#import "JGJModifyBillListViewController.h"
#import "JGJMarkBillViewController.h"
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75
static NSInteger cellColorIndex = 100;
@interface YZGAddForemanAndMateViewController ()
<
    DSectionIndexViewDataSource,
    DSectionIndexViewDelegate,
    YZGAddFmNoContactsViewDelegate
>
@property (nonatomic,strong) UILabel *centerShowLetter;
@property (nonatomic,strong) NSMutableArray *indexArray;
@property (nonatomic,strong) NSMutableArray *addressBookArray;
@property (nonatomic,strong) YZGAddFmNoContactsView *addFmNoContactsView;
@property (nonatomic,strong) NSMutableArray <YZGAddForemanModel *> *searchDataArray;
@property (nonatomic,strong) UIBarButtonItem *rightBarButtonItem;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomH;
@property (retain, nonatomic) DSectionIndexView *sectionIndexView;
@property (assign, nonatomic) BOOL isDelete;//是否删除联系人
@property (weak, nonatomic) UIButton *delButton;
@property (strong, nonatomic) UIView *rightNavView;
@property (strong, nonatomic) UIButton *BottomButton;
@property (strong, nonatomic) UIView *containSaveButtonView;
@property (weak, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *NewButton;
@property (strong, nonatomic) UIView *newPlaceView;

@end

@implementation YZGAddForemanAndMateViewController
- (void)viewDidLoad{
    [super viewDidLoad];

    
    self.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    self.title = [NSString stringWithFormat:@"添加%@",JGJRecordIDStr];
    if (self.workProListModel) {
        self.title = @"添加工人";
    }
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.searchBar.barTintColor = [UIColor colorWithWhite:0.95 alpha:1.0];

    [self.tableView registerClass:[TLCityHeaderView class] forHeaderFooterViewReuseIdentifier:@"TLCityHeaderView"];
    [self.view addSubview:self.centerShowLetter];
    [self setNavigationButtonItem]; //设置返回按钮
    
 }

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (!self.dataArray.count) {
        [self JLGHttpRequest];
    }else{
        [self updateTableViewNormal];
    }
    if (JLGisLeaderBool && [_recordType isEqualToString:@"1"]) {
        [self.view addSubview:self.containSaveButtonView];
        
    }else{
        _bottomDistance.constant = 0;
        [self.tableView layoutIfNeeded];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.dataArray removeAllObjects];

    [self.addFmNoContactsView hiddenAddFmNocontactsView];
    [self.view endEditing:YES];
    [self.searchBar resignFirstResponder];
}

- (void)JLGHttpRequest{
    [self.dataArray removeAllObjects];
    [self.searchDataArray removeAllObjects];
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    
    //如果是聊天界面进入的，调用v2,如果不是就矫勇fmlist
    NSString *postApi = self.workProListModel?@"v2/Workday/billToGroupMemberList":@"jlworkday/fmlist";
    
    NSDictionary *parameters = self.workProListModel ? @{@"group_id":self.workProListModel.group_id}:nil;
    
    [JLGHttpRequest_AFN PostWithApi:postApi parameters:parameters success:^(NSArray *responseObject) {
        self.dataArray  = [YZGAddForemanModel mj_objectArrayWithKeyValuesArray:responseObject];
        if (self.dataArray.count == 0) {
//            self.delButton.hidden = YES;
            self.rightNavView.hidden = YES;
        }
        self.searchDataArray = [self.dataArray mutableCopy];
        [self contactsSortByDataArray:[self.searchDataArray mutableCopy] needSelected:YES];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 设置searchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    [self.searchDataArray removeAllObjects];
    if (searchText!=nil && searchText.length>0) {
        //增加数据
        NSMutableArray *dataArray = [self.dataArray mutableCopy];
        [dataArray enumerateObjectsUsingBlock:^(YZGAddForemanModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *searchTelephone = [NSString string];
            if ([obj.telph rangeOfString:searchText].location != NSNotFound) {
                searchTelephone = [obj.telph substringToIndex:searchText.length];
            }
            if ([obj.name containsString:searchText] || [searchTelephone isEqualToString:searchText]|| (obj.name.length == 1?[obj.name_pinyin_abbr containsString:[searchText capitalizedString]]:[obj.name_pinyin containsString:[searchText capitalizedString]])) {//汉字，电话，拼音
                [self.searchDataArray addObject:obj];
            }
        }];
        
        [self contactsSortByDataArray:[self.searchDataArray mutableCopy] needSelected:NO];
    }else{
        [self updateTableViewNormal];
    }
    
}

- (void)updateTableViewNormal{
    if (self.dataArray.count == 0) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    self.searchDataArray = [self.dataArray  mutableCopy];
    //去掉选中的数据
    [self.dataArray enumerateObjectsUsingBlock:^(YZGAddForemanModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.telph isEqualToString:weakSelf.addForemanModel.telph]) {
            [weakSelf.searchDataArray removeObject:obj];
        }
    }];
    
    [self contactsSortByDataArray:[weakSelf.searchDataArray mutableCopy] needSelected:YES];
}

- (void)contactsSortByDataArray:(NSMutableArray *)dataArray needSelected:(BOOL )needSelected{//NeedSelected，需要添加选中的数据，YES:需要添加,NO不添加
    if (self.dataArray.count == 0) {//没有数据
        [self showAddFmNoContactsView];
        [self.searchBar resignFirstResponder];
        return ;
    }
    
    [self.indexArray removeAllObjects];
    [self.addressBookArray removeAllObjects];
    
    if (dataArray.count == 0 && [NSString isEmpty:self.addForemanModel.telph]) {
        [self.tableView reloadData];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    __block NSMutableArray *addressBookStringArr = [NSMutableArray array];
    __block NSMutableArray *tmpAddressBookArray = [NSMutableArray array];
    
    if (needSelected) {
        __block NSInteger removeIdx = -1;
        //不需要选中的数据
        [dataArray enumerateObjectsUsingBlock:^(YZGAddForemanModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj.telph isEqualToString:weakSelf.addForemanModel.telph]) {
                [addressBookStringArr addObject:obj.name];
            }else{
                removeIdx = idx;
            }
        }];
        if (removeIdx != -1) {
            [dataArray removeObjectAtIndex:removeIdx];
        }
    }else{
        [dataArray enumerateObjectsUsingBlock:^(YZGAddForemanModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [addressBookStringArr addObject:obj.name];
        }];
    }

    if (!_indexArray) {
        
        self.indexArray = [NSMutableArray array];
    }
    self.indexArray = [TYAddressBook IndexArray:addressBookStringArr];
    if (needSelected && ![NSString isEmpty:self.addForemanModel.name]) {
        [self.indexArray insertObject:@"已选中" atIndex:0];
        self.addForemanModel.isSelected = YES; //标记为当前已选中
        [tmpAddressBookArray addObject:@[self.addForemanModel].mutableCopy];
    }
    
    self.addressBookArray = [self addressBookSortArray:dataArray];
    [self.addressBookArray enumerateObjectsUsingBlock:^(NSArray *addressBookArr, NSUInteger idx, BOOL * _Nonnull stop) {//分组循环
        
        NSMutableArray *cellAddressBookArr = [NSMutableArray array];
        
        [addressBookArr enumerateObjectsUsingBlock:^(YZGAddForemanModel *addressBook, NSUInteger subidx, BOOL * _Nonnull subStop) {
            [dataArray enumerateObjectsUsingBlock:^(YZGAddForemanModel *obj, NSUInteger idx, BOOL *stop) {
                if ([obj.telph isEqualToString:weakSelf.addForemanModel.telph]) {//如果是选中
                    [cellAddressBookArr addObject:weakSelf.addForemanModel];
                    *subStop = YES;
                }else if ([addressBook.telph isEqualToString:obj.telph]) {//没有选中
                    [cellAddressBookArr addObject:obj];
                }
            }];
        }];
        [tmpAddressBookArray addObject:cellAddressBookArr];
    }];
    
    self.addressBookArray = tmpAddressBookArray;
    cellColorIndex = 0;
    
    [self.tableView reloadData];
}

- (void)addContactsBtnClick:(UIButton *)sender {
    JGJSynAddressBookVC *synAddressBookVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSynAddressBookVC"];
    NSMutableArray *addManModels = [NSMutableArray array];
    for (YZGAddForemanModel *addManModel in self.dataArray) {
        NSDictionary *addManDic = [addManModel mj_keyValues];
        [addManModels addObject:addManDic];
    }
    synAddressBookVC.synBillingModels = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:addManModels];
    synAddressBookVC.addressBookAddButtonType = AddressBookAddWorkerButton;
    synAddressBookVC.dataArray = [self.dataArray mutableCopy];
    synAddressBookVC.workProListModel = self.workProListModel;
    
    [self.navigationController pushViewController:synAddressBookVC animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
//    self.addContactsHUBView = nil;
    self.dataArray = nil;
}

- (void)showAddFmNoContactsView{
//    self.navigationItem.rightBarButtonItem = nil;
    [self.addFmNoContactsView showAddFmNoContactsView];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.addressBookArray.count?:1;

    return count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.addressBookArray.count ||self.addressBookArray.count <= section) {
        return 0;
    }
    
    NSArray *dataArr = self.addressBookArray[section];
    return dataArr.count?:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.addressBookArray.count == 0?0:28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (!self.indexArray ||self.indexArray.count <= indexPath.section) {
        return [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    }
    
    YZGAddContactsTableViewCell *cell = [YZGAddContactsTableViewCell cellWithTableView:tableView];
    
    cell.searchValue = self.searchBar.text;
    
    cell.deleteForemanModelBlock = ^(YZGAddForemanModel *addForemanModel){
        [weakSelf deleteContactButtonPressed:addForemanModel indexPath:(NSIndexPath *)indexPath];
    };
    cell.tag = cellColorIndex++;
    YZGAddForemanModel *addForemanModel = self.addressBookArray[indexPath.section][indexPath.row];
    addForemanModel.isDelete = self.isDelete;
    addForemanModel.addForemanModelindexPath = indexPath;
    cell.addForemanModel = addForemanModel;
//    cell.selectedImage.hidden = ![addForemanModel.telph isEqualToString:self.addForemanModel.telph];
    NSArray *contacts = self.addressBookArray[indexPath.section];
    CGFloat lineHeight = (contacts.count - 1 - indexPath.row) == 0 ? 0 : 7;
    cell.lineViewH.constant = lineHeight;
    return cell;
}

#pragma mark - tableViewDelegate
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.indexArray ||self.indexArray.count <= section) {
        return nil;
    }
    
    TLCityHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLCityHeaderView"];
    NSString *title = self.indexArray[section];
    [headerView setTitle:title];
    return headerView;
}

#pragma mark -设置右方表格的索引数组
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return  self.dataArray.count > 8 ? self.indexArray:@[@""];
//}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YZGAddForemanModel *addForemanModel = self.addressBookArray[indexPath.section][indexPath.row];
    [self popToReleaseBillVc:addForemanModel];
}

#pragma mark - 添加通信录联系人
- (void)YZGAddFmNoViewBtnClick:(YZGAddFmNoContactsView *)addFmNoContactsView {
    [self addContactsBtnClick:nil];
}

- (void)popToReleaseBillVc:(YZGAddForemanModel *)addForemanModel{
    if (_modifySelect) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[JGJModifyBillListViewController class]]) {
                JGJModifyBillListViewController *ModifyVC = (JGJModifyBillListViewController *)vc;
                ModifyVC.addForemanModel = addForemanModel;
                [self.navigationController popViewControllerAnimated:YES];

            }
        }
    }else{
//        JGJQRecordViewController *releaseBillVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];

    JGJMarkBillViewController *releaseBillVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    releaseBillVc.addForemanModel = addForemanModel;
//    releaseBillVc.addForemandataArray = [self.dataArray mutableCopy];
//    [releaseBillVc ModifySalaryTemplateData];
    [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}
#pragma mark - 排序
-(NSMutableArray*)addressBookSortArray:(NSArray <YZGAddForemanModel *>*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    NSMutableArray *tempStringArray = [NSMutableArray array];
    [tempArray enumerateObjectsUsingBlock:^(TYAddressBook *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [stringArr enumerateObjectsUsingBlock:^(YZGAddForemanModel * _Nonnull addForemanModel, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isSame = [obj.string isEqualToString:addForemanModel.name];
            if (isSame) {
                [tempStringArray addObject:addForemanModel];
            }
        }];
    }];
    
    //去重
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [tempStringArray count]; i++){
        if ([categoryArray containsObject:[tempStringArray objectAtIndex:i]] == NO){
            [categoryArray addObject:[tempStringArray objectAtIndex:i]];
        }
    }
    
    NSMutableArray *addressBookResult=[NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString ;
    //拼音分组
    for (NSInteger idx = 0; idx < tempArray.count; idx++) {
        TYAddressBook *object = tempArray[idx];
        
        NSString *pinyin;
        if ([NSString isEmpty:object.pinYin]) {
            pinyin = @"";
        }else{
            pinyin = [object.pinYin substringToIndex:1];
        }
        //不同 2.1.0-yj源代码开始 ****
        //if(![tempString isEqualToString:pinyin] && categoryArray.count > 0 && item.count > 0)
//        2.1.0-yj源代码结束 ****
        //不同
        if(![tempString isEqualToString:pinyin] && categoryArray.count > 0)
        {
            //分组
            item = [NSMutableArray array];
            [item  addObject:categoryArray[idx]];
            [addressBookResult addObject:item];
            //遍历
            tempString = pinyin;
        }else//相同
        {
            if (categoryArray.count > 0) {
                 [item  addObject:categoryArray[idx]];
            }
        }
    }
    
    return addressBookResult;
}

//返回通讯录的汉字对应的拼音
-(NSMutableArray*)ReturnSortChineseArrar:(NSArray <YZGAddForemanModel *>*)stringArr
{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    
    for(int i=0;i<[stringArr count];i++)
    {
        TYAddressBook *addressBookString=[[TYAddressBook alloc]init];
        YZGAddForemanModel *addForeman = stringArr[i];
        addressBookString.string = [NSString stringWithString:addForeman.name];
        
        if(addressBookString.string==nil){
            addressBookString.string=@"";
        }
        
        //去除两端空格和回车
        addressBookString.string  = [addressBookString.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        NSString *initialStr = [addressBookString.string length]?[addressBookString.string substringToIndex:1]:@"";
        if ([predicate evaluateWithObject:initialStr])
        {
            //首字母大写
            addressBookString.pinYin = [addressBookString.string capitalizedString] ;
        }else{
            if(![addressBookString.string isEqualToString:@""]){
                NSString *pinYinResult = [NSString string];
                for(int j = 0;j < addressBookString.string.length;j++){
                    NSString *shorString = [addressBookString.string substringWithRange:NSMakeRange(j, 1)];
                    NSString *singlePinyinLetter = [TYAddressBook firstCharactor:shorString];
                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                addressBookString.pinYin = pinYinResult;
            }else{
                addressBookString.pinYin=@"";
            }
        }
        [chineseStringsArray addObject:addressBookString];
    }
    
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    return chineseStringsArray;
    
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    TYLog(@"%@-%ld",title,(long)index);
    
    return index;
}

#pragma mark - 显示中间的字母
- (void)scrollViewDidScroll:(UITableView *)tableView {
    if (tableView.visibleCells.count == 0) return;
    
    YZGAddContactsTableViewCell *cell = tableView.visibleCells[0];
    if (cell.addForemanModel.name_pinyin_abbr.length >= 1) {
        self.centerShowLetter.text = [cell.addForemanModel.name_pinyin_abbr substringToIndex:1].uppercaseString;
    }
    self.centerShowLetter.hidden = self.indexArray .count < ShowCount;
    self.sectionIndexView.hidden = self.indexArray .count < ShowCount;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.centerShowLetter.hidden = self.indexArray .count < ShowCount;
    self.sectionIndexView.hidden = self.indexArray .count < ShowCount;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.centerShowLetter.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.centerShowLetter.hidden = !decelerate;
}

#pragma mark - 懒加载
- (YZGAddFmNoContactsView *)addFmNoContactsView
{
    if (!_addFmNoContactsView) {
        _addFmNoContactsView = [[YZGAddFmNoContactsView alloc] initWithFrame:TYSetRect(0, 65, TYGetUIScreenWidth, TYGetUIScreenHeight - 65)];
        _addFmNoContactsView.delegate = self;
        [_addFmNoContactsView addSubview:self.newPlaceView];
    }
    return _addFmNoContactsView;
}

- (NSMutableArray<YZGAddForemanModel *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray<YZGAddForemanModel *> *)searchDataArray
{
    if (!_searchDataArray) {
        _searchDataArray = [[NSMutableArray alloc] init];
    }
    return _searchDataArray;
}

//- (NSMutableArray *)indexArray
//{
//    if (!_indexArray) {
//        _indexArray = [[NSMutableArray alloc] init];
//    }
//    return _indexArray;
//}

- (NSMutableArray *)addressBookArray
{
    if (!_addressBookArray) {
        _addressBookArray = [[NSMutableArray alloc] init];
    }
    return _addressBookArray;
}

- (YZGAddForemanModel *)addForemanModel
{
    if (!_addForemanModel) {
        _addForemanModel = [[YZGAddForemanModel alloc] init];
    }
    return _addForemanModel;
}

- (UILabel *)centerShowLetter {
    if (!_centerShowLetter) {
        
        _centerShowLetter = [[UILabel alloc] init];
        _centerShowLetter.hidden = YES;
        _centerShowLetter.textColor = [UIColor whiteColor];
        _centerShowLetter.textAlignment = NSTextAlignmentCenter;
        _centerShowLetter.font = [UIFont systemFontOfSize:30];
        _centerShowLetter.frame = CGRectMake(0, 0, 55, 55);
        _centerShowLetter.center = self.view.center;
        _centerShowLetter.clipsToBounds = YES;
        _centerShowLetter.layer.cornerRadius = TYGetViewW(_centerShowLetter)  / 2;
        _centerShowLetter.backgroundColor = [UIColor orangeColor];
    }
    return _centerShowLetter;
}

- (void)setIndexArray:(NSMutableArray *)indexArray {
    _indexArray = indexArray;
    if (_indexArray.count > ShowCount ) {
        if (!self.sectionIndexView) {
            [self creatTableIndexView];
        }
        BOOL isShow = _indexArray.count  > ShowCount? NO:YES; //搜索时隐藏所以
        self.sectionIndexView.hidden = isShow;
        [self.sectionIndexView reloadItemViews];
    }else {
        
        self.sectionIndexView.hidden = YES;
    }
}

#pragma Mark - 创建右边索引
- (void)creatTableIndexView {
    
    _sectionIndexView = [[DSectionIndexView alloc] init];
    _sectionIndexView.frame = CGRectMake(TYGetUIScreenWidth - kSectionIndexWidth - IndexPadding, OffsetY, kSectionIndexWidth, TYGetUIScreenHeight - OffsetY * 3);
    [_sectionIndexView setBackgroundViewFrame];
    _sectionIndexView.backgroundColor = [UIColor whiteColor];
    _sectionIndexView.dataSource = self;
    _sectionIndexView.delegate = self;
    _sectionIndexView.isShowCallout = NO;
    _sectionIndexView.calloutViewType = CalloutViewTypeForUserDefined;
    _sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
    _sectionIndexView.calloutMargin = 100.f;
    if (self.sectionIndexView) {
        [self.sectionIndexView removeFromSuperview];
        [self.view addSubview:self.sectionIndexView];
    }
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.indexArray.count;
}

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section
{
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    itemView.titleLabel.text = [self.indexArray objectAtIndex:section];
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
    label.text = [self.indexArray objectAtIndex:section];
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

- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section {
    return [self.indexArray objectAtIndex:section];
}

- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    __weak typeof(self) weakSelf  = self;
    self.centerShowLetter.text = self.indexArray[section];
    self.centerShowLetter.hidden = NO;
    sectionIndexView.touchCancelBlock = ^(DSectionIndexView *sectionIndexView, BOOL isTouchCancel){
        //        延时的目的是当touch停止的时候还会滚动一小段时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.centerShowLetter.hidden = isTouchCancel;
        });
    };
}

#pragma mark - 设置导航栏按钮
- (void)setNavigationButtonItem {
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIView *rightNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    self.rightNavView = rightNavView;
    UIButton *addButton = [[UIButton alloc] init];
    self.addButton = addButton;
    [addButton addTarget:self action:@selector(addContactsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"RecordWorkpoints_AddFmNoAdd"] forState:UIControlStateNormal];
    [rightNavView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 20));
        make.centerY.mas_equalTo(rightNavView);
        make.right.mas_equalTo(rightNavView.mas_right);
    }];
    UIButton *delButton = [[UIButton alloc] init];
    self.delButton = delButton;
    if (!self.workProListModel) {//不是聊天界面进入的时候才添加删除
        [delButton addTarget:self action:@selector(rightBarDeleteButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [delButton setTitle:@"删除" forState:UIControlStateNormal];
        [delButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
        [rightNavView addSubview:delButton];
        [delButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 20));
            make.centerY.mas_equalTo(rightNavView);
            make.right.mas_equalTo(addButton.mas_left);
        }];
        
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavView];
}

#pragma mark - 删除按钮按下
- (void)rightBarDeleteButtonItemPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isDelete = sender.selected;
    NSString *buttonTitle = sender.selected ? @"取消" : @"删除";
    [sender setTitle:buttonTitle forState:UIControlStateNormal];
    
//    if (sender.selected) {
//        
//        self.addButton.hidden = YES;
//        self.BottomButton.height = 0;
//    }else {
//        
//        self.addButton.hidden = NO;
//        self.BottomButton.height = 45;
//    }
    
    [self.tableView reloadData];
}

#pragma mark - 删除联系人按钮按下
- (void)deleteContactButtonPressed:(YZGAddForemanModel  *)addForemanModel indexPath:(NSIndexPath *)indexPath {
    NSString *title = [NSString stringWithFormat:@"确定要删除 %@ 吗?", addForemanModel.name];
    __weak typeof(self) weakSelf = self;
    CustomAlertView *alertView = [CustomAlertView showWithMessage:title leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
    alertView.onOkBlock = ^{
        [weakSelf deleteServiceContactMdoel:addForemanModel indexPath:indexPath];
    };
}

#pragma mark - 删除服务器数据
- (void)deleteServiceContactMdoel:(YZGAddForemanModel  *)addForemanModel indexPath:(NSIndexPath *)indexPath {
    NSString *uid = [NSString stringWithFormat:@"%@", @(addForemanModel.uid)];
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/delfm" parameters:@{@"partner" : uid ?:[NSNull null]} success:^(id responseObject) {
        
        //删除当前选中的模型时
        if ([self.addForemanModel.telph isEqualToString:addForemanModel.telph] && self.addForemanModel.isSelected) {
            
            self.addForemanModel = nil;
        }
        
        [self deleteLocalContactModel:addForemanModel indexPath:indexPath];
    } failure:^(NSError *error) {
//        [TYShowMessage  showError:@"删除联系人失败"];
    }];
}

#pragma mark - 删除本地静态数据
- (void)deleteLocalContactModel:(YZGAddForemanModel  *)addForemanModel indexPath:(NSIndexPath *)indexPath {
//    NSArray *addressBookModels = self.addressBookArray.copy;
//    for (int idx = 0; idx < addressBookModels.count; idx ++) {
//        NSMutableArray *contacts = addressBookModels[idx];
//        NSArray *copyContacts = contacts.copy;
//        for (YZGAddForemanModel *foremanModel in copyContacts) {
//            if ([addForemanModel.telph isEqualToString:foremanModel.telph]) {
//                [contacts removeObject:addForemanModel];
//                if (contacts.count == 0) {
//                    [self.indexArray removeObjectAtIndex:idx];
//                     [self.addressBookArray removeObjectAtIndex:idx];
//                }
//                [self.dataArray removeObject:foremanModel];
//            }
//        }
//    }
//    if (self.dataArray.count == 0) {
//        [self.addFmNoContactsView showAddFmNoContactsView];
//    }
//    
//    //人数是0不显示删除按钮
//    if (self.dataArray.count == 0) {
//        [self.delButton setTitle:@"删除" forState:UIControlStateNormal];
//        self.delButton.hidden = YES;
//    }
//    [self.tableView reloadData];
    
    //这里原打算不请求网络、发版前发现删除人员显示有问题
    [self JLGHttpRequest];
}

- (void)backButtonPressed:(UIButton *)sender {
//    YZGMateReleaseBillViewController *releaseBillVc = nil;
//    if (self.dataArray.count == 0) {
//        for (UIViewController *vc in self.navigationController.viewControllers) {
//            if ([vc isKindOfClass:[YZGMateReleaseBillViewController class]]) {
//                releaseBillVc = (YZGMateReleaseBillViewController *)vc;
//                YZGAddForemanModel *addForemanModel = [[YZGAddForemanModel alloc] init];
//                [self popToReleaseBillVc:addForemanModel];
//                [releaseBillVc ModifySalaryTemplateData];
//                continue;
//            }
//        }
//    }else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    [self popToReleaseBillVc:self.addForemanModel];
    
//    [self.navigationController popViewControllerAnimated:YES];

}
//添加记多人的按钮
- (UIButton *)BottomButton
{
    if (!_BottomButton) {
        //添加保存按钮
        _BottomButton = [[UIButton alloc] init];
        [self.containSaveButtonView addSubview:_BottomButton];
        _BottomButton.backgroundColor = JGJMainColor;
        _BottomButton.titleLabel.textColor = [UIColor whiteColor];
        [_BottomButton setTitle:@"我要给多个人记账" forState:UIControlStateNormal];
        [_BottomButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_BottomButton addTarget:self action:@selector(jumpMorepeopleVC) forControlEvents:UIControlEventTouchUpInside];
        [_BottomButton setFrame:CGRectMake(10, CGRectGetHeight(_containSaveButtonView.frame)+10, TYGetUIScreenWidth - 20, 45)];
    }
    return _BottomButton;
}

- (UIView *)containSaveButtonView {
    if (!_containSaveButtonView) {
        _containSaveButtonView = [[UIView alloc] init];
        _containSaveButtonView.backgroundColor = AppFontfafafaColor;
        [self.view addSubview:_containSaveButtonView];
        [_containSaveButtonView addSubview:self.BottomButton];
        [_containSaveButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@63);
            make.left.right.bottom.equalTo(self.view);
        }];
        UIView *lineViewTop = [[UIView alloc] init];
        lineViewTop.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:lineViewTop];
        [lineViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.equalTo(_containSaveButtonView);
            make.height.equalTo(@1);
        }];
        UIView *lineViewBottom = [[UIView alloc] init];
        lineViewBottom.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:lineViewBottom];
        [lineViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(_containSaveButtonView);
            make.height.equalTo(@1);
        }];
    }
    return _containSaveButtonView;
}

-(void)jumpMorepeopleVC
{
   
   
    [self getpro];
}
-(void)getpro{

    [JLGHttpRequest_AFN PostWithNapi:@"group/forman-group-list" parameters:nil success:^(NSArray * responseObject) {
        if (responseObject.count) {
            JGJTeamWorkListViewController *workList = [[JGJTeamWorkListViewController alloc]init];
            [self.navigationController pushViewController:workList animated:YES];
        }else{
//            JGJShowHubView *showHub = [[JGJShowHubView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
//            [[[UIApplication sharedApplication]keyWindow]addSubview:showHub];
            
            
            
            JGJCustomAlertView *customAlertView = [JGJCustomAlertView customAlertViewShowWithMessage:@"创建班组\n就可以使用批量记工记账"];
            customAlertView.message.font = [UIFont systemFontOfSize:AppFont34Size];
            customAlertView.onClickedBlock = ^{
//                 [alertView removeFromSuperview];
//                CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
//                [alertView showProgressImageView];
//                
//                [JLGHttpRequest_AFN PostWithApi:@"jlworksync/syncpro" parameters:parameters success:^(NSDictionary *responseObject) {
//                    [alertView showSuccessImageView];
//                    alertView.onOkBlock = ^{
//                        [weakSelf.navigationController popViewControllerAnimated:YES];
//                    };
//                    [weakSelf.tableView reloadData];
//                }failure:^(NSError *error) {
//                    [alertView removeFromSuperview];
//                    [TYShowMessage showPlaint:@"同步失败!"];
//                }];
            };

        }
           }failure:^(NSError *error) {
    }];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setIndexArray:nil];
    [self setSectionIndexView:nil];
    [super viewDidUnload];
}

- (UIButton *)NewButton
{
    if (!_NewButton) {
        _NewButton = [[UIButton alloc] init];
//        [self.containSaveButtonView addSubview:_BottomButton];
        _NewButton.backgroundColor = JGJMainColor;
        _NewButton.titleLabel.textColor = [UIColor whiteColor];
        [_NewButton setTitle:@"我要给多个人记账" forState:UIControlStateNormal];
        [_NewButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_NewButton addTarget:self action:@selector(jumpMorepeopleVC) forControlEvents:UIControlEventTouchUpInside];
        [_NewButton setFrame:CGRectMake(10, 9, TYGetUIScreenWidth - 20, 45)];
    }
    return _NewButton;
}



-(UIView *)newPlaceView
{
    if (!_newPlaceView) {
        _newPlaceView = [[UIView alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 127, TYGetUIScreenWidth, 63)];
        _newPlaceView.backgroundColor = AppFontfafafaColor;
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, .5)];
        lable.backgroundColor = AppFontdbdbdbColor;
        [_newPlaceView addSubview:lable];
        [_newPlaceView addSubview:self.NewButton];
        
    }
    return _newPlaceView;
}


@end
