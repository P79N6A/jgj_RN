//
//  YZGWageBestDetailTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGWageBestDetailTableViewCell.h"
#import "TYVerticalLabel.h"
#import "YZGRecordWorkpointTool.h"
#import "UILabel+GNUtil.h"
#import "UILabel+JGJCopyLable.h"
@interface YZGWageBestDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataTurnLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
@property (weak, nonatomic) IBOutlet TYVerticalLabel *amoutDiffLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextVcCellImage;

@property (weak, nonatomic) IBOutlet UIImageView *modifyImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineViewL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineViewR;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelLayoutL;
@property (strong, nonatomic) IBOutlet UILabel *centerTitleLable;
@end

@implementation YZGWageBestDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _centerTitleLable.hidden = YES;
    [self.contentView addSubview:self.roleLable];
//    [self.dataTurnLabel.layer setLayerCornerRadiusWithRatio:0.005];
    self.dataTurnLabel.layer.masksToBounds = YES;
    self.dataTurnLabel.layer.cornerRadius = 2;
#if 0
    self.amoutDiffLabel.hidden = YES;
    self.amoutDiffLabel.text = @"有\n差\n账";
    [self.amoutDiffLabel.layer setLayerBorderWithColor:self.amoutDiffLabel.textColor width:0.5 ration:0.15];
#endif
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIsLastCell:(BOOL)isLastCell{
    _isLastCell = isLastCell;
    self.bottomLineViewL.constant = isLastCell?0:10;
    self.bottomLineViewR.constant = isLastCell?0:10;
}

- (void)setWageBestDetailWorkday:(WageBestDetailWorkday *)wageBestDetailWorkday{
    _wageBestDetailWorkday = wageBestDetailWorkday;
    self.dateLabel.text = wageBestDetailWorkday.date_txt;
    self.dataTurnLabel.text = wageBestDetailWorkday.date_turn;
    
    if (wageBestDetailWorkday.accounts_type.code != 1) {
        self.middleLabel.text = wageBestDetailWorkday.accounts_type.txt;
    }else{
        [YZGRecordWorkpointTool setLabel:self.middleLabel manHour:wageBestDetailWorkday.manhour overhour:wageBestDetailWorkday.overtime];
    }
    
    CGFloat amounts = wageBestDetailWorkday.amounts*(wageBestDetailWorkday.accounts_type.code == 3?-1:1);
    [YZGRecordWorkpointTool setLabel:self.amoutLabel amount:amounts];
#if 0
    self.amoutDiffLabel.hidden = !wageBestDetailWorkday.amounts_diff;
#endif
    switch (wageBestDetailWorkday.modify_marking) {
        case 0://没有查账,显示叉的图片
        {
            self.modifyImage.hidden = YES;
            break;
        }
        case 2:
        {
            self.modifyImage.hidden = NO;
            self.modifyImage.image = [UIImage imageNamed:@"RecordWorkpoints_cellOther"];
            break;
        }
        case 3:
        {
            self.modifyImage.hidden = NO;
            self.modifyImage.image = [UIImage imageNamed:@"RecordWorkpoints_cellMine"];
            break;
        }
        default:
            break;
    }
    self.nextVcCellImage.hidden = wageBestDetailWorkday.amounts_diff;

}
//设置四级页面
- (void)setPersonDetailWageListWorkday:(JGJeRecordFourBillDetailArrModel *)personDetailWageListWorkday{
    
    
    
    
    
    self.roleLable.hidden = NO;
    _dataTurnLabel.hidden = NO;
    _middleLabel.transform = CGAffineTransformMakeTranslation(0, 0);
    self.turnDateLable.layer.cornerRadius = 2;
    self.turnDateLable.layer.masksToBounds = YES;

    self.turnDateLable.backgroundColor = AppFontf0f0f0Color;
    _personDetailWageListWorkday = personDetailWageListWorkday;
//    self.dateLabel.text = personDetailWageListWorkday.date_txt;
//    self.dataTurnLabel.text = personDetailWageListWorkday.date_turn;
    self.dateLable.text = personDetailWageListWorkday.date_txt;
    self.turnDateLable.text = personDetailWageListWorkday.date_turn;
    
    self.nameLable.text = [NSString stringWithFormat:@"工头 %@",[self.nameLable sublistNameSurplusFour:personDetailWageListWorkday.foreman_name]];
    
    
    [self.nameLable markText:personDetailWageListWorkday.foreman_name withColor:AppFont333333Color];
    
    self.pronameLable.text = personDetailWageListWorkday.proname;
    if (personDetailWageListWorkday.accounts_type  == 1) {

        
        NSString *overStr;
        NSString *overCStr;

        if ([personDetailWageListWorkday.overtime floatValue] <= 0) {
            overStr = @"无加班";
            overCStr = @"";
        }else{
            overStr = [NSString stringWithFormat:@"%@小时", personDetailWageListWorkday.overtime];
            overCStr = personDetailWageListWorkday.overtime_hours;
        }
        if (personDetailWageListWorkday.is_rest) {
           
        [YZGRecordWorkpointTool setLabel:self.middleLabel manHourTexts:@"上班 休息" overhourTexts:[NSString stringWithFormat:@"加班 %@%@",overStr,overCStr] ManColor:@"" OverColor:overCStr];
            
        }else{
        
            
            
        [YZGRecordWorkpointTool setLabel:self.middleLabel manHourTexts:[NSString stringWithFormat:@"上班 %@小时%@",personDetailWageListWorkday.manhour,personDetailWageListWorkday.working_hours] overhourTexts:[NSString stringWithFormat:@"加班 %@%@",overStr,overCStr] ManColor:personDetailWageListWorkday.working_hours OverColor:overCStr];

        }
    }else if (personDetailWageListWorkday.accounts_type  == 2)
    {
     self.middleLabel.text = @"包工";
        
    }else if (personDetailWageListWorkday.accounts_type  == 3)
    {
     self.middleLabel.text = @"借支";
        
    }else{
        
     self.middleLabel.text = @"工资结算";

    }
//    [self.middleLabel SetLinDepart:4];


    self.amoutLabel.text = personDetailWageListWorkday.amounts;
    
    if (personDetailWageListWorkday.accounts_type  >=3) {
        self.amoutLabel.textColor = AppFonte83c76eColor;
        _amoutLabel.text = [NSString stringWithFormat:@"-%@",personDetailWageListWorkday.amounts];

 
    }else{
        self.amoutLabel.textColor = AppFontd7252cColor;
        if (personDetailWageListWorkday.total < 0) {
            self.amoutLabel.textColor = AppFonte83c76eColor;
            
        }
    }
    
    if (personDetailWageListWorkday.amounts_diff == 1) {
        self.modifyImage.hidden = NO;
        self.nextVcCellImage.hidden = YES;
    }else{
        self.modifyImage.hidden = YES;
        self.nextVcCellImage.hidden = NO;


    }
//    switch (personDetailWageListWorkday.amounts_diff) {
//        case 0://没有查账,显示叉的图片
//        {
//            self.modifyImage.hidden = YES;
//            break;
//        }
//        case 2:
//        {
//            self.modifyImage.hidden = NO;
//            self.modifyImage.image = [UIImage imageNamed:@"chazhang"];
//            break;
//        }
//        case 3:
//        {
//            self.modifyImage.hidden = NO;
//            self.modifyImage.image = [UIImage imageNamed:@"chazhang"];
//            break;
//        }
//        default:
//            break;
//    }
    
//    self.nextVcCellImage.hidden = personDetailWageListWorkday.amounts_diff;
    
    self.centerTitleLable.text = [self.centerTitleLable sublistNameSurplusFour:personDetailWageListWorkday.worker_name];
}

- (void)setDateLabelLeft:(CGFloat)dateLabelLeft{
    _dateLabelLeft = dateLabelLeft;
    self.dateLabelLayoutL.constant = dateLabelLeft;
    [self.contentView layoutIfNeeded];
}
-(void)layoutSubviews
{
//    CGRect rect = _nextVcCellImage.frame;
//    rect.size.height = 14;
//    [self.nextVcCellImage setFrame:rect];
//
}
#pragma mark -设置三几页面的模型
-(void)setRecordBillDetailArrmodel:(JGJeRecordBillDetailArrModel *)recordBillDetailArrmodel
{
    _roleLable.hidden = YES;
    _dataTurnLabel.hidden = YES;
    _centerTitleLable.hidden = NO;
    _centerTitleLable.textColor = AppFont333333Color;
    _middleLabel.numberOfLines = 0;
    
    _updepartLable.hidden = YES;
    _upBaseView.hidden = YES;
    _downBaseLable.hidden = YES;
    _downDepartLable.hidden = YES;
    _pronameLable.hidden = YES;
    
    _centerTitleLable.text = recordBillDetailArrmodel.name;
    
    NSString *workStr;
    NSString *overStr;
    NSString *workUnite;
    NSString *overUnite;

    if ([recordBillDetailArrmodel.total_manhour floatValue]) {
        
    
    if ((int)[recordBillDetailArrmodel.total_manhour floatValue] == [recordBillDetailArrmodel.total_manhour floatValue]) {
        workStr = [NSString stringWithFormat:@"%d",(int)[recordBillDetailArrmodel.total_manhour floatValue]];
    }else{
    
        workStr = [NSString stringWithFormat:@"%.1f",[recordBillDetailArrmodel.total_manhour floatValue]];

     }
        workUnite = @"个工";
    }else{
    workStr = @"-.-";
    workUnite = @"";
    }
    
    if ([recordBillDetailArrmodel.total_overtime floatValue]) {
        
    
    if ((int)[recordBillDetailArrmodel.total_overtime floatValue] == [recordBillDetailArrmodel.total_overtime floatValue]) {
        
        overStr = [NSString stringWithFormat:@"%d",(int)[recordBillDetailArrmodel.total_overtime floatValue]];
        
    }else{
        
        overStr = [NSString stringWithFormat:@"%.1f",[recordBillDetailArrmodel.total_overtime floatValue]];
        
         }
        overUnite = @"个工";
    }else{
    overStr = @"-.-";
    overUnite = @"";

    }

    _middleLabel.text = [NSString stringWithFormat:@"上班 %@%@\n加班 %@%@",workStr,workUnite,overStr,overUnite];
//    [_middleLabel markText:[NSString stringWithFormat:@"加班 %@个工",recordBillDetailArrmodel.total_overtime] withFont:[UIFont systemFontOfSize:AppFont26Size] color:AppFont333333Color];
    
      [self.middleLabel SetLinDepart:4];

     _amoutLabel.text = [NSString stringWithFormat:@"%.2f",recordBillDetailArrmodel.total];
    
    if ([recordBillDetailArrmodel.accounts_type.code intValue] <= 2) {
        
        _amoutLabel.textColor = JGJMainColor;
        
        if (recordBillDetailArrmodel.total < 0) {
            
        _amoutLabel.textColor = AppFonte83c76eColor;
 
        }
        
    }else{

        _amoutLabel.textColor = AppFonte83c76eColor;

    }
    _modifyImage.hidden = YES;
    _nextVcCellImage.hidden = NO;
}
- (UIImageView *)roleLable
{
    if (!_roleLable) {
        _roleLable = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/2 - 50 - 1.5 - 40, 0, 31, 15)];
        
        _roleLable.backgroundColor = [UIColor whiteColor];
    }
    return _roleLable;
}
@end
