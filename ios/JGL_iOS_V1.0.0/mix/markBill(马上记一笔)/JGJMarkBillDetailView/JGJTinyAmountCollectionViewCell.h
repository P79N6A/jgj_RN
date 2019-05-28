//
//  JGJTinyAmountCollectionViewCell.h
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZGGetBillModel.h"

#import "YZGAddContactsTableViewCell.h"
typedef enum: NSInteger{
    rowzero = 0,
    rowone,
    rowtwo,
    rowthree,

}markBillRowType;
@protocol JGJTinyAmountCollectionViewCellDelegate <NSObject>

-(void)didSelectTinyTableViewFromIndexpath:(NSIndexPath *)indexpath WithModel:(YZGGetBillModel *)model;

@end
@interface JGJTinyAmountCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;

@property (nonatomic,strong) id <JGJTinyAmountCollectionViewCellDelegate> delegate;

@property (nonatomic,assign) BOOL mainGo;//首页进来 不能切换人

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@end
