//
//  CFRefreshTableView.m
//  RepairHelper
//
//  Created by coreyfu on 15/6/4.
//
//

#import "CFRefreshTableView.h"
#import "MJRefresh.h"

@interface CFRefreshTableView ()
@property (nonatomic, copy) CFRefreshTableviewStatusCallback statusViewCallback;

@property (nonatomic, strong) UIView *tmpHeaderView;//save tableView.headerView TEMPERARY
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) NSMutableDictionary *bodyDic;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation CFRefreshTableView

- (void)loadWithViewOfStatus:(CFRefreshTableviewStatusCallback)statusBlock{
    
    _statusViewCallback = statusBlock;
    NSDictionary *dic = @{@"pg" : @(1),
                          @"pagesize" : @(30)};
    self.pageStart = 1;
    self.pageLength = 30;
    self.bodyDic = [NSMutableDictionary dictionary];
    [self.bodyDic addEntriesFromDictionary:self.parameters];
    [self.bodyDic addEntriesFromDictionary:dic];
    self.tmpHeaderView = self.tableHeaderView;
    if (self.mj_header == nil) {
        
           self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onHeadRereshing)];
    }
//    if (!self.mj_footer) {
//        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onFooterRereshing)];
//    }
    [self.mj_header beginRefreshing];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)reset{
    
    self.tableHeaderView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 0);
    self.rowHeight = 0;
    [self done];
    if (self.mj_header) [self.mj_header endRefreshing];
    if (self.mj_footer) self.mj_footer = nil;
}

- (void)changeTableView {
   
}

- (void)headerBegainRefreshing{
    if (self.mj_header) [self.mj_header beginRefreshing];
}
- (void)footerBegainRefreshing{
    
    if (self.mj_footer) [self.mj_footer beginRefreshing];
}

- (void)commonInit {
    self.dataArray = [[NSMutableArray alloc] init];
}

- (void)onHeadRereshing {
    self.pageStart = 1;
     [self.bodyDic setValue:@(self.pageStart) forKey:@"pg"];
    
//    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:self.currentUrl parameters:self.bodyDic success:^(id responseObject) {
//        [TYLoadingHub hideLoadingView];
        [self.mj_header endRefreshing];
        [self.dataArray removeAllObjects];
        NSArray *arr = nil;
        if ([responseObject isKindOfClass:[NSArray class]]) {
            arr = responseObject;
        }
        if (arr.count > 0) {
            [self.dataArray addObjectsFromArray:arr];
            [self onRefreshStatus:RefreshTableViewStatusNormal];
        }
        if (self.pageLength > 0) {
            if (self.pageLength > 0 && arr.count == self.pageLength/*视为分页*/) {
                if (!self.mj_footer)
                    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onFooterRereshing)];
            }else{
                if (self.mj_footer) {
                    [self.mj_footer endRefreshing];
                    self.mj_footer = nil;
                }
            }
        }
        if (self.dataArray.count == 0) {
            [self onRefreshStatus:RefreshTableViewStatusNoResult];
        }else{
            [self done];
        }
        if (self.delegateOfTable) {
            [self.delegateOfTable CFRefreshTableViewLoadDataSuccess:self];
        }
        [self reloadData];
    } failure:^(NSError *error) {
//        [TYLoadingHub hideLoadingView];
        [self.mj_header endRefreshing];
        [self.dataArray removeAllObjects];
        if (self.pageLength > 0 && self.mj_footer) self.mj_footer = nil;
        [self onRefreshStatus:RefreshTableViewStatusLoadError];
    }];
}

- (void)onRefreshStatus:(ERefreshTableViewStatus)status {
    if (self.statusViewCallback) {
        
        if (self.statusView) [self done];//打回原形

        self.statusView = self.statusViewCallback(self,status);
   
        self.tmpHeaderView = self.tableHeaderView;
        
        self.statusView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        self.tableHeaderView = self.statusView;
    }
}

- (void)done {
    self.tableHeaderView = self.tmpHeaderView;
}

- (void)onFooterRereshing {

    self.pageStart ++;
    [self.bodyDic setValue:@(self.pageStart) forKey:@"pg"];
    [JLGHttpRequest_AFN PostWithApi:self.currentUrl parameters:self.bodyDic success:^(id responseObject) {
        [self.mj_footer endRefreshing];
        NSArray *arr = responseObject;
        if (![arr isKindOfClass:[NSArray class]]) arr = nil;
        if (arr.count > 0) {
            [self.dataArray addObjectsFromArray:arr];
            [self onRefreshStatus:RefreshTableViewStatusNormal];
            [self reloadData];
        }
        if (arr.count < self.pageLength) {
            self.mj_footer = nil;
        }
    } failure:^(NSError *error) {
         [self.mj_footer endRefreshing];
    }];
}


#pragma mark - Implement of CFRefreshTableView
//
- (BOOL)isValid {
    if ([self isTableViewController]) {
        return self.parentViewController != nil;
    }
    return self.superview != nil;
}

- (BOOL)isTableViewController {
    return [[self nextResponder] isKindOfClass:[UITableViewController class]];
}

- (UIViewController *)parentViewController {
    if ([self isTableViewController]) {
        return (UIViewController *)[self nextResponder];
    }
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
