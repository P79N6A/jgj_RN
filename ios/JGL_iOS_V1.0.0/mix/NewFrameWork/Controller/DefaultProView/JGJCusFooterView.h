//
//  JGJCusFooterView.h
//  mix
//
//  Created by yj on 2018/6/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJCusFooterViewBlock)();

@interface JGJCusFooterView : UIView

@property (nonatomic, copy) JGJCusFooterViewBlock footerViewBlock;

+(CGFloat)cusFooterViewHeight;

@end
