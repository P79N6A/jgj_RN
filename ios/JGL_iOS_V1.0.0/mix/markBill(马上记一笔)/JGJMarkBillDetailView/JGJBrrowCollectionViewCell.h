//
//  JGJBrrowCollectionViewCell.h
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZGGetBillModel.h"
@protocol JGJBrrowCollectionViewCellDelegate <NSObject>

-(void)didSelectBrrowTableViewFromIndexpath:(NSIndexPath *)indexpath WithModel:(YZGGetBillModel *)model;

-(void)textFiledBrrowEditing:(NSString *)content andTag:(NSInteger)tag;

- (void)textfiledBrrowWillBeginEting;

@end
@interface JGJBrrowCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic, strong) id <JGJBrrowCollectionViewCellDelegate>delegate;

@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic,assign) BOOL mainGo;//首页进来 不能切换人

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@end
