//
//  JGJTeamDetailSourceProCell.h
//  JGJCompany
//
//  Created by yj on 16/11/11.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJTeamDetailSourceProCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJSyncProlistModel *prolistModel;
@end
