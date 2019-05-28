//
//  JGJConRecomSectionHeaderView.h
//  mix
//
//  Created by yj on 2018/12/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJConRecomSectionHeaderViewBlock)();

@interface JGJConRecomSectionHeaderView : UIView

@property (nonatomic, copy) JGJConRecomSectionHeaderViewBlock headerViewBlock;

@end
