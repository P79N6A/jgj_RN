//
//  JGJRefreshTableView.m
//  mix
//
//  Created by yj on 2018/5/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRefreshTableView.h"

@interface JGJRefreshTableView ()

/** 自定义缺省页回调处理 通用返回nil就可以了*/
@property (nonatomic, copy) JGJRefreshTableviewStatusCallback statusViewCallback;

@property (nonatomic, strong) UIView *statusView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JGJRequestBaseModel


@end

@implementation JGJRefreshTableView

- (void)loadWithViewOfStatus:(JGJRefreshTableviewStatusCallback)statusBlock{
    
    _statusViewCallback = statusBlock;
    
    if (self.mj_header == nil) {
        
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onHeadRereshing)];
        
    }
    
    //初始化数据
    if (self.request.pagesize == 0) {
        
        self.request.pagesize = 20;
    
    }
    
    if (self.request.pg == 0) {
        
        self.request.pg = 1;
    }

    [self.mj_header beginRefreshing];
}

- (void)onHeadRereshing {
    
    self.request.pg = 1;
    
    if (!self.request.body) {
        
        self.request.body = [[NSMutableDictionary alloc] init];
        
    }
    
    [self.request.body setValue:@(20) forKey:@"pagesize"];
    
    [self.request.body setValue:@(self.request.pg) forKey:@"pg"];
    
    if (self.request.isOldApi) {
        
        [JLGHttpRequest_AFN PostWithApi:self.request.requestApi parameters:self.request.body?:nil success:^(id responseObject) {
            
            [self headerSuccessResponse:responseObject];
            
        } failure:^(NSError *error) {
            
            [self headerResponseError:error];
            
        }];
        
    }else {
        
        [JLGHttpRequest_AFN PostWithNapi:self.request.requestApi parameters:self.request.body?:nil success:^(id responseObject) {
            
            [self headerSuccessResponse:responseObject];
            
        } failure:^(NSError *error) {
            
            [self headerResponseError:error];
            
        }];
        
    }
    
}

#pragma mark - 成功时候处理
- (void)headerSuccessResponse:(id)responseObject {
    
    //        [TYLoadingHub hideLoadingView];
    [self.mj_header endRefreshing];
    
    [self.dataArray removeAllObjects];
    
    NSArray *arr = nil;
    
    if ([responseObject isKindOfClass:[NSArray class]]) {
        
        arr = responseObject;
        
    }
    if (arr.count > 0) {
        
        self.dataArray = arr.mutableCopy;
        
        [self onRefreshStatus:JGJRefreshTableViewStatusNormal];
        
    }
    if (self.request.pagesize > 0) {
        
        if (self.request.pagesize > 0 && arr.count == self.request.pagesize/*视为分页*/) {
            
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
        
        [self onRefreshStatus:JGJRefreshTableViewStatusNoResult];
        
    }
    
    [self reloadData];
    
}

#pragma mark - 失败
- (void)headerResponseError:(NSError *)error {
    
    [self.mj_header endRefreshing];
    
    [self.dataArray removeAllObjects];
    
    self.mj_footer = nil;
    
    [self onRefreshStatus:JGJRefreshTableViewStatusLoadError];
}

#pragma mark - 加载更多成功
- (void)footerSuccessResponse:(id)responseObject {
    
    [self.mj_footer endRefreshing];
    
    NSArray *arr = responseObject;
    
    if (![arr isKindOfClass:[NSArray class]]) arr = nil;
    
    if (arr.count > 0) {
        
        [self.dataArray addObjectsFromArray:arr];
        
        [self onRefreshStatus:JGJRefreshTableViewStatusNormal];
        
        [self reloadData];
    }
    if (arr.count < self.request.pagesize) {
        
        self.mj_footer = nil;
        
    }
}

#pragma mark - 加载更多失败
- (void)footerResponseError:(NSError *)error {
    
    [self.mj_footer endRefreshing];
}

- (void)onRefreshStatus:(JGJRefreshTableViewStatus)status {
    
    if (self.statusViewCallback) {
        
        UIView *statusView = self.statusViewCallback(self,status);
        
        switch (status) {
                
            case JGJRefreshTableViewStatusNoResult: {
                
                if (!statusView) {
                    
                    JGJComDefaultViewModel *defaultModel = [JGJComDefaultViewModel new];
                                        
                    defaultModel.des = [NSString isEmpty:self.des] ? @"暂无数据哦" : self.des;
                    
                    defaultModel.isHiddenButton = YES;
                    
                    JGJComDefaultView *headerView = [[JGJComDefaultView alloc] initWithFrame:self.bounds];
                    
                    headerView.defaultViewModel = defaultModel;
                    
                    statusView = headerView;
                    
                }
                
                self.tableHeaderView = statusView;
                
            }
                break;
                
            case JGJRefreshTableViewStatusNoNetwork:{
                
                
            }
                
                break;
                
            case JGJRefreshTableViewStatusLoadError:{
                
                
            }
                
                break;
                
            case JGJRefreshTableViewStatusNormal:{
                
//                [self reset];
                
            }
                
                break;
                
            default:break;
        }
    
    }
}

- (void)reset {
    
    self.tableHeaderView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 0.01);
    
    if (self.mj_header) [self.mj_header endRefreshing];
    
    if (self.mj_footer) self.mj_footer = nil;
    
}

- (void)onFooterRereshing {
    
    self.request.pg ++;
    
    [self.request.body setValue:@(self.request.pg) forKey:@"pg"];
    
    if (self.request.isOldApi) {
        
        [JLGHttpRequest_AFN PostWithApi:self.request.requestApi parameters:self.request.body?:nil success:^(id responseObject) {
            
            [self footerSuccessResponse:responseObject];
            
        } failure:^(NSError *error) {
            
            [self footerResponseError:error];
            
        }];
        
    }else {
        
        [JLGHttpRequest_AFN PostWithNapi:self.request.requestApi parameters:self.request.body?:nil success:^(id responseObject) {
            
            [self footerSuccessResponse:responseObject];
            
        } failure:^(NSError *error) {
            
            [self footerResponseError:error];
            
        }];
    }

}

- (JGJRequestBaseModel *)request {
    
    if (!_request) {
        
        _request = [[JGJRequestBaseModel alloc] init];
        
        _request.pagesize = 20;
        
        _request.pg = 1;

    }
    
    return _request;
}

@end
