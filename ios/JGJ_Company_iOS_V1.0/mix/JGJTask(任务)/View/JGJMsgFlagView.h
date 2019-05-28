//
//  JGJMsgFlagView.h
//  mix
//
//  Created by yj on 2017/9/26.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJMsgFlagViewBlock)(void);

@interface JGJMsgFlagView : UIView

@property (nonatomic, copy) JGJMsgFlagViewBlock msgFlagViewBlock;

@property (weak, nonatomic) IBOutlet UIView *flagView;

- (void)setHiddenFlagView:(BOOL)isHidden;
@end
