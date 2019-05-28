//
//  JGJGetPeopleInfosViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/7/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
@interface JGJGetPeopleInfosViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) JGJMyWorkCircleProListModel *WorkCircleProListModel;
@property (strong ,nonatomic) JGJSetRainWorkerModel *peopleInfoModel;
@property (nonatomic, strong) NSMutableArray <JGJSynBillingModel *>*principalModels;//存储排序后信息
@property (strong, nonatomic) DSectionIndexView *sectionIndexView;
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;//存储排序后信息
@property (strong, nonatomic) JGJSynBillingModel *SynBillingModel;

@end
