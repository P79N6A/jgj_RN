//
//  JGJCommonInfoDesCell.h
//  mix
//
//  Created by yj on 2017/10/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJAccountComDesModel.h"

@interface JGJCommonInfoDesCell : UITableViewCell

@property (nonatomic, strong) JGJCommonInfoDesModel *infoDesModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextImageTrail;

@property (weak, nonatomic, readonly) IBOutlet UIView *lineView;

+ (CGFloat)JGJCommonInfoDesCellHeight;

@end
