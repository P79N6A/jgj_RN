//
//  JGJBillEditProNameTableViewCell.h
//  mix
//
//  Created by yj on 16/7/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditProNameBlock)(JGJBillEditProNameModel *);
@interface JGJBillEditProNameTableViewCell : UITableViewCell
@property (nonatomic, strong) JGJBillEditProNameModel *proNameModel;
@property (nonatomic, copy) EditProNameBlock editProNameBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
