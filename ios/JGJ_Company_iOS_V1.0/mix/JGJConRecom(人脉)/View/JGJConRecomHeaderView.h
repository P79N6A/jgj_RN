//
//  JGJConRecomHeaderView.h
//  mix
//
//  Created by yj on 2018/1/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJConRecomHeaderViewBlock)(id);

@interface JGJConRecomHeaderView : UIView

@property (nonatomic, copy) JGJConRecomHeaderViewBlock conRecomHeaderViewBlock;

//是否已查看新朋友
@property (nonatomic, assign) BOOL isCheckFreshFriend;

@end
