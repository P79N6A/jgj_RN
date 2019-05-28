//
//  JLGWorkTypeViewController.m
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGWorkTypeViewController.h"

#import "TYFMDB.h"
#import "JLGNeedJobCollectionViewCell.h"

@interface JLGWorkTypeViewController ()
<
    JLGNeedJobCollectionViewCellDelegate
>
@property (strong, nonatomic) NSString *identifierStr;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation JLGWorkTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //注册collection
    self.identifierStr = NSStringFromClass([JLGNeedJobCollectionViewCell class]);
    UINib *nib = [UINib nibWithNibName:self.identifierStr
                                bundle: [NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:self.identifierStr];
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.workTypesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JLGNeedJobCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifierStr forIndexPath:indexPath];
    collectionCell.delegate = self;
    collectionCell.tag = indexPath.row;
    [collectionCell jobTypeButtonSelected:[self.selectedArray[indexPath.row] boolValue]];
    [collectionCell.jobTypeButton setTitle:self.workTypesArray[indexPath.row][@"name"] forState:UIControlStateNormal];
    return collectionCell;
}

//collectionCell的delegate
- (void)needJobCollectionCellBtnClikIndex:(NSUInteger)index selected:(BOOL)selected{
    self.selectedArray[index] = @(selected);
}

- (IBAction)confirmBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(JLGWorkTypeVc:SelectedArray:)]) {
        [self.delegate JLGWorkTypeVc:self SelectedArray:self.selectedArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
