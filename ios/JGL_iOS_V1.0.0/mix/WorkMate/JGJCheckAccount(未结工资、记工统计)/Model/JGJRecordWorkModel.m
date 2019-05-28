//
//  JGJRecordWorkModel.m
//  mix
//
//  Created by yj on 2018/1/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkModel.h"
#import "NSDate+Extend.h"
@implementation JGJRecordWorkModel

@end

@implementation JGJRecordWorkTypeModel

@end

@implementation JGJRecordContractTypeModel


@end

@implementation JGJRecordWorkStaListModel

- (CGFloat)height {
    
    NSString *name = self.name;
    
    if (![NSString isEmpty:name]) {
        
        _height = [NSString stringWithContentWidth:82.5 content:name font:AppFont30Size] + 22;
    }
    
    if (_height > 90) {
        
        _height = 90;
    }
    
    return _height;
}

//-(JGJRecordContractTypeModel *)contract_type_one {
//
//    _contract_type_one = [[JGJRecordContractTypeModel alloc] init];
//
//    _contract_type_one.amounts = @"12345678";
//
//    _contract_type_one.total = @"12345";
//
//    return _contract_type_one;
//}
//
//-(JGJRecordContractTypeModel *)contract_type_two{
//
//    _contract_type_two = [[JGJRecordContractTypeModel alloc] init];
//
//    _contract_type_two.amounts = @"66666677";
//
//    _contract_type_two.total = @"1234";
//
//    return _contract_type_two;
//}

@end


@implementation JGJRecordWorkStaModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
                 @"list" : @"JGJRecordWorkStaListModel",
                 
                 @"month_list" : @"JGJRecordWorkStaListModel"
             
             };
}

- (NSArray<JGJRecordWorkStaListModel *> *)list {
    
    if (self.month_list.count > 0) {
        
        _list = self.month_list;
    }
    
    return _list;
}

- (BOOL)isFilter {
    
    //筛选之后(balance_amount空改变)改变颜色
    return [NSString isEmpty:self.balance_amount];
}

#pragma mark - 顶部统计点工和包工记工天相加
- (void)handleTopContractorSta {
    
    //包工记工天
    
    //时单位
    CGFloat manhour = [self.attendance_type.manhour doubleValue];
    
    CGFloat working_hours = [self.attendance_type.working_hours doubleValue];
    
    
    CGFloat overtime = [self.attendance_type.overtime doubleValue];
    
    CGFloat overtime_hours = [self.attendance_type.overtime_hours doubleValue];
    
    //点工上班
    CGFloat workmanhour = [self.work_type.manhour doubleValue];
    
    CGFloat work_working_hours = [self.work_type.working_hours doubleValue];
    
    //点工加班
    
    CGFloat work_overtime = [self.work_type.overtime doubleValue];
    
    CGFloat work_overtime_hours = [self.work_type.overtime_hours doubleValue];
    
    //上班
    
    manhour += workmanhour;
    
    working_hours += work_working_hours;
    
    //加班
    overtime += work_overtime;
    
    overtime_hours += work_overtime_hours;
    
    //上班
    
    NSString *manhourStr = [NSString stringWithFormat:@"%.2lf", manhour];
    
    manhourStr = [manhourStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    NSString *working_hoursStr = [NSString stringWithFormat:@"%.2lf", working_hours];
    
    working_hoursStr = [working_hoursStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    //加班
    NSString *overtimeStr = [NSString stringWithFormat:@"%.2lf", overtime];
    
    overtimeStr = [overtimeStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    NSString *overtime_hoursStr = [NSString stringWithFormat:@"%.2lf", overtime_hours];
    
    overtime_hoursStr = [overtime_hoursStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    self.work_type.manhour = [self removeFloatAllZeroByString:manhourStr];
    
    self.work_type.working_hours = [self removeFloatAllZeroByString:working_hoursStr];
    
    self.work_type.overtime = [self removeFloatAllZeroByString:overtimeStr];
    
    self.work_type.overtime_hours = [self removeFloatAllZeroByString:overtime_hoursStr];
    
}

- (NSString*)removeFloatAllZeroByString:(NSString *)number{
    
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(number.floatValue)];
    
    return outNumber;
}

- (NSMutableArray *)setStaPopViewCellModel {
    
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    
    JGJAccountShowTypeModel *selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    NSInteger showType = selTypeModel.type;
    
    UIColor *redColor = AppFontEB4E4EColor;
    
    UIColor *greenColor = AppFont83C76EColor;
    
    NSString *space = @"";
    
    //点工
    
    NSString *unit = @"小时";
    
    if (showType == 0 || showType == 1) {
        
        unit = @"个工";
    }
    
    NSString *over_work_unit = @"小时";
    
    if (showType == 1) {
        
        over_work_unit = @"个工";
    }
    
    NSString *moneyFlag = self.moneyFlag;
    
    if ([NSString isEmpty:moneyFlag]) {
        
        moneyFlag = @"";
    }

    NSString *titleSpace = @"       ";
    
    //点工 上班加班
    JGJCheckStaPopViewCellModel *work_type = [[JGJCheckStaPopViewCellModel alloc] init];
    
    work_type.otherType = 1;
    
    work_type.typeTitle = [NSString stringWithFormat:@"点%@工", titleSpace];
    
    work_type.firTitle = @"上班";
    
    work_type.firChangeColor = redColor;
    
    work_type.money = [NSString stringWithFormat:@"%@%@%@",moneyFlag,space,self.work_type.amounts];
    
    NSString *firChangeStr = showType == 2 ?self.work_type.manhour :self.work_type.working_hours;
    
    work_type.firDes = [NSString stringWithFormat:@"%@%@%@", firChangeStr, space,unit];
    
    work_type.firChangeStr = firChangeStr;
    
    work_type.secTitle = @"加班";
    
    work_type.secChangeColor = redColor;
    
    NSString *secChangeStr = showType != 1 ?self.work_type.overtime :self.work_type.overtime_hours;
    
    work_type.secDes = [NSString stringWithFormat:@"%@%@%@", secChangeStr,space, over_work_unit];
    
    work_type.secChangeStr = secChangeStr;
    
    [dataSource addObject:work_type];
    
    //包工考勤 上班加班
    JGJCheckStaPopViewCellModel *attendance_type = [[JGJCheckStaPopViewCellModel alloc] init];
    
    attendance_type.typeTitle = @"包工记工天";
    
    attendance_type.otherType = 2;
    
    attendance_type.money = @"-";
    
    attendance_type.firTitle = @"上班";
    
    attendance_type.firChangeColor = redColor;
    
    firChangeStr = showType == 2 ?self.attendance_type.manhour :self.attendance_type.working_hours;
    
    attendance_type.firDes = [NSString stringWithFormat:@"%@%@%@", firChangeStr, space,unit];
    
    attendance_type.firChangeStr = firChangeStr?:@"";
    
    
    attendance_type.secTitle = @"加班";
    
    attendance_type.secChangeColor = redColor;
    
    secChangeStr = showType != 1 ?self.attendance_type.overtime :self.attendance_type.overtime_hours;
    
    attendance_type.secDes = [NSString stringWithFormat:@"%@%@%@", secChangeStr,space, over_work_unit];
    
    attendance_type.secChangeStr = secChangeStr;
    
    [dataSource addObject:attendance_type];
    
    
    //包工记账 笔数
    JGJCheckStaPopViewCellModel *contract_type = [[JGJCheckStaPopViewCellModel alloc] init];
    
    contract_type.money = [NSString stringWithFormat:@"%@%@%@",moneyFlag,space,self.contract_type.amounts];
    
    contract_type.typeTitle = @"包工记账";
    
    contract_type.otherType = 3;
    
    contract_type.firChangeColor = redColor;
    
    contract_type.firChangeStr = self.contract_type.total?:@"";
    
    contract_type.firDes = [NSString stringWithFormat:@"%@笔", self.contract_type.total];
    
    [dataSource addObject:contract_type];
    
    //借支 笔数
    JGJCheckStaPopViewCellModel *expend_type = [[JGJCheckStaPopViewCellModel alloc] init];
    
    expend_type.otherType = 4;
    
    expend_type.typeTitle = [NSString stringWithFormat:@"借%@支", titleSpace];
    
    expend_type.money = [NSString stringWithFormat:@"%@%@%@",moneyFlag,space,self.expend_type.amounts];
    
    expend_type.firChangeColor = greenColor;
    
    expend_type.firChangeStr = self.expend_type.total?:@"";
    
    expend_type.firDes = [NSString stringWithFormat:@"%@笔", self.expend_type.total];;
    
    [dataSource addObject:expend_type];
    
    //结算 笔数
    JGJCheckStaPopViewCellModel *balance_type = [[JGJCheckStaPopViewCellModel alloc] init];
    
    balance_type.otherType = 5;
    
    balance_type.money = [NSString stringWithFormat:@"%@%@%@",moneyFlag,space,self.balance_type.amounts];
    
    balance_type.typeTitle = [NSString stringWithFormat:@"结%@算", titleSpace];
    
    balance_type.firChangeColor = greenColor;
    
    balance_type.firChangeStr = self.balance_type.total?:@"";
    
    balance_type.firDes = [NSString stringWithFormat:@"%@笔", self.balance_type.total];
    
    [dataSource addObject:balance_type];
    
    return dataSource;
    
}

@end


@implementation JGJRecordWorkStaDetailListModel


@end

@implementation JGJRecordWorkStaDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"month_list" : @"JGJRecordWorkStaDetailListModel"};
}

@end


//记工流水

@implementation JGJRecordWorkPointListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"recordId" : @"id"};
}

@end

@implementation JGJRecordWorkPointWorkdayListModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list" : @"JGJRecordWorkPointListModel"};
}

@end


@implementation JGJRecordWorkPointModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"workday" : @"JGJRecordWorkPointWorkdayListModel"};
}

@end


//未结工资
@implementation JGJRecordUnWageListModel



@end

@implementation JGJRecordUnWageModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list" : @"JGJRecordUnWageListModel"};
}

@end


@implementation  JGJUnsetSalaryTplByUidListModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"date_list" : @"JGJRecordWorkPointListModel"};
}

@end


@implementation JGJRecordWorkPointFilterModel

#pragma mark - 对联系人进行排序
+ (NSMutableArray *)sortProModels:(NSMutableArray *)sortProModels {

    NSMutableArray *sortModels = [NSMutableArray array];

    for (JGJRecordWorkPointFilterModel *proModel in sortProModels) {

        if ([NSString isEmpty:proModel.name]) { //姓名为空的情况将姓名赋值为电话号码

            proModel.name = proModel.telephone;

        }

        NSString *firstLetter = [NSString firstCharactor:proModel.name].uppercaseString;

        proModel.firLetter = firstLetter;

        [sortModels addObject:proModel];
        
    }

    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firLetter" ascending:YES]];

    [sortModels sortUsingDescriptors:sortDescriptors];

    return sortModels;
}

@end


@implementation JGJRecordWorkDownLoadModel


@end

@implementation JGJPageSizeModel

- (NSMutableArray *)sortDesDataSource:(NSArray *)dataSource {
    
    NSMutableArray *sortDataSource = [NSMutableArray array];
    
    [self classifyRecordModelWithArr:dataSource.mutableCopy sourceArr:sortDataSource];
    
    // 倒序
    NSArray *tempArr = [NSArray array];
    // 如果遍历一遍没有交换过数据，则证明没有必要继续排序了
    for (int i = 0; i < sortDataSource.count; i ++) {
        
        for (int j = (int)sortDataSource.count-2; j >= i; j--) {
        
            NSArray *firstArr = sortDataSource[j];
            JGJRecordWorkPointListModel *firstPointModel = firstArr.firstObject;
            NSDate *firstDate = [NSDate dateFromString:firstPointModel.date withDateFormat:@"yyyy-MM-dd"];
            
            NSArray *secondArr = sortDataSource[j + 1];
            JGJRecordWorkPointListModel *sencondPointModel = secondArr.firstObject;
            NSDate *secondDate = [NSDate dateFromString:sencondPointModel.date withDateFormat:@"yyyy-MM-dd"];
            
            if (firstDate.timeIntervalSince1970 < secondDate.timeIntervalSince1970) {
                
                tempArr = firstArr;
                
                [sortDataSource replaceObjectAtIndex:j withObject:secondArr];
                [sortDataSource replaceObjectAtIndex:j + 1 withObject:tempArr];
            }
            
        }
        
        
    }
    
    return sortDataSource;
    
}

// 递归处理数据按时间分组
- (void)classifyRecordModelWithArr:(NSMutableArray *)dataArr sourceArr:(NSMutableArray *)sorceArr {
    
    if (dataArr.count == 0) {
        
        return;
    }
    
    NSMutableArray *leftArr = [[NSMutableArray alloc] initWithArray:dataArr];
    NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
    JGJRecordWorkPointListModel *firstModel = [[JGJRecordWorkPointListModel alloc] init];
    firstModel = dataArr.firstObject;
    for (int i = 0; i < dataArr.count; i ++) {
        
        JGJRecordWorkPointListModel *compareModel = dataArr[i];
        if ([compareModel.date isEqualToString:firstModel.date]) {

            [sectionArr addObject:compareModel];
            [leftArr removeObject:compareModel];
        }
    }
    
    dataArr = [[NSMutableArray alloc] initWithArray:leftArr];
    [sorceArr addObject:sectionArr];
    
    [self classifyRecordModelWithArr:dataArr sourceArr:sorceArr];
}

- (NSMutableArray *)sortDataSource:(NSArray *)dataSource{
    
    JGJRecordWorkPointListModel *listModel = nil;
    
    if (dataSource.count > 0) {
        
        listModel = dataSource.firstObject;
        
    }else {
        
        return nil;
    }
    
    JGJPageSizeModel *pageSizeModel = [[JGJPageSizeModel alloc] init];
    
    JGJPageSizeModel *lastPageSizeModel = [[JGJPageSizeModel alloc] init];
    
    NSString *lastDate = listModel.date;
    
    NSInteger length = 0;
    
    NSMutableArray *sectionDataSource = [NSMutableArray new];
    
    pageSizeModel.location = 0;
    
    pageSizeModel.length = 0;
    
    [sectionDataSource addObject:pageSizeModel];
    
    for (NSInteger index = 0; index < dataSource.count; index++) {
        
        listModel = dataSource[index];
        
        if ([listModel isKindOfClass:NSClassFromString(@"JGJRecordWorkPointListModel")]) {
            
            if (![listModel.date isEqualToString:lastDate]) {
                
                lastDate = listModel.date;
                
                lastPageSizeModel = pageSizeModel;
                
                //初始化下一个
                pageSizeModel = [[JGJPageSizeModel alloc] init];
                
                pageSizeModel.location = index;
                
                
                [sectionDataSource addObject:pageSizeModel];
                
            }
            
            length = index - (lastPageSizeModel.location + lastPageSizeModel.length) + 1;
            
            pageSizeModel.length = length;
            
        }
        
    }
    
    //筛选后的数据
    NSMutableArray *sortDataSource = [NSMutableArray array];
    
    for (JGJPageSizeModel *pageSizeModel in sectionDataSource) {
        
        NSRange range = NSMakeRange(pageSizeModel.location, pageSizeModel.length);
        
        [sortDataSource addObject:[dataSource subarrayWithRange:range]];
        
    }
    
    return sortDataSource;
    
}

@end

@implementation JGJHomeWorkRecordTotalModel


@end

@implementation JGJCheckStaPopViewCellModel


@end

@implementation JGJRecordWorkSetFormModel


@end


