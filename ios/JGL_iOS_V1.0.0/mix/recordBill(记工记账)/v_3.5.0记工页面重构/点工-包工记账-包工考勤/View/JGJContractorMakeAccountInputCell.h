//
//  JGJContractorMakeAccountInputCell.h
//  mix
//
//  Created by Tony on 2019/1/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
#import "TYTextField.h"
#import "JGJCusTextField.h"
@protocol JGJContractorMakeAttendanceInputCellDelegate <NSObject>

- (void)JGJContractorMakeAttendanceInputTextFileEditingText:(NSString *)text cellTag:(NSInteger)cellTag;
- (void)inputTextFieldEndEditing;

@end
@interface JGJContractorMakeAccountInputCell : UITableViewCell

@property (nonatomic, assign) NSInteger cellTag;

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (nonatomic, strong,readonly) JGJCusTextField *inputField;// 输入框
@property (nonatomic, weak) id<JGJContractorMakeAttendanceInputCellDelegate> delegate;
@end
