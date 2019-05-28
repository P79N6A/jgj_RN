//
//  JGJNewContracortCollectionViewCell.h
//  mix
//
//  Created by Tony on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"

typedef enum:NSUInteger{
    
    JGJContractorMakeAttendanceType = 0,// 包工记考勤类型
    
    JGJContractorMakeAccountType,// 包工记账类型
    
}JGJContractorMakeType;
@protocol JGJContractorMakeAttendanceViewCellDelegate <NSObject>

- (void)didSelectContractTableViewFromIndexpath:(NSIndexPath *)indexpath WithContractorMakeType:(JGJContractorMakeType)contractorType;//回调点击行数，并且当前记包工的记账类型(考勤/记账)

- (void)didSelectContractTableViewWithContractorMakeType:(JGJContractorMakeType)contractorType;// 是包工记考勤还是包工记账类型

- (void)textFiledContractEditing:(NSString *)content andTag:(NSInteger)tag;//编辑框
- (void)JGJTextFieldEndEditing;
@end
@interface JGJContractorMakeAttendanceViewCell : UICollectionViewCell


@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长

@property (nonatomic,assign) BOOL mainGo;//首页进来 不能切换人

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, weak) id<JGJContractorMakeAttendanceViewCellDelegate> delegate;

@end
