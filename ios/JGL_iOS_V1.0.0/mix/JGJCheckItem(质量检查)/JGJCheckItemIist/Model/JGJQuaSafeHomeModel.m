//
//  JGJQuaSafeHomeModel.m
//  JGJCompany
//
//  Created by yj on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeHomeModel.h"

#import "JGJNineSquareView.h"

@implementation JGJQuaSafeHomeModel

@end

@implementation JGJInspectHomeModel

- (NSArray *)topTitles {
    
    NSString *inspect_pro = @"检查项";
    
    if ([NSString isEmpty:self.inspect_pro] || [self.inspect_pro isEqualToString:@"0"]) {
        
        inspect_pro = @"检查项";
        
    }else {
        
        inspect_pro = [NSString stringWithFormat:@"检查项(%@)",self.inspect_pro ];
        
    }
    
    NSString *inspect_all = @"所有计划";
    
    if ([NSString isEmpty:self.inspect_all] || [self.inspect_all isEqualToString:@"0"]) {
        
        inspect_all = @"所有计划";
        
    }else {
        
        inspect_all = [NSString stringWithFormat:@"所有计划(%@)",self.inspect_all];
        
    }
    
    NSString *inspect_finish = @"已完成";
    
    if ([NSString isEmpty:self.inspect_finish] || [self.inspect_finish isEqualToString:@"0"]) {
        
        inspect_finish = @"已完成";
        
    }else {
        
        inspect_finish = [NSString stringWithFormat:@"已完成(%@)",self.inspect_finish];
        
    }
    
    _topTitles = @[inspect_pro, inspect_all, inspect_finish];
    
    return _topTitles;
}

- (NSArray *)aboutMeTitles {
    
//    inspect_my_oper
    
    NSString *inspect_my_oper = @"待我执行";
    
    if ([NSString isEmpty:self.inspect_my_oper] || [self.inspect_my_oper isEqualToString:@"0"]) {
        
        inspect_my_oper = @"待我执行";
        
    }else {
        
        inspect_my_oper = [NSString stringWithFormat:@"待我执行(%@)",self.inspect_my_oper];
        
    }
    
    NSString *inspect_my_creater = @"我创建的";
    
    if ([NSString isEmpty:self.inspect_my_creater] || [self.inspect_my_creater isEqualToString:@"0"]) {
        
        inspect_my_creater = @"我创建的";
        
    }else {
        
        inspect_my_creater = [NSString stringWithFormat:@"我创建的(%@)",self.inspect_my_creater];
        
    }
    
    _aboutMeTitles = @[inspect_my_oper, inspect_my_creater];
    
    return _aboutMeTitles;
}

@end


@implementation JGJInspectListModel


@end

@implementation JGJInspectListDetailCheckItemModel

@end

@implementation JGJInspectListDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"pro_list" : @"JGJInspectListDetailCheckItemModel",
             
             @"member_list" : @"JGJSynBillingModel"
             };
}

@end


@implementation JGJInspectPlanProInfoDotReplyModel


@end

@implementation JGJInspectPlanProInfoDotListModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"dot_status_list" : @"JGJInspectPlanProInfoDotReplyModel"};
}

@end


@implementation JGJInspectPlanProInfoContentListModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"dot_list" : @"JGJInspectPlanProInfoDotListModel"};
}

@end

@implementation JGJInspectPlanProInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"content_list" : @"JGJInspectPlanProInfoContentListModel"};
}

@end


@implementation JGJInspectPlanRecordPathModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"log_list" : @"JGJInspectPlanRecordPathReplyModel"};
}

@end

@implementation JGJInspectPlanRecordPathReplyModel

- (CGFloat)cellHeight {
    
    CGFloat fixHeight = 65;
    
    CGFloat thumbnailTop = 7;
    
    CGFloat thumbnailBottom = 16;
    
    CGFloat thumbnailH = [JGJNineSquareView nineSquareViewHeight:self.imgs headViewWH:80 headViewMargin:5];
    
    _cellHeight = fixHeight + self.contentHeight + thumbnailH + thumbnailTop + thumbnailBottom;;
    
    if (self.imgs.count == 0 && ![NSString isEmpty:self.comment]) {
        
        _cellHeight -= (thumbnailH + thumbnailBottom);
        
    } else if (self.imgs.count == 0 && [NSString isEmpty:self.comment]) {
        
        _cellHeight = fixHeight;
        
    }else if (self.imgs.count > 0 && ![NSString isEmpty:self.comment]) {
        
        _cellHeight = fixHeight + self.contentHeight + thumbnailH + thumbnailTop + thumbnailBottom;
        
    }else if (self.imgs.count > 0 && [NSString isEmpty:self.comment]) {
        
        _cellHeight -= (self.contentHeight + 10);
        
    }
    
    return _cellHeight;
}

- (CGFloat)contentHeight {
        
    _contentHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 118 content:self.comment font:AppFont30Size lineSpace:1] + 1;
    
    return _contentHeight;
}

@end
