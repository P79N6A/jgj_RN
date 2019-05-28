//
//  JGJWorkbillCollectionViewCell.h
//  mix
//
//  Created by Tony on 2017/4/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"

@protocol didSelectedBillTableviewdelegate <NSObject>

- (void)didselectedBillTableviewforIndexpath:(NSIndexPath *)indexpath withTableviewclass:(NSString *)classStr;
- (void)clickSaveDatabillButtonwithModel:(YZGGetBillModel *)model;

@end

@interface JGJWorkbillCollectionViewCell : UICollectionViewCell
@property (nonatomic ,strong)UITableView *BillTableview;//借支界面
@property (strong, nonatomic)UIButton *SaveButtond;
@property (strong, nonatomic)UIImageView *headerViewd;
@property (strong, nonatomic)UILabel *NumLabled;
@property (strong, nonatomic)UILabel *deslabled;
@property (strong, nonatomic)UIImageView *imageviewd;
@property (strong, nonatomic)NSArray *titleArr;
@property (strong, nonatomic)NSArray *subTitleArr;
@property (strong, nonatomic)UIButton *refrashViewd;
@property  (strong ,nonatomic)NSDate  *selectDate;
@property (weak, nonatomic)id <didSelectedBillTableviewdelegate> delegate;
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (strong, nonatomic)NSArray *imageArr;
@property (assign, nonatomic)BOOL CreaterModel;
@property (assign, nonatomic)BOOL morePeople;//几多人进入
@property (strong, nonatomic)UIImageView *leftimageview;//左边白点点
@property (strong, nonatomic)UIImageView *rightimageview;//邮编白点嗲
@end
