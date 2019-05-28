//
//  JGJSelectedCurrentCityVC.h
//  mix
//
//  Created by yj on 16/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGCityModel.h"
@protocol JGJSelectedCurrentCityVCDelegate <NSObject>
- (void)handleJGJSelectedCurrentCityModel:(JLGCityModel *)cityModel;
@end
@interface JGJSelectedCurrentCityVC : UIViewController
@property (nonatomic, weak) id <JGJSelectedCurrentCityVCDelegate> delegate;
@property (nonatomic, strong) JLGCityModel *cityModel;//显示当前选择的所在城市
@end
