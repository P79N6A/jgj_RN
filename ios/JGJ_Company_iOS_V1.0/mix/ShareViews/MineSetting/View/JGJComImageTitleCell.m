//
//  JGJComImageTitleCell.m
//  mix
//
//  Created by yj on 2018/12/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJComImageTitleCell.h"

@implementation JGJComImageTitleModel


@end

@interface JGJComImageTitleCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *detailLable;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;


@end

@implementation JGJComImageTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfoModel:(JGJMineInfoThirdModel *)infoModel {
    
    _infoModel = infoModel;
    
    self.icon.image = [UIImage imageNamed:infoModel.workerIcon];
    
    self.detailLable.text = infoModel.detailTitle;
    
    self.titleLable.text = infoModel.title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
