//
//  JGJTaskJoinMemberCell.m
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskJoinMemberCell.h"

#import "JGJTaskJoinMmeberCollectionCell.h"

@interface JGJTaskJoinMemberCell ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation JGJTaskJoinMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonSet];
}

- (void)commonSet {
    self.layout.itemSize = CGSizeMake(60, 85);
    
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"JGJTaskJoinMmeberCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"JGJTaskJoinMmeberCollectionCell"];

    self.collectionView.showsHorizontalScrollIndicator = NO;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.taskTracerModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJSynBillingModel *memeberModel = self.taskTracerModels[indexPath.row];
    
    JGJTaskJoinMmeberCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JGJTaskJoinMmeberCollectionCell" forIndexPath:indexPath];
    cell.memberModel = memeberModel;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    JGJSynBillingModel *memberModel = self.taskTracerModels[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(taskJoinMemberCell:didSelectedMember:)]) {
        
        [self.delegate taskJoinMemberCell:self didSelectedMember:memberModel];
        
        if (!memberModel.isAddModel) {
            
//            //这里防止后台返回的人员重复数据，导致删除同一个人时列表的重复人员没有清掉选中标记
            
//            [self.taskTracerModels removeObject:memberModel];
            
            //相同的数据源会出错
            
//            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            
            [self.taskTracerModels removeObjectAtIndex:indexPath.row];
            
            [self.collectionView reloadData];
            
        }
        
    }
}




@end
