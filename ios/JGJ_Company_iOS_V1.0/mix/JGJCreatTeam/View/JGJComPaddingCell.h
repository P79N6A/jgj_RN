//
//  JGJComPaddingCell.h
//  mix
//
//  Created by yj on 2018/6/7.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJAccountComDesModel.h"

@interface JGJComPaddingCell : UITableViewCell

@property (nonatomic, strong) JGJCommonInfoDesModel *infoDesModel;

@property (weak, nonatomic,readonly) IBOutlet UIView *topLineView;

@property (weak, nonatomic, readonly) IBOutlet NSLayoutConstraint *centerY;

+ (CGFloat)cellHeight;

@end
