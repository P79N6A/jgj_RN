//
//  JGJComTool.m
//  mix
//
//  Created by yj on 2018/1/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJComTool.h"

@interface JGJComTool()



@end

@implementation JGJComTool

+ (instancetype)showCloseProImageViewWithTargetView:(UIView *)targetView classtype:(NSString *)classtype isClose:(BOOL)isClose {
    
    return [[self alloc] initWithTargetView:targetView classtype:classtype isClose:isClose];
    
}

- (instancetype)initWithTargetView:(UIView *)targetView classtype:(NSString *)classtype isClose:(BOOL)isClose {
    
    self = [super init];
    
    if (self) {
        
        BOOL isTeam = [classtype isEqualToString:@"team"];
        
        NSString *typeStr = isTeam ? @"pro_closedFlag_icon" : @"Chat_closedGroup";
        
        if (isClose) {
            
            UIImageView *clocedImageView = [[UIImageView alloc] init];
            
            clocedImageView.image = [UIImage imageNamed:typeStr];
            
            [targetView addSubview:clocedImageView];
            
            [clocedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.center.mas_equalTo(targetView);
                make.width.mas_equalTo(126);
                make.height.mas_equalTo(70);
            }];
            
        }
    }
    
    return self;
}

+ (void)showCloseProPopViewWithClasstype:(NSString *)classtype {
    
    BOOL isTeam = [classtype isEqualToString:@"team"];
    
    NSString *tips = [NSString stringWithFormat:@"当前%@已关闭", isTeam ? @"项目" :@"班组"];
    
    [TYShowMessage showPlaint:tips];
}

+ (void)changeRoleWithType:(NSInteger)roleType successBlock:(void (^)())successBlock{
    
    [JLGHttpRequest_AFN PostWithApi:@"jlsignup/changerole" parameters:@{@"role":@(roleType),@"os":@"I"} success:^(NSDictionary *responseObject) {
        
        NSInteger roleNum = [responseObject[@"role"] integerValue];
        if ([responseObject[@"is_info"] integerValue] == 0) {//需要填补充资料
            
            roleNum == 1?[TYUserDefaults setBool:NO forKey:JLGMateIsInfo]:[TYUserDefaults setBool:NO forKey:JLGLeaderIsInfo];
            [TYUserDefaults synchronize];
            
        }else{//有权限，保存权限
            roleNum == 1?[TYUserDefaults setBool:YES forKey:JLGMateIsInfo]:[TYUserDefaults setBool:YES forKey:JLGLeaderIsInfo];
            [TYUserDefaults synchronize];
        }
        
        //保存状态,1为工人，2为班组长/工头
        roleNum != 1?[TYUserDefaults setBool:YES forKey:JLGisLeader]:[TYUserDefaults setBool:NO forKey:JLGisLeader];
        [TYUserDefaults synchronize];
        
        [TYUserDefaults setBool:YES forKey:JGJSelRole];
        
        NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
        
        infoVer += 1;
        
        [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
        if (successBlock) {
            
            [TYShowMessage showSuccess:@"切换身份成功!"];
            successBlock();
        }
    
    } failure:^(NSError *error) {
        
        [TYShowMessage showPlaint:@"请检查网络"];
        
    }];
}

+ (CABasicAnimation *)opacityForever_Animation:(float)time //永久闪烁的动画
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.2];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
@end
