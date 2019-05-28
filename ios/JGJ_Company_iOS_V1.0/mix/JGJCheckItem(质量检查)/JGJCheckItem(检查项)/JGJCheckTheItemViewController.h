//
//  JGJCheckTheItemViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/11/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJLogHeaderView.h"
@interface JGJCheckTheItemViewController : UIViewController
@property (nonatomic ,strong)JGJLogHeaderView *headerView;

@property (nonatomic, assign)logClickType logQuestType;

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *WorkproListModel;

@property (nonatomic, assign) BOOL backMain;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *departConstance;
@end
