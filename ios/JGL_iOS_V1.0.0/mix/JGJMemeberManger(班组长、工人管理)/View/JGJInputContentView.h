//
//  JGJInputContentView.h
//  mix
//
//  Created by yj on 2018/4/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJInputContentView;

typedef void(^JGJInputContentViewBlock)(NSString *content);

typedef void(^JGJAddButtonPressedBlock)(NSString *content);

@interface JGJInputContentView : UIView

@property (nonatomic, copy) JGJInputContentViewBlock inputContentViewBlock;

@property (nonatomic, copy) JGJAddButtonPressedBlock addButtonPressedBlock;

@end
