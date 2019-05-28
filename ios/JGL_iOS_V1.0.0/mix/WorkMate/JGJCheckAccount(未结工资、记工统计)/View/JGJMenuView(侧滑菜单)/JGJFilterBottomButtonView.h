//
//  JGJFilterBottomButtonView.h
//  mix
//
//  Created by yj on 2018/5/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJFilterBottomDefaultButtonType,
    
    JGJFilterBottomResetButtonype, //重置按钮(左边)
    
    JGJFilterBottomConfirmButtonType, //确定按钮(右边)

} JGJFilterBottomButtonType;

@interface JGJFilterBottomButtonView : UIView

@property (nonatomic, copy) void(^bottomButtonBlock) (JGJFilterBottomButtonType buttonType);

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *btnColors;

@property (nonatomic, strong) NSArray *layerColors;

@property (nonatomic, strong) NSArray *titleColors;

@end
