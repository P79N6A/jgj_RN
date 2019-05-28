//
//  JGJPackCollectionViewCell.h
//  mix
//
//  Created by Tony on 2017/2/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
@protocol didSelectedPackTableviewdelegate <NSObject>

- (void)didselectedPackTableviewforIndexpath:(NSIndexPath *)indexpath withTableviewclass:(NSString *)classStr;
- (void)clickSaveDataPackButtonwithModel:(YZGGetBillModel *)model;
- (void)PacketselectUnite;
@end

@interface JGJPackCollectionViewCell : UICollectionViewCell
@property (nonatomic ,strong)UITableView *packTableview;//包工界面
@property (strong, nonatomic)UIButton *SaveButtons;
@property (strong, nonatomic)UIImageView *headerViews;
@property (strong, nonatomic)UILabel *NumLables;
@property (strong, nonatomic)UILabel *deslables;
@property (strong, nonatomic)UIImageView *imageviews;
@property (strong, nonatomic)NSArray *titleArr;
@property (strong, nonatomic)NSArray *subTitleArr;
@property (strong, nonatomic)UIButton *refrashViews;
@property (weak, nonatomic)id <didSelectedPackTableviewdelegate> delegate;
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (strong, nonatomic)NSArray *imageArr;
@property (assign, nonatomic)BOOL CreaterModel;
@property (assign, nonatomic)BOOL morePeople;//几多人进入
@property (strong, nonatomic)UIImageView *leftimageview;//左边白点点
@property (strong, nonatomic)UIImageView *rightimageview;//邮编白点嗲
@end
