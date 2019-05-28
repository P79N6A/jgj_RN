//
//  JGJFilterListsViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/8/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJFilterListsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong ,nonatomic) NSMutableArray  <JGJGetLogTemplateModel *>*dataArr;

@end
