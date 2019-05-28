//
//  JGJTaskModel.m
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskModel.h"

#import "NSString+Extend.h"

@implementation JGJTaskCommonModel


@end

@implementation JGJTaskModel

@end

@implementation JGJTaskLevelSelModel


@end

@implementation JGJTaskListModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"task_list" : @"JGJTaskModel"};
}

- (NSArray *)filterCounts {
    
    NSString *waitDeal = @"待处理";
    
    if ([NSString isEmpty:self.un_deal_count] || [self.un_deal_count isEqualToString:@"0"]) {
        
        waitDeal = @"待处理";
    }else {
        
        NSInteger unDealCount = [NSString stringWithFormat:@"%@", self.un_deal_count].integerValue;
        
        if (unDealCount > 99) {
            
            self.un_deal_count = @"99+";
        }
        
        waitDeal = [NSString stringWithFormat:@"待处理(%@)",self.un_deal_count];
        
    }
    
    NSString *my_admin_count = @"我负责的";
    
    if ([NSString isEmpty:self.my_admin_count] || [self.my_admin_count isEqualToString:@"0"]) {
        
        my_admin_count = @"我负责的";
        
    }else {
        
        NSInteger myAdminCount = [NSString stringWithFormat:@"%@", self.my_admin_count].integerValue;
        
        if (myAdminCount > 99) {
            
            self.my_admin_count = @"99+";
        }
        
        my_admin_count = [NSString stringWithFormat:@"我负责的(%@)",self.my_admin_count];
        
    }
    
    NSString *my_join_count = @"我参与的";
    
    if ([NSString isEmpty:self.my_join_count] || [self.my_join_count isEqualToString:@"0"]) {
        
        my_join_count = @"我参与的";
    }else {
        
        NSInteger adminCount = [NSString stringWithFormat:@"%@", self.my_join_count].integerValue;
        
        if (adminCount > 99) {
            
            self.my_join_count = @"99+";
        }
        
        my_join_count = [NSString stringWithFormat:@"我参与的(%@)",self.my_join_count];
        
    }
    
    NSString *my_submit_count = @"我提交的";
    
    if ([NSString isEmpty:self.my_submit_count] || [self.my_submit_count isEqualToString:@"0"]) {
        
        my_submit_count = @"我提交的";
    }else {
        
        NSInteger mySubmitCount = [NSString stringWithFormat:@"%@", self.my_submit_count].integerValue;
        
        if (mySubmitCount > 99) {
            
            self.my_submit_count = @"99+";
        }
        
        my_submit_count = [NSString stringWithFormat:@"我提交的(%@)",self.my_submit_count];
        
    }
    
    _filterCounts= @[waitDeal,@"已完成"];
    
    _aboutMeCounts = @[my_admin_count, my_join_count, my_submit_count];
    
    return _filterCounts;
    
}

@end

