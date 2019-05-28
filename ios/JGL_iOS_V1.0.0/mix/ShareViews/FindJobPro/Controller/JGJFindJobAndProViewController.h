//
//  JGJFindJobAndProViewController.h
//  mix
//
//  Created by Tony on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJWorkerHeaderListVC.h"
#import "JLGCitysListView.h"
@interface JGJFindJobAndProViewController : UIViewController
@property (strong, nonatomic) FHLeaderWorktypeCity *workTypeModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) JLGCitysListView *jlgCitysListView;
- (void)getCityslist;
@end
