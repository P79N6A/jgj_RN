//
//  JGJPoorBillPhotoTableViewCell.m
//  mix
//
//  Created by Tony on 2017/10/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPoorBillPhotoTableViewCell.h"
#import "UIImageView+WebCache.h"
static NSString *cellIndentifer = @"cellIndentifer";
@implementation JGJPoorBillPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    [_collectionView registerNib:[UINib nibWithNibName:@"JGJModifyBillImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIndentifer];
    _collectionView.bounces = NO;
}

- (IBAction)clickAddButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickPoorBillPhotoBtn)]) {
        [self.delegate ClickPoorBillPhotoBtn];
    }
}
- (void)setImageArr:(NSArray *)imageArr
{
    _imageArr = [[NSArray alloc]initWithArray:imageArr];
    [_collectionView reloadData];

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJModifyBillImageCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    imageCell.delegate = self;
    imageCell.tag = indexPath.row;
    if (!_imageArr.count) {
        imageCell.addBtn.hidden = NO;
        imageCell.deleteImageView.hidden = YES;
    }else{
        if (indexPath.row > self.imageArr.count - 1 && self.imageArr.count != 4) {
            imageCell.addBtn.hidden = NO;
            imageCell.deleteImageView.hidden = YES;
        }else{

            imageCell.addBtn.hidden = YES;
            imageCell.imageview.image = _imageArr[indexPath.row];
            imageCell.deleteImageView.hidden = NO;
        }

    }

    return imageCell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_imageArr.count >= 4) {
        return 4;
    }
    return _imageArr.count + 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{

    return CGSizeMake((TYGetUIScreenWidth - 50)/4, (TYGetUIScreenWidth - 50)/4);
}

- (void)JGJModifyBillImageCollectionViewDeleteImageAndIndex:(NSInteger)index
{
    NSMutableArray *imageArrs = [[NSMutableArray alloc]initWithArray:_imageArr];
    [imageArrs removeObjectAtIndex:index];
    _imageArr = [[NSArray alloc]initWithArray:imageArrs];
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteImageAndImageArr: andDeletedIndex:)]) {
        [self.delegate deleteImageAndImageArr:imageArrs andDeletedIndex:index];
    }
    [_collectionView reloadData];

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (!self.imageArr.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ClickPoorBillPhotoBtn)]) {
            [self.delegate ClickPoorBillPhotoBtn];
        }

    }else{
        if (self.imageArr.count - 1 < indexPath.row) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ClickPoorBillPhotoBtn)]) {
                [self.delegate ClickPoorBillPhotoBtn];
            }

        }
    }
    
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{

    return 2;

}

@end
