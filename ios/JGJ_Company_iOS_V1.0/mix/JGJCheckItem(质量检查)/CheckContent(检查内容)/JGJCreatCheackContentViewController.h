//
//  JGJCreatCheackContentViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/11/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCreatCheackContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstance;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *WorkproListModel;

@property (nonatomic ,assign) BOOL EditeBool;//是否是编辑

@property (strong, nonatomic) JGJCheckItemListDetailModel *listModel;

@property (strong, nonatomic) JGJCheckContentDetailModel *totalModel;

@property (nonatomic ,assign) BOOL checkContentListGo;//是否是列表新建进入
@property (strong, nonatomic) IBOutlet UIView *bottmViews;

@end
