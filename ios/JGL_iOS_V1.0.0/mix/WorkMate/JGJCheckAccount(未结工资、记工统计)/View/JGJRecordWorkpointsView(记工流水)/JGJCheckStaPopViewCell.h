//
//  JGJCheckStaPopViewCell.h
//  mix
//
//  Created by yj on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@interface JGJCheckStaPopViewCell : UITableViewCell

@property (nonatomic, strong) JGJCheckStaPopViewCellModel *desInfoModel;

+ (CGFloat)JGJCheckStaPopViewCellHeight;

@property (weak, nonatomic,readonly) IBOutlet UIImageView *dotLineView;
@property (weak, nonatomic) IBOutlet LineView *lineVIew;

@property (weak, nonatomic, readonly) IBOutlet NSLayoutConstraint *typeTitleTrail;

@end
