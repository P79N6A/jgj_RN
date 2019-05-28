//
//  JGJCustomPopView.h
//  JGJCompany
//
//  Created by yj on 16/10/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCustomPopView : UIView
@property (nonatomic, copy)void (^leftButtonBlock) (void);
@property (nonatomic, copy)void (^onOkBlock) (void);
@property (nonatomic, copy)void (^onlineChatButtonBlock) (void);
@property (weak, nonatomic) IBOutlet UILabel *messageLable;
+ (JGJCustomPopView *)showWithMessage:(JGJShareProDesModel *)desModel;
@end
