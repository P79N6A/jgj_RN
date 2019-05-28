//
//  JGJRecordWorkpointsChangeModel.m
//  mix
//
//  Created by Tony on 2018/8/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkpointsChangeModel.h"

@implementation JGJRecordWorkpointsChangeModel

- (CGFloat)cellHeight {
    
    CGFloat height = 0.0;
    if (![NSString isFloatZero:_cellHeight]) {
        
        return _cellHeight;
    }
    
    CGFloat topContainHeight = 53.0;// 公共部分 上方高度
    CGFloat bottomContainHieght = 20.0;// 子view距离父类下方高度,看层级图就知道布局情况
    // 新增
    if ([self.record_type integerValue] == 1) {
        
        // 新增类型 每个cell高度为55
        height = topContainHeight + bottomContainHieght + self.add_info.count * 55;
        
    }else if ([self.record_type integerValue] == 2) {// 修改
        
        height = topContainHeight + bottomContainHieght + 90;// 修改类型 公共view高度为90
        
    }else if ([self.record_type integerValue] == 3) {// 删除
        
        height = topContainHeight + bottomContainHieght + 90 + 20;// 删除类型 增加一个操作人信息 所有增加20pt
        
    }else {// 时间类型
        
        height = 50;
    }
    
    return height;
}

- (BOOL)isMySelfOprationRecord {
    
    return [self.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]];
}

- (NSString *)typeTitle {
    
    NSString *title = [[NSString alloc] init];
    // 类型
    if ([self.record_type integerValue] == 1) {// 新增
        
        title = @"新增记账";
        
    }else if ([self.record_type integerValue] == 2) {// 修改
        
        // 记账类型
        if ([self.record_info.accounts_type integerValue] == 1) {// 点工
            
            title = @"修改了记账-点工";
            
        }else if ([self.record_info.accounts_type integerValue] == 2) {// 包工记账
            
            title = @"修改了记账-包工";
        }else if ([self.record_info.accounts_type integerValue] == 3) {// 借支
            
            title = @"修改了记账-借支";
        }else if ([self.record_info.accounts_type integerValue] == 4) {// 结算
            
            title = @"修改了记账-结算";
        }else if ([self.record_info.accounts_type integerValue] == 5) {// 包工考勤
            
            title = @"修改了记账-包工记工天";
        }
        
    }else if ([self.record_type integerValue] == 3) {// 删除
        
        // 记账类型
        if ([self.record_info.accounts_type integerValue] == 1) {// 点工
            
            title = @"删除了记账-点工";
            
        }else if ([self.record_info.accounts_type integerValue] == 2) {// 包工记账
            
            title = @"删除了记账-包工";
        }else if ([self.record_info.accounts_type integerValue] == 3) {// 借支
            
            title = @"删除了记账-借支";
        }else if ([self.record_info.accounts_type integerValue] == 4) {// 结算
            
            title = @"删除了记账-结算";
        }else if ([self.record_info.accounts_type integerValue] == 5) {// 包工考勤
            
            title = @"删除了记账-包工记工天";
        }
    }
    
    return title;
}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"add_info":@"JGJAdd_infoChangeModel"};
}

@end


@implementation JGJUser_infoChangeModel

@end

@implementation JGJRecord_infoChangeModel

@end


@implementation JGJAdd_infoChangeModel

@end
