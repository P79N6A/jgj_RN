//
//  JGJCreatTeamCell.h
//  mix
//
//  Created by yj on 16/8/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

@protocol JGJCreatTeamCellDelegate <NSObject>
@end
@interface JGJCreatTeamCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJCreatTeamModel *creatTeamModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (assign, nonatomic) BOOL hidden;

@end
