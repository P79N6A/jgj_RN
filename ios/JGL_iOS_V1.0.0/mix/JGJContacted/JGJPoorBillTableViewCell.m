//
//  JGJPoorBillTableViewCell.m
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPoorBillTableViewCell.h"
#import "UILabel+GNUtil.h"
#import "UILabel+JGJCopyLable.h"
@implementation JGJPoorBillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lookfoorButton.layer.masksToBounds = YES;
    self.lookfoorButton.layer.cornerRadius = 2.5;
    self.lookfoorButton.layer.borderWidth = .5;
    self.lookfoorButton.layer.borderColor = AppFont666666Color.CGColor;
    
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 2.5;
    self.sureButton.layer.borderWidth = .5;
    [self.sureButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    self.sureButton.layer.borderColor = AppFontEB4E4EColor.CGColor;
    [self drawLine];
    

}
-(void)drawLine{
    CAShapeLayer *shaplayer = [[CAShapeLayer alloc]init];
    shaplayer.strokeColor = AppFontdbdbdbColor.CGColor;
    shaplayer.fillColor = nil;
    //    shaplayer.path = [UIBezierPath bezierPathWithRect:button.bounds].CGPath;
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:CGPointMake(0, 0)];
    [triangle addLineToPoint:CGPointMake(TYGetUIScreenWidth - 20, 0)];
    shaplayer.path = triangle.CGPath;
    shaplayer.frame = self.lineLable.bounds;
    shaplayer.lineWidth = 0.5f;
    shaplayer.lineCap = @"square";
    shaplayer.lineDashPattern = @[@4, @2];
    [self.lineLable.layer addSublayer:shaplayer];
}
-(void)setPoorBillModel:(JGJPoorBillListDetailModel *)PoorBillModel
{
    _PoorBillModel = PoorBillModel;
    
    NSString *ManunitStr;
    NSString *OverunitStr;
    
    NSString *manHourStr;
    NSString *overStr;

    ManunitStr = @"小时";
    
    manHourStr = PoorBillModel.manhour?:@"";
    
    if (_showType == 0 || _showType == 1) {
        
        ManunitStr = @"个工";
        
        manHourStr = PoorBillModel.working_hours?:@"";
    }
    
    OverunitStr = @"小时";
    
    overStr = PoorBillModel.overtime?:@"";
    
    if (_showType == 1) {
        
        OverunitStr = @"个工";
        
        overStr = PoorBillModel.overtime_hours?:@"";
    }
    
    if (PoorBillModel.is_rest || [PoorBillModel.manhour isEqualToString:@"0"]) {
       
        manHourStr = @"休息";
        ManunitStr = @"";
        
    }
    if (![PoorBillModel.overtime floatValue] || [PoorBillModel.overtime isEqualToString:@"0"]){
        overStr = @"无加班";
        OverunitStr = @"";
        
    }
    
    //这里改了布局三个lable的布局改变了  需求改动
//    self.proLable.text = PoorBillModel.is_diff_pro ? PoorBillModel.oth_proname : PoorBillModel.proname;
    self.proLable.text = PoorBillModel.proname;
    self.nameLable.text = PoorBillModel.worker_name;
    self.overTimeLable.text =  PoorBillModel.proname?:@"";
    self.overTimeLable.textColor = AppFont999999Color;
    
    if ([PoorBillModel.accounts_type intValue] == 2 && PoorBillModel.contractor_type == 1) {
        
        self.overTPL.text = [@"承包对象：" stringByAppendingString:[self.overTPL sublistNameSurplusFour: PoorBillModel.foreman_name?:@""]];
        
    }else {
        
        self.overTPL.text = [@"班组长：" stringByAppendingString:[self.overTPL sublistNameSurplusFour: PoorBillModel.foreman_name?:@""]];
    }
    
    self.overTPL.textColor = AppFont999999Color;
    
    if ([PoorBillModel.accounts_type intValue] == 1 || [PoorBillModel.accounts_type intValue] == 5) {
        
        if ([PoorBillModel.accounts_type intValue] == 1) {
            
            self.typeImage.image = IMAGE(@"work_type_icon");
            
        }else {
            
            self.typeImage.image = IMAGE(@"contract_type_icon");
            
        }
        
        if (PoorBillModel.is_notes) {// 有备注
            
            self.remarkImage.hidden = NO;
            self.typeImageCenterY.constant = -8;
            
            
        }else {
            
            self.remarkImage.hidden = YES;
            self.typeImageCenterY.constant = 0;
        }
        
        if (PoorBillModel.is_del) {
            
            self.workCenterConstance.constant = -11;
            if ([PoorBillModel.accounts_type intValue] == 1) {
                
                self.worktimeLable.text = @"删除点工";
            }else {
                
                self.worktimeLable.text = @"删除包工记工天";
            }
            
            self.manHourTPL.text = @"";
        
        }else{
        
            self.recordPeople.text = [NSString stringWithFormat:@"上班：%@%@", manHourStr?:@"",ManunitStr?:@""];
            self.worktimeLable.text = [NSString stringWithFormat:@"加班：%@%@", overStr?:@"",OverunitStr?:@""];
        
            self.salaryTitleLable.text = [[NSString stringWithFormat:@"上班 %.1f小时算1个工", PoorBillModel.set_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
       
            if ([PoorBillModel.accounts_type intValue] == 1) {
                
                if (PoorBillModel.set_tpl.hour_type == 0) {
                    
                    self.manHourTPL.text = [[NSString stringWithFormat:@"加班 %.1f小时算1个工", PoorBillModel.set_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                }else {
                    
                    self.manHourTPL.text = [NSString stringWithFormat:@"加班 %.2f元/小时",PoorBillModel.set_tpl.o_s_tpl];
                }
                
            }else {
                
               self.manHourTPL.text = [[NSString stringWithFormat:@"加班 %.1f小时算1个工", PoorBillModel.set_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
            }
            
       
            self.centerConstance.constant = 0;
        
            self.workCenterConstance.constant = 0;
      
        }
        
    }else {
     
        if ([PoorBillModel.accounts_type intValue] == 2){
            if (PoorBillModel.is_del) {
                self.worktimeLable.text = @"删除包工";
                self.manHourTPL.text = @"";
                self.workCenterConstance.constant = -11;
                self.centerConstance.constant = 0;
                
            }else{
                
                if (PoorBillModel.contractor_type == 1) {// 承包
                    
                    self.worktimeLable.text = @"包工(承包)";
                    
                }else if (PoorBillModel.contractor_type == 2) {// 分包
                    
                    self.worktimeLable.text = @"包工(分包)";
                }
                self.manHourTPL.text = [NSString stringWithFormat:@"%.2f", PoorBillModel.amounts ];
                self.workCenterConstance.constant = -11;
                self.centerConstance.constant = -11;
            }
            
            self.manHourTPL.textColor = AppFontEB4E4EColor;
            self.manHourTPL.font = [UIFont boldSystemFontOfSize:15];
            
        }else if ([PoorBillModel.accounts_type intValue] == 3){
            if (PoorBillModel.is_del) {
                self.worktimeLable.text = @"删除借支";
                self.manHourTPL.text = @"";
                self.workCenterConstance.constant = -11;
                self.centerConstance.constant = 0;
            }else{
                self.worktimeLable.text = @"借支";
                self.manHourTPL.text = [NSString stringWithFormat:@"%.2f", PoorBillModel.amounts ];
                self.workCenterConstance.constant = -11;
                self.centerConstance.constant = -11;
            }
            
            self.manHourTPL.textColor = AppFont83C76EColor;
            self.manHourTPL.font = [UIFont boldSystemFontOfSize:15];
            
        }else{
            
            if (PoorBillModel.is_del) {
                self.worktimeLable.text = @"删除结算";
                self.manHourTPL.text = @"";
                self.workCenterConstance.constant = -11;
                self.centerConstance.constant = 0;
            }else{
                self.worktimeLable.text = @"结算";
                self.manHourTPL.text = [NSString stringWithFormat:@"%.2f", PoorBillModel.amounts];
                self.workCenterConstance.constant = -11;
                self.centerConstance.constant = -11;
            }
            self.manHourTPL.textColor = AppFont83C76EColor;
            self.manHourTPL.font = [UIFont boldSystemFontOfSize:15];
        }
        
        if (PoorBillModel.is_notes) {// 有备注
            
            self.remarkImage.hidden = NO;
            self.remarkImageCenterY.constant = 0;
            
        }else {
            
            self.remarkImage.hidden = YES;
        }
    }
    
    // 3.4.1新增顶部信息
    self.topInfoView.detailInfo.text = _PoorBillModel.record_desc;
    if ([_PoorBillModel.record_type integerValue] == 1) {// 1.新增
        
        self.topInfoView.detailInfo.textColor = AppFont1892E7Color;
        
    }else if ([_PoorBillModel.record_type integerValue] == 2) {// 2.修改
        
        self.topInfoView.detailInfo.textColor = AppFont27B441Color;
        
    }else {// 3.删除
        
        self.topInfoView.detailInfo.textColor = AppFontEB4E4EColor;
        
    }
    
}
- (IBAction)ClickLookForBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickPoorBillLookForBtnAndIndex:)]) {
        [self.delegate ClickPoorBillLookForBtnAndIndex:_indexPath];
    }
}
- (IBAction)clickSureBtn:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickPoorBillSureBtnAndIndex: cell:)]) {
        
        [self.delegate ClickPoorBillSureBtnAndIndex:_indexPath cell:self];
    }
    
}
@end
