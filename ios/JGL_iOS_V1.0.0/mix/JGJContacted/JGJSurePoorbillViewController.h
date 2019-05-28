//
//  JGJSurePoorbillViewController.h
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SurePoorbillSuccessBlock)();

@interface JGJSurePoorbillViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstance;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *topLable;
@property (strong, nonatomic) NSDate *currectDate;
@property (strong, nonatomic) NSString *currectTime;//记账页面跳转
@property (strong, nonatomic) NSString *uid;//被记账人

//2.包工 3借支 4结算
@property (copy, nonatomic) NSString *accounts_type;

@property (nonatomic, strong) NSString *agency_uid;// 代班长uid

@property (nonatomic, strong) NSString *group_id;// 班组id

//项目id，出勤公示进入
@property (nonatomic, copy)  NSString *pro_id;

//待确认记账成功回调

@property (nonatomic, copy) SurePoorbillSuccessBlock successBlock;

- (void)beginRefreshSureBillListWithIndexPath:(NSIndexPath *)indexPath;

@end
