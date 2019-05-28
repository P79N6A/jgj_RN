//
//  TYTextField.h
//  mix
//
//  Created by Tony on 15/12/31.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

//textFiled默认的颜色
//#define TYTextFieldDefualtColor ([UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1])
#define TYTextFieldDefualtColor ([UIColor colorWithRed:((0xc7c7c7>>16)&0xFF)/255.0f green:((0xc7c7c7>>8)&0xFF)/255.0f blue:(0xc7c7c7&0xFF)/255.0f alpha:1.0f])


@interface TYTextField : UITextField
//开始编辑的颜色
+ (void)textFieldDidBeginEditingColor:(UITextField *)textField color:(UIColor *)color;

//结束编辑的颜色
+ (void)textFieldDidEndEditing:(UITextField *)textField color:(UIColor *)color;
@end

@interface BaseTextField : UITextField
- (void)customInit;
@end
@interface NormalTextField : BaseTextField
@end
@interface LengthLimitTextField : BaseTextField
@property(nonatomic, assign) NSInteger maxLength;
@property (nonatomic,copy) void (^valueDidChange)(NSString *value);

@end
