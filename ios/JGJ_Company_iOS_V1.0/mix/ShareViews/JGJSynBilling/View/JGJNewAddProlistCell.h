//
//  JGJNewAddProlistCell.h
//  mix
//
//  Created by celion on 16/5/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

typedef void(^SelelctedProlistSynBlock)(JGJSyncProlistModel *);
@interface JGJNewAddProlistCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJSyncProlistModel *syncProlistModel;
@property (nonatomic, copy) SelelctedProlistSynBlock selelctedProlistSynBlock;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
