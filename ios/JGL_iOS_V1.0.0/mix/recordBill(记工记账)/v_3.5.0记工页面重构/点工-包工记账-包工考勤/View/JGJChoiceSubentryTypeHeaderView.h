//
//  JGJChoiceSubentryTypeHeaderView.h
//  mix
//
//  Created by Tony on 2019/2/14.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChoiceSubentryType)(NSInteger type);
@interface JGJChoiceSubentryTypeHeaderView : UIView

@property (nonatomic, assign) BOOL markBillMore;
@property (nonatomic, copy) ChoiceSubentryType choiceSubentryType;

@property (nonatomic, assign) NSInteger subentryType;// 承包 还是 分包 0 - 承包， 1 - 分包
@end
