//
//  JGJRefreshTableView.h
//  mix
//
//  Created by yj on 2018/5/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJComDefaultView.h"

#import "MJRefresh.h"

typedef NS_ENUM(NSInteger, JGJRefreshTableViewStatus) {
    
    JGJRefreshTableViewStatusNormal,  //正常
    
    JGJRefreshTableViewStatusNoResult = 10001,   //无数据
    
    JGJRefreshTableViewStatusNoNetwork, //无网络
    
    JGJRefreshTableViewStatusLoadError
    
};

@class JGJRefreshTableView;

typedef UIView *(^JGJRefreshTableviewStatusCallback)(JGJRefreshTableView *tableView, JGJRefreshTableViewStatus status);

@interface JGJRequestBaseModel : NSObject

@property (nonatomic, assign) NSInteger pg;

@property (nonatomic, assign) NSInteger pagesize;

@property (nonatomic, copy)   NSString *requestApi;

//是否是老接口
@property (nonatomic, assign) BOOL isOldApi;

@property (nonatomic, strong) NSMutableDictionary *body;

@end

@interface JGJRefreshTableView : UITableView

@property (nonatomic, strong) JGJRequestBaseModel *request;

@property (nonatomic, strong, readonly) NSMutableArray *dataArray;

//没有数据描述文字
@property (nonatomic, strong) NSString *des;

/** 加载数据 */
- (void)loadWithViewOfStatus:(JGJRefreshTableviewStatusCallback)statusBlock;

- (void)reset;

@end
