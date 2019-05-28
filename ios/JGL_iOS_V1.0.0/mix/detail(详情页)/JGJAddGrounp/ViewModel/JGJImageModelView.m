//
//  JGJImageModelView.m
//  mix
//
//  Created by Tony on 2016/12/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJImageModelView.h"
#import "UIImageView+WebCache.h"
#import "JGJJoinGroupCollectionViewCell.h"
#define ScreenSize [UIScreen mainScreen].bounds.size
#define selfframe CGRectGetHeight(self.frame)
@interface JGJImageModelView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIImageView *imageview;
}
@property(nonatomic,strong)UILabel *topLable;

@end
@implementation JGJImageModelView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.peopleCollectionview];
        _DataNameModel = [[JGJSynBillingModel alloc]init];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.topLable];

    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self addSubview:self.peopleCollectionview];
        
        _DataNameModel = [[JGJSynBillingModel alloc]init];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.topLable];
    }
    
    return self;
}

-(UILabel *)topLable
{
    if (!_topLable) {
        _topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
        _topLable.backgroundColor = AppFontdbdbdbColor;
    }
    return _topLable;
    
}
-(UICollectionView *)peopleCollectionview
{
    if (!_peopleCollectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _peopleCollectionview =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 5,ScreenSize.width, selfframe - 10) collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [_peopleCollectionview registerNib:[UINib nibWithNibName:@"JGJJoinGroupCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"peopleCollectionindentFer"];
        _peopleCollectionview.dataSource = self;
        _peopleCollectionview.delegate = self;
        _peopleCollectionview.scrollEnabled = YES;
        _peopleCollectionview.pagingEnabled = YES;
        _peopleCollectionview.backgroundColor =[UIColor clearColor];
        
    }
    return _peopleCollectionview;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _DataMutableArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJJoinGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"peopleCollectionindentFer" forIndexPath:indexPath];
    cell.DataNameModel = _DataMutableArray[indexPath.row];
    return cell;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    

    return CGSizeMake(selfframe-10, selfframe-10);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{


    return 1;

}


- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
//    return UIEdgeInsetsMake(5.0f, 18.0f, 5.0f, 18.0f);
    return UIEdgeInsetsMake(5, 18.0f, 5, 18.0f);

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.peopledelegate respondsToSelector:@selector(ClickPeopleItem:anIndexpath:deleteObeject:)]) {
        [self.peopledelegate ClickPeopleItem:_DataMutableArray anIndexpath:indexPath deleteObeject:_DataMutableArray[indexPath.row]];
    }
//    [_DataMutableArray removeObjectAtIndex:indexPath.row]; //外部已经移除yj-2.1.0
//    [_peopleCollectionview reloadData]; //setter方法已经刷新 yj-2.1.0
}
-(void)setDataMutableArray:(NSMutableArray *)DataMutableArray
{
    _DataMutableArray = DataMutableArray;
    [_peopleCollectionview reloadData];
}

@end
