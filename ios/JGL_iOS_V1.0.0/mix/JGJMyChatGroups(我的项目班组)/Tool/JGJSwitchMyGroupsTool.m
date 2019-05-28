//
//  JGJSwitchMyGroupsTool.m
//  mix
//
//  Created by yj on 2019/3/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJSwitchMyGroupsTool.h"

#import "JGJMyChatGroupsVc.h"

@implementation JGJSwitchMyGroupsTool

+(instancetype)switchMyGroupsTool {
    
    return [[self alloc] init];
}

#pragma mark - 选中之后切换项目，首页项目改变
- (void)switchMyGroupsWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type targetVc:(UIViewController *)targetVc {
    
    TYWeakSelf(self);
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JGJChatGetOffLineMsgInfo http_gotoTheGroupHomeVCWithGroup_id:group_id?:@"" class_type:class_type?:@"" isNeedChangToHomeVC:YES isNeedHttpRequest:YES success:^(BOOL isSuccess) {
        
        [TYLoadingHub hideLoadingView];
        
        UIViewController *popVc = nil;
        
        for (UIViewController *vc in targetVc.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:NSClassFromString(@"JGJMyChatGroupsVc")]) {
                
                popVc = vc;
            }
        }
        
        if (popVc) {
            
            [targetVc.navigationController popToViewController:popVc animated:YES];
            
        }else {
          
            JGJMyChatGroupsVc *groupVc = [[JGJMyChatGroupsVc alloc] init];
            groupVc.classType = class_type;
            groupVc.popVc = targetVc;
            
            [targetVc.navigationController pushViewController:groupVc animated:YES];
            
        }
        
    }];
    
}

@end
