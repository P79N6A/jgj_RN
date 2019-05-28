//
//  JGJContractorCollectionViewCell.h
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZGGetBillModel.h"
@protocol JGJContractorCollectionViewCellDelegate <NSObject>

- (void)didSelectContractTableViewFromIndexpath:(NSIndexPath *)indexpath WithModel:(YZGGetBillModel *)model;//惦记了某一行

- (void)textFiledContractEditing:(NSString *)content andTag:(NSInteger)tag;//编辑框

- (void)textfiledContractWillBeginEting;
@end
@interface JGJContractorCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic,strong) id <JGJContractorCollectionViewCellDelegate> delegate;

@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来

@property (nonatomic,assign) BOOL mainGo;//首页进来 不能切换人

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;



@end
