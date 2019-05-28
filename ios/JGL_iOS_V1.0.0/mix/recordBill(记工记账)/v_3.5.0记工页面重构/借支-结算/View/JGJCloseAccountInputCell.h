//
//  JGJCloseAccountInputCell.h
//  mix
//
//  Created by Tony on 2019/1/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
#import "JGJCusTextField.h"

@protocol JGJCloseAccountInputCellDelegate <NSObject>

- (void)JGJCloseAccountInputTextFileEditingText:(NSString *)text cellTag:(NSInteger)cellTag;

- (void)inputTextFieldEndEditing;
@end

@interface JGJCloseAccountInputCell : UITableViewCell

@property (nonatomic, assign) NSInteger cellTag;
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (nonatomic, strong,readonly) JGJCusTextField *inputField;// 输入框
@property (nonatomic, weak) id<JGJCloseAccountInputCellDelegate> delegate;

- (void)startTwinkleAnimation;// 文字 箭头闪烁效果动画
- (void)stopTwinkleAnimation;
@end
