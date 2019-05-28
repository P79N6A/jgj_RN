//
//  JGJNewNotifyDetailHeadCell.h
//  mix
//
//  Created by yj on 16/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJNewNotifyDetailHeadCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;
@end
