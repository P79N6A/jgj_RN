//
//  JGJInputNamePopView.h
//  mix
//
//  Created by yj on 2019/2/14.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TYTextField.h"

@class JGJInputNamePopView;

NS_ASSUME_NONNULL_BEGIN

typedef void(^JGJInputNamePopViewCancelBlock)(void);

typedef void(^JGJInputNamePopViewConfirmBlock)(JGJInputNamePopView *popView);

@interface JGJInputNamePopView : UIView

@property (weak, nonatomic) IBOutlet LengthLimitTextField *name;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *tel;

@property (nonatomic, copy) JGJInputNamePopViewCancelBlock cancelBlock;

@property (nonatomic, copy) JGJInputNamePopViewConfirmBlock confirmBlock;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userTel;

@end

NS_ASSUME_NONNULL_END
