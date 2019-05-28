//
//  JGJChatWorkOtherRecruitInfoCell.m
//  mix
//
//  Created by ccclear on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJChatWorkOtherRecruitInfoCell.h"
#import "UILabel+GNUtil.h"

@interface JGJChatWorkOtherRecruitInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *verbTitle;

@property (weak, nonatomic) IBOutlet UILabel *verbType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verbTypeConstraintW;

@property (weak, nonatomic) IBOutlet UILabel *verbTreatmentInfo;
@property (weak, nonatomic) IBOutlet UILabel *verbTreatmentDetailInfo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verbTreatmentInfoConstraintH;

@end
@implementation JGJChatWorkOtherRecruitInfoCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.verbType.clipsToBounds = YES;
    self.verbType.layer.cornerRadius = 3;
}

- (void)setChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    _chatListModel = chatListModel;
    
    _verbTreatmentDetailInfo.hidden = YES;
    // 招工信息标题
    self.verbTitle.text = _chatListModel.recruitMsgModel.pro_title;
    
    NSString *balanceway = _chatListModel.recruitMsgModel.classes.balance_way;
    
    NSString *unitStr = [NSString stringWithFormat:@"元/%@", balanceway];
    
    NSString *money = _chatListModel.recruitMsgModel.classes.money;
    
    CGFloat conver_money = [NSString stringWithFormat:@"%@", money].doubleValue;
    
    if (conver_money >= 10000) {
        
        money = [self unitConverWithMoney:money];
    }
    
    NSString *max_money = _chatListModel.recruitMsgModel.classes.max_money;
    
    CGFloat conver_max_money = [NSString stringWithFormat:@"%@", max_money].doubleValue;
    
    if (conver_max_money >= 10000) {
        
        max_money = [self unitConverWithMoney:max_money];
    }
    
    NSString *merMoney = money;
    
    if (![NSString isEmpty:_chatListModel.recruitMsgModel.classes.max_money]) {
        
        if (![_chatListModel.recruitMsgModel.classes.max_money isEqualToString:@"0"]) {
            
            merMoney = [NSString stringWithFormat:@"%@~%@",money, max_money];
        }
        
    }
    
    NSString *total_scale = _chatListModel.recruitMsgModel.classes.total_scale;
    
    CGFloat conver_total_scale = [NSString stringWithFormat:@"%@", total_scale].doubleValue;
    
    if (conver_total_scale >= 10000) {
        
        total_scale = [self unitConverWithMoney:total_scale];
    }
    
    if (_chatListModel.recruitMsgModel.classes.cooperate_type.type_id == 1) { //点工
        
        self.verbType.backgroundColor = TYColorHex(0xeb7a4e);
        
        if ([_chatListModel.recruitMsgModel.classes.money isEqualToString:@"0"] || [NSString isEmpty:_chatListModel.recruitMsgModel.classes.money]) {
            
            unitStr = @"面议";
            
            self.verbTreatmentInfo.text = [NSString stringWithFormat:@"工资标准  %@",unitStr];
            [self.verbTreatmentInfo markText:unitStr withColor:AppFontd7252cColor];
            
        }else {
            
            self.verbTreatmentInfo.text = [NSString stringWithFormat:@"工资标准  %@ %@", merMoney, unitStr];
            [self.verbTreatmentInfo markText:merMoney withColor:AppFontd7252cColor];
        }
        
        
    }else if (_chatListModel.recruitMsgModel.classes.cooperate_type.type_id == 2 || _chatListModel.recruitMsgModel.classes.cooperate_type.type_id == 3){ //包工
        
        self.verbType.backgroundColor = TYColorHex(0xeb4e4e);
        
        unitStr = _chatListModel.recruitMsgModel.classes.balance_way;
        
        if ([total_scale isEqualToString:@"0"] || [NSString isEmpty:total_scale]) {
            
            unitStr = @"面议";
            
            self.verbTreatmentInfo.text = [NSString stringWithFormat:@"总规模  %@",unitStr];
            [self.verbTreatmentInfo markText:unitStr withColor:AppFontd7252cColor];
            
        }else {
            
            self.verbTreatmentInfo.text = [NSString stringWithFormat:@"总规模  %@ %@", total_scale, unitStr];
            [self.verbTreatmentInfo markText:total_scale withColor:AppFontd7252cColor];
            
        }
        
    }else if (_chatListModel.recruitMsgModel.classes.cooperate_type.type_id == 4) { //突击队
        
        _verbTreatmentDetailInfo.hidden = NO;
        NSString *time = _chatListModel.recruitMsgModel.classes.work_begin;
        
        if ([NSString isEmpty:time]) {
            
            time = @"";
        }
        
        self.verbType.backgroundColor = TYColorHex(0x4886ed);
        
        
        if ([money isEqualToString:@"0"] || [NSString isEmpty:money]) {
            
            unitStr = @"面议";
            
            self.verbTreatmentInfo.text = [NSString stringWithFormat:@"开工时间：%@", time?:@""];
            self.verbTreatmentDetailInfo.text = [NSString stringWithFormat:@"工钱：%@",unitStr];
            
            [self.verbTreatmentInfo markattributedTextArray:@[_chatListModel.recruitMsgModel.classes.work_begin?:@"",unitStr] color:AppFontd7252cColor font:FONT(12) isGetAllText:YES withLineSpacing:0];
            
            [self.verbTreatmentDetailInfo markattributedTextArray:@[unitStr] color:AppFontd7252cColor font:FONT(12) isGetAllText:YES withLineSpacing:0];
            
        }else {
            
            NSString *unit = [NSString stringWithFormat:@"元/人/%@", balanceway];
            
            self.verbTreatmentInfo.text = [NSString stringWithFormat:@"开工时间：%@",time?:@""];
            self.verbTreatmentDetailInfo.text = [NSString stringWithFormat:@"工钱：%@ %@",merMoney,unitStr];
            [self.verbTreatmentInfo markattributedTextArray:@[_chatListModel.recruitMsgModel.classes.work_begin?:@""] color:AppFontd7252cColor font:FONT(12) isGetAllText:YES withLineSpacing:0];
            [self.verbTreatmentDetailInfo markattributedTextArray:@[merMoney] color:AppFontd7252cColor font:FONT(12) isGetAllText:YES withLineSpacing:0];
        }
    }
    
    self.verbType.text = _chatListModel.recruitMsgModel.classes.cooperate_type.type_name;
    CGFloat verbTypeW = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 15) content:self.verbType.text font:12].width;
    self.verbTypeConstraintW.constant = verbTypeW + 5;
    
//    CGFloat verbTreatmentInfoH = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 64 - 76 - 36 - self.verbTypeConstraintW.constant font:12 lineSpace:5 content:self.verbTreatmentInfo.text];
    
//    if (_chatListModel.recruitMsgModel.classes.cooperate_type.type_id == 4) { //突击队
//
//        self.verbTreatmentInfoConstraintH.constant = 12;
//
//    }else {
//
//        self.verbTreatmentInfoConstraintH.constant = 12;
//    }
}

//金额转换
- (NSString *)unitConverWithMoney:(NSString *)money {
    
    if ([NSString isEmpty:money]) {
        
        return @"0";
    }
    
    double moneyF = [NSString stringWithFormat:@"%@", money].doubleValue;
    
    double m = (moneyF / 1000.0);
    
    double converMoney = [NSString stringWithFormat:@"%.2lf",m / 10.0].doubleValue;
    
    NSString *moneyceil = [NSString stringWithFormat:@"%.2lf", converMoney];
    
    moneyceil = [moneyceil stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    if (![NSString isEmpty:moneyceil] && moneyceil.length > 2 && [moneyceil containsString:@"."]) {
        
        NSString *lastZero = [moneyceil substringFromIndex:moneyceil.length - 1];
        
        if ([lastZero isEqualToString:@"0"]) {
            
            moneyceil = [moneyceil substringToIndex:moneyceil.length - 1];
        }
        
    }
    
    moneyceil = (moneyF >= 1000) ? [NSString stringWithFormat:@"%@万", moneyceil] : money;
    
    return moneyceil;
}
@end
