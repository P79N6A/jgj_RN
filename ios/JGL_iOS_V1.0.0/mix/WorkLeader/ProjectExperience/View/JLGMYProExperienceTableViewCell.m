
//
//  JLGMYProExperienceTableViewCell.m
//  mix
//
//  Created by jizhi on 15/12/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGMYProExperienceTableViewCell.h"
#import "TYFMDB.h"
#import "NSDate+Extend.h"
#import "UIButton+WebCache.h"


#define titleMaxY 32//标题的最大的Y

//项目经验都是显示3个
#define kMYProExperienceLineMaxNum 3//(TYIS_IPHONE_5_OR_LESS?3:4)

@interface JLGMYProExperienceTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *noMoreLabel;

@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *ctimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pronameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomPointView;

//constant
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLineViewLayoutB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionLayoutB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLineViewLayoutW;
@end

@implementation JLGMYProExperienceTableViewCell


- (void )setJlgProjectModel:(JLGProjectModel *)jlgProjectModel{
    _jlgProjectModel = jlgProjectModel;
    
    self.imagesArray = [jlgProjectModel.imgs mutableCopy];
    self.imagesCollectionCell.delegate = self;

    [self.imagesCollectionCell initByImagesArray:self.imagesArray byLineMaxNum:kMYProExperienceLineMaxNum width:TYGetUIScreenWidth - 65];
    self.cellHeight = titleMaxY + 30 + self.imagesCollectionCell.collectionViewH;

    if (self.isGetCellHeight) {
        return;
    }
    self.ctimeLabel.text = jlgProjectModel.ctime;
    self.pronameLabel.text = jlgProjectModel.proname;
    self.regionLabel.text = jlgProjectModel.regionname;
    
    self.pointImageView.highlighted = self.tag == 0;
}

- (void)setHiddenEditButton:(BOOL)hiddenEditButton{
    _hiddenEditButton = hiddenEditButton;
    self.editButton.hidden = hiddenEditButton;
    self.hiddenAddButton = hiddenEditButton;
}

- (void)setHiddenAddButton:(BOOL)hiddenAddButton{
    _hiddenAddButton = hiddenAddButton;
    self.imagesCollectionCell.hiddenAddButton = hiddenAddButton;
}

- (void)setHiddenTopLine:(BOOL)hiddenTopLine{
    _hiddenTopLine = hiddenTopLine;
    self.topLineView.hidden = hiddenTopLine;
}

- (void)setShowBottomPointView:(BOOL)showBottomPointView{
    _showBottomPointView = showBottomPointView;
    self.bottomPointView.hidden = !showBottomPointView;
    self.noMoreLabel.hidden = !showBottomPointView;
    self.leftLineViewLayoutW.constant = showBottomPointView?8:14;
    self.leftLineViewLayoutB.constant = showBottomPointView?8:0;
    self.bottomViewLayoutB.constant = showBottomPointView?4:0;
    if (showBottomPointView) {//最后一个
        self.collectionLayoutB.constant = LastCellExtraHeight + 2;
        self.bottomPointView.image = [UIImage imageNamed:@"proExperience_LastPoint"];
    }else{
        self.collectionLayoutB.constant = 2;
        self.bottomPointView.image = [UIImage imageNamed:@"proExperience_Point_L"];
    }
    [self layoutIfNeeded];
}

//代理－选择行的触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TYLog(@"点击了collectionView indexPath.row = %@",@(indexPath.row));
    if ([self.delegate respondsToSelector:@selector(CollectionCellDidSelected:imageIndex:)]) {
        [self.delegate CollectionCellDidSelected:self.tag imageIndex:indexPath.row];
    }
}


#pragma mark - 点击了图片的操作
- (void)phoneDidSelected:(JLGPhoneCollection *)phoneCollectionCell index:(NSInteger )index{
    
    if (index == self.imagesArray.count) {
        TYLog(@"点击了添加图片 ");
    }else{
        TYLog(@"点击了现成图片 ");
    }
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(CollectionCellDidSelected:imageIndex:)]) {
        [self.delegate CollectionCellDidSelected:self.tag imageIndex:index];
    }
}

- (void)phoneTouch{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CollectionCellTouch)]) {
        [self.delegate CollectionCellTouch];
    }
}


- (IBAction)editBtnClick:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(CollectionCellEdit:)]) {
        [self.delegate CollectionCellEdit:self.tag];
    }
}

@end
