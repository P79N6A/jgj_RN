//
//  LeftMenuVC.h
//  mix
//
//  Created by celion on 16/3/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoCell.h"
@interface LeftMenuVC : UIViewController
@property (nonatomic, assign) SelectedWorkType  workType;//确定类型
@property (nonatomic, copy) NSString *imageName;//顶部图片名字
@property (nonatomic, strong) MyWorkZone *myWorkZone;
@property (nonatomic, strong) MyWorkLeaderZone *myWorkLeaderZone;
@property (nonatomic, strong) NSString *userName; //用户名字
@end
