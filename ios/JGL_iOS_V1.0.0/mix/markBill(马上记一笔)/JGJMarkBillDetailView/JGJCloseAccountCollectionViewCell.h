//
//  JGJCloseAccountCollectionViewCell.h
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZGGetBillModel.h"
typedef enum: NSUInteger{
    sectionZero = 0,
    sectionOne,
    sectionTwo,
    sectionThree,
    sectionFour,
    sectionFive,
    sectionSix,
}sectionNum;
@protocol JGJCloseAccountCollectionViewCellDelegate <NSObject>

- (void)didSelectCloseAccountFromIndexpath:(NSIndexPath *)indexpath withModel:(YZGGetBillModel *)model;

- (void)closeAccountTextfiledEditing:(NSString *)content andtag:(NSInteger)tag;

- (void)clickNoSalaryTplBtn;//点击无金额点工按钮

@end
@interface JGJCloseAccountCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic, strong) id <JGJCloseAccountCollectionViewCellDelegate>delegete;

@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic,assign) BOOL mainGo;//首页进来 不能切换人

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, assign) CGFloat editeMoney;
@end
