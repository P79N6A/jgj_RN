//
//  JGJCusSetTinyPopView.h
//  mix
//
//  Created by yj on 2019/2/13.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJCusTextField.h"

#import "UILabel+GNUtil.h"

@class JGJCusSetTinyPopView;

typedef void(^JGJCusSetTinyPopViewCancelBlock)(JGJCusSetTinyPopView *popView);

typedef void(^JGJCusSetTinyPopViewConfirmBlock)(JGJCusSetTinyPopView *popView);

NS_ASSUME_NONNULL_BEGIN

@interface JGJCusSetTinyPopView : UIView

@property (nonatomic, copy) JGJCusSetTinyPopViewCancelBlock cancelBlock;

@property (nonatomic, copy) JGJCusSetTinyPopViewConfirmBlock confirmBlock;

@property (weak, nonatomic) IBOutlet UILabel *selCntsDes;

@property (weak, nonatomic) IBOutlet UILabel *wageTitle;

@property (weak, nonatomic) IBOutlet JGJCusTextField *money;

@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentDetailViewH;


@end

NS_ASSUME_NONNULL_END
