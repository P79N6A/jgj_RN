//
//  JGJTabPaddingView.h
//  mix
//
//  Created by yj on 2018/6/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@interface JGJTabPaddingView : UIView

+(instancetype)tabPaddingView;

@property (weak, nonatomic) IBOutlet LineView *topLineView;

@property (weak, nonatomic) IBOutlet LineView *bottomLineView;

@end
