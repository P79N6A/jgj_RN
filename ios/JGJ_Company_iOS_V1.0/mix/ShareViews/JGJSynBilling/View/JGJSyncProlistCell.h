//
//  JGJSyncProlistCell.h
//  mix
//
//  Created by celion on 16/5/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

typedef void(^ProlistSynCloseBlock)(JGJSyncProlistModel *);
@interface JGJSyncProlistCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJSyncProlistModel *syncProlistModel;
@property (nonatomic, copy) ProlistSynCloseBlock prolistSynCloseBlock;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
