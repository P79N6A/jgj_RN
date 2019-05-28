//
//  JGJWorkCircleProGroupCell.h
//  mix
//
//  Created by yj on 16/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "SWTableViewCell.h"
#import "CustomView.h"
#define WorkCircleProGroupHeiht 75
@interface JGJWorkCircleProGroupCell : SWTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@end
