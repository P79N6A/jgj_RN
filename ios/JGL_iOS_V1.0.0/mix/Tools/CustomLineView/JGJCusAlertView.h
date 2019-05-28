//
//  JGJCusAlertView.h
//  mix
//
//  Created by yj on 17/3/3.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJCustomAlertViewBlock)();

@interface JGJCusAlertView : UIView
+ (JGJCusAlertView *)cusAlertViewShowWithDesModel:(JGJShareProDesModel *)desModel;
@property (copy, nonatomic) JGJCustomAlertViewBlock customLeftButtonAlertViewBlock;
@property (strong, nonatomic) IBOutlet UILabel *desTitleLable;
@property (copy, nonatomic) JGJCustomAlertViewBlock customRightButtonAlertViewBlock;
@end
