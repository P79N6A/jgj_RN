//
//  JGJMarkBillBottomBaseView.h
//  mix
//
//  Created by Tony on 2018/1/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef enum: NSUInteger{
//    
//    JGJRemaingAmountType,//未接工资
//    
//    JGJMarkBillJobForemanType,// 班组长
//    
//    JGJMarkBillWorkerManagement,// 工人管理
//    
//    JGJMarkBillWaterType,//记工流水
//    
//    JGJMarkBillTotalType,//记工统计
//    
//    JGJMarkBillSynchronizationType,//同步记工
//    
//    JGJMarkBillSynchronizationTypeToMe,//同步给我的记工
//    
//    JGJMarkBillFrequentlyQuestionsType// 记工常见问题
//    
//}JGJMainMarkBillType;
//
//typedef void(^didSelectMarkBillBlock)(JGJMainMarkBillType mainMarkBillType);

@interface JGJMarkBillBottomBaseView : UIView

@property (strong, nonatomic) IBOutlet UITableView *tableView;

//@property (assign, nonatomic) JGJMainMarkBillType mainMarkBillType;

//@property (copy, nonatomic) didSelectMarkBillBlock didSelectMarkBillBlock;

@property (assign, nonatomic) BOOL isLeder;//是否是工头

@property (strong, nonatomic)  JGJRecordMonthBillModel *model;

//+ (JGJMarkBillBottomBaseView *)showMarkBillBottomViewFromSuperView:(UIView *)superView withDelegate:(id)delegate andDidSelectBlock:(didSelectMarkBillBlock)responseBlock FromLeder:(BOOL)isLeder;

@end
