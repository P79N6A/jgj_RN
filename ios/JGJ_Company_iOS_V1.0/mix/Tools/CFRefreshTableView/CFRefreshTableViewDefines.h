//
//  CFRefreshTableViewDefines.h
//  RepairHelper
//
//  Created by coreyfu on 15/6/8.
//
//

#ifndef RepairHelper_CFRefreshTableViewDefines_h
#define RepairHelper_CFRefreshTableViewDefines_h

@class CFRefreshTableView;

typedef NS_ENUM (NSInteger, ERefreshTableViewStatus){
    RefreshTableViewStatusNormal,  //正常
    RefreshTableViewStatusNoResult = 10001,   //无数据
    RefreshTableViewStatusNoNetwork, //无网络
    RefreshTableViewStatusLoadError
};

typedef UIView *(^CFRefreshTableviewStatusCallback)(CFRefreshTableView *tableView, ERefreshTableViewStatus status);

#endif
