//
//  JGJMemeberMangerCell.m
//  mix
//
//  Created by yj on 2018/11/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemeberMangerCell.h"

#import "UIButton+JGJUIButton.h"

#import "UILabel+GNUtil.h"

@interface JGJMemeberMangerCell()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selBtnW;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *desLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkAccountBtnW;

@property (weak, nonatomic) IBOutlet UIButton *checkAccountBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaBtnW;

@property (weak, nonatomic) IBOutlet UIButton *evaBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaBtnTrail;

@end

@implementation JGJMemeberMangerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.checkAccountBtn.layer setLayerBorderWithColor:AppFont999999Color width:0.5 radius:2.5];
    
    [self.evaBtn.layer setLayerBorderWithColor:AppFont999999Color width:0.5 radius:2.5];
    
    [self.checkAccountBtn setTitleColor:AppFont000000Color forState:UIControlStateNormal];
    
    [self.evaBtn setTitleColor:AppFont000000Color forState:UIControlStateNormal];
    
    [self.headButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    
    self.headButton.userInteractionEnabled = NO;
    
    self.nameLable.textColor = AppFont333333Color;
    
    self.nameLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.desLable.textColor = AppFont333333Color;
    
    self.desLable.font = [UIFont systemFontOfSize:AppFont24Size];
        
    self.selBtnW.constant = 0;
    
    self.selBtn.hidden = YES;
    
    self.selBtnW.constant = 12;
    
}

- (void)setWorkerManger:(JGJSynBillingModel *)workerManger {
    
    _workerManger = workerManger;
    
    [self.headButton setMemberPicButtonWithHeadPicStr:workerManger.head_pic memberName:workerManger.name memberPicBackColor:workerManger.modelBackGroundColor membertelephone:workerManger.telph];

    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];

    self.nameLable.text = workerManger.name;

    if (![NSString isEmpty:workerManger.proname]) {

        NSString *des = [NSString stringWithFormat:@"你在%@为他干活", workerManger.proname];

        if (!JLGisMateBool) {

            des = [NSString stringWithFormat:@"他在%@干活", workerManger.proname];

        }

        self.desLable.text = des;

        [self.desLable markText:workerManger.proname withColor:AppFontEB4E4EColor];
        
        [self jgj_updateWithConstraint:self.nameTop constant:10];
        
    }else {

        [self setHiddenMemberTel];
    }
    
    if (![NSString isEmpty:self.searchValue]) {

        [self.nameLable markText:self.searchValue withColor:AppFontEB4E4EColor];

        [self.desLable markText:self.searchValue withColor:AppFontEB4E4EColor];
    }
    
    //按钮状态
    [self btnStatusWithWorkerManger:workerManger];
    
    //更新按钮多选状态
    
    [self jgj_updateWithConstraint:self.selBtnW constant:self.isCancelStatus ? 40 : 12];
    
    self.selBtn.selected = workerManger.isSelected;
    
    [self setPreMaxWidthWorkerManger:workerManger];
    
}

- (void)setPreMaxWidthWorkerManger:(JGJSynBillingModel *)workerManger {
    
    CGFloat maxW = TYGetUIScreenWidth - 43 - 27;
    
    BOOL is_comment = workerManger.is_comment;
    
    BOOL is_check_accounts = workerManger.is_check_accounts;
    
    if (!is_comment && !is_check_accounts) {
        
        maxW = TYGetUIScreenWidth - 43 - 27;
        
    }else if (is_comment ^ is_check_accounts) {
        
        maxW = TYGetUIScreenWidth - 43 - 90;
        
    }else if (is_comment && is_check_accounts) {
        
        maxW = TYGetUIScreenWidth - 43 - 163;
        
    }else {
        
        maxW = TYGetUIScreenWidth - 43 - 153;
    }
    
    self.desLable.preferredMaxLayoutWidth = maxW;
    
}

- (void)btnStatusWithWorkerManger:(JGJSynBillingModel *)workerManger {
    
    //删除状态隐藏评价、对账按钮
    
    self.selBtn.hidden = !_isCancelStatus;
    
    self.evaBtn.hidden = _isCancelStatus;
    
    self.checkAccountBtn.hidden = _isCancelStatus;
    
    //非删除状态
    if (!_isCancelStatus) {
        
        self.evaBtn.hidden = !workerManger.is_comment;
        
        self.checkAccountBtn.hidden = !workerManger.is_check_accounts;
        
    }
    
    //能评价和能对账
    
    CGFloat btnW = 63.0;
    
    CGFloat padding = 12.0;
    
    [self jgj_updateWithConstraint:self.evaBtnTrail constant:5];
    
    if (workerManger.is_comment && workerManger.is_check_accounts) {
        
        [self jgj_updateWithConstraint:self.evaBtnW constant:btnW];
        
        [self jgj_updateWithConstraint:self.checkAccountBtnW constant:btnW];
        
    }else if (!workerManger.is_comment && workerManger.is_check_accounts) {
        
        [self jgj_updateWithConstraint:self.evaBtnW constant:0];
        
        [self jgj_updateWithConstraint:self.checkAccountBtnW constant:btnW];
        
    }else if (workerManger.is_comment && !workerManger.is_check_accounts) {
        
        [self jgj_updateWithConstraint:self.evaBtnW constant:btnW];
        
        [self jgj_updateWithConstraint:self.checkAccountBtnW constant:0];
        
        [self jgj_updateWithConstraint:self.evaBtnTrail constant:0];
        
    }else {
        
        [self jgj_updateWithConstraint:self.evaBtnW constant:0];
        
        [self jgj_updateWithConstraint:self.checkAccountBtnW constant:0];
        
    }
    
    if (_isCancelStatus) {
        
        [self jgj_updateWithConstraint:self.evaBtnW constant:0];
        
        [self jgj_updateWithConstraint:self.checkAccountBtnW constant:0];
        
    }
    
}

- (void)setTrail:(NSLayoutConstraint *)trail {
    
    _trail = trail;
    
    [self jgj_updateWithConstraint:trail constant:40];
    
}

#pragma mark - 隐藏姓名子类使用
- (void)setHiddenMemberTel {
    
    self.desLable.hidden = YES;
    
    [self jgj_updateWithConstraint:self.nameTop constant:21];
    
    [self layoutIfNeeded];
}

- (void)jgj_updateWithConstraint:(NSLayoutConstraint *)constraint constant:(CGFloat)constant {
    
    if (constraint.constant == constant) {
        
        return;
        
    }
    
    constraint.constant = constant;
    
}


- (IBAction)evaBtnPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(memeberMangerCell:btnType:)]) {
        
        [self.delegate memeberMangerCell:self btnType:EvaBtnType];
        
    }
    
}

- (IBAction)checkPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(memeberMangerCell:btnType:)]) {
        
        [self.delegate memeberMangerCell:self btnType:checkAccountBtnType];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
