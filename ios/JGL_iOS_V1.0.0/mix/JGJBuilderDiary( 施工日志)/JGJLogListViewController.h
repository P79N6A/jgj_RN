//
//  JGJLogListViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/7/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJPublishLogButton.h"
@interface JGJLogListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet JGJPublishLogButton *pubButton;
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
@property (nonatomic,strong) NSMutableDictionary *parameters;
@property (nonatomic,strong) NSMutableArray      *datasource;

@end
