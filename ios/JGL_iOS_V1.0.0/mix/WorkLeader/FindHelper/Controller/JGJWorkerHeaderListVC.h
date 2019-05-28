//
//  JGJWorkerHeaderListVC.h
//  mix
//
//  Created by celion on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"
#import "CityMenuView.h"
#import "JLGCityModel.h"
#import "JLGFHLeaderModel.h"
#import "JGJWorkTypeSelectedView.h"
#import "JGJWorkTypeCollectionView.h"

@class JGJWorkerHeaderListVC,FHLeaderWorktypeCity;
@protocol JGJWorkerHeaderListVCDelegate <NSObject>
- (void )WorkerHeaderList:(JGJWorkerHeaderListVC *)workerHeaderVc pushVc:(UIViewController *)pushVc;
@end

@interface JGJWorkerHeaderListVC : UIViewController
<UITableViewDataSource, UITableViewDelegate, JGJWorkTypeCollectionViewDelegate>
@property (nonatomic , weak) id<JGJWorkerHeaderListVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *cityNameButton;
@property (weak, nonatomic) IBOutlet UIButton *workTypeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) NSInteger pageNum;

@property (strong, nonatomic) FHLeaderWorktypeCity *workTypeModel;
- (void)commonSet;
- (void)loadNetData;

- (void)loadNetMoreData;
- (void)JLGHttpRequest;
@end

@interface FHLeaderWorktypeCity : FHLeaderWorktype

@property (copy, nonatomic) NSString *roleStr;
@property (copy, nonatomic) NSString *cityNameID;
@property (copy, nonatomic) NSString *workTypeID;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *is_all_area;//增加查看是否查看全国数据
@end
