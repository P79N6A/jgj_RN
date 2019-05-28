//
//  RFCollectionViewCell.h
//  RFCircleCollectionView
//
//  Created by Arvin on 15/11/25.
//  Copyright © 2015年 mobi.refine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
@protocol didSelectedTableviewdelegate <NSObject>

- (void)didselectedTableviewforIndexpath:(NSIndexPath *)indexpath withTableviewclass:(NSString *)classStr;
- (void)clickSaveDataTimeButtonwithModel:(YZGGetBillModel *)model;

@end
@interface RFCollectionViewCell : UICollectionViewCell
@property (nonatomic ,strong)UITableView *TimeTableview;//点工界面
@property (strong, nonatomic)UIButton *SaveButton;
@property (strong, nonatomic)UIImageView *headerView;
@property (strong, nonatomic)UILabel *NumLable;
@property (strong, nonatomic)UILabel *deslable;
@property (strong, nonatomic)UIImageView *imageview;
@property (strong, nonatomic)UIImageView *leftimageview;//左边白点点
@property (strong, nonatomic)UIImageView *rightimageview;//邮编白点嗲

@property (strong, nonatomic)NSArray *titleArr;
@property (strong, nonatomic)NSArray *subTitleArr;
@property (strong, nonatomic)UIButton *refrashView;
@property (weak, nonatomic)id <didSelectedTableviewdelegate> delegate;
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (strong, nonatomic)NSArray *imageArr;
@property (strong, nonatomic)UIView *topFreshView;
@property (assign, nonatomic)BOOL CreaterModel;//区别是不是聊天进入记账的 冲聊天进入几点公的都是工人 工头都跳转到几多人的界面

@property (assign, nonatomic)BOOL morePeople;//几多人进入

@property (assign, nonatomic)BOOL typeRole;


@end
