//
//  JGJContractorMakeAccountInputCountAndUnitsCell.h
//  mix
//
//  Created by Tony on 2019/2/14.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
#import "JGJCusTextField.h"

@protocol JGJContractorMakeAccountInputCountAndUnitsCellDelegate <NSObject>

- (void)JGJContractorMakeAttendanceInputCountTextFileEditingText:(NSString *)text cellTag:(NSInteger)cellTag;
- (void)inputCountTextFieldEndEditing;

- (void)inputCountAndUnitsCellChoiceUnitsWithCellTag:(NSInteger)cellTag;


@end
@interface JGJContractorMakeAccountInputCountAndUnitsCell : UITableViewCell

@property (nonatomic, assign) NSInteger cellTag;

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (nonatomic, strong,readonly) JGJCusTextField *inputField;// 输入框
@property (nonatomic, weak) id<JGJContractorMakeAccountInputCountAndUnitsCellDelegate> delegate;
@end

