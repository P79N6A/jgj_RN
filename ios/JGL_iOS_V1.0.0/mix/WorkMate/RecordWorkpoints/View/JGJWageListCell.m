//
//  JGJWageListCell.m
//  mix
//
//  Created by Tony on 2016/7/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWageListCell.h"
#import "JGJLabel.h"
#import "UILabel+JGJCopyLable.h"
@interface JGJWageListCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *overWorkLablel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@end

@implementation JGJWageListCell

- (void)setJgjWageListModel:(JGJWageListModel *)jgjWageListModel{
    _jgjWageListModel = jgjWageListModel;
    
    //设置姓名
    if (!_acodingPro) {
        self.nameLabel.text = [self.nameLabel sublistNameSurplusFour:jgjWageListModel.name];
   
    }else{
        
        self.nameLabel.text = jgjWageListModel.name;
        
    }
    

    //设置上班合计
//    self.totalLabel.attributedText = [JGJLabel getWorkHour:jgjWageListModel.total_manhour == 0.0?@"-.-":[NSString stringWithFormat:@"%.1f",jgjWageListModel.total_manhour] hourColor:TYColorHex(0x333333) fontSize:13.f];
    if ((int)jgjWageListModel.total_manhour == jgjWageListModel.total_manhour){
        self.totalLabel.attributedText = [JGJLabel getWorkHours:jgjWageListModel.total_manhour == 0.0?@"上班 -.-":[NSString stringWithFormat:@"上班 %.0f个工",jgjWageListModel.total_manhour] hourColor:TYColorHex(0x333333) fontSize:13.f];
   
    }else{
    self.totalLabel.attributedText = [JGJLabel getWorkHours:jgjWageListModel.total_manhour == 0.0?@"上班 -.-":[NSString stringWithFormat:@"上班 %.1f个工",jgjWageListModel.total_manhour] hourColor:TYColorHex(0x333333) fontSize:13.f];
    }
    
    if (jgjWageListModel.total_manhour == 0.0 &&jgjWageListModel.total_overtime > 0) {
        self.totalLabel.text = @"休息";
    }else if (jgjWageListModel.total_overtime == 0.0 && jgjWageListModel.total_manhour == 0.0){
        self.totalLabel.text = @"上班 -.-";
    
    }
    //设置加班合计
    if ((int)jgjWageListModel.total_overtime == jgjWageListModel.total_overtime) {
        self.overWorkLablel.attributedText = [JGJLabel getWorkHours:jgjWageListModel.total_overtime == 0.0?@"加班 -.-":[NSString stringWithFormat:@"加班 %.0f个工",jgjWageListModel.total_overtime]  hourColor:TYColorHex(0x333333) fontSize:13.f];
 
    }else{
    self.overWorkLablel.attributedText = [JGJLabel getWorkHours:jgjWageListModel.total_overtime == 0.0?@"加班 -.-":[NSString stringWithFormat:@"加班 %.1f个工",jgjWageListModel.total_overtime]  hourColor:TYColorHex(0x333333) fontSize:13.f];
    }
//    NSString *totalStr = [NSString stringWithFormat:@"%.2f",jgjWageListModel.total];
//    self.moneyLabel.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(totalStr)];

    //设置money
//    if (jgjWageListModel.total >= 10000 || jgjWageListModel.total <= -10000) {
//        self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f 万",jgjWageListModel.total/10000];
//        
//
//    }else{
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",jgjWageListModel.total];
//
//    }
    self.moneyLabel.textColor = jgjWageListModel.total > 0?TYColorHex(0xd7252c):TYColorHex(0x83c76e);
}
@end
