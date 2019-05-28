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
        
        NSString *typeStr = isTeam ? @"closed_pro_icon" : @"Chat_closedGroup";
        
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
    
    NSString *tips = [NSString stringWithFormat:@"%@已关闭，不能执行此操作", isTeam ? @"项目" :@"班组"];
    
    [TYShowMessage showPlaint:tips];
}

@end
