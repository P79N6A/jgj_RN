//
//  JGJKonwBaseDownloadCell.h
//  mix
//
//  Created by yj on 2018/7/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWTableViewCell.h"

#import "CustomView.h"

@interface JGJKonwBaseDownloadCell : SWTableViewCell

@property (strong, nonatomic) JGJKnowBaseModel *knowBaseModel;

//搜索的的值根据当前搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;

//是否批量删除
@property (nonatomic, assign) BOOL isBatchDel;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
