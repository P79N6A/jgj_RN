//
//  JGJCheckClosedProListCell.h
//  mix
//
//  Created by YJ on 17/4/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

#import "SWTableViewCell.h"
#import "JGJChatGroupListModel.h"
@interface JGJCheckClosedProListCell : SWTableViewCell

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (nonatomic, strong) JGJChatGroupListModel *groupListModel;
@end
