//
//  JGJNotifyJoinExistTeamCell.h
//  JGJCompany
//
//  Created by yj on 16/11/10.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

@interface JGJNotifyJoinExistTeamCell : UITableViewCell
@property (nonatomic, strong) JGJExistTeamInfoModel *teamInfoModel;
@property (nonatomic, strong) JGJSyncProlistModel *prolistModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@end
