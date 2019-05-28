//
//  JGJRecordWorkpointStaView.m
//  mix
//
//  Created by yj on 2018/7/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkpointStaView.h"

#import "UILabel+GNUtil.h"

#import "JGJTabPaddingView.h"

@interface JGJRecordWorkpointStaView () {
    
    NSInteger _showType;
}

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIView *shortWorkFlagView;

@property (weak, nonatomic) IBOutlet UILabel *shortWorkLable;

@property (weak, nonatomic) IBOutlet UILabel *borrowMoneyLable;

@property (weak, nonatomic) IBOutlet UIView *borrowMoneyFlagView;

@property (weak, nonatomic) IBOutlet UIView *contractorFlagView;

@property (weak, nonatomic) IBOutlet UILabel *contractorLable;

@property (weak, nonatomic) IBOutlet UILabel *settlementMoneyLable;

@property (weak, nonatomic) IBOutlet UIView *settlementMoneyFlagView;


@property (weak, nonatomic) IBOutlet UILabel *workLable;

@property (weak, nonatomic) IBOutlet UILabel *overTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *borrowCountLable;

@property (weak, nonatomic) IBOutlet UILabel *settlementCountLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

@property (weak, nonatomic) IBOutlet JGJTabPaddingView *paddingView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnH;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation JGJRecordWorkpointStaView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self commonSet];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonSet];
        
    }
    
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    UIColor *redColor = AppFontEB4E4EColor;
    
    UIColor *greenColor = AppFont83C76EColor;
    
    CGFloat radius = 3.0;
    
    self.shortWorkFlagView.backgroundColor = redColor;
    
    self.contractorFlagView.backgroundColor = redColor;
    
    self.borrowMoneyFlagView.backgroundColor = greenColor;
    
    self.settlementMoneyFlagView.backgroundColor = greenColor;
    
    [self.shortWorkFlagView.layer setLayerCornerRadius:radius];
    
    [self.contractorFlagView.layer setLayerCornerRadius:radius];
    
    [self.borrowMoneyFlagView.layer setLayerCornerRadius:radius];
    
    [self.settlementMoneyFlagView.layer setLayerCornerRadius:radius];
    
    //借支、结算
    
    UIColor *lightColor = AppFont666666Color;
    
    UIColor *blackColor = AppFont333333Color;
    
    self.shortWorkLable.textColor = blackColor;
    
    self.borrowMoneyLable.textColor = blackColor;
    
    self.contractorLable.textColor = blackColor;
    
    self.settlementMoneyLable.textColor = blackColor;
    
    
    self.workLable.textColor = lightColor;
    
    self.borrowCountLable.textColor = lightColor;
    
    self.overTimeLable.textColor = lightColor;
    
    self.settlementCountLable.textColor = lightColor;
    
    if (TYIS_IPHONE_5_OR_LESS) {
        
        self.leading.constant = 12;
        
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    tap.numberOfTapsRequired = 1;
    
    [self addGestureRecognizer:tap];
    
    self.paddingView.bottomLineView.hidden = YES;
}

- (void)setRecordWorkPointModel:(JGJRecordWorkPointModel *)recordWorkPointModel {
    
    _recordWorkPointModel = recordWorkPointModel;
    
    //默认显示方式
    JGJAccountShowTypeModel *selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    _showType = selTypeModel.type;
    
    [self setRecordWorkStaModel:_recordWorkPointModel];
    
}

- (void)setRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {

    
    UIColor *redColor = AppFontEB4E4EColor;
    
    UIColor *greenColor = AppFont83C76EColor;
        
    //点工
    
    NSString *unit = @"小时";
    
    if (_showType == 0 || _showType == 1) {
        
        unit = @"个工";
    }
    
    NSString *over_work_unit = @"小时";
    
    if (_showType == 1) {
        
        over_work_unit = @"个工";
    }
    
    NSString *space = @":  ";
    
    //上班
    
    self.workLable.text = [NSString stringWithFormat:@"上班%@%@%@", space,_showType == 2 ?recordWorkStaModel.work_type.manhour :recordWorkStaModel.work_type.working_hours, unit];
    
    //点工
    self.shortWorkLable.text = [NSString stringWithFormat:@"点工%@%@", space, recordWorkStaModel.work_type.amounts?:@""];
    
    UIFont *boldFont = [UIFont systemFontOfSize:AppFont30Size];
    
    //加班
    
    self.overTimeLable.text = [NSString stringWithFormat:@"加班%@%@%@", space,_showType != 1 ?recordWorkStaModel.work_type.overtime :recordWorkStaModel.work_type.overtime_hours, over_work_unit];
    
    //包工
    self.contractorLable.text =  [NSString stringWithFormat:@"包工%@%@", space, recordWorkStaModel.contract_type.amounts?:@""];
    
    
    // 借支
    
    self.borrowMoneyLable.text =  [NSString stringWithFormat:@"%@%@", space, recordWorkStaModel.expend_type.amounts?:@""];
    
    // 借支
    
    self.borrowMoneyLable.text =  [NSString stringWithFormat:@"借支%@%@", space, recordWorkStaModel.expend_type.amounts?:@""];
    
    NSString *countUnit = [NSString stringWithFormat:@" 笔"];
    
    //借支笔数
    self.borrowCountLable.text = [NSString stringWithFormat:@"借支%@%@%@", space, recordWorkStaModel.expend_type.total?:@"", countUnit];
    
    //结算
    self.settlementMoneyLable.text = [NSString stringWithFormat:@"结算%@%@", space, recordWorkStaModel.balance_type.amounts?:@""];
    
    //结算笔数
    self.settlementCountLable.text = [NSString stringWithFormat:@"结算%@%@%@", space, recordWorkStaModel.balance_type.total?:@"", countUnit];
    
    //点工
    if (![NSString isEmpty:recordWorkStaModel.work_type.amounts]) {
        
        [self.shortWorkLable markText:recordWorkStaModel.work_type.amounts withFont:boldFont color:redColor];
        
    }
    
    //包工
    if (![NSString isEmpty:recordWorkStaModel.contract_type.amounts]) {
        
        [self.contractorLable markText:recordWorkStaModel.contract_type.amounts withFont:boldFont color:redColor];
    }
    
    
    if (![NSString isEmpty:recordWorkStaModel.expend_type.amounts]) {
        
        [self.borrowMoneyLable markText:recordWorkStaModel.expend_type.amounts withFont:boldFont color:greenColor];
    }
    
    if (![NSString isEmpty:recordWorkStaModel.balance_type.amounts]) {
        
        [self.settlementMoneyLable markText:recordWorkStaModel.balance_type.amounts withFont:boldFont color:greenColor];
    }
    
}

- (void)setIs_change_date:(BOOL)is_change_date {
    
    _is_change_date = is_change_date;
    
    if (is_change_date) {
        
        self.checkBtnH.constant = 0;
        
    }
    
    self.checkBtn.hidden = is_change_date;

    
}

- (void)setIs_hidden_checkBtn:(BOOL)is_hidden_checkBtn {
    
    _is_hidden_checkBtn = is_hidden_checkBtn;
    
    if (is_hidden_checkBtn) {
        
        self.checkBtnH.constant = 0;
        
    }
    
    self.checkBtn.hidden = is_hidden_checkBtn;
    
}

- (void)tapAction {
    
    if (self.tapActionBlock) {
        
        self.tapActionBlock(self.recordWorkPointModel);
        
    }
    
}

+(CGFloat)staViewHeight {
    
    return 166;
}

@end
