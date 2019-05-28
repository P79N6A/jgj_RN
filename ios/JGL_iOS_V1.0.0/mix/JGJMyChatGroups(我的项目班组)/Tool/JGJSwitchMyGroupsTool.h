//
//  JGJSwitchMyGroupsTool.h
//  mix
//
//  Created by yj on 2019/3/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JGJSwitchMyGroupsTool : NSObject

+(instancetype)switchMyGroupsTool;

//传入切换项目的group_id、class_type和当前vc
- (void)switchMyGroupsWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type targetVc:(UIViewController *)targetVc;

@end

NS_ASSUME_NONNULL_END
