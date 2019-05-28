//
//  JGJClearCacheTableViewCell.m
//  mix
//
//  Created by Tony on 2017/1/3.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJClearCacheTableViewCell.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
@interface JGJClearCacheTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *detailLable;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextImageW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextImageH;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;


@end

@implementation JGJClearCacheTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.flagImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMineInfoThirdModel:(JGJMineInfoThirdModel *)mineInfoThirdModel {
    _mineInfoThirdModel = mineInfoThirdModel;
    self.detailLable.text = mineInfoThirdModel.detailTitle;
    self.titleLable.text = mineInfoThirdModel.title;
    self.nextImageW.constant = 9.0;
    self.nextImageH.constant = 15.0;
    self.nextImageView.image = [UIImage imageNamed:@"arrow_right"];
    if (mineInfoThirdModel.isShowQrcode) {
        self.nextImageH.constant = 20.0;
        self.nextImageW.constant = 20.0;
        self.nextImageView.image =  [UIImage imageNamed:@"teamManger_Qrcode"];
    }
    self.titleLable.textColor = AppFont333333Color;
    if (![NSString isEmpty:mineInfoThirdModel.remark] && mineInfoThirdModel.isShowRemark) {
        self.titleLable.text = [NSString stringWithFormat:@"%@\n%@", mineInfoThirdModel.title, mineInfoThirdModel.remark];
        [self.titleLable markLineText:mineInfoThirdModel.remark withLineFont:[UIFont systemFontOfSize:AppFont24Size] withColor:AppFont999999Color lineSpace:6];
        self.titleLable.textAlignment = NSTextAlignmentLeft;
    }
    
    self.detailLable.hidden = mineInfoThirdModel.is_hidden_detail;
    
    self.flagImageView.hidden = !mineInfoThirdModel.is_unshow_detail_Flag;
}

@end
