//
//  JGJCollectionImageHeadView.m
//  九宫格图片
//
//  Created by Tony on 2017/6/8.
//  Copyright © 2017年 test. All rights reserved.
//

#import "JGJCollectionImageHeadView.h"
#import "JGJLImageCollectionViewCell.h"
@interface JGJCollectionImageHeadView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource

>
@property (nonatomic, strong)UICollectionView *MainCollectionview;


@end
static NSString *reciveHead     = @"reciveCellIdentifer";

@implementation JGJCollectionImageHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
- (void)setupView{

    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.MainCollectionview];

}
-(UICollectionView *)MainCollectionview
{
    if (!_MainCollectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        _MainCollectionview =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,263, CGRectGetHeight(self.frame)) collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _MainCollectionview.showsHorizontalScrollIndicator = NO;
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJLImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reciveHead];
        _MainCollectionview.dataSource = self;
        _MainCollectionview.delegate = self;
        _MainCollectionview.backgroundColor = [UIColor whiteColor];
        _MainCollectionview.scrollEnabled = YES;
        _MainCollectionview.bounces = NO;
        _MainCollectionview.showsVerticalScrollIndicator = NO;
        
    }
    
    return _MainCollectionview;
    
    
}
-(void)setDataArr:(NSMutableArray *)DataArr
{
    if (!_DataArr) {
        _DataArr = [NSMutableArray array];
    }
    _DataArr = DataArr;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        JGJLImageCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reciveHead forIndexPath:indexPath];
        cell.urlStr = _DataArr[indexPath.row];
        
        return cell;
        
    }
    return 0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _DataArr.count ;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_DataArr.count <= 0) {
    return CGSizeMake(TYGetUIScreenWidth, 0);
    }
    return CGSizeMake(80, 100);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    
    return 1;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
        [self.delegate didSelectItemAtIndexPath:indexPath];
    }

}
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(0, 1, 0, 1);
}
@end
