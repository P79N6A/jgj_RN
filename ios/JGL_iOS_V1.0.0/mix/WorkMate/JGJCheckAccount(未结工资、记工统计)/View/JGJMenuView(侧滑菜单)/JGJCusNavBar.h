//
//  JGJCusNavBar.h
//  mix
//
//  Created by yj on 2018/5/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJCusNavBarBlock)(void);

@interface JGJCusNavBar : UIView

@property (nonatomic, copy) JGJCusNavBarBlock backBlock;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end
