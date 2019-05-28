//
//  JGJChoicePeoViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJChoicePeoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) JGJMyWorkCircleProListModel *WorkCircleProListModel;
@property (strong ,nonatomic) JGJSetRainWorkerModel *peopleInfoModel;
@property (nonatomic, strong) JGJMyRelationshipProModel *MyRelationshipProModel;
@property (nonatomic, strong) NSMutableArray <JGJMyRelationshipProModel *>*groupListArr;

@end
