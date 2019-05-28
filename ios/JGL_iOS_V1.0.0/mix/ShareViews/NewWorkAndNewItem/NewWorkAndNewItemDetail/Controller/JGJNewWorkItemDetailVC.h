//
//  JGJNewWorkItemVC.h
//  mix
//
//  Created by celion on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
//分享代码注释
//#import "UMSocial.h"
#import "JLGFindProjectModel.h"
#import "JGJNewWorkDetailTimelimitCell.h"
#import "JGJNewWorkDetailTopCell.h"
#import "JGJNewWorkDetailPublshCell.h"
#import "JGJNewWorkDetailReportCell.h"
#import "JGJNewWorkDetailBenefitCell.h"
#import "JLGFindJobDetailWelfareTableViewCell.h"
#import "JLGFindJobDetailContactsTableViewCell.h"

#define ImageScrollowHeight 80
typedef enum : NSUInteger {
    TopCellType = 0,
    TimelimitCellType,
    BenefitCellType,
    PublshCellType,
    ReportCellType,
    ContactsCellType
} CellType;

@interface JGJNewWorkItemDetailVC : UIViewController
<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, copy) NSString *workTypeID;//工种类型ID
@property (nonatomic, assign) BOOL isShowSkill;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JLGFindProjectModel *jlgFindProjectModel;
@property (strong, nonatomic) JGJNewWorkDetailTimelimitCell *timelimitCell;
@property (strong, nonatomic)  JGJNewWorkDetailPublshCell *publishCell;
- (void)commonset;
- (void)RefreshBottomView;
- (JGJNewWorkDetailTopCell *)getTopCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (JGJNewWorkDetailTimelimitCell *)getTimelimitCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (JGJNewWorkDetailPublshCell *)getPublshCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (JGJNewWorkDetailReportCell *)getReportCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (JLGFindJobDetailContactsTableViewCell *)getContactsCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (JGJNewWorkDetailBenefitCell *)getBenefitCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


@end
