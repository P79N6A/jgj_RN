//
//  JGJCreatTeamSelectedCell.h
//  mix
//
//  Created by yj on 16/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

@interface JGJCreatTeamSelectedCell : UITableViewCell
@property (nonatomic, strong) JGJProjectListModel *projectListModel;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (nonatomic, copy) NSString *searchValue;
@end
