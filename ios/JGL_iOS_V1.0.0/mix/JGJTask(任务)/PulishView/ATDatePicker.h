//
//  ATDatePicker.h
//  ATDatePicker
//
//  Created by Jam on 16/8/4.
//  Copyright © 2016年 Attu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    ATDatePickerDefautType, //默认样式
    
    ATDatePickerCusBtnType, //自定义取消按钮位置，点击取消清空时间
    
    ATDatePickerResetBtnType //重置按钮，重置之后时间回复
    
} ATDatePickerType;

typedef void(^DatePickerFinishBlock)(NSString *dateString);

typedef void(^DatePickerCusBtnFinishBlock)(NSString *dateString);

@interface ATDatePicker : UIView

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

//自定义按钮点击后
@property (nonatomic, copy) DatePickerCusBtnFinishBlock cusBtnFinishBlock;

//默认样式不需要传 取消确定
@property (nonatomic, assign) ATDatePickerType type;

- (instancetype)initWithDatePickerMode:(UIDatePickerMode) datePickerMode DateFormatter:(NSString *)dateFormatter datePickerFinishBlock:(DatePickerFinishBlock)datePickerFinishBlock;

- (instancetype)initWithDatePickerMode:(UIDatePickerMode)datePickerMode ATDatePickerType:(ATDatePickerType)type DateFormatter:(NSString *)dateFormatter datePickerFinishBlock:(DatePickerFinishBlock)datePickerFinishBlock;

- (void)show;

@end
