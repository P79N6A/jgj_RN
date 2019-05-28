//
//  UITableView+JGJLoadCategory.h
//  mix
//
//  Created by yj on 2018/3/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJTabFooterView.h"

#define JGJFooterHeight 70

@interface UITableView (JGJLoadCategory)

- (UIView *)setFooterViewInfoModel:(JGJFooterViewInfoModel *)footerInfoModel;

@end
