//
//  JGJMoreLogView.m
//  JGJCompany
//
//  Created by Tony on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMoreLogView.h"
#import "JGJMoreLogCollectionViewCell.h"
static NSString *itemId = @"LogItemIndentifer";
@interface JGJMoreLogView()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
{
UIView *placeView;
NSMutableArray *dataArr;
BOOL showAdd;

}
@end
@implementation JGJMoreLogView
-(instancetype)initWithFrame:(CGRect)frame ishowAddRow:(BOOL)add didSelectedIndexPathBlock:(didselectIndexpath)indexpath initWithArr:(NSMutableArray *)arr
{
    if (self = [super initWithFrame:frame]) {
        showAdd = add;
        [self initView];
        
        self.didSelectIndexpath = indexpath;
        dataArr = [[NSMutableArray alloc]initWithArray:arr];
        [_collectionView reloadData];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
}
- (void)initView{
  
    [[[NSBundle mainBundle]loadNibNamed:@"JGJMoreLogView" owner:self options:nil]firstObject];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"JGJMoreLogCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:itemId];
    [self.contentView setFrame:CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, 270)];
    self.contentView.userInteractionEnabled = YES;
    self.contentView.alpha = 1;
    

    placeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    placeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPlaceViwe)];
    [placeView addGestureRecognizer:tap];
    
    [[[UIApplication sharedApplication]keyWindow] addSubview:placeView];
    [[[UIApplication sharedApplication]keyWindow] addSubview:self.contentView];
    
}

- (void)show {
    
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -270);
        
    } completion:nil];
}

- (void)tapPlaceViwe
{
    [UIView animateWithDuration:.2 animations:^{
        [self removeFromSuperview];
        [placeView removeFromSuperview];
        [self.contentView removeFromSuperview];
    }];


}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJMoreLogCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:itemId forIndexPath:indexPath];
    if (dataArr.count&&indexPath.row <= dataArr.count -1) {
        cell.model = dataArr[indexPath.row];
    
    if (indexPath.row == dataArr.count) {
        cell.addImageview.hidden = NO;
        cell.nameLable.text = nil;
    }else{
        cell.addImageview.hidden = YES;
    }
    }else{
    
    cell.nameLable.text = @"";
    }
    if (!showAdd && indexPath.row == dataArr.count) {
        cell.hidden = YES;
    }
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
    return dataArr.count + 1;

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake((TYGetUIScreenWidth - 45)/2, 40);

}
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0f, 15.0f, 5.0f, 15.0f);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    self.didSelectIndexpath(indexPath);

    [self removeFromSuperview];
    [placeView removeFromSuperview];
    [self.contentView removeFromSuperview];

  
}
- (IBAction)closeButton:(id)sender {
    self.didSelectIndexpath = nil;
    [self removeFromSuperview];
    [placeView removeFromSuperview];
    [self.contentView removeFromSuperview];

}


@end
