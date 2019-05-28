//
//  JGJPersonWageListTopView.m
//  mix
//
//  Created by Tony on 2016/7/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJPersonWageListTopView.h"
#import "JGJLabel.h"
#import "UILabel+GNUtil.h"
@interface JGJPersonWageListTopView()

@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet UILabel *manhourLabel;

@property (weak, nonatomic) IBOutlet UILabel *overHourLabel;

//@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;

//@property (weak, nonatomic) IBOutlet UILabel *expendLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *incomeTextLabel;
//@property (strong, nonatomic) IBOutlet UILabel *browLable;
//@property (strong, nonatomic) IBOutlet UILabel *residueLable;
//@property (strong, nonatomic) IBOutlet UILabel *incomeLable;
//@property (strong, nonatomic) IBOutlet UILabel *totalLables;

//@property (strong, nonatomic) IBOutlet UILabel *browLable;
//@property (strong, nonatomic) IBOutlet UILabel *resideLable;
@property (strong, nonatomic) IBOutlet UILabel *inComeLable;//应收应付
@property (strong, nonatomic) IBOutlet UILabel *browLable;//借支
@property (strong, nonatomic) IBOutlet UILabel *jieSuanLable;//结算
@property (strong, nonatomic) IBOutlet UILabel *remainSumLable;//余额

@property (strong, nonatomic) UILabel *departLable;//分割线


@end

@implementation JGJPersonWageListTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self.contentView addSubview:self.departLable];
    [self addSubview:self.contentView];
//    self.incomeTextLabel.text  = JLGisMateBool?@"应收总和:":@"应付总和:";
    self.inComeLable.text  = JLGisMateBool?@"应收总和:":@"应付总和:";

}

- (void)setJgjPersonWageListModel:(JGJPersonWageListModel *)jgjPersonWageListModel{
    _jgjPersonWageListModel = jgjPersonWageListModel;
    
    self.manhourLabel.attributedText = [JGJLabel getWorkHour:[NSString stringWithFormat:@"%.1f",jgjPersonWageListModel.total_manhour] hourColor:TYColorHex(0xd7252c) fontSize:12.f];

    self.overHourLabel.attributedText = [JGJLabel getWorkHour:[NSString stringWithFormat:@"%.1f",jgjPersonWageListModel.total_overtime] hourColor:TYColorHex(0x83c76e) fontSize:12.f];
    
//
//    self.incomeLabel.text = [NSString stringWithFormat:@"￥%.2f",jgjPersonWageListModel.total_income];
//
        self.inComeLable.text = @"  ";
//    self.expendLabel.text = [NSString stringWithFormat:@"￥%.2f",jgjPersonWageListModel.total_expend];
    self.browLable.text = @"  ";
    self.
//    self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",jgjPersonWageListModel.total];
    self.remainSumLable.text  = @"  ";
    self.jieSuanLable.text  = @"  ";

//    if (jgjPersonWageListModel.total_income >= 10000 ||jgjPersonWageListModel.total_income <= 10000) {
//    self.inComeLable.text = [NSString stringWithFormat:@"%@\n￥%.2f万", JLGisMateBool?@"应收总和:":@"应付总和:",jgjPersonWageListModel.total_income/10000];
//        [self.inComeLable markText:[NSString stringWithFormat:@"￥%.2f万",jgjPersonWageListModel.total_income/10000] withFont:[UIFont systemFontOfSize:11] color:AppFont333333Color];
//
//    }else{
    self.inComeLable.text = [NSString stringWithFormat:@"%@\n%.2f", @"工资总和:",jgjPersonWageListModel.total_income];
    [self.inComeLable markText:[NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_income] withFont:[UIFont systemFontOfSize:11] color:AppFont333333Color];
//    }
    
//    NSString *total_incomestr = [NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_income];
//    
//    self.inComeLable.text =  [NSString stringWithFormat:@"%@\n￥%@", JLGisMateBool?@"应收总和:":@"应付总和:",JGJMoneyNumStr(total_incomestr)];
//    
//    [self.inComeLable markText:[NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_income] withFont:[UIFont systemFontOfSize:11] color:AppFont333333Color];
//    if (jgjPersonWageListModel.total_income < 0) {
//        [self.inComeLable markText:[@"￥" stringByAppendingString:JGJMoneyNumStr(total_incomestr)] withFont:[UIFont systemFontOfSize:11] color:AppFonte83c76eColor];
//    }
//    if (jgjPersonWageListModel.total_expend >= 10000 ||jgjPersonWageListModel.total_expend <= -10000) {
//        self.browLable.text = [NSString stringWithFormat:@"借支总和:\n￥%.2f万", jgjPersonWageListModel.total_expend/10000];
//        [self.browLable markText:[NSString stringWithFormat:@"￥%.2f万",jgjPersonWageListModel.total_expend/10000] withFont:[UIFont systemFontOfSize:11] color:AppFonte83c76eColor];
//    }else{
    self.browLable.text = [NSString stringWithFormat:@"借支总和:\n%.2f", jgjPersonWageListModel.total_expend];
    [self.browLable markText:[NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_expend] withFont:[UIFont systemFontOfSize:11] color:AppFonte83c76eColor];
//    }
    
//    NSString *total_incomestrs = [NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_expend];
//    
//    self.browLable.text =  [NSString stringWithFormat:@"借支总和:\n￥%@", JGJMoneyNumStr(total_incomestrs)];
//    [self.browLable markText:[@"￥" stringByAppendingString:JGJMoneyNumStr(total_incomestrs)] withFont:[UIFont systemFontOfSize:11] color:AppFonte83c76eColor];
    
//    if (jgjPersonWageListModel.total_balance >= 10000 ||jgjPersonWageListModel.total_balance <= -10000) {
//        self.jieSuanLable.text = [NSString stringWithFormat:@"结算总和:\n￥%.2f万", jgjPersonWageListModel.total_balance/10000];
//        [self.jieSuanLable markText:[NSString stringWithFormat:@"￥%.2f万",jgjPersonWageListModel.total_balance/10000] withFont:[UIFont systemFontOfSize:11] color:AppFonte83c76eColor];
//
//    }else{
    self.jieSuanLable.text = [NSString stringWithFormat:@"结算总和:\n%.2f", jgjPersonWageListModel.total_balance];
    [self.jieSuanLable markText:[NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_balance] withFont:[UIFont systemFontOfSize:11] color:AppFonte83c76eColor];
//    }
    
//    NSString *total_incomestrss = [NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_balance];
//    
//    self.jieSuanLable.text =   [NSString stringWithFormat:@"结算总和:\n￥%@", JGJMoneyNumStr(total_incomestrss)];
//    [self.jieSuanLable markText:[@"￥" stringByAppendingString:JGJMoneyNumStr(total_incomestrss)] withFont:[UIFont systemFontOfSize:11] color:AppFonte83c76eColor];

    
//    if (jgjPersonWageListModel.total >= 10000 ||jgjPersonWageListModel.total <= -10000) {
//        self.remainSumLable.text = [NSString stringWithFormat:@"余额:\n￥%.2f万",jgjPersonWageListModel.total/10000];
//        [self.remainSumLable markText:[NSString stringWithFormat:@"￥%.2f万",jgjPersonWageListModel.total/10000] withFont:[UIFont systemFontOfSize:11] color:AppFontd7252cColor];
//
//    }else{
    self.remainSumLable.text = [NSString stringWithFormat:@"余额:\n%.2f",jgjPersonWageListModel.total];
     [self.remainSumLable markText:[NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total] withFont:[UIFont systemFontOfSize:11] color:AppFontd7252cColor];
//    }
    
//    NSString *total_incomestrsss = [NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total];
    
//    self.remainSumLable.text =   [NSString stringWithFormat:@"余额:\n￥%@", JGJMoneyNumStr(total_incomestrsss)];
//    [self.remainSumLable markText:[NSString stringWithFormat:@"￥%.2f",jgjPersonWageListModel.total] withFont:[UIFont systemFontOfSize:11] color:AppFontd7252cColor];
//    if (jgjPersonWageListModel.total < 0) {
//    [self.remainSumLable markText:[@"￥" stringByAppendingString:JGJMoneyNumStr(total_incomestr)] withFont:[UIFont systemFontOfSize:11] color:AppFonte83c76eColor];
//    }
    [self.contentView layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    [self.bottomView.layer setLayerBorderWithColor:TYColorHex(0xffffff) width:1 radius:10];
    [self.layer setLayerShadowWithColor:[UIColor blackColor] offset:CGSizeMake(0, 0) opacity:0.5 radius:5];
}
-(UILabel *)departLable
{
    if (!_departLable) {
        _departLable = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(_manhourLabel.frame)+CGRectGetHeight(_manhourLabel.frame) - 1, TYGetUIScreenWidth - 20, .5)];
        _departLable.backgroundColor = AppFontdbdbdbColor;
        
    }
    return _departLable;
}

@end
