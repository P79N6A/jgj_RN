//
//  JGJQualityDetailContentCell.h
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

@interface JGJQualityDetailContentCell : UITableViewCell

@property (nonatomic, strong) JGJQualityDetailModel *qualityDetailModel;

@property (weak, nonatomic) IBOutlet LineView *lineView;
@end
