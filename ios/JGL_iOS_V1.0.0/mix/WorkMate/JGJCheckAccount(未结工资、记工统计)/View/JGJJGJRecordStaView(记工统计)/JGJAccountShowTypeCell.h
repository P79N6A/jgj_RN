//
//  JGJAccountShowTypeCell.h
//  mix
//
//  Created by yj on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@interface JGJAccountShowTypeCell : UITableViewCell

@property (nonatomic, strong) JGJAccountShowTypeModel *showTypeModel;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (weak, nonatomic) IBOutlet LineView *topLineView;

@end
