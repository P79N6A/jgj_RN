//
//  JGJChatWorkSendRecruitInfoCell.m
//  mix
//
//  Created by ccclear on 2019/3/28.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJChatWorkSendRecruitInfoCell.h"
#import "UILabel+GNUtil.h"
@interface JGJChatWorkSendRecruitInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *verbInfoBackView;
@property (weak, nonatomic) IBOutlet UILabel *verbType;// 类型
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verbTypeConstraintW;

@property (weak, nonatomic) IBOutlet UIButton *sendVerbInfoBtn;
@property (weak, nonatomic) IBOutlet UILabel *verbTitle;// 招工标题

@property (weak, nonatomic) IBOutlet UILabel *verbTreatmentInfo;// 待遇
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verbTreatmentInfoConstraintH;

@property (weak, nonatomic) IBOutlet UIView *isHaveVerbBackView;// 是否认证
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recruitInfoConstraintH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recruitInfoContraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recruitTopInfoConsraintH;

@end
@implementation JGJChatWorkSendRecruitInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.verbInfoBackView.clipsToBounds = YES;
    self.verbInfoBackView.layer.cornerRadius = 10;
    
    self.verbType.clipsToBounds = YES;
    self.verbType.layer.cornerRadius = 3;
    
    self.sendVerbInfoBtn.clipsToBounds = YES;
    self.sendVerbInfoBtn.layer.cornerRadius = 2;
}

- (void)setChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    _chatListModel = chatListModel;
    
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
        
        NSString *time = _chatListModel.recruitMsgModel.classes.work_begin;
        
        if ([NSString isEmpty:time]) {
            
            time = @"";
        }
        
        self.verbType.backgroundColor = TYColorHex(0x4886ed);
        
        
        if ([money isEqualToString:@"0"] || [NSString isEmpty:money]) {
            
            unitStr = @"面议";
            
            self.verbTreatmentInfo.text = [NSString stringWithFormat:@"开工时间：%@  工钱：%@", time?:@"",unitStr];
            
            [self.verbTreatmentInfo markattributedTextArray:@[_chatListModel.recruitMsgModel.classes.work_begin?:@"",unitStr] color:AppFontd7252cColor];
            
        }else {
            
            NSString *unit = [NSString stringWithFormat:@"元/人/%@", balanceway];
            
            self.verbTreatmentInfo.text = [NSString stringWithFormat:@"开工时间：%@  工钱：%@ %@",time?:@"", merMoney, unit];
            
            [self.verbTreatmentInfo markattributedTextArray:@[_chatListModel.recruitMsgModel.classes.work_begin?:@"",merMoney] color:AppFontd7252cColor];
        }
        
    }
    
    self.verbType.text = _chatListModel.recruitMsgModel.classes.cooperate_type.type_name;
    CGFloat verbTypeW = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 15) content:self.verbType.text font:12].width;
    self.verbTypeConstraintW.constant = verbTypeW + 5;
    
    // 验证是否实名 隐藏和显示底部信息
    if ([self.chatListModel.recruitMsgModel.verified isEqualToString:@"3"]) {// 已实名认证
        
        self.isHaveVerbBackView.hidden = YES;
        self.recruitInfoConstraintH.constant = 0;
        self.recruitInfoContraintTop.constant = 0;
        if (_chatListModel.is_send_success) {
            
            self.verbInfoBackView.hidden = YES;
            self.recruitTopInfoConsraintH.constant = 0;
            
        }else {
            
            self.verbInfoBackView.hidden = NO;
            self.recruitTopInfoConsraintH.constant = 68;
        }
        
    }else {
        
        self.isHaveVerbBackView.hidden = NO;
        self.recruitInfoConstraintH.constant = 45;
        
        if (_chatListModel.is_send_success) {
            
            self.verbInfoBackView.hidden = YES;
            self.recruitTopInfoConsraintH.constant = 0;
            self.recruitInfoContraintTop.constant = 11;
            
        }else {
            
            self.verbInfoBackView.hidden = NO;
            self.recruitTopInfoConsraintH.constant = 68;
            self.recruitInfoContraintTop.constant = 46;
        }
    }
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


- (IBAction)sendVerbInfoBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(sendRecruitInfoMsgWithChatListModel:cell:)]) {
        
        [self.delegate sendRecruitInfoMsgWithChatListModel:self.chatListModel cell:self];
    }
}
- (IBAction)gotoRealNameAuthentication:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(recruitCellGotoRealNameAuthenticationWithChatListModel:cell:)]) {
        
        [self.delegate recruitCellGotoRealNameAuthenticationWithChatListModel:self.chatListModel cell:self];
    }
}

@end
