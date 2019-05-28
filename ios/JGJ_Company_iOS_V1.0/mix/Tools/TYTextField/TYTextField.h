//
//  TYTextField.h
//  mix
//
//  Created by Tony on 15/12/31.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TYTextFieldDefualtColor ([UIColor colorWithRed:((0xc7c7c7>>16)&0xFF)/255.0f green:((0xc7c7c7>>8)&0xFF)/255.0f blue:(0xc7c7c7&0xFF)/255.0f alpha:1.0f])

#define SearchbarHeight 48

@interface TYTextField : UITextField
//开始编辑的颜色
+ (void)textFieldDidBeginEditingColor:(UITextField *)textField color:(UIColor *)color;

//结束编辑的颜色
+ (void)textFieldDidEndEditing:(UITextField *)textField color:(UIColor *)color;
@end

@interface BaseTextField : UITextField
- (void)customInit;
//设置字符颜色
- (void)markText:(NSString *)t withColor:(UIColor *)c;
@end
@interface NormalTextField : BaseTextField
@end
@interface LengthLimitTextField : BaseTextField
@property(nonatomic, assign) NSInteger maxLength;
@property (nonatomic,copy) void (^valueDidChange)(NSString *value);

@end

@class JGJCustomSearchBar;

typedef void(^HandleButtonPressedBlcok)(JGJCustomSearchBar *);

@interface JGJCustomSearchBar : UIView

@property (copy, nonatomic) HandleButtonPressedBlcok handleButtonPressedBlcok;

@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) LengthLimitTextField *searchBarTF;

@property (assign, nonatomic) BOOL isAddedNavbar; //是否添加在leftbarItem

@property (assign, nonatomic) CGFloat cancelButtonW;

@property (assign, nonatomic) CGFloat searchBarTFRight;//到右边的距离

@property (assign, nonatomic) BOOL isShowSearchBarTop;//搜索框在顶部

@end
