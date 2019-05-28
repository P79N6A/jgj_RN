//
//  JGJBottomMulButtonView.h
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJBottomAllSelButtonType, //全选、取消全选
    
    JGJBottomDelButtonType //删除按钮

} JGJBottomMulButtonType;

typedef void(^JGJBottomMulButtonViewBlock)(JGJBottomMulButtonType buttonType, BOOL isAllSelButton);

@interface JGJBottomMulButtonView : UIView

@property (nonatomic, copy) JGJBottomMulButtonViewBlock bottomMulButtonViewBlock;

@property (nonatomic, assign) BOOL isAllSelStatus;

//选中的要删除账单个数
@property (nonatomic, assign) NSInteger selRecordCount;

@end
