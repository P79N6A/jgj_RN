//
//  JGJCloseAnAccountInfoAlertView.h
//  mix
//
//  Created by Tony on 2018/5/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureToSubmit)(void);
typedef void(^modify)(void);
@interface JGJCloseAnAccountInfoAlertView : UIView

@property (nonatomic, copy) sureToSubmit submit;
@property (nonatomic, copy) modify modify;
- (void)show;

- (void)setCurrentCloseAnCountMoney:(NSString *)closeMoney leftMoney:(NSString *)leftMoney;

@end
