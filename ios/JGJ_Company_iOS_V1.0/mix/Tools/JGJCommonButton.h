//
//  JGJCommonButton.h
//  mix
//
//  Created by yj on 2018/5/21.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJCommonDefaultType,
    
    JGJCommonCreatProType
    
} JGJCommonButtonType;

typedef void(^JGJCommonButtonBlock)(UIButton *button);

@interface JGJCommonButton : UIButton

@property (copy, nonatomic) JGJCommonButtonBlock buttonBlock;

@property (copy, nonatomic) NSString *buttonImageStr;

@property (copy, nonatomic) NSString *buttonTitle;

@property (assign, nonatomic) JGJCommonButtonType type;

@end
