//
//  JGJNORecordTableViewCell.m
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJNORecordTableViewCell.h"

@implementation JGJNORecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModelList:(JgjRecordMorePeoplelistModel *)modelList
{

    if ([modelList.is_salary intValue] != 1) {
        _distance.constant = -100;
        _overTimeLable.text = @"他还没有设置工资标准，点击设置";
        _workTimeLable.text = @"";
        _overTimeLable.font = [UIFont systemFontOfSize:AppFont24Size];
        self.backgroundColor = AppFontfdf0f0Color;
    }else{
        self.backgroundColor = [UIColor whiteColor];
        _overTimeLable.font = [UIFont systemFontOfSize:AppFont30Size];
    }

    _nameLable.text = modelList.name;

    //修改记工时间
    if (modelList.work_time) {
        _workTimeLable.text = [self workoroverTime:modelList.work_time andtplTime:modelList.tpl.w_h_tpl isWork:YES];
        
    }else{
        if (modelList.choose_tpl.choose_w_h_tpl) {
            _workTimeLable.text = [self workoroverTime:modelList.choose_tpl.choose_w_h_tpl andtplTime:modelList.tpl.w_h_tpl isWork:YES];
        }else{
            if ([modelList.is_salary intValue] == 1) {
                
            
        _workTimeLable.text = [self workoroverTime:modelList.tpl.w_h_tpl andtplTime:modelList.tpl.w_h_tpl isWork:YES];
            }
        }
    }
    if (modelList.over_time) {
        _overTimeLable.text = [self workoroverTime:modelList.over_time andtplTime:modelList.tpl.o_h_tpl isWork:NO];
        _overTimeLable.font = [UIFont systemFontOfSize:15];
        
    }else{
        if (modelList.choose_tpl.choose_o_h_tpl) {
            _overTimeLable.text = [self workoroverTime:modelList.choose_tpl.choose_o_h_tpl andtplTime:modelList.tpl.o_h_tpl isWork:NO];
            
        }else{
            if ([modelList.is_salary  intValue] == 1) {

            _overTimeLable.text = [self workoroverTime:@"0" andtplTime:modelList.tpl.o_h_tpl isWork:NO];
            }
        }
    }
    if (modelList.tpl) {
        if ([modelList.tpl.is_diff isEqualToString:@"--"]) {
            _workTimeLable.text = @"--";
            _overTimeLable.text = @"--";
        }
    }
  

}
-(void)setDataArr:(NSArray *)dataArr
{
    self.dataArr = [NSArray array];
    self.dataArr = dataArr;
}
-(void)setMoneyModel:(JGJMoneyListModel *)moneyModel
{
    _moneyModel = moneyModel;
    if (![moneyModel.normal_time containsString:@"小时"]) {
        if (moneyModel.workTime_tpl) {
        if ([moneyModel.normal_time floatValue] > 0) {
            //无加班时间
        if ([moneyModel.normal_time floatValue]/[moneyModel.workTime_tpl floatValue] == .5) {
        _workTimeLable.text = [NSString stringWithFormat:@"半个工(%@小时)",moneyModel.normal_time];

        
        
            }else if ([moneyModel.normal_time floatValue] == [moneyModel.workTime_tpl floatValue] ){
            _workTimeLable.text = [NSString stringWithFormat:@"1个工(%@小时)",moneyModel.normal_time];
            }else{
            
            _workTimeLable.text = [NSString stringWithFormat:@"%@小时",moneyModel.normal_time];

            }
        }
        else{
            
        _workTimeLable.text = moneyModel.normal_time;

        }
         }
    }else{
        _workTimeLable.text = moneyModel.normal_time;
    }
    
    
    
    if ([moneyModel.normal_time floatValue] == 0 && ![moneyModel.normal_time containsString:@"休息"]) {
        _workTimeLable.text = @"";
        _distance.constant = -80;
    }else{
    }
    if ([moneyModel.over_time floatValue] == 0 ) {
      moneyModel.over_time = @"无加班";
        
    }else{
        if (![moneyModel.over_time containsString:@"小时"]) {
            if (moneyModel.overTime_tpl) {
        if ([moneyModel.over_time floatValue] > 0) {
            
        if ( [moneyModel.over_time floatValue] == [moneyModel.overTime_tpl floatValue] ) {
            _overTimeLable.text = [NSString stringWithFormat:@"1个工(%@小时)",moneyModel.over_time];

            }else if ([moneyModel.over_time floatValue]/[moneyModel.overTime_tpl floatValue] == .5){
            _overTimeLable.text = [NSString stringWithFormat:@"半个工(%@小时)",moneyModel.over_time];
            }else{
            
                _overTimeLable.text = [NSString stringWithFormat:@"%@小时",moneyModel.over_time];

            }
            
                }else{
                    if (![moneyModel.over_time containsString:@"无加班"]) {
                        _overTimeLable.text = @"无加班";

                    }else{
            _overTimeLable.text = [NSString stringWithFormat:@"%@小时",moneyModel.over_time];
                    }
            }
                
                
            }
        }else{
    _overTimeLable.text = moneyModel.over_time;
        }
    }
    if ([moneyModel.is_salary intValue] != 1) {
        self.backgroundColor = AppFontfdf0f0Color;
        _overTimeLable.text = @"他还没有设置工资标准,点击设置";
        _workTimeLable.text = @"";
    }else{
        self.backgroundColor = [UIColor whiteColor];

    }
    
}

-(NSString *)workoroverTime:(NSString *)work_time andtplTime:(NSString *)tpl isWork:(BOOL)work
{
    
    if ([work_time containsString:@"小时"]) {
        work_time = [work_time substringToIndex:work_time.length - 2];
    }
    //工作时间
    if ([work_time floatValue] > 0) {
        //一个工
        if ([work_time floatValue] == [tpl floatValue]) {
            return [NSString stringWithFormat:@"%@(%@%@)",@"1个工",work_time,@"小时"];
        }
        //半个工
        else if ([work_time floatValue]*2 == [tpl floatValue]){
            return [NSString stringWithFormat:@"%@(%@%@)",@"半个工",work_time,@"小时"];
        }else{
            return [NSString stringWithFormat:@"%@%@",work_time,@"小时"];
        }
    }else{
        
        if (work) {
            return @"休息";
        }else{
            return @"无加班";
        }
        
    }
    return @"";
}

@end
