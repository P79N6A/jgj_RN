//
//  JGJHeaderFooterPaddingView.h
//  mix
//
//  Created by yj on 2018/6/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJHeaderFooterPaddingView : UITableViewHeaderFooterView

+ (instancetype)headerFooterPaddingViewWithTableView:(UITableView *)tableView;

- (void) setUpdateLineViewLayoutWithTop:(CGFloat)top left:(CGFloat)left right:(CGFloat)right isHidden:(BOOL)isHidden;

@end
