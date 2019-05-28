//
//  JGJWorkReplyViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/11/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJWorkReplyViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JGJMyWorkCircleProListModel *WorkproListModel;

@end
