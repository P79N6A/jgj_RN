//
//  JGJSynToMyProListCell.h
//  mix
//
//  Created by yj on 2018/4/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJAboutSynProModel.h"

#import "CustomView.h"

typedef void(^JGJSynToMyProListCellBlock)(JGJSynedProListModel *proListModel);

@interface JGJSynToMyProListCell : UITableViewCell

@property (nonatomic, strong) JGJSynedProListModel *proListModel;

@property (nonatomic, assign) BOOL isDelStatus;

@property (nonatomic, copy) JGJSynToMyProListCellBlock synToMyProListCellBlock;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
