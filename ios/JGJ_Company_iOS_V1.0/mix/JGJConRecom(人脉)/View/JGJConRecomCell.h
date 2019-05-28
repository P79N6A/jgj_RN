//
//  JGJConRecomCell.h
//  mix
//
//  Created by yj on 2018/1/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

typedef void(^JGJConRecomCellBlock)(JGJSynBillingModel *friendlyModel);

@interface JGJConRecomCell : UITableViewCell

@property (nonatomic, strong) JGJSynBillingModel *friendlyModel;

@property (nonatomic, copy) JGJConRecomCellBlock conRecomCellBlock;
@property (weak, nonatomic) IBOutlet LineView *topLineView;

@end
