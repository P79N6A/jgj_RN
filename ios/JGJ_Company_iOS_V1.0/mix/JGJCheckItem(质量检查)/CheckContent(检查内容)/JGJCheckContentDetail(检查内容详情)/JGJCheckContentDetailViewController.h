//
//  JGJCheckContentDetailViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCheckContentDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) JGJMyWorkCircleProListModel *WorkproListModel;
@property (strong, nonatomic) JGJCheckItemListDetailModel *listModel;
@end
