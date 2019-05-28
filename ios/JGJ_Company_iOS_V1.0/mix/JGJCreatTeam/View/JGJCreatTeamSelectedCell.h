//
//  JGJCreatTeamSelectedCell.h
//  mix
//
//  Created by yj on 16/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCreatTeamSelectedCell : UITableViewCell
@property (nonatomic, strong) JGJProjectListModel *projectListModel;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
