//
//  JGJNotepadListViewController.m
//  mix
//
//  Created by Tony on 2018/4/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNotepadListViewController.h"
#import "JGJNotepadListEmptyView.h"
#import "TYTextField.h"
#import "JGJNotepadListCell.h"
#import "MJRefresh.h"
#import "JGJAddNewNotepadViewController.h"
#import "JGJNotepadListModel.h"
#import "JGJNotepadDetailInfoViewController.h"
#import "JGJCommonButton.h"
#import "JGJNotePadListCanlederController.h"
#import "JGJRefreshTableView.h"
@interface JGJNotepadListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
    NSMutableArray *_notepadListArr;
    NSMutableArray *_searchListArr;
    NSInteger _pageSize;
    NSString *_searchKey;
    NSString *_didChangeSearchKey;
    BOOL _isStartSearchingState;// 是否是搜索状态
    UIView *_allline;
    
    NSString *_beforeTimeStr;// 用于分组判断，如果下一个cell的时间和上一个相同，则header高度变为10，不显示时间
    NSMutableArray *_isShowTimeStrArr;// 用于分组判断，如果下一个cell的时间和上一个相同，则header高度变为10，不显示时间，否则为50 显示时间
    
}
@property (nonatomic, strong) JGJNotepadListEmptyView *emptyView;
@property (nonatomic, strong) UITableView *noteListTable;
@property (nonatomic, strong) UIButton *createNewNote;

@property (nonatomic, strong) JGJCustomSearchBar *searchbar;
@property (nonatomic, strong) JGJFooterViewInfoModel *footerInfoModel;

@end

@implementation JGJNotepadListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"记事本";
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self createRightItem];
    _beforeTimeStr = @"";
    _isStartSearchingState = NO;
    _isShowTimeStrArr = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheNotepadList) name:@"refreshTheNotepadList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneDayRefreshTheNotepadList) name:@"OneDayControllerRefreshTheNotepadList" object:nil];
    
    _pageSize = 1;
    _searchKey = @"";
    
    UIView *allline = [[UIView alloc] init];
    allline.backgroundColor = AppFontdbdbdbColor;
    [self.view addSubview:allline];
    [allline mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(20);
        make.top.bottom.mas_equalTo(@0);
        make.width.mas_equalTo(2);
    }];
    _allline = allline;
    _allline.hidden = YES;
    
    
    [self initializeAppearance];
    
    [self.noteListTable.mj_header beginRefreshing];
    
}

- (void)createRightItem {
    
    
    JGJCommonButton *rightBtn = [[JGJCommonButton alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [rightBtn setTitle:@"日历" forState:UIControlStateNormal];
    
    [rightBtn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    [rightBtn setImage:[UIImage imageNamed:@"notePadListCanleder"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"notePadListCanleder"] forState:UIControlStateHighlighted];
    
    [rightBtn addTarget:self action:@selector(notePadListCalendar) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

// 记事本日历界面
- (void)notePadListCalendar {
    
    JGJNotePadListCanlederController * canlederVC = [[JGJNotePadListCanlederController alloc] init];
    [self.navigationController pushViewController:canlederVC animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.searchbar];
    [self.view addSubview:self.noteListTable];
    [self.view addSubview:self.createNewNote];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    _noteListTable.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 48).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    _createNewNote.sd_layout.rightSpaceToView(self.view, 10).bottomSpaceToView(self.view, 25).widthIs(80).heightIs(80);
}

- (void)refreshTheNotepadList {
    
    _searchKey = @"";
    _isStartSearchingState = NO;
    [self.noteListTable.mj_header beginRefreshing];
}

- (void)oneDayRefreshTheNotepadList {
    
    _searchKey = @"";
    _isStartSearchingState = NO;
    [self.noteListTable.mj_header beginRefreshing];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)NodepadlistRequst {
    
    _pageSize = 1;
    [self loadDataWithPage:_pageSize content_key:_searchKey];
}

- (void)NodepadlistLoadMoreRequst {
    
    _pageSize ++;
    [self.noteListTable.mj_footer  beginRefreshing];
    [self loadDataWithPage:_pageSize content_key:_searchKey];
}

#pragma mark - method
// 加载数据
- (void)loadDataWithPage:(NSInteger)page content_key:(NSString *)content_key{
    
    NSDictionary *param = @{@"content_key":_searchKey?:@"",
                            @"pg":@(_pageSize),
                            @"pagesize":@(20)
                            };
    
    [JLGHttpRequest_AFN PostWithNapi:@"notebook/get-list" parameters:param success:^(id responseObject) {

        // 第一页数据
        if (_pageSize == 1) {

            // 搜索条件为空
            if (_searchKey.length == 0) {

                [_notepadListArr removeAllObjects];

                _notepadListArr = [JGJNotepadListModel mj_objectArrayWithKeyValuesArray:responseObject];

            }else {

                [_searchListArr removeAllObjects];

                _searchListArr = [JGJNotepadListModel mj_objectArrayWithKeyValuesArray:responseObject];

            }
            [_noteListTable.mj_header endRefreshing];

        }else {

            if (_searchKey.length == 0) {

                [_notepadListArr addObjectsFromArray:[JGJNotepadListModel mj_objectArrayWithKeyValuesArray:responseObject]];
                
            }else {

                [_searchListArr addObjectsFromArray:[JGJNotepadListModel mj_objectArrayWithKeyValuesArray:responseObject]];
            }
            [_noteListTable.mj_footer endRefreshing];
        }


        // 正常状态
        if (!_isStartSearchingState) {

            if (_notepadListArr.count == 0) {

                _allline.hidden = YES;
                _searchbar.hidden = YES;
                [self.emptyView setEmptyImage:@"notepad_quesheng" emptyText:@"开始记录你的生活吧..."];
                self.emptyView.recordLabel.font = [UIFont systemFontOfSize:AppFont36Size];
                self.emptyView.recordLabel.textColor = [UIColor blackColor];

                [_searchbar mas_updateConstraints:^(MASConstraintMaker *make) {

                    make.height.mas_equalTo(0);
                }];

                _noteListTable.sd_layout.topSpaceToView(self.view, 0);

                [_noteListTable updateLayout];
                self.emptyView.frame = _noteListTable.bounds;
                _noteListTable.tableHeaderView = _emptyView;

            }else {

                _allline.hidden = NO;
                _searchbar.hidden = NO;
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
                _noteListTable.tableHeaderView = view;

                [_searchbar mas_updateConstraints:^(MASConstraintMaker *make) {

                    make.height.mas_equalTo(48);
                }];
                _noteListTable.sd_layout.topSpaceToView(self.view, 48);
            }

        }else {// 搜索状态

            if (_searchListArr.count == 0) {

                _allline.hidden = YES;
                [self.emptyView setEmptyImage:@"NoDataDefault_NoManagePro" emptyText:@"未搜索到相关内容"];
                self.emptyView.recordLabel.font = [UIFont systemFontOfSize:AppFont34Size];
                self.emptyView.recordLabel.textColor = AppFontccccccColor;
                [_searchbar mas_updateConstraints:^(MASConstraintMaker *make) {

                    make.height.mas_equalTo(48);
                }];

                _noteListTable.sd_layout.topSpaceToView(self.view, 48);
                [_noteListTable updateLayout];
                self.emptyView.frame = _noteListTable.bounds;
                _noteListTable.tableHeaderView = _emptyView;

            }else {

                _allline.hidden = NO;
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
                _noteListTable.tableHeaderView = view;

                [_searchbar mas_updateConstraints:^(MASConstraintMaker *make) {

                    make.height.mas_equalTo(48);
                }];

                _noteListTable.sd_layout.topSpaceToView(self.view, 48);
            }

        }

        if (!_isStartSearchingState) {

            [self manageTheIsShowTimeStrArrWithArr:_notepadListArr];

        }else {

            [self manageTheIsShowTimeStrArrWithArr:_searchListArr];
        }
        
        // 底部添加 提示
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSArray *list = (NSArray *)responseObject;
            
            if (list.count < 20) {
                
                UIView *footerView = [self.noteListTable setFooterViewInfoModel:self.footerInfoModel];
                
                self.noteListTable.tableFooterView = footerView;
                
                MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.noteListTable.mj_footer;
                
                footer.stateLabel.hidden = YES;
                
                [footer endRefreshingWithNoMoreData];
                
                
            }else {
                
                
                self.noteListTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
                
                MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.noteListTable.mj_footer;
                
                footer.stateLabel.hidden = NO;
                
                [footer resetNoMoreData];
            }
        }

        [_noteListTable reloadData];

    } failure:^(NSError *error) {

        [_noteListTable.mj_header endRefreshing];
        [_noteListTable.mj_footer endRefreshing];

    }];
}

- (void)manageTheIsShowTimeStrArrWithArr:(NSMutableArray *)arr {
    
    _isShowTimeStrArr = [NSMutableArray new];
    for (int i = 0; i < arr.count; i ++) {
        
        JGJNotepadListModel *model = arr[i];
        NSArray *yearMDArr = [model.publish_time componentsSeparatedByString:@"-"];
        if (i == 0) {
            
            _beforeTimeStr = [NSString stringWithFormat:@"%@年%@月%@日 %@",yearMDArr[0],yearMDArr[1],yearMDArr[2],model.weekday];
            
            [_isShowTimeStrArr addObject:@"显示"];
            
        }else {
            
            NSString *thisTimeStr = [NSString stringWithFormat:@"%@年%@月%@日 %@",yearMDArr[0],yearMDArr[1],yearMDArr[2],model.weekday];
            if ([_beforeTimeStr isEqualToString:thisTimeStr]) {
                
                [_isShowTimeStrArr addObject:@"隐藏"];
                
            }else {
                
                [_isShowTimeStrArr addObject:@"显示"];
            }
            _beforeTimeStr = thisTimeStr;
        }
    }
}

- (void)createNewNoteBtnClick {
    
    JGJAddNewNotepadViewController *addController = [[JGJAddNewNotepadViewController alloc] init];
    addController.orignalImgArr = [[NSMutableArray alloc] init];
    _searchKey = @"";
    [self presentViewController:addController animated:YES completion:nil];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_searchKey.length == 0) {
        
        return _notepadListArr.count;
    }else {
        
        return _searchListArr.count;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGJNotepadListCell *listCell = [JGJNotepadListCell cellWithTableView:tableView];
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    listCell.searchKey = [_searchKey stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (_searchKey.length == 0) {

        listCell.noteModel = _notepadListArr[indexPath.section];
        [listCell setImageViewListwWithNoteModel:_notepadListArr[indexPath.section]];

    }else {

        listCell.noteModel = _searchListArr[indexPath.section];
        [listCell setImageViewListwWithNoteModel:_searchListArr[indexPath.section]];
    }

    return listCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *backHeader = [[UIView alloc] init];
    backHeader.backgroundColor = [UIColor clearColor];
    backHeader.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);

    
    UIView *point = [[UIView alloc] init];
    point.backgroundColor = AppFontEB4E4EColor;
    [backHeader addSubview:point];
    
    point.sd_layout.leftSpaceToView(backHeader, 18).topSpaceToView(backHeader, 26).widthIs(6).heightIs(6);
    [point.layer setLayerCornerRadius:3];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.backgroundColor = [UIColor clearColor];
    
    
    JGJNotepadListModel *model = [[JGJNotepadListModel alloc] init];
    if (_searchKey.length == 0) {
        
        model = _notepadListArr[section];
    }else {
        
        model = _searchListArr[section];
    }
    NSArray *yearMDArr = [model.publish_time componentsSeparatedByString:@"-"];

    timeLabel.text = [NSString stringWithFormat:@"%@年%@月%@日 %@",yearMDArr[0],yearMDArr[1],yearMDArr[2],model.weekday];
    timeLabel.font = FONT(14);
    timeLabel.textColor = AppFont333333Color;
    [backHeader addSubview:timeLabel];
    
    timeLabel.sd_layout.leftSpaceToView(point, 9).centerYEqualToView(point).rightSpaceToView(backHeader, 10).heightIs(20);
    
    NSString *isShowTime = _isShowTimeStrArr[section];
    if ([isShowTime isEqualToString:@"显示"]) {
        
        point.hidden = NO;
        timeLabel.hidden = NO;
        
    }else {
        
        point.hidden = YES;
        timeLabel.hidden = YES;
    }
    
    return backHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJNotepadListModel *model = [[JGJNotepadListModel alloc] init];
    if (_searchKey.length == 0) {
        
        model = _notepadListArr[indexPath.section];
    }else {
        
        model = _searchListArr[indexPath.section];
    }
    return model.row_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *backHeader = [[UIView alloc] init];
    backHeader.backgroundColor = [UIColor clearColor];
    backHeader.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
    
    return backHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSString *isShowTime = _isShowTimeStrArr[section];
    if ([isShowTime isEqualToString:@"显示"]) {
        
        return 50;
        
    }else {
        
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJNotepadDetailInfoViewController *editeVC = [[JGJNotepadDetailInfoViewController alloc] init];
    
    if (_searchKey.length == 0) {
        
        editeVC.noteModel = _notepadListArr[indexPath.section];
    }else {
        
        editeVC.noteModel = _searchListArr[indexPath.section];
    }
    
    [self.navigationController pushViewController:editeVC animated:YES];
    [self.view endEditing:YES];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _isStartSearchingState = YES;
    _searchKey = _didChangeSearchKey;
    [_searchKey stringByReplacingOccurrencesOfString:@" " withString:@""];
    [_noteListTable.mj_header beginRefreshing];
    [self.view endEditing:YES];
    if (_searchKey.length == 0) {
        
        _isStartSearchingState = NO;
    }
    return YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (JGJNotepadListEmptyView *)emptyView {
    
    if (!_emptyView) {
        
        _emptyView = [[JGJNotepadListEmptyView alloc] init];
    }
    return _emptyView;
}

- (UITableView *)noteListTable {
    
    if (!_noteListTable) {
        
        _noteListTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _noteListTable.backgroundColor = [UIColor clearColor];
        _noteListTable.showsVerticalScrollIndicator = NO;
        _noteListTable.delegate = self;
        _noteListTable.dataSource = self;
        _noteListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noteListTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 110)];
        _noteListTable.estimatedRowHeight = 0;
        _noteListTable.estimatedSectionHeaderHeight = 0;
        _noteListTable.estimatedSectionFooterHeight = 0;
        
        
        __weak typeof(self) weakSelf = self;
        
        __strong typeof(self) strongSelf = self;
        
        _noteListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            strongSelf -> _pageSize = 1;
            [weakSelf loadDataWithPage:strongSelf -> _pageSize content_key:strongSelf -> _searchKey];
        }];

//         MJRefreshBackNormalFooter  MJRefreshAutoNormalFooter

        _noteListTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

            strongSelf -> _pageSize ++;
            [weakSelf loadDataWithPage:strongSelf -> _pageSize content_key:strongSelf -> _searchKey];
        }];
    }
    return _noteListTable;
}

- (UIButton *)createNewNote {
    
    if (!_createNewNote) {
        
        _createNewNote = [UIButton buttonWithType:UIButtonTypeCustom];
        _createNewNote.contentMode = UIViewContentModeCenter;
        [_createNewNote setBackgroundImage:IMAGE(@"createNewNote") forState:UIControlStateNormal];
        [_createNewNote addTarget:self action:@selector(createNewNoteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createNewNote;
}

- (JGJCustomSearchBar *)searchbar {
    
    if (!_searchbar) {
        
        _searchbar = [JGJCustomSearchBar new];
        _searchbar.searchBarTF.clearButtonMode = UITextFieldViewModeAlways;
        _searchbar.searchBarTF.returnKeyType = UIReturnKeySearch;
        _searchbar.searchBarTF.placeholder = @"快速搜索关键字";
        _searchbar.searchBarTF.delegate = self;
        
        __weak typeof(self) weakSelf = self;
        __strong typeof(self) strongSelf = self;
        _searchbar.searchBarTF.valueDidChange = ^(NSString *value){
            
            strongSelf -> _didChangeSearchKey = value;
            if (value.length == 0) {
                
                strongSelf -> _isStartSearchingState = NO;
                strongSelf -> _allline.hidden = NO;
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
                weakSelf.noteListTable.tableHeaderView = view;
                _searchKey = @"";
                [weakSelf.noteListTable.mj_header beginRefreshing];
                [weakSelf.searchbar mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.height.mas_equalTo(48);
                }];
                
                weakSelf.noteListTable.sd_layout.topSpaceToView(weakSelf.view, 48);
            }
        };
        
        
        _searchbar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_searchbar];
        _searchbar.hidden = YES;
        [_searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.right.equalTo(self.view);
            make.height.mas_equalTo(48);
            
        }];
        
    }
    
    return _searchbar;
    
}

- (JGJFooterViewInfoModel *)footerInfoModel {
    
    if (!_footerInfoModel) {
        
        _footerInfoModel = [JGJFooterViewInfoModel new];
        
        _footerInfoModel.backColor = self.noteListTable.backgroundColor;
        
        _footerInfoModel.textColor = AppFont999999Color;
        
        _footerInfoModel.desType = UITableViewNoteListTableFooterType;
        
    }
    
    return _footerInfoModel;
    
}

@end
