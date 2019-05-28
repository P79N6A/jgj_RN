//
//  JGJMarkBillTextFileTableViewCell.h
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTextField.h"
typedef enum: NSUInteger{
    JGJStrKeyBoardType,
    JGJNumberKeyBoardType,
    JGJNumberKeyNoDecimalBoardType
}JGJNumberType;//是不是数字键盘
typedef enum: NSUInteger{
    JGJContractSubProType,//包公分项
    JGJContractUnitPriceType,//包公单价
    JGJBrrowUnitPriceType,//借支单价
}JGJShowPlainType;//报错
@protocol JGJMarkBillTextFileTableViewCellDelegate <NSObject>

- (void)JGJMarkBillTextFileEditingText:(NSString *)text  WithTag:(NSInteger)tag;

@optional
- (void)JGJMarkBillTextFilEndEditing;

- (void)JGJMarkBillWillBeginTextFilEditing;//开始编辑

@end


@interface JGJMarkBillTextFileTableViewCell : UITableViewCell
<
UITextFieldDelegate
>
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
//LengthLimitTextField
@property (strong, nonatomic) IBOutlet LengthLimitTextField *textfiled;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) id <JGJMarkBillTextFileTableViewCellDelegate>delegate;
@property (assign, nonatomic) JGJNumberType numberType;
@property (assign, nonatomic) JGJShowPlainType showPlainType;
@property (assign, nonatomic) int maxLength;
@property (assign, nonatomic) long maxvalue;
@property (assign, nonatomic) BOOL showPlain;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftLineConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightLineConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textfiledRightConstance;
@property (weak, nonatomic) IBOutlet UIImageView *choiceMoreBtn;

@property (nonatomic, assign) BOOL showMoreButton;
@property (nonatomic, assign) CGFloat editeMoney;

@end

@interface JGJNocopyTextfiled :UITextField

@end
