//
//  JGJCustomPopView.h
//  JGJCompany
//
//  Created by yj on 16/10/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJCustomLable.h"
@interface JGJCustomPopView : UIView
@property (nonatomic, copy)void (^touchDismissBlock) (void);
@property (nonatomic, copy)void (^leftButtonBlock) (void);
@property (nonatomic, copy)void (^onOkBlock) (void);
@property (nonatomic, copy)void (^onlineChatButtonBlock) (void);
@property (weak, nonatomic) IBOutlet JGJCustomLable *messageLable;
@property (weak, nonatomic) IBOutlet UILabel *TitleLable;

@property (nonatomic, assign) BOOL isNotTouchViewHide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

+ (JGJCustomPopView *)showWithMessage:(JGJShareProDesModel *)desModel;
@end
