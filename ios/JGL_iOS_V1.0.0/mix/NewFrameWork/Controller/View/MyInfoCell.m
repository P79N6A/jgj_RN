//
//  MyInfoCell.m
//  mix
//
//  Created by celion on 16/3/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "MyInfoCell.h"
@interface MyInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
//分割线
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageViewCenterY;

@property (weak, nonatomic) IBOutlet UILabel *detailTitle;

@end
@implementation MyInfoCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor = highlighted?TYColorHex(0Xf8f8f8):[UIColor whiteColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.textColor = AppFont333333Color;
    [self.title setFont:[UIFont systemFontOfSize:AppFont34Size]];
    self.detailTitle.textColor = AppFont999999Color;
    self.detailTitle.font = [UIFont systemFontOfSize:AppFont28Size];
    self.flagImageView.clipsToBounds = YES;
    self.flagImageView.layer.cornerRadius = 4;
    self.flagImageView.backgroundColor = [UIColor redColor];
    self.remarkLable.textColor = AppFont999999Color;
    self.lineView.backgroundColor = AppFontdbdbdbColor;
}

- (void)cellWithType:(SelectedWorkType)type indexPath:(NSIndexPath *)indexPath  {    
#pragma 我的重新布局  LYQ 2017-1-3
    
//    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
    JGJMineInfoSecModel *minInfoSecModel = self.mineInfoFirstModel.mineInfos[indexPath.section];
    JGJMineInfoThirdModel *mineInfoThirdModel = minInfoSecModel.mineInfos[indexPath.row];
    self.iconImageView.image = [UIImage imageNamed:mineInfoThirdModel.workerIcon];
    self.title.text = mineInfoThirdModel.title;
    self.lineView.hidden = indexPath.row == minInfoSecModel.mineInfos.count - 1 ;
    self.flagImageView.hidden = YES; //备用标记红点
//    self.remarkLable.text = mineInfoThirdModel.remark;
//    self.detailTitle.text = mineInfoThirdModel.detailTitle;
//    BOOL isVerified = NO;
//    switch (type) {
//        case workCellType: {
//            self.flagImageView.hidden = !(indexPath.section == 3 && indexPath.row == 2 && self.myWorkZone.reply_cnt  != 0);
//            isVerified = self.myWorkZone.verified == 0;
//            if (section == 0 && row == 1) {
//                self.detailTitle.text = self.myWorkZone. statusString;
//            }else if (section == 2 && row == 0) {
//                self.detailTitle.text = self.myWorkZone.verifiedString;
//            }else  if (section == 0 && row == 0) {
//                self.detailTitle.text = self.myWorkZone.roleString;
//            }
//        }
//            break;
//        case workLeaderCellType: {
//            self.flagImageView.hidden = !(section == 3 && row == 2 && self.myWorkLeaderZone.overall != 0);
//            isVerified = self.myWorkLeaderZone.verified == 0;
//            if (section == 2 && row == 0) {
//                self.detailTitle.text = self.myWorkLeaderZone.verifiedString;
//            }else if (section == 0 && row == 0) {
//                self.detailTitle.text = self.myWorkLeaderZone.roleString;
//                self.lineView.hidden = indexPath.row == minInfoSecModel.mineInfos.count - 2 ;
//            }
//        }
//            break;
//        default:
//            break;
//    }
//    self.remarkLable.hidden = YES;
//    self.iconImageViewCenterY.constant = 0;
    
//    if (indexPath.section == 2) {
//        if (isVerified && indexPath.row == 0 && JLGisLoginBool) {
//            self.iconImageViewCenterY.constant = -10;
//            self.remarkLable.hidden = NO;
//        }else if (!JLGisLoginBool && indexPath.row == 0) {
//            self.iconImageViewCenterY.constant = -10;
//            self.remarkLable.hidden = NO;
//            self.detailTitle.text = @"立即认证";
//        }
//        if (indexPath.row == 1) {
//            self.iconImageViewCenterY.constant = -10;
//            self.remarkLable.hidden = NO;
//        }
//    }

}

@end
