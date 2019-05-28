//
//  JGJCusTopTitleView.h
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJCusTopTitleView;

typedef void(^JGJCusTopTitleViewBlock)(JGJCusTopTitleView *);

@interface JGJCusTopTitleView : UIView

@property (nonatomic, copy) JGJCusTopTitleViewBlock cusTopTitleViewBlock;

+ (JGJCusTopTitleView *)cusTopTitleView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end
