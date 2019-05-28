//
//  JGJChatWorkTypeAllInfoCell.m
//  mix
//
//  Created by yj on 17/2/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJChatWorkTypeAllInfoCell.h"
#import "UILabel+GNUtil.h"
#import "CustomView.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"

@interface JGJChatWorkTypeAllInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *memberTitleLable;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UILabel *workAgeLable;
@property (weak, nonatomic) IBOutlet UILabel *memberDes;

@property (weak, nonatomic) IBOutlet UILabel *typeNameLable;
@property (weak, nonatomic) IBOutlet UILabel *typeNameDesLable;
@property (weak, nonatomic) IBOutlet UILabel *typeUnitLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberDesH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomDis;

@property (weak, nonatomic) IBOutlet UIButton *helperButton;

@property (weak, nonatomic) IBOutlet UIView *vertifyView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vertifyViewBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vertifyViewH;

@property (weak, nonatomic) IBOutlet UIButton *vertifyBtn;

@property (weak, nonatomic) IBOutlet UILabel *vertifyDes;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentDetailViewH;

@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@end

@implementation JGJChatWorkTypeAllInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.typeNameLable.textColor = [UIColor whiteColor];
    self.typeNameDesLable.textColor = AppFont999999Color;
    self.typeUnitLable.textColor = AppFont999999Color;
    [self.typeNameLable.layer setLayerCornerRadius:JGJCornerRadius];
    self.typeNameLable.backgroundColor = TYColorHex(0xeb7a4e);
    self.memberName.textColor = AppFont333333Color;
    self.workAgeLable.textColor = AppFont666666Color;
    self.memberDes.textColor = AppFont999999Color;
    self.titleLable.textColor = AppFont333333Color;
    self.titleLable.font = [UIFont boldSystemFontOfSize:AppFont32Size];
    
    UITapGestureRecognizer *proDetailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSkipProDetail:)];
    [self.topView addGestureRecognizer:proDetailTap];
    
    UITapGestureRecognizer *perInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSkipPerInfo:)];
    [self.bottomView addGestureRecognizer:perInfoTap];
    
    [self.helperButton.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
    
//    self.vertifyView.backgroundColor = AppFontf1f1f1Color;
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    self.backgroundColor = AppFontf1f1f1Color;
    
    self.contentDetailView.backgroundColor = [UIColor clearColor];
    
    self.vertifyView.backgroundColor = [UIColor clearColor];
    
    self.vertifyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
}

- (void)setChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    _chatListModel = chatListModel;
    self.titleLable.text = _chatListModel.msg_prodetail.prodetailactive.protitle;
    Cooperate_Type *cooperate_Type = chatListModel.msg_prodetail.prodetailactive.classes.cooperate_type;
    JGJChatFindHelperModel *searchuser  = _chatListModel.msg_prodetail.searchuser;
    
    Classes *classes = chatListModel.msg_prodetail.prodetailactive.classes;
    
    NSString *balanceway = _chatListModel.msg_prodetail.prodetailactive.classes.balanceway;
    
    NSString *unitStr = [NSString stringWithFormat:@"元/%@", balanceway];
    
    NSString *money = classes.money;
    
    CGFloat conver_money = [NSString stringWithFormat:@"%@", money].doubleValue;
    
    if (conver_money >= 10000) {
        
        money = [self unitConverWithMoney:money];
    }
    
    NSString *max_money = classes.max_money;
    
    CGFloat conver_max_money = [NSString stringWithFormat:@"%@", max_money].doubleValue;
    
    if (conver_max_money >= 10000) {
        
        max_money = [self unitConverWithMoney:max_money];
    }
    
    NSString *merMoney = money;
    
    if (![NSString isEmpty:classes.max_money]) {
        
        if (![classes.max_money isEqualToString:@"0"]) {
            
            merMoney = [NSString stringWithFormat:@"%@~%@",money, max_money];
        }
        
    }
    
    NSString *total_scale = classes.total_scale;
    
    CGFloat conver_total_scale = [NSString stringWithFormat:@"%@", total_scale].doubleValue;
    
    if (conver_total_scale >= 10000) {
        
        total_scale = [self unitConverWithMoney:total_scale];
    }
    
    if (cooperate_Type.code == 1) { //点工
        
        self.typeNameDesLable.text = @"工资标准";
        
        self.typeNameLable.backgroundColor = TYColorHex(0xeb7a4e);
        
        if ([classes.money isEqualToString:@"0"] || [NSString isEmpty:classes.money]) {
            
            unitStr = @"面议";
            
            self.typeUnitLable.text = unitStr;
            
            [self.typeUnitLable markText:unitStr withColor:AppFontd7252cColor];
            
        }else {
            
            self.typeUnitLable.text = [NSString stringWithFormat:@"%@ %@", merMoney, unitStr];
            
            [self.typeUnitLable markText:merMoney withColor:AppFontd7252cColor];
        }
        
        
    }else if (cooperate_Type.code == 2 || cooperate_Type.code == 3){ //包工
        
        self.typeNameDesLable.text = @"总规模";
        
        self.typeNameLable.backgroundColor = TYColorHex(0xeb4e4e);
        
        unitStr = _chatListModel.msg_prodetail.prodetailactive.classes.balanceway;
        
        if ([total_scale isEqualToString:@"0"] || [NSString isEmpty:total_scale]) {
            
            unitStr = @"面议";
            
            self.typeUnitLable.text = unitStr;
            
            [self.typeUnitLable markText:total_scale withColor:AppFontd7252cColor];
            
        }else {
            
            self.typeUnitLable.text = [NSString stringWithFormat:@"%@ %@", total_scale, unitStr];
            
            [self.typeUnitLable markText:total_scale withColor:AppFontd7252cColor];
        }

    }else if (cooperate_Type.code == 4) { //突击队
        
        NSString *time = classes.work_begin;
        
        if ([NSString isEmpty:time]) {
            
            time = @"";
        }
        
        self.typeNameLable.backgroundColor = TYColorHex(0x4886ed);
        
        self.typeNameDesLable.text = [NSString stringWithFormat:@"开工时间：%@", time?:@""];
        
        [self.typeNameDesLable markText:classes.work_begin?:@"" withColor:AppFontd7252cColor];
        
        if ([money isEqualToString:@"0"] || [NSString isEmpty:money]) {
            
            unitStr = @"面议";
            
            self.typeUnitLable.text = unitStr;
            
            self.typeUnitLable.text = [NSString stringWithFormat:@"工钱：%@", unitStr];
            
             [self.typeUnitLable markText:unitStr withColor:AppFontd7252cColor];
            
        }else {
            
            NSString *unit = [NSString stringWithFormat:@"元/人/%@", balanceway];
            
            self.typeUnitLable.text = [NSString stringWithFormat:@"工钱：%@ %@", merMoney, unit];
            
            [self.typeUnitLable markText:merMoney withColor:AppFontd7252cColor];
        }
        
    }
    
    self.typeNameLable.text = cooperate_Type.name;
    
    self.typeUnitLable.textAlignment = NSTextAlignmentCenter;
    
    self.memberDes.text = _chatListModel.msg_prodetail.searchuser.title;
    self.memberName.text = searchuser.realname;
    self.workAgeLable.text = [NSString stringWithFormat:@"工龄：%@年", searchuser.work_year];
    
    self.topViewH.constant = ProDetailTopViewH;
    
    self.topView.hidden = NO;
    
    self.bottomViewH.constant = ProDetailBottomViewH;
    
    self.bottomView.hidden = NO;
    
    self.lineView.hidden = NO;
    
    self.memberDesH.constant = ProDetailMemberDesH;
    
    self.memberDes.hidden = NO;
    
    self.vertifyView.hidden = YES;
    
    self.vertifyViewH.constant = 0;
    
    self.vertifyDes.hidden = YES;
    
    if (!chatListModel.msg_prodetail.prodetailactive) {
        
        self.topViewH.constant = 0;
        
        self.topView.hidden = YES;
        
    }
    
    NSString *verified = chatListModel.msg_prodetail.verified;
    
    if (![NSString isEmpty:verified]) {
        
        if (![verified isEqualToString:@"3"]) {
            
            self.vertifyViewH.constant = ChatVertifyViewH;
            
            self.vertifyView.hidden = NO;
            
            self.vertifyDes.hidden = NO;
            
        }
        
    }
    
    if (!chatListModel.msg_prodetail.searchuser) {
        
        self.bottomViewH.constant = 0;
        
        self.bottomView.hidden = YES;
        
        self.lineView.hidden = YES;
        
    }else {
        
        UIColor *nameColor = [NSString modelBackGroundColor:searchuser.realname];
        [self.workAgeLable markText:searchuser.work_year withColor:AppFontd7252cColor];
        
        [self.helperButton setMemberPicButtonWithHeadPicStr:searchuser.head_pic memberName:searchuser.realname memberPicBackColor:nameColor];
        self.helperButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    }
    
    if ([NSString isEmpty:searchuser.title] ) {
        self.memberDesH.constant = 0;
        self.memberDes.hidden = YES;
    }
    
    self.contentDetailViewH.constant = self.topViewH.constant + self.bottomViewH.constant + self.vertifyViewH.constant + 10;
    
    NSString *vertify = chatListModel.msg_prodetail.verified;
    
    if (!chatListModel.msg_prodetail.searchuser && !chatListModel.msg_prodetail.prodetailactive && ![chatListModel.msg_prodetail.verified isEqualToString:@"3"]) {
        
        self.vertifyViewBottom.constant = 20;
    }
    
    [self.vertifyBtn setEnlargeEdgeWithTop:50 right:10 bottom:20 left:10];
    
    
    //认证信息显示
    
    [self vertifyDesWithChatListModel:chatListModel];
    
}

#pragma mark - 认证信息描述

- (void)vertifyDesWithChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    BOOL  isMine = chatListModel.belongType == JGJChatListBelongMine;
    
    NSString *vertify = chatListModel.msg_prodetail.verified;
    
    self.vertifyDes.textColor = AppFont666666Color;
    
    self.vertifyBtn.hidden = !isMine;
    
    self.vertifyViewBottom.constant = 0;
    
    if (![NSString isEmpty:vertify]) {
        
        if (![chatListModel.msg_prodetail.verified isEqualToString:@"3"]) {
            
            if (isMine) {
                
                //招工自己未认证
                
                NSString *des = @"你还未实名认证，实名认证能提高找工作的成功率";
                
                if (chatListModel.msg_prodetail.searchuser) {
                    
                    des = @"你还未实名认证，实名认证能提高招工的成功率";
                    
                }else if (!chatListModel.msg_prodetail.searchuser && !chatListModel.msg_prodetail.prodetailactive) {
                    
                    des = @"你还未实名认证，实名认证能提高招工的成功率";
                    
                    self.vertifyViewBottom.constant = 20;
                    
                }else if (!chatListModel.msg_prodetail.searchuser && chatListModel.msg_prodetail.prodetailactive) {
                    
                    
                }
                
                self.vertifyDes.text = des;
                
                
            }else {
                
                self.vertifyDes.text = [NSString stringWithFormat:@"%@ 未实名认证", chatListModel.group_name?:@""];
                
                [self.vertifyDes markText:chatListModel.group_name?:@"" withColor:AppFontFF6600Color];
                
            }
            
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

#pragma mark - 子类用的
- (void)subClassInit{
    //添加长按手势
    [self addLongTapHandler];
}

#pragma mark - 进入详情页
- (void)handleSkipProDetail:(UITapGestureRecognizer *)tap {
    if ([self.chatWorkTypeDelegate respondsToSelector:@selector(chatWorkTypeAllInfoCellWithCell:didSelectedType:)]) {
        [self.chatWorkTypeDelegate chatWorkTypeAllInfoCellWithCell:self didSelectedType:JGJChatWorkProDetailType];
    }
}

#pragma mark - 进入TA的资料
- (void)handleSkipPerInfo:(UITapGestureRecognizer *)tap {
    if ([self.chatWorkTypeDelegate respondsToSelector:@selector(chatWorkTypeAllInfoCellWithCell:didSelectedType:)]) {
        [self.chatWorkTypeDelegate chatWorkTypeAllInfoCellWithCell:self didSelectedType:JGJChatWorkPerInfoDetailType];
    }
}

- (IBAction)vertifyBtnPressed:(UIButton *)sender {
    
    if (sender.hidden) {
        
        return;
    }
    
    if ([self.chatWorkTypeDelegate respondsToSelector:@selector(chatWorkTypeAllInfoCellWithCell:didSelectedType:)]) {
        [self.chatWorkTypeDelegate chatWorkTypeAllInfoCellWithCell:self didSelectedType:JGJChatMyIdcardType];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
