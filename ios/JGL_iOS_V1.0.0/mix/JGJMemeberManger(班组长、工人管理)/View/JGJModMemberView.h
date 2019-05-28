//
//  JGJModMemberView.h
//  mix
//
//  Created by yj on 2018/4/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJModMemberViewBlock)(NSString *name);

@interface JGJModMemberView : UIView

@property (nonatomic, copy) JGJModMemberViewBlock modMemberViewBlock;

@property (nonatomic, copy) NSString *uid;

@end
