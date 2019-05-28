//
//  JGJRecordStaListCell.m
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordStaListCell.h"

#define WorkerUndertakeTop 29 //工人承包到顶部距离

#define UndertakeTop JLGisLeaderBool ? 46 : WorkerUndertakeTop //承包到顶部距离

@interface JGJRecordStaListCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;


@property (weak, nonatomic) IBOutlet UILabel *work;
@property (weak, nonatomic) IBOutlet UILabel *overTime;
@property (weak, nonatomic) IBOutlet UILabel *contractor;
@property (weak, nonatomic) IBOutlet UILabel *borrow;

@property (weak, nonatomic) IBOutlet UILabel *settlement;


@property (weak, nonatomic) IBOutlet UILabel *shortWorkTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shortWorkCenterConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shortWorkRightConstraints;

@property (weak, nonatomic) IBOutlet UILabel *contractorTitle;

@property (weak, nonatomic) IBOutlet UILabel *borrowTitle;

@property (weak, nonatomic) IBOutlet UILabel *settlementTitle;

@property (weak, nonatomic) IBOutlet UILabel *unSettlementTitle;



@property (weak, nonatomic) IBOutlet UILabel *shortWorkMoney;

//包工分包

@property (weak, nonatomic) IBOutlet UILabel *contractorMoney;

@property (weak, nonatomic) IBOutlet UILabel *borrowMoney;

@property (weak, nonatomic) IBOutlet UILabel *settlementMoney;

@property (weak, nonatomic) IBOutlet UILabel *unSettlementMoney;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyTrail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lead;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTrail;

//分包顶部距离。单个搜索的时候。工头角色用

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contractorTitleTop;


//借支、结算、包工记账共用借支样式

@property (weak, nonatomic) IBOutlet UILabel *comType;

@property (weak, nonatomic) IBOutlet UILabel *comtitle;

@property (weak, nonatomic) IBOutlet UILabel *comMoney;

//点工金额居中,当前只筛选点工才显示

@property (weak, nonatomic) IBOutlet UILabel *otherShortWorkTitle;

@property (weak, nonatomic) IBOutlet UILabel *otherShortWorkMoney;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTop;

//分包承包
@property (weak, nonatomic) IBOutlet UILabel *undertakeTitle;

//分包承包钱
@property (weak, nonatomic) IBOutlet UILabel *undertakeMoney;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *undertakeTop;



@end

@implementation JGJRecordStaListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initialSubView];
    
    self.workTrail.constant = TYIS_IPHONE_5_OR_LESS ? 12 : MaxTrail;
    
    self.moneyTrail.constant = TYIS_IPHONE_5_OR_LESS ? 104 : 120;
    
    self.nextImageView.hidden = TYIS_IPHONE_5_OR_LESS;
    
    self.undertakeTop.constant = UndertakeTop;
    
    //默认显示方式
    JGJAccountShowTypeModel *selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    _showType = selTypeModel.type;
    
    self.name.preferredMaxLayoutWidth = 82.5;
    
}

- (void)setStaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    _staListModel = staListModel;
    
    if (![NSString isEmpty:self.des]) {
        
        self.name.text = self.des;
        
    }else {

        self.name.text = staListModel.name;
        
        if ([staListModel.class_type isEqualToString:@"person"]) {
            
            self.name.text = [NSString cutWithContent:staListModel.name maxLength:4];
        }
        
    }
    
    NSString *space = @":  ";
    
    //点工
    
    NSString *unit = @"小时";
    
    if (_showType == 0 || _showType == 1) {
        
        unit = @"个工";
    }
    
    NSString *over_work_unit = @"小时";
    
    if (_showType == 1) {
        
        over_work_unit = @"个工";
    }
        
    NSString *otherUnit = @"笔";
    
    self.work.text = [NSString stringWithFormat:@"上班%@%@%@", space,_showType == 2 ?staListModel.work_type.manhour :staListModel.work_type.working_hours, unit];
    
    self.overTime.text = [NSString stringWithFormat:@"加班%@%@%@", space,_showType != 1 ?staListModel.work_type.overtime :staListModel.work_type.overtime_hours, over_work_unit];
    
    self.shortWorkMoney.text = staListModel.work_type.amounts;
    
    //包工(分包)
    
    self.contractor.text = @"包工(分包)";
    
    self.contractorMoney.text = [NSString stringWithFormat:@"%@", staListModel.contract_type_two.amounts];
    
    //包工(承包)
    
    self.undertakeTitle.text = @"包工(承包):";
    
    self.undertakeMoney.text = [NSString stringWithFormat:@"%@", staListModel.contract_type_one.amounts];
    
    //借支
    
    self.borrow.text = [NSString stringWithFormat:@"借支%@%@%@", space,staListModel.expend_type.total, otherUnit];
    
    self.borrowMoney.text = [NSString stringWithFormat:@"%@", staListModel.expend_type.amounts];
    
    //结算
    
    self.settlement.text = [NSString stringWithFormat:@"结算%@%@%@", space,staListModel.balance_type.total, otherUnit];
    
    self.settlementMoney.text = [NSString stringWithFormat:@"%@", staListModel.balance_type.amounts];
    
    //未结兼容老接口
    
    if ([NSString isEmpty:staListModel.balance_amount]) {
        
        self.unSettlementTitle.hidden = YES;
        
        self.unSettlementMoney.text = @"";
        
    } else if (![NSString isEmpty:staListModel.balance_amount]) {
        
        self.unSettlementMoney.text = [NSString stringWithFormat:@"%@", staListModel.balance_amount];
        
        self.unSettlementTitle.hidden = NO;
        
    }
    
    //新接口评价使用
    
    if (![NSString isEmpty:staListModel.unbalance_type.amounts]) {
        
        self.unSettlementMoney.text = [NSString stringWithFormat:@"%@", staListModel.unbalance_type.amounts];
        
        self.unSettlementTitle.hidden = NO;
        
    }
    
    //偏移到金额尾部头部的偏移距离
    
    CGFloat offsetTrail = 10;
    
    CGFloat minTrail = TYIS_IPHONE_5_OR_LESS ? 20 : 80;
    
    //设置尾部间距
    CGFloat moneyTrail = self.maxTrail + offsetTrail + MaxTrail;
    
    if (self.maxTrail > MaxTrail) {
        
        moneyTrail = self.maxTrail + MaxTrail + offsetTrail;

    }else {
        
        moneyTrail = MaxTrail + (TYIS_IPHONE_5_OR_LESS ? 13 : 20);
        
        if (!TYIS_IPHONE_5_OR_LESS && moneyTrail < minTrail) {
            
            moneyTrail = minTrail;
        }

    }
    
    //包工尾部距离比例0.37
    
    if (moneyTrail >= 0.37 * TYGetUIScreenWidth) {
        
        self.moneyTrail.constant = 0.37 * TYGetUIScreenWidth;
        
    }else {
        
        self.moneyTrail.constant = moneyTrail;
    }
    
    NSArray *account_types = @[];
    
    if (![NSString isEmpty:self.accounts_type]) {
        
        account_types = [self.accounts_type componentsSeparatedByString:@","];
        
    }
    
    //搜索类型大于1个或者为空的时候，显示全部
    BOOL isHidden = account_types.count > 1 || [NSString isEmpty:self.accounts_type];
    
    [self isHiddenLable:!isHidden];
    
    //设置顶部距离
    if (staListModel.is_change_workTop) {
        
        [self setworkTopConstantWithStaListModel:staListModel];
        
    }else {
        
        [self jgj_updateWithConstraint:self.workTop constant:12];
        
    }
    
    //包工分包顶部距离
    
    [self jgj_updateWithConstraint:self.contractorTitleTop constant:29];
    
    //包工承包顶部距离
    
    [self jgj_updateWithConstraint:self.undertakeTop constant:UndertakeTop];
    
    //单个搜索类型显示
    
    if (account_types.count > 0) {
        
        NSInteger account_type = [account_types.firstObject integerValue];
        
        if (account_types.count == 1) {
            
            [self filterSingleStyleWithStaListModel:staListModel];
            
            //点工 、包工记账、包工记工天。不用共用样式
            BOOL isHidden = account_type == 1 || account_type == 5 || (account_type == 2 && JLGisLeaderBool);
            
            [self isHiddenComLable:isHidden];
            
            self.comType.hidden = !(account_type == 2 || account_type == 3 || account_type == 4);
            
            //点工才显示
            [self isHiddenOtherShortLable:account_type != 1];
            
        }else {
            
            self.shortWorkCenterConstraints.constant = 0;
            self.shortWorkRightConstraints.constant = 20;
            [self isHiddenComLable:YES];
            
            [self isHiddenOtherShortLable:YES];
            
        }
        
    }else {
        
        [self isHiddenComLable:YES];
        
        [self isHiddenOtherShortLable:YES];
    }

     self.name.hidden = NO;
    
}

- (void)setworkTopConstantWithStaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    [self jgj_updateWithConstraint:self.workTop constant:(staListModel.height / 2.0) - (86 / 2.0) + 12];
    
}

#pragma mark-借支、结算、包工记账显示或隐藏
- (void)isHiddenComLable:(BOOL)isHidden {
    
    self.comType.hidden = isHidden;
    
    self.comtitle.hidden = isHidden;
    
    self.comMoney.hidden = isHidden;
}

#pragma mark-点工金额显示或隐藏
- (void)isHiddenOtherShortLable:(BOOL)isHidden {
    
    self.otherShortWorkTitle.hidden = isHidden;
    
    self.otherShortWorkMoney.hidden = isHidden;
    
}

- (void)setIsScreenShowLine:(BOOL)isScreenShowLine {
    
    _isScreenShowLine = isScreenShowLine;
    
    if (_isScreenShowLine) {
        
        self.trail.constant = 0;
        
        self.lead.constant = 0;
        
    }else {
        
        self.trail.constant = 12;
        
        self.lead.constant = 12;
    }
    
}

- (void)setIsHiddenName:(BOOL)isHiddenName {
    
    _isHiddenName = isHiddenName;
    
    self.name.hidden = isHiddenName;
    
    if (_isHiddenName) {

        [self.work mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(self.contentView).mas_offset(20);
        }];

    }else {
        
        [self.work mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(self.name);
        }];
    }
    
}

#pragma mark - 搜索单个样式

- (void)filterSingleStyleWithStaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    NSArray *account_types = [self.accounts_type componentsSeparatedByString:@","];
    
    //点工、包工记账、借支、结算、包工考勤
    
    if (account_types.count == 1) {
        
        NSInteger account_type = [account_types.firstObject integerValue];
        
        switch (account_type) {
                
            case 1:{ //点工
                
                [self setWork_typeWithStaListModel:staListModel];
            }
                
                break;
                
            case 2:{ //包工记账.承包分包。(工人之后承包)
                
                [self setContract_typeStyleWithStaListModel:staListModel];
                
            }
                
                break;
                
            case 3:{ //借支
                
                [self setBorrowStyleWithStaListModel:staListModel];
            }
                
                break;
                
            case 4:{ //结算
                
                [self setSettlementStyleWithStaListModel:staListModel];
            }
                
                break;
                
            case 5:{ //包工考勤
                
                [self setAttendance_typeWithStaListModel:staListModel];
            }
                
                break;
                
            default:
                break;
        }
        
        self.name.hidden = NO;
        
    }
    
}

#pragma mark - 借支
- (void)setBorrowStyleWithStaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    self.comType.text = self.borrow.text;
    
    self.comType.textColor = self.borrow.textColor;
    
    self.comType.font = self.borrow.font;
    
    
    self.comtitle.text = self.borrowTitle.text;
    
    self.comtitle.textColor = self.borrowTitle.textColor;
    
    self.comtitle.font = self.borrowTitle.font;
    
    
    self.comMoney.text = self.borrowMoney.text;
    
    self.comMoney.textColor = self.borrowMoney.textColor;
    
    self.comMoney.font = self.borrowMoney.font;
    
}

- (void)isHiddenLable:(BOOL)isHidden {
    
    self.name.hidden = isHidden;
    
    self.work.hidden = isHidden;
    
    self.overTime.hidden = isHidden;
    
    self.contractor.hidden = isHidden;
    
    self.borrow.hidden = isHidden;
    
    self.settlement.hidden = isHidden;
    
    
    self.shortWorkTitle.hidden = isHidden;
    
    //分包
    self.contractorTitle.hidden = isHidden || JLGisMateBool;
    
    self.borrowTitle.hidden = isHidden;
    
    self.settlementTitle.hidden = isHidden;
    
    
    self.undertakeTitle.hidden = isHidden;
    
    self.shortWorkMoney.hidden = isHidden;
    
    //分包
    self.contractorMoney.hidden = isHidden || JLGisMateBool;
    
    //承包
    self.undertakeMoney.hidden = isHidden;
    
    self.borrowMoney.hidden = isHidden;
    
    self.settlementMoney.hidden = isHidden;
    
    self.comType.hidden = !isHidden;
    
    self.comtitle.hidden = !isHidden;
    
    self.comMoney.hidden = !isHidden;
}

#pragma mark - 结算
- (void)setSettlementStyleWithStaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    self.comType.text = self.settlement.text;
    
    self.comtitle.text = self.settlementTitle.text;
    
    self.comMoney.text = self.settlementMoney.text;
    
    self.comMoney.textColor = self.settlementMoney.textColor;
}

#pragma mark - 包工记账
- (void)setContract_typeStyleWithStaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    NSString *space = @":  ";
    
    NSString *contract = [NSString stringWithFormat:@"包工%@%@%@", space,staListModel.contract_type.total, @"笔"];
    
    self.comType.text = contract;
    
    if (JLGisMateBool) {
        
        self.comtitle.text = self.undertakeTitle.text;
        
        self.comMoney.text = self.undertakeMoney.text;
        
        self.comMoney.textColor = self.undertakeMoney.textColor;
        
        //工人是包工分包
        
        self.contractorTitle.hidden = YES;
        
        self.contractorMoney.hidden = YES;
        
    }else {
        
        self.undertakeTitle.hidden = NO;
        
        self.undertakeMoney.hidden = NO;
        
        self.contractorTitle.hidden = NO;
        
        self.contractorMoney.hidden = NO;
        
        [self jgj_updateWithConstraint:self.contractorTitleTop constant:10];
        
        [self jgj_updateWithConstraint:self.undertakeTop constant:WorkerUndertakeTop];
        
        
    }
    
}

#pragma mark - 包工考勤
- (void)setAttendance_typeWithStaListModel:(JGJRecordWorkStaListModel *)staListModel {

    self.work.hidden = NO;
    
    self.overTime.hidden = NO;
    
    self.shortWorkTitle.hidden = YES;
    
    self.shortWorkMoney.hidden = NO;
    
    self.shortWorkCenterConstraints.constant = 10;
    self.shortWorkRightConstraints.constant = 50;
    self.shortWorkMoney.text = @"-";
    [self setSingleWorkContactConstantWithStaListModel:staListModel];
    
}

#pragma mark - 点工
- (void)setWork_typeWithStaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    self.work.hidden = NO;
    
    self.overTime.hidden = NO;
    
    self.otherShortWorkTitle.text = self.shortWorkTitle.text;
    
    self.otherShortWorkTitle.textColor = self.shortWorkTitle.textColor;
    
    self.otherShortWorkMoney.text = self.shortWorkMoney.text;
    
    self.otherShortWorkMoney.textColor = self.shortWorkMoney.textColor;
    
    [self setSingleWorkContactConstantWithStaListModel:staListModel];
    
    
}

#pragma mark - 设置点工和包工考勤，顶部间距

- (void)setSingleWorkContactConstantWithStaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    if (staListModel.is_change_workTop) {
     
        [self jgj_updateWithConstraint:self.workTop constant:(staListModel.height / 2.0) - 6 - 12];
        
    }
    
}

- (void)jgj_updateWithConstraint:(NSLayoutConstraint *)constraint constant:(CGFloat)constant {
    
    if (constraint.constant == constant) {
        
        return;
        
    }
    
    constraint.constant = constant;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialSubView {
    
    UIColor *darkColor = AppFont333333Color;
    
    UIColor *lightColor = AppFont333333Color;
    
    UIColor *redColor = AppFontEB4E4EColor;
    
    UIColor *blueColor = AppFont5BA0EDColor;
    
    UIColor *greenColor = AppFont83C76EColor;
    
    self.name.textColor = darkColor;
    
    self.work.textColor = darkColor;
    
    self.overTime.textColor = darkColor;
    
    self.contractor.textColor = darkColor;
    
    self.borrow.textColor = darkColor;
    
    self.settlement.textColor = darkColor;
    
    
    self.shortWorkTitle.textColor = lightColor;
    
    self.contractorTitle.textColor = lightColor;
    
    self.borrowTitle.textColor = lightColor;
    
    self.settlementTitle.textColor = lightColor;
    
    self.unSettlementTitle.textColor = lightColor;
    

    self.shortWorkMoney.textColor = redColor;
    
    self.contractorMoney.textColor = redColor;
    
    self.borrowMoney.textColor = greenColor;
    
    self.settlementMoney.textColor = greenColor;
    
    self.unSettlementMoney.textColor = blueColor;
    
    self.undertakeMoney.textColor = JLGisLeaderBool ? greenColor : redColor;
    
}

#pragma mark - 比较宽度，显示的时候最大宽度为准
+ (CGFloat)maxWidthWithStaList:(NSArray *)staList {
    
    NSMutableArray *moneyWidths = [NSMutableArray new];
    
    NSMutableArray *maxMoneyWidths = [NSMutableArray new];
    
    CGFloat max = MaxTrail;
    
    CGFloat font = 16.5;
    
    for (JGJRecordWorkStaListModel *staListModel in staList) {
        
        //点工
        CGFloat width1 = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth, 50) content:staListModel.work_type.amounts font:font].width;
        
        CGFloat offset = 34;
        
        //包工承包
        CGFloat width2 = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth, 50) content:staListModel.contract_type_one.amounts font:font].width + offset;
        
        //借支
        CGFloat width3 = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth, 50) content:staListModel.expend_type.amounts font:font].width;;
        
        //结算
        
        CGFloat width4 = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth, 50) content:staListModel.balance_type.amounts font:font].width;
        
        CGFloat width5 = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth, 50) content:staListModel.balance_amount font:font].width;
        
        //包工分包
        CGFloat width6 = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth, 50) content:staListModel.contract_type_two.amounts font:font].width + offset;
        
        if (width1 > MaxTrail) {
            
            [moneyWidths addObject:@(width1)];
        }
        
        if (width2 > MaxTrail) {
            
            [moneyWidths addObject:@(width2)];
        }
        
        if (width3 > MaxTrail) {
            
            [moneyWidths addObject:@(width3)];
        }
        
        if (width4 > MaxTrail) {
            
            [moneyWidths addObject:@(width4)];
        }
        
        if (width5 > MaxTrail) {
            
            [moneyWidths addObject:@(width5)];
        }
        
        if (width6 > MaxTrail) {
            
            [moneyWidths addObject:@(width6)];
        }
        
        if (moneyWidths.count > 0) {
            
            max = [NSString maxSizeMaxWidths:moneyWidths];
        }
        
        [maxMoneyWidths addObject:@(max)];
        
    }
    
    NSSet *set = [NSSet setWithArray:maxMoneyWidths];
    
    TYLog(@"%@",[set allObjects]);
    
    max = [NSString maxSizeMaxWidths:[set allObjects]];
    
    return max;
}

+ (CGFloat)cellHeight {
    
    return JLGisLeaderBool ? 106 : 92;;
}

@end
