//
//  JGJWorkCircleTodayAccountCell.m
//  mix
//
//  Created by yj on 16/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkCircleTodayAccountCell.h"
#import "JSBadgeView.h"
#import "UILabel+GNUtil.h"
#import "CustomView.h"
@interface JGJWorkCircleTodayAccountCell ()

@property (weak, nonatomic) IBOutlet UIButton *checkRecordPointButton;
@property (strong, nonatomic) JSBadgeView *badgeView ;

@property (weak, nonatomic) IBOutlet UILabel *normalWorkHourLable;
@property (weak, nonatomic) IBOutlet UILabel *normalWorkHourTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *workOverLable;
@property (weak, nonatomic) IBOutlet UILabel *workOverTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *incomeLable;

@property (weak, nonatomic) IBOutlet UILabel *incometitleLable;

@property (weak, nonatomic) IBOutlet UIView *containView;


@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (weak, nonatomic) IBOutlet UIView *leftLineView;

@property (weak, nonatomic) IBOutlet UIView *middleLineView;

@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *normalWorkHourLableCenterX;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *incomeLableCenterX;

@end

@implementation JGJWorkCircleTodayAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];

    UIFont *mainfont = [UIFont boldSystemFontOfSize:AppFont44Size];
    UIFont *detailTitlefont = [UIFont systemFontOfSize:AppFont22Size];
    
    self.workOverLable.textColor = AppFont333333Color;
    self.workOverLable.font = mainfont;
    self.workOverTitleLable.font = detailTitlefont;
    self.workOverTitleLable.textColor = AppFont999999Color;
    
    self.normalWorkHourLable.textColor = AppFont333333Color;
    self.normalWorkHourLable.font = mainfont;
    self.normalWorkHourTitleLable.font = detailTitlefont;
    self.normalWorkHourTitleLable.textColor = AppFont999999Color;
    
    self.incomeLable.textColor = AppFont333333Color;
    self.incomeLable.font = mainfont;
    self.incometitleLable.font = detailTitlefont;
    self.incometitleLable.textColor = AppFont999999Color;
    
    [self.containView.layer setLayerCornerRadius:JGJCornerRadius];
    self.checkRecordPointButton.backgroundColor = AppFontFBFBFBColor;
    
    [self.checkRecordPointButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkRecordPointButton.layer setLayerBorderWithColor:AppFontdbdbdbColor width:0.5 radius:8.0];
    self.checkRecordPointButton.backgroundColor = AppFontEB4E4EColor;
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJWorkCircleTodayAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJWorkCircleTodayAccountCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setYzgWorkDayModel:(YZGWorkDayModel *)yzgWorkDayModel {
    _yzgWorkDayModel = yzgWorkDayModel;

    CGFloat recordWorkPointsFloat = yzgWorkDayModel.selectType == workCellType?yzgWorkDayModel.total_workday:yzgWorkDayModel.todaybill_count;
    
    CGFloat incomeNoRecordsFloat = yzgWorkDayModel.selectType == workCellType?yzgWorkDayModel.total_amounts:yzgWorkDayModel.yestodaybill_count;

    self.normalWorkHourLable.text = [self getStrByNum:recordWorkPointsFloat];
    
    NSString *income = [self getStrByNum:incomeNoRecordsFloat];
    
    self.incomeLable.text = income;
    
    NSString *unit = @"";
    
    if (yzgWorkDayModel.selectType == workCellType) {
        
        if ([NSString isEmpty:yzgWorkDayModel.unit] || [yzgWorkDayModel.unit isEqualToString:@"元"]) {
            
            unit = @"";
            
        }else if ([yzgWorkDayModel.unit isEqualToString:@"万元"]) {
            
            unit = @"万";
            
        }
        
        self.incomeLable.text = [NSString stringWithFormat:@"%@%@",income, unit];
        
        if ([NSString isFloatZero:incomeNoRecordsFloat]) {
            
            self.incomeLable.text = @"0.00";
        }
        
        [self.incomeLable markText:unit withFont:[UIFont boldSystemFontOfSize:AppFont22Size] color:AppFont333333Color];
    }
    
    if (!JLGisLeaderBool) {
        
        self.leftLineView.hidden = NO;
        self.rightLineView.hidden = NO;
        self.middleLineView.hidden = YES;
        
        CGFloat total_overtime = [yzgWorkDayModel.total_overtime floatValue];
        
        self.workOverLable.text = [self getStrByNum:total_overtime];
        
        [self showNormalWorkerInfoYzgWorkDayModel:yzgWorkDayModel];
        
    }else {
        
        self.leftLineView.hidden = YES;
        self.rightLineView.hidden = YES;
        self.middleLineView.hidden = NO;
        
        [self showNormalWorkerLeaderInfoYzgWorkDayModel:yzgWorkDayModel];
        
        [self.normalWorkHourLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.containView).offset(-((TYGetUIScreenWidth - 24) / 4.0));
        }];
        
        [self.incomeLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.containView).offset((TYGetUIScreenWidth - 24) / 4.0);
        }];
        
    }
    
    self.workOverLable.hidden = JLGisLeaderBool;
    self.workOverTitleLable.hidden = JLGisLeaderBool;
    
}
#pragma mark - 显示普通工人信息
- (void)showNormalWorkerInfoYzgWorkDayModel:(YZGWorkDayModel *)yzgWorkDayModel {

    self.normalWorkHourTitleLable.text = @"今日上班(小时)";
//    [self.normalWorkHourTitleLable markText:@"(小时)" withColor:AppFontccccccColor];
    
    self.workOverTitleLable.text = @"今日加班(小时)";
//    [self.workOverTitleLable markText:@"(小时)" withColor:AppFontccccccColor];
    
//    self.incometitleLable.text = @"记工收入(元)";
    self.incometitleLable.text = [NSString stringWithFormat:@"今日收入(%@)",@"元"];
    
//    [self.incometitleLable markText:[NSString stringWithFormat:@"(%@)",yzgWorkDayModel.unit] withColor:AppFontccccccColor];
}

#pragma mark - 显示班组长信息
- (void)showNormalWorkerLeaderInfoYzgWorkDayModel:(YZGWorkDayModel *)yzgWorkDayModel {
    
    //昨日已记
    self.normalWorkHourTitleLable.text = @"今日已记(笔)";
//    [self.normalWorkHourTitleLable markText:@"(笔)" withColor:AppFontccccccColor];
    
    //昨日记工
    self.incometitleLable.text = @"昨日记工(笔)";
//    [self.incometitleLable markText:@"(笔)" withColor:AppFontccccccColor];
    
}

//- (void)setUnread_msg_count:(NSString *)unread_msg_count {
//    _unread_msg_count = unread_msg_count;
//    self.badgeView.badgeText = unread_msg_count;
//    self.badgeView.hidden = [unread_msg_count isEqualToString:@"0"];
//}

- (NSString *)getStrByNum:(CGFloat )numFloat{
    CGFloat dFloat = roundf(numFloat);//对num取整
    NSString *dFloatStr = [NSString string];
    
    if (dFloat == numFloat) {//整数
        
        dFloatStr =[NSString stringWithFormat:@"%@",@(dFloat)];
        
    }else{//小数
        
        dFloatStr =[NSString stringWithFormat:@"%.2f",numFloat];
        
    }
    
    return dFloatStr;
}

- (NSString *)getTodayIncomeStrByNum:(CGFloat )numFloat{
    
    NSString *dFloatStr = [NSString string];
    
    dFloatStr =[NSString stringWithFormat:@"%.2f",numFloat];
    
    return dFloatStr;
}

//处理新通知,同步项目，查看记工，马上记一笔
- (IBAction)handleButtonAction:(UIButton *)sender {

    if (self.todayAccountCellBlock) {
        self.todayAccountCellBlock(TodayAccountCellCheckRecordButtonType);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (JSBadgeView *)badgeView {
//    if (!_badgeView) {
//        _badgeView = [[JSBadgeView alloc] initWithParentView:self.notifyFlagView alignment:JSBadgeViewAlignmentTopRight];
//        _badgeView.badgeBackgroundColor = TYColorHex(0xef272f);
//        _badgeView.badgeTextFont = [UIFont systemFontOfSize:AppFont24Size];
//        _badgeView.badgeStrokeColor = [UIColor redColor];
//    }
//    return _badgeView;
//}


@end
