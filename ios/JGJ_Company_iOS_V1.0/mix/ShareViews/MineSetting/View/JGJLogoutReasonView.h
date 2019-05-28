//
//  JGJLogoutReasonView.h
//  mix
//
//  Created by yj on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJLogoutOtherReasonCell.h"

@interface JGJLogoutReasonView : UIView

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak, readonly) JGJLogoutOtherReasonCell *cell;

+ (CGFloat)logoutReasonViewHeightWithCount:(NSInteger)count;

@end
