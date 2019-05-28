//
//  JGJWorkReportSelectedTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWorkReportSelectedTableViewCell.h"
#import "JGJImageHeadCollectionViewCell.h"
#import "JGJSetRecorderViewController.h"
@interface JGJWorkReportSelectedTableViewCell ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@end
@implementation JGJWorkReportSelectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentView addSubview:self.collectionview];
}
-(UICollectionView *)collectionview
{
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 110) collectionViewLayout:layout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.backgroundColor = [UIColor whiteColor];
        [_collectionview registerNib: [UINib nibWithNibName:@"JGJImageHeadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageHeadIndetifer"];
    }
    return _collectionview;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return 5;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(50, 65);

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJImageHeadCollectionViewCell *imagecell =[collectionView dequeueReusableCellWithReuseIdentifier:@"imageHeadIndetifer" forIndexPath:indexPath];
    if (indexPath.row == 4) {
        imagecell.imageView.image = [UIImage imageNamed:@"add"];
        imagecell.nameLable.text = @"添加";
    }
    return imagecell;
}
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section

{
    return UIEdgeInsetsMake(12, 10, 0, 15);

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJImageHeadCollectionViewCell *cell = (JGJImageHeadCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.imageView.image == [UIImage imageNamed:@"add"] || [cell.nameLable.text isEqualToString: @"添加"]) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(selectedCollectionViewItem)]) {
            [self.delegate selectedCollectionViewItem];
        }

    }


}
@end
