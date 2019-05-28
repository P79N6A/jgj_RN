//
//  JGJCusSeniorPopView.h
//  mix
//
//  Created by yj on 2018/1/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCusSeniorPopView : UIView

@property (nonatomic, copy) void (^seniorServiceInfoBlock) (void);

@property (nonatomic, copy)void (^leftButtonBlock) (void);

@property (nonatomic, copy)void (^onOkBlock) (void);

@property (nonatomic, copy)void (^onlineChatButtonBlock) (void);

+ (JGJCusSeniorPopView *)showWithMessage:(JGJShareProDesModel *)desModel;

@end
