//
//  JGJAddPeopleToGroupListView.m
//  mix
//
//  Created by Tony on 2016/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJAddPeopleToGroupListView.h"
#import "JGJNetAnimation.h"
#import "UIImageView+WebCache.h"
#import "AddPeopleCollectionViewCell.h"
#define ScreenSize [UIScreen mainScreen].bounds.size
static NSString *cellid = @"cellindentifer";
@interface JGJAddPeopleToGroupListView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)JGJNetAnimation *animationview;

@end
@implementation JGJAddPeopleToGroupListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _JoinArray = [NSMutableArray array];
        self.backgroundColor = AppFont131313Color;
        [self addSubview:self.peopleCollectionview];
        [self addSubview:self.JoinGrounpButton];

    }

    return self;
}

-(UICollectionView *)peopleCollectionview
{
    if (!_peopleCollectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _peopleCollectionview =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,ScreenSize.width, ScreenSize.height-60-120) collectionViewLayout:layout];
        [_peopleCollectionview registerNib:[UINib nibWithNibName:@"AddPeopleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellid];
        _peopleCollectionview.dataSource = self;
        _peopleCollectionview.delegate = self;
        _peopleCollectionview.backgroundColor = AppFont131313Color;
        _peopleCollectionview.showsVerticalScrollIndicator = YES;
        _peopleCollectionview.delaysContentTouches = NO;
    }
    return _peopleCollectionview;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _JoinArray.count;
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"peopleCollectionindentFer" forIndexPath:indexPath];
//    UIImageView *imageview = (UIImageView *)[cell viewWithTag:10];
//    imageview.layer.masksToBounds = YES;
//    imageview.layer.cornerRadius = JGJCornerRadius;
//    NSString *urlstr = _JoinArray[indexPath.row][@"head_pic"];
//    NSURL *ImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,urlstr]];
//    [imageview sd_setImageWithURL:ImageUrl placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
//    UILabel *lable = (UILabel *)[cell viewWithTag:11];
//    lable.text = [NSString stringWithFormat:@"%@",_JoinArray[indexPath.row][@"real_name"]];
    AddPeopleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    cell.userInfo = _JoinArray[indexPath.row];
//    cell.Url_Str = _JoinArray[indexPath.row][@"head_pic"];
//    cell.NameStr = [NSString stringWithFormat:@"%@",_JoinArray[indexPath.row][@"real_name"]];
    return cell;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    return CGSizeMake(50, 100);
    
}
-(UIButton *)JoinGrounpButton
{
    if (!_JoinGrounpButton) {
        _JoinGrounpButton = [[UIButton alloc]initWithFrame:CGRectMake(7.5, ScreenSize.height-250, ScreenSize.width-15, 45.5)];
        _JoinGrounpButton.layer.cornerRadius = 5;
        _JoinGrounpButton.layer.masksToBounds = YES;
        _JoinGrounpButton.backgroundColor = [UIColor colorWithRed:202/255.0f green:15.0/255.0f blue:33.0/255.0f alpha:1];
        [_JoinGrounpButton setTitle:@"进入群聊" forState:UIControlStateNormal];
        _JoinGrounpButton.titleLabel.textColor = [UIColor whiteColor];
        [_JoinGrounpButton addTarget:self action:@selector(JoinGrounp) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _JoinGrounpButton;
}
-(void)JoinGrounp
{
    if ([self.delegate respondsToSelector:@selector(ClickjoinGroup)]) {
        [self.delegate ClickjoinGroup];
    }


}
-(void)waitAnimal
{

    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    imageview.animationImages=@[[UIImage imageNamed:@"new_feature_1"],[UIImage imageNamed:@"new_feature_2"],[UIImage imageNamed:@"new_feature_3"],[UIImage imageNamed:@"new_feature_4"]];
    imageview.animationDuration = .5;
    imageview.animationRepeatCount = 10;
    [imageview startAnimating];
    




}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20.0f, 18.0f, 20.0f, 18.0f);
}
-(void)setJoinArray:(NSMutableArray *)JoinArray
{
    _JoinArray = [NSMutableArray array];

    _JoinArray = JoinArray;
    [_peopleCollectionview reloadData];


}
@end
