//
//  JGJQualitySafeModel.m
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualitySafeModel.h"

#import "NSString+Extend.h"

#import "JGJNineSquareView.h"

@implementation JGJQualitySafeCommonModel


@end

@implementation JGJQualitySafeListModel


@end

@implementation JGJQualitySafeModel

+ (NSDictionary *)mj_objectClassInArray {

    return @{@"list" : @"JGJQualitySafeListModel"};
}

- (NSArray *)filterCounts {

    NSString *statu_rect = @"待整改";
    
    if ([NSString isEmpty:self.is_statu_rect] || [self.is_statu_rect isEqualToString:@"0"]) {
        
        statu_rect = @"待整改";
    }else {
    
        statu_rect = [NSString stringWithFormat:@"待整改(%@)",self.is_statu_rect ];
        
    }
    
    NSString *statu_check = @"待复查";
    
    if ([NSString isEmpty:self.is_statu_check] || [self.is_statu_check isEqualToString:@"0"]) {
        
        statu_check = @"待复查";
        
    }else {
        
        statu_check = [NSString stringWithFormat:@"待复查(%@)",self.is_statu_check ];
        
    }
    
    NSString *check_me = @"待我复查";
    
    if ([NSString isEmpty:self.check_me] || [self.check_me isEqualToString:@"0"]) {
        
        check_me = @"待我复查";
    }else {
        
        check_me = [NSString stringWithFormat:@"待我复查(%@)",self.check_me ];
        
    }
    
    NSString *rect_me = @"待我整改";
    
    if ([NSString isEmpty:self.rect_me] || [self.rect_me isEqualToString:@"0"]) {
        
        rect_me = @"待我整改";
        
    }else {
        
        rect_me = [NSString stringWithFormat:@"待我整改(%@)",self.rect_me ];
        
    }
    
    NSString *offer_me = @"我提交的";
    
    if ([NSString isEmpty:self.offer_me] || [self.offer_me isEqualToString:@"0"]) {
        
        offer_me = @"我提交的";
        
    }else {
        
        offer_me = [NSString stringWithFormat:@"我提交的(%@)",self.offer_me];
        
    }
    
    _filterCounts = @[statu_rect, statu_check, @"已完成", @"统计"];

    _aboutMeCounts = @[rect_me, check_me, offer_me];
    
    return _filterCounts;
}



@end

@implementation JGJQualityDetailReplayListModel

- (CGFloat)taskHeight {
    
    if (![NSString isFloatZero:_taskHeight]) {
        
        return _taskHeight;
    }
    
    CGFloat contentMinY = 36.0;
    
    CGFloat padding = 21.0;
    
    CGFloat contentHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 20 content:self.reply_text font: AppFont30Size lineSpace:5];
    
    CGFloat thumnailImageViewH = self.msg_src.count == 0 ? CGFLOAT_MIN : [JGJNineSquareView nineSquareViewHeight:self.msg_src headViewWH:80.0 headViewMargin:5];
    
    _taskHeight = contentMinY + padding + contentHeight + thumnailImageViewH;
    
    return _taskHeight;
}

@end


@implementation JGJQualityDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"reply_list" : @"JGJQualityDetailReplayListModel"};
}

- (NSString *)severityDes {

    _severityDes = @"";
//    if ([self.severity isEqualToString:@"1"]) {
//        
//        _severityDes = @"[一般]";
//    }else if ([self.severity isEqualToString:@"2"]) {
//    
//        _severityDes = @"[严重]";
//    }

    _severityDes = [NSString stringWithFormat:@"[%@]", self.severity_text];
    
    return _severityDes;
}

- (BOOL)isAuthorModify {

    _isAuthorModify = NO;
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if ([myUid isEqualToString:self.uid] || [self.is_admin isEqualToString:@"1"] || [self.is_creater isEqualToString:@"1"]) {
        
        _isAuthorModify = YES;
    }
    
    return _isAuthorModify;
}


@end

@implementation JGJQualityLocationModel


@end

//2.3.0
@implementation JGJQuaSafePubCheckInfoModel


@end

@implementation JGJQuaSafeCheckPlanModel


@end

@implementation JGJQuaSafeCheckListModel


@end

@implementation JGJQuaSafeCheckModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list" : @"JGJQuaSafeCheckListModel"};
}

- (NSArray *)checkFilterCounts {
    
    NSString *waitCheck = @"待检查";
    
    if ([NSString isEmpty:self.check] || [self.check_me isEqualToString:@"0"]) {
        
        waitCheck = @"待检查";
    }else {
        
        waitCheck = [NSString stringWithFormat:@"待检查(%@)",self.check];
        
    }
    
    NSString *waitMeCheck = @"待我检查";
    
    if ([NSString isEmpty:self.check_me] || [self.check_me isEqualToString:@"0"]) {
        
        waitMeCheck = @"待我检查";
        
    }else {
        
        waitMeCheck = [NSString stringWithFormat:@"待我检查(%@)",self.check_me];
        
    }
    
    _checkFilterCounts = @[@"全部", waitCheck, @"已完成", @"我提交的",waitMeCheck, @"", @"筛选"];
    
    return _checkFilterCounts;
}

@end


@implementation JGJQuaSafeCheckRecordReplyModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{@"replyId" : @"id"};
}

@end

@implementation JGJQuaSafeCheckRecordListModel

- (BOOL)isShowContainBottomBtnView {

    _isShowContainBottomBtnView = YES;
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    //不是任务执行人也是不是待整改隐藏底部按钮
    
    JGJQuaSafeCheckRecordReplyModel *replyModel = [self.reply_list firstObject];
    
    if (![replyModel.statu isEqualToString:@"1"] && ![self.uid isEqualToString:myUid]) {
        
        _isShowContainBottomBtnView = NO;
    }
    
    return _isShowContainBottomBtnView;
}

+ (NSDictionary *)mj_objectClassInArray {

    return @{@"reply_list" : @"JGJQuaSafeCheckRecordReplyModel"};
}

@end

@implementation JGJQuaSafeCheckRecordModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list" : @"JGJQuaSafeCheckRecordListModel"};
}

@end
