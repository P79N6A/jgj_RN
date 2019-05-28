//
//  JGJNormalTableViewCell.m
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJNormalTableViewCell.h"
#import "UILabel+GNUtil.h"

@implementation JGJNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setMoneyModel:(JGJMoneyListModel *)moneyModel
{
    
    _Namelable.text = moneyModel.real_name;
    
    if ([moneyModel.normal_time containsString:@"休息"]) {
        moneyModel.normal_time = @"0";
    }
    if ([moneyModel.over_time containsString:@"无加班"]) {
        moneyModel.over_time = @"0";
    }
    if ([moneyModel.normal_time floatValue] == [moneyModel.workTime_tpl floatValue]) {
        
        _workTimelable.text = [NSString stringWithFormat:@"%@小时(1个工)", moneyModel.normal_time];
        
        
    }else if ([moneyModel.normal_time floatValue] / [moneyModel.workTime_tpl floatValue] == 0.5){
        
        
        _workTimelable.text = [NSString stringWithFormat:@"%@小时(半个工)", moneyModel.normal_time];
        
    }else{
        
        _workTimelable.text = [moneyModel.normal_time stringByAppendingString:@"小时"];
    }
    
    if ([moneyModel.over_time floatValue] == [moneyModel.overTime_tpl floatValue] ) {
        
        _overTimeLable.text = [NSString stringWithFormat:@"1个工(%@小时)", moneyModel.over_time];
        
    }else if ([moneyModel.over_time floatValue]  / [moneyModel.overTime_tpl floatValue] == 0.5){
        
        _overTimeLable.text = [NSString stringWithFormat:@"半个工(%@小时)", moneyModel.over_time];
        
    }else{
        
        _overTimeLable.text = [moneyModel.over_time stringByAppendingString:@"小时"];
    }
    
}
-(void)setListModel:(JgjRecordMorePeoplelistModel *)listModel
{
    _listModel = listModel;
    _Namelable.text = listModel.name;
    // 判断是记得点工还是包工考勤 (1是点工,2是包工)
    if ([listModel.msg.accounts_type integerValue] == 1) {
        
        _typeImageView.image = IMAGE(@"work_type_icon");
        //修改记工时间
        [self workoroverTime:listModel.choose_tpl.choose_w_h_tpl andtplTime:listModel.tpl.w_h_tpl isWork:YES andLable:_workTimelable];
        
        [self workoroverTime:listModel.choose_tpl.choose_o_h_tpl andtplTime:listModel.tpl.o_h_tpl isWork:NO andLable:_overTimeLable];
        if ([listModel.is_salary intValue] != 1) {
            
            _overTimeLable.text = @"他还没有设置工资标准，点击设置";
            self.backgroundColor = AppFontfdf0f0Color;
        }else{
            
            self.backgroundColor = AppFontffffffColor;
        }
        
    }else if ([listModel.msg.accounts_type integerValue] == 5) {
        
        _typeImageView.image = IMAGE(@"contract_type_icon");
        [self workoroverTime:listModel.choose_tpl.choose_w_h_tpl andtplTime:listModel.unit_quan_tpl.w_h_tpl isWork:YES andLable:_workTimelable];
        
        [self workoroverTime:listModel.choose_tpl.choose_o_h_tpl andtplTime:listModel.unit_quan_tpl.o_h_tpl isWork:NO andLable:_overTimeLable];
    }
    
    
    //    if (listModel.is_notes) {// 有备注
    //
    //        self.remarkImage.hidden = NO;
    //        self.typeCenterY.constant = -8;
    //
    //
    //    }else {
    //
    //        self.remarkImage.hidden = YES;
    //        self.typeCenterY.constant = 0;
    //    }
    
    if (listModel.msg.msg_text.length != 0) {
        
        _typeImageView.hidden = YES;
        self.arrowImage.hidden = YES;
        _workTimeWidth.constant = 170 * TYGetUIScreenWidth/375;
        _workTimelable.numberOfLines = 2;
        _workTimelable.text = [NSString stringWithFormat:@"你已在 %@ 对他记了一笔",listModel.msg.msg_text];
        
        _workTimelable.textAlignment = NSTextAlignmentLeft;
        _workTimelable.textColor = AppFont999999Color;
        [_workTimelable markText:listModel.msg.msg_text withColor:AppFont333333Color];
        _overTimeLable.text = @"";
        _centerConstance.constant = 30;
        
    }
}
-(void)workoroverTime:(NSString *)work_time andtplTime:(NSString *)tpl isWork:(BOOL)work andLable:(UILabel *)lable
{
    if ([work_time containsString:@"小时"]) {
        
        work_time = [work_time substringToIndex:work_time.length - 2];
        
    }
    
    //工作时间
    if ([work_time floatValue] > 0) {
        
        NSString *uniteStr;
        
        if ([tpl floatValue] > 0) {
            
            CGFloat num ;
            num = [work_time floatValue]/[tpl floatValue];
            if (!work) {// 加班时间
                
                if (_listModel.tpl.hour_type == 1) {// 如果是按小时工资计算加班，加班工天重新算,公式： 加班时间 /（正常工资模版 / 按钱 加班小时）
                    
                    num = [work_time floatValue] / ([_listModel.tpl.s_tpl floatValue] / _listModel.tpl.o_s_tpl);
                }
            }
            
            uniteStr = [NSString stringWithFormat:@"(%.2f个工)",[NSString roundFloat:num]];
            
        }else{
            
            uniteStr = @"";
            
        }
        
        lable.text = [NSString stringWithFormat:@"%@小时%@",work_time,uniteStr];
        [lable markText:uniteStr withColor:AppFont999999Color];
        
    }else{
        
        if (work) {
            
            lable.text = @"休息";
        }else{
            
            lable.text = @"无加班";
        }
        
    }
}

@end
