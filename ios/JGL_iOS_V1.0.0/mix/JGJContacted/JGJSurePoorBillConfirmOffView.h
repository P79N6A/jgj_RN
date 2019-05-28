//
//  JGJSurePoorBillConfirmOffView.h
//  mix
//
//  Created by Tony on 2019/2/19.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StartConfirmBlock)(void);
@interface JGJSurePoorBillConfirmOffView : UIView

@property (nonatomic, copy) StartConfirmBlock startConfirmBlock;
@end
