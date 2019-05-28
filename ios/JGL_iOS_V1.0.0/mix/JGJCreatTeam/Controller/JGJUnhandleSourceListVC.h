//
//  JGJUnhandleSourceListVC.h
//  JGJCompany
//
//  Created by YJ on 16/11/10.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
//2.0.2数据源类型
typedef enum : NSUInteger {
    JGJUnHandleSourceTeamType = 1, //未处理数据源类型
    JGJExistSourceTeamType //现有数据源类型
} JGJSourceTeamType;

@class JGJUnhandleSourceListVC;
@protocol JGJUnhandleSourceListVCDelegate <NSObject>

@optional
- (void)JGJUnhandleSourceListVcConfirmButtonPressed:(JGJUnhandleSourceListVC *)sourceListVC;
@end
@interface JGJUnhandleSourceListVC : UIViewController
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) JGJSourceSynProFirstModel *synProFirstModel;
@property (weak, nonatomic) id <JGJUnhandleSourceListVCDelegate> delegate;
@property (strong, nonatomic) JGJSynBillingModel *teamMemberModel;
@property (nonatomic, strong) UIViewController *skipVC;
@property (nonatomic, strong) NSArray *teamMemberModels;//存储已经是数据来源模型
@property (strong, nonatomic) NSMutableArray *selectedPros;
@property (assign, nonatomic) JGJSourceTeamType sourceTeamType;
@end
