//
//  JGJSourceSynedProCell.h
//  JGJCompany
//
//  Created by yj on 16/11/10.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJSourceSynedProCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJSyncProlistModel *prolistModel;
@end
