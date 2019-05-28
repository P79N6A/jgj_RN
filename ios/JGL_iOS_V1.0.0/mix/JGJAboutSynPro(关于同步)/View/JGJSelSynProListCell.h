//
//  JGJSelSynProListCell.h
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJAboutSynProModel.h"

@interface JGJSelSynProListCell : UITableViewCell

@property (nonatomic, strong) JGJSelSynProListModel *prolistModel;

@property (nonatomic, copy) NSString *searchValue;

@end
