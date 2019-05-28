//
//  JGJSubentryListCell.h
//  mix
//
//  Created by Tony on 2019/2/14.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJSubentryListModel.h"
#import "SWTableViewCell.h"
@interface JGJSubentryListCell : SWTableViewCell

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) JGJSubentryListModel *model;

@end
