//
//  JGJWorkCircleMiddleTableViewCell.m
//  JGJCompany
//
//  Created by yj on 16/9/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkCircleMiddleTableViewCell.h"
#import "JGJWorkCircleCollectionViewCell.h"
#import "UIView+YYAdd.h"
#define ItemWidth TYGetUIScreenWidth / 4.0
#define ImageIcons @[@"icon_specification", @"icon_ standard", @"icon_contract", @"icon_ locale _data"]
#define Descs @[@"行业规范", @"标准图集", @"合同模板", @"施工资料"]
static NSString *const CellID = @"JGJWorkCircleCollectionViewCell";
@interface JGJWorkCircleMiddleTableViewCell ()
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *infoModels;//存储首页信息模型数组
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UIView *contentDetailView;
@property (weak, nonatomic) IBOutlet UIView *contentSubView;

@end
@implementation JGJWorkCircleMiddleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonSet];
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *CellID = @"Cell";
    JGJWorkCircleMiddleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJWorkCircleMiddleTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)commonSet {
    self.titleLable.textColor = AppFont333333Color;
    self.lineView.backgroundColor = AppFontf1f1f1Color;
    [self.collectionView registerNib:[UINib nibWithNibName:@"JGJWorkCircleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellID];
    self.topLineView.backgroundColor = AppFontf1f1f1Color;
    CGFloat itemW = (TYGetUIScreenWidth - 50) / 4.0;
    self.collectionViewLayout.itemSize = CGSizeMake(itemW, ItemHeight);
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionViewLayout.minimumInteritemSpacing = 0;
    self.collectionViewLayout.minimumLineSpacing = 0;
    self.contentView.backgroundColor = AppFontf1f1f1Color;

    self.contentSubView.backgroundColor = [UIColor clearColor];
    [self.contentDetailView.layer setLayerCornerRadius:JGJCornerRadius];
    self.titleLable.backgroundColor = TYColorHex(0XF7F7F7);
    
    
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor redColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius = 2.0;
    sublayer.shadowColor = TYColorHex(0xeb4e4e).CGColor;
    sublayer.shadowOpacity = 0.1;
    sublayer.frame = CGRectMake(0, 0, TYGetUIScreenWidth - 24 , 125);
    sublayer.cornerRadius = 6.0;
    [self.contentView.layer insertSublayer:sublayer atIndex:0];

}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.infoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJWorkCircleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    JGJWorkCircleMiddleInfoModel *infoModel = self.infoModels[indexPath.row];
    infoModel.unread_msg_count = self.infoModel.unread_msg_count;
    cell.infoModel = infoModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WorkCircleCollectionViewCellType  cellType = indexPath.row;
    JGJWorkCircleMiddleInfoModel *infoModel = self.infoModels[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(WorkCircleMiddleTableViewCellType:infoModel:)]) {
        [self.delegate WorkCircleMiddleTableViewCellType:cellType infoModel:infoModel];
    }
}

- (NSArray *)infoModels {

    if (!_infoModels) {
        NSMutableArray *infos = [NSMutableArray array];
        for (int i = 0; i < ImageIcons.count; i ++) {
            JGJWorkCircleMiddleInfoModel *infoModel = [[JGJWorkCircleMiddleInfoModel alloc] init];
            
            infoModel.InfoImageIcon = ImageIcons[i];
            
            infoModel.desc = Descs[i];
            
            infoModel.cellType = i;
            
            JGJKnowBaseModel *knowBaseModel = [JGJKnowBaseModel new];
            
            knowBaseModel.knowBaseId = [NSString stringWithFormat:@"%@", @(i+1)];
            
            knowBaseModel.childVcIndex = i;
            
            infoModel.knowBaseModel = knowBaseModel;
            
            [infos addObject:infoModel];
        }
        _infoModels = infos;
    }
    return _infoModels;
}

//- (void)setIsNotReachableStatus:(BOOL)isNotReachableStatus {
//    _isNotReachableStatus= isNotReachableStatus;
//    self.netNotReachableViewH.constant = isNotReachableStatus ? 50 : 0;
//    self.netNotReachableView.hidden = !isNotReachableStatus;
//    if (isNotReachableStatus) {
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleNetNotReachabeTapAction:)];
//        [self.netNotReachableView addGestureRecognizer:tapGesture];
//    }
//}

#pragma mark - 处理没有网络情况按钮按下
//- (void)handleNetNotReachabeTapAction:(UITapGestureRecognizer *)tap {
//    if ([self.delegate respondsToSelector:@selector(workCircleMiddleTableViewCell:didSelectedNetNotReachabeTapAction:)]) {
//        [self.delegate workCircleMiddleTableViewCell:self didSelectedNetNotReachabeTapAction:tap];
//    }
//}


@end
