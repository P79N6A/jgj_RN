//
//  JGJNotePadCanledarOneDayController.m
//  mix
//
//  Created by Tony on 2019/1/10.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNotePadCanledarOneDayController.h"
#import "NSDate+Extend.h"
#import "JGJNotepadListEmptyView.h"
#import "TYTextField.h"
#import "JGJNotepadListCell.h"
#import "MJRefresh.h"
#import "JGJAddNewNotepadViewController.h"
#import "JGJNotepadListModel.h"
#import "JGJNotepadDetailInfoViewController.h"
#import "SJButton.h"
#import "JGJNotePadListCanlederController.h"
@interface JGJNotePadCanledarOneDayController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
    NSMutableArray *_notepadListArr;
    NSInteger _pageSize;
    
}

@property (nonatomic, strong) UITableView *noteListTable;
@property (nonatomic, strong) UIButton *createNewNote;
@property (nonatomic, strong) JGJFooterViewInfoModel *footerInfoModel;
@property (nonatomic, strong) JGJNotepadListEmptyView *emptyView;
@end

@implementation JGJNotePadCanledarOneDayController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *dateStr = [NSDate stringFromDate:_oneDayDate format:@"yyyy年MM月dd日"];
    
    NSString *weekday = [NSDate weekdayWithDate:_oneDayDate];
    
    self.title = [NSString stringWithFormat:@"%@ %@",dateStr, weekday];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    _pageSize = 1;
    
    [self initializeAppearance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheNotepadList) name:@"refreshTheNotepadList" object:nil];
}

- (void)refreshTheNotepadList {
    
    _pageSize = 1;

    [self.noteListTable.mj_header beginRefreshing];
    
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.noteListTable];
    [self.view addSubview:self.createNewNote];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    _noteListTable.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    _createNewNote.sd_layout.rightSpaceToView(self.view, 10).bottomSpaceToView(self.view, 25).widthIs(80).heightIs(80);
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

#pragma mark - method
// 加载数据
- (void)loadDataWithPage:(NSInteger)page {
    
    NSDictionary *param = @{
                            @"pg":@(_pageSize),
                            @"pagesize":@(20),
                            @"publish_time":[NSDate stringFromDate:_oneDayDate format:@"yyyy-MM-dd"]
                            };
    [JLGHttpRequest_AFN PostWithNapi:@"notebook/get-list" parameters:param success:^(id responseObject) {
        
        _noteListTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.01)];
        // 第一页数据
        if (_pageSize == 1) {
            
            [_notepadListArr removeAllObjects];
            
            _notepadListArr = [JGJNotepadListModel mj_objectArrayWithKeyValuesArray:responseObject];
            [_noteListTable.mj_header endRefreshing];
            
        }else {
            
            [_notepadListArr addObjectsFromArray:[JGJNotepadListModel mj_objectArrayWithKeyValuesArray:responseObject]];
            [_noteListTable.mj_footer endRefreshing];
        }
      
        
        if (_notepadListArr.count == 0) {
            
            self.noteListTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            
            [self.emptyView setEmptyImage:@"notepad_quesheng" emptyText:@"开始记录你的生活吧..."];
            self.emptyView.recordLabel.font = [UIFont systemFontOfSize:AppFont36Size];
            self.emptyView.recordLabel.textColor = [UIColor blackColor];
            
            self.emptyView.frame = _noteListTable.bounds;
            _noteListTable.tableHeaderView = _emptyView;
        }
        
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

- (void)setOneDayDate:(NSDate *)oneDayDate {
    
    _oneDayDate = oneDayDate;
    
    [self.noteListTable.mj_header beginRefreshing];
}

- (void)createNewNoteBtnClick {
    
    JGJAddNewNotepadViewController *addController = [[JGJAddNewNotepadViewController alloc] init];
    JGJNotepadListModel *noteModel = [[JGJNotepadListModel alloc] init];
    noteModel.weekday = [NSDate weekdayWithDate:_oneDayDate];
    noteModel.publish_time = [NSDate stringFromDate:_oneDayDate format:@"yyyy-MM-dd"];
    addController.noteModel = noteModel;
    
    addController.tagVC = self;
    addController.orignalImgArr = [[NSMutableArray alloc] init];
    [self presentViewController:addController animated:YES completion:nil];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _notepadListArr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGJNotepadListCell *listCell = [JGJNotepadListCell cellWithTableView:tableView];
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    listCell.indexPath = indexPath;
    listCell.isOneDayComing = YES;
    listCell.noteModel = _notepadListArr[indexPath.section];
    [listCell setImageViewListwWithNoteModel:_notepadListArr[indexPath.section]];
    
    __strong typeof(self) strongSelf = self;
    
    __weak JGJNotepadListCell*weakCell = listCell;
    
    TYWeakSelf(self);
    listCell.markNoteImportWithNoteModel = ^(JGJNotepadListModel *noteModel,NSIndexPath *index) {
      
        NSDictionary *param = @{ @"id" : @(noteModel.noteId),
                                 @"is_import" : @(!noteModel.is_import)
                                 };
        
        [TYLoadingHub showLoadingWithMessage:nil];
        
        [JLGHttpRequest_AFN PostWithNapi:@"notebook/put-one" parameters:param success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
//这个row有可能不是当前的行，要用的话写在高度那个位置直接用模型即可
            noteModel.is_import = !noteModel.is_import;
            weakCell.noteModel = noteModel;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OneDayControllerRefreshTheNotepadList" object:nil];
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
            
        }];
        
    };
    return listCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJNotepadListModel *model = [[JGJNotepadListModel alloc] init];
    
    model = _notepadListArr[indexPath.section];
    
    return model.row_height + 44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = AppFontf1f1f1Color;
    view.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = AppFontf1f1f1Color;
    view.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
    
    return view;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJNotepadDetailInfoViewController *editeVC = [[JGJNotepadDetailInfoViewController alloc] init];
    
    editeVC.noteModel = _notepadListArr[indexPath.section];
    [self.navigationController pushViewController:editeVC animated:YES];
    [self.view endEditing:YES];
    
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
        _noteListTable.tableHeaderView = [[UIView alloc] init];
        _noteListTable.estimatedRowHeight = 0;
        _noteListTable.estimatedSectionHeaderHeight = 0;
        _noteListTable.estimatedSectionFooterHeight = 0;
        
        __weak typeof(self) weakSelf = self;
        __strong typeof(self) strongSelf = self;
        _noteListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            strongSelf -> _pageSize = 1;
            [weakSelf loadDataWithPage:strongSelf -> _pageSize];
        }];
        
        _noteListTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            strongSelf -> _pageSize ++;
            [weakSelf loadDataWithPage:strongSelf -> _pageSize ];
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

- (JGJFooterViewInfoModel *)footerInfoModel {
    
    if (!_footerInfoModel) {
        
        _footerInfoModel = [JGJFooterViewInfoModel new];
        
        _footerInfoModel.backColor = self.noteListTable.backgroundColor;
        
        _footerInfoModel.textColor = AppFont999999Color;
        
        _footerInfoModel.desType = UITableViewNoteListTableFooterType;
        
    }
    
    return _footerInfoModel;
    
}

- (JGJNotepadListEmptyView *)emptyView {
    
    if (!_emptyView) {
        
        _emptyView = [[JGJNotepadListEmptyView alloc] init];
    }
    return _emptyView;
}
@end

