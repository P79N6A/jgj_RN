//
//  FaceGroupDetail.m
//  mix
//
//  Created by Tony on 2016/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "FaceGroupDetail.h"
#import "JGJAddGrounpHeaderView.h"

#define ScreenSize [UIScreen mainScreen].bounds.size
@interface FaceGroupDetail ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic ,strong)JGJAddGrounpHeaderView *headerView;
@property(nonatomic ,strong)UIButton *JoinGrounpButton;

@end

@implementation FaceGroupDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"面对面建群";
    [self.view addSubview:self.peopleCollectionview];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.JoinGrounpButton];
    
}
-(JGJAddGrounpHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [JGJAddGrounpHeaderView new];
        [_headerView setFrame:CGRectMake(0, 0, ScreenSize.width, 120)];
        
    }

    return _headerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UICollectionView *)peopleCollectionview
{
    if (!_peopleCollectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _peopleCollectionview =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 120,ScreenSize.width, ScreenSize.height-60-120) collectionViewLayout:layout];
        [_peopleCollectionview registerNib:[UINib nibWithNibName:@"AddPeopleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"peopleCollectionindentFer"];
        _peopleCollectionview.dataSource = self;
        _peopleCollectionview.delegate = self;
        
    
    }
    return _peopleCollectionview;

}
-(UIButton *)JoinGrounpButton
{
    if (!_JoinGrounpButton) {
        _JoinGrounpButton = [[UIButton alloc]initWithFrame:CGRectMake((ScreenSize.width-355)/2, ScreenSize.height-130, 355, 64)];
        _JoinGrounpButton.layer.cornerRadius = 5;
        _JoinGrounpButton.layer.masksToBounds = YES;
        _JoinGrounpButton.backgroundColor = [UIColor redColor];
        [_JoinGrounpButton setTitle:@"进入群聊" forState:UIControlStateNormal];
        _JoinGrounpButton.titleLabel.textColor = [UIColor whiteColor];
        
    }

    return _JoinGrounpButton;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 70;


}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"peopleCollectionindentFer" forIndexPath:indexPath];
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:10];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = 4;
    [imageview setImage:[UIImage imageNamed:@"new_feature_1.jpg"]];
    
    UILabel *lable = (UILabel *)[cell viewWithTag:11];
    lable.text = @"老例";
    
    
    return cell;



}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{


    return CGSizeMake(50, 100);

}
@end
