//
//  UITableView+JGJLoadCategory.m
//  mix
//
//  Created by yj on 2018/3/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "UITableView+JGJLoadCategory.h"

static JGJTabFooterView *_footerView = nil;

@implementation UITableView (JGJLoadCategory)

- (UIView *)setFooterViewInfoModel:(JGJFooterViewInfoModel *)footerInfoModel; {
    
    _footerView = [[JGJTabFooterView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, JGJFooterHeight)];
    
    _footerView.footerInfoModel = footerInfoModel;
    
    self.tableFooterView = _footerView;
    
    return _footerView;
}

@end
