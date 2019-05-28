//
//  JGJCusHeaderView.h
//  mix
//
//  Created by yj on 2018/6/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJCusHeaderViewBlock)();

@interface JGJCusHeaderView : UIView

@property (nonatomic, copy) JGJCusHeaderViewBlock headerViewBlock;

+(CGFloat)cusHeaderViewHeight;

@end
