//
//  JLGSearchViewController.m
//  mix
//
//  Created by jizhi on 15/12/23.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGSearchViewController.h"
#import "CALayer+SetLayer.h"
#import "GeoSearchTableViewCell.h"
#import "UITableViewCell+Extend.h"
#import "GeoSearchingTableViewCell.h"
#import "TYTextField.h"
#import "UIView+GNUtil.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"

#import "JGJSelProAddressPopView.h"

#import "JGJGroupMangerVC.h"

#import "NSString+Extend.h"

@interface JLGSearchViewController ()
<
    BMKPoiSearchDelegate//poi
>
{
    BMKPoiSearch* _poisearch;
    BOOL _isSearching;//是否正在搜索,YES:正在搜索，NO:没有搜索
    GeoSearchingTableViewCell *_searchingTableViewCell;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic,strong) NSMutableArray *datasArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *searchBarTF;

@property (weak, nonatomic) IBOutlet UILabel *proNameLable;

@property (weak, nonatomic) IBOutlet UIView *proNameBackgroundView;

@property (strong, nonatomic) JGJProAddressModel *proAddressModel;

//搜索时间控制
@property (strong, nonatomic) NSTimer *searchTimer;

@end

@implementation JLGSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"项目地址";
    
    self.proNameLable.textColor = AppFont999999Color;
    
    self.proNameLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    self.proNameLable.text = [NSString stringWithFormat:@" 请为 %@ 设置项目地址", self.proName];
    
    self.proNameLable.textColor = AppFont999999Color;
    
    self.proNameBackgroundView.backgroundColor = AppFontf1f1f1Color;
    
    [self.proNameLable markText:self.proName withColor:AppFont333333Color];
    
    self.searchBarTF.layer.borderWidth = 0;
    self.searchBarTF.layer.cornerRadius = 3;
    self.searchBarTF.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    self.searchBarTF.backgroundColor = TYColorHex(0Xf3f3f3);
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;

    self.searchBarTF.maxLength = 20;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-icon"]];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.width = 33;
    searchIcon.height = 33;
    
    self.searchBarTF.placeholder = @"请搜索项目详细地址";
    
    self.searchBarTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchBarTF.leftView = searchIcon;
    __weak typeof(self) weakSelf = self;
    
    _isSearching = NO;
    
    self.searchBarTF.valueDidChange = ^(NSString *value){
        
        [weakSelf searchValueChange:value];
        
    };
    
    
//    //项目特定需要，设置边框
//    UITextField *searchTextField = [[[self.searchBar.subviews firstObject] subviews] lastObject];
//    [searchTextField.layer setLayerBorderWithColor:TYColorHex(0xd9d9d9) width:1.0 radius:4.0];
//
//    //去掉背景
//    [[[[self.searchBar.subviews firstObject] subviews] firstObject]removeFromSuperview];
    //设置数据数组
    self.datasArray = [NSMutableArray array];
    
    _isSearching = NO;
    _searchingTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"GeoSearchingTableViewCell" owner:nil options:nil] firstObject];
    self.topView.backgroundColor = [UIColor whiteColor];

}

#pragma mark - 设置searchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if (searchText!=nil && searchText.length>0) {
        [self updatePoiSearch:searchText];
    }else
    {
        [self.datasArray removeAllObjects];
        [self.tableView reloadData];
    }
    
}

- (void)searchValueChange:(NSString *)value {
    
    if (![NSString isEmpty:value]) {
        
        [self updatePoiSearch:value];
        
        [self searchTimer];
        
    }else {
        
        [_searchingTableViewCell activityViewStopAnimating];
        
        _isSearching = NO;
        
        [self.datasArray removeAllObjects];
        
        [self stopSearchLocation];

    }
}

#pragma mark - Poi
-(void)updatePoiSearch:(NSString *)searchText{
    _isSearching = YES;
    [_searchingTableViewCell activityViewStartAnimating];
    [self.tableView reloadData];
    
    if (!_poisearch) {
        //初始化geo
        _poisearch = [[BMKPoiSearch alloc]init];
        _poisearch.delegate = self;
    }
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    
    NSString *cityName = self.searchName;
    
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city = cityName;
    citySearchOption.keyword = searchText;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        TYLog(@"城市内检索发送成功");
    }
    else
    {
        TYLog(@"城市内检索发送失败");
    }
}

#pragma mark poiDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        TYLog(@"Poi检索成功");
        
        [self.datasArray removeAllObjects];
        
        self.datasArray =  [result.poiInfoList mutableCopy];
        
        _isSearching = NO;
        [_searchingTableViewCell activityViewStopAnimating];
        
        [self.tableView reloadData];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        TYLog(@"Poi检索起始点有歧义");
    } else if(error == BMK_SEARCH_PERMISSION_UNFINISHED){
        TYLog(@"Poi鉴权有问题 error = %@",@(error));
    } else{
        TYLog(@"Poi的其他情况 error = %@",@(error));
    }
    
    
}

- (NSTimer *)searchTimer {
    
    if (!_searchTimer) {
        
        // 调用了scheduledTimer返回的定时器，已经自动被添加到当前runLoop中，而且是NSDefaultRunLoopMode
        _searchTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopSearchLocation) userInfo:nil repeats:YES];
        
        // 修改模式
        [[NSRunLoop currentRunLoop] addTimer:_searchTimer forMode:NSRunLoopCommonModes];
    }
    
    return _searchTimer;
}

- (void)stopSearchLocation {

    if (self.datasArray.count == 0) {
        
        _isSearching = NO;
        
        [_searchTimer invalidate];
        
        _searchTimer = nil;
        
        [_searchingTableViewCell activityViewStopAnimating];
        
        [self.datasArray removeAllObjects];
        
        [self.tableView reloadData];
    }
}

#pragma mark - 设置tableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count;
    
    if (_isSearching) {
        
        count = 1;
        
    }else{
        
        count = self.datasArray.count;
        
        if (count == 0 && ![NSString isEmpty:self.searchBarTF.text]) {
            
            count = 1;
            
        }
        
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //去掉了加载动画
    if (_isSearching) {//正在搜索
        return _searchingTableViewCell;
    }
    
    UITableViewCell *cell = [JGJTSearchProAddressDefaultCell cellWithTableView:tableView];
    
    if ((self.datasArray.count == 0 && ![NSString isEmpty:self.searchBarTF.text]) && !_isSearching) {
        
        JGJTSearchProAddressDefaultCell *defaultCellcell = (JGJTSearchProAddressDefaultCell *)cell;
        
        defaultCellcell.proAddressModel = self.proAddressModel;
        
    } else {
    
        GeoSearchTableViewCell *searchResultcell = [GeoSearchTableViewCell cellWithTableView:tableView];
        
        if (self.datasArray.count > 0) {
            
            BMKPoiInfo *poiInfo = self.datasArray[indexPath.row];
            
            searchResultcell.searchTextLabel.text = poiInfo.name;
            searchResultcell.searchDetailTextLabel.text = poiInfo.address;
            
            searchResultcell.lineView.hidden = self.datasArray.count - 1 == indexPath.row;
        }
    
        cell = searchResultcell;
        
    }
    
    return cell;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 64;
    
    if ((self.datasArray.count == 0 && ![NSString isEmpty:self.searchBarTF.text]) || _isSearching) {
        
        height = 64;
        
    } else {
        
        BMKPoiInfo *poiInfo = self.datasArray[indexPath.row];
        
        height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 20 content:poiInfo.address font:AppFont30Size] + 45;
        
        height = height < 64 ? 64 : height;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSearching) {
        return ;
    }
    
    JGJProAddressModel *addressModel = [JGJProAddressModel new];
    
    if (self.datasArray.count == 0) {
    
        addressModel.addressTitle = self.proName;
        
        addressModel.addressDetailTitle = self.searchBarTF.text;
        
        [self handleSelSearchAddress:addressModel];
        
    }else {
    
        BMKPoiInfo *poiInfo = self.datasArray[indexPath.row];
        NSString *location = [NSString stringWithFormat:@"%.6f,%.6f",poiInfo.pt.longitude,poiInfo.pt.latitude];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchVcSelectLocation:addressName:)]) {
            [self.delegate searchVcSelectLocation:location addressName:poiInfo.name];
        }
        
        addressModel.addressTitle = self.proName;
        
        addressModel.addressDetailTitle = poiInfo.address;

        [self handleSelSearchAddress:addressModel];
        
    }
    
}

#pragma mark - 结束编辑

- (IBAction)backBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchVcCancel)]) {
        [self.delegate searchVcCancel];
    }
}

-(void)dealloc{
    if (_poisearch.delegate) {
        _poisearch.delegate = nil;
    }
    
    if (_poisearch) {
        _poisearch = nil;
    }
    
    [_searchTimer invalidate];
    
    _searchTimer = nil;
}

- (JGJProAddressModel *)proAddressModel {

    if (!_proAddressModel) {
        
        _proAddressModel = [JGJProAddressModel new];
        
        _proAddressModel.addressTitle = @"未找到该地址，可能是该地址还未被收录";
        
        _proAddressModel.addressDetailTitle = @"如是项目实际地址，请直接选择使用";
    }

    return _proAddressModel;
}

- (void)handleSelSearchAddress:(JGJProAddressModel *)addressModel  {

     [self.view endEditing:YES];
    
    self.searchAddressModel = addressModel;
    
    JGJTeamMemberCommonModel *addressCommonModel = [JGJTeamMemberCommonModel new];
    
    addressCommonModel.alertmessage = addressModel.addressDetailTitle;
    
    addressCommonModel.headerTitle = addressModel.addressTitle;
    
    JGJSelProAddressPopView *addressPopView = [JGJSelProAddressPopView selProAddressPopViewWithCommonModel:addressCommonModel];
    
    __weak typeof(self) weakSelf = self;
    addressPopView.handleSelProAddressPopViewBlock = ^(JGJSelProAddressPopView *popView) {
      
        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJGroupMangerVC class]]) {
                
                JGJGroupMangerVC *groupMangerVC = (JGJGroupMangerVC *)vc;
                
                groupMangerVC.proDetailAddress = addressModel.addressDetailTitle;
                
                [weakSelf.navigationController popToViewController:groupMangerVC animated:YES];
                
                break;
                
            }
            
        }
        
    };
    
}

@end
