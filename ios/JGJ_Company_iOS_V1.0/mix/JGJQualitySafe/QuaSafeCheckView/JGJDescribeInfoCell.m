//
//  JGJDescribeInfoCell.m
//  JGJCompany
//
//  Created by yj on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJDescribeInfoCell.h"

#import "UILabel+GNUtil.h"

#import "NSString+Extend.h"

@implementation JGJDescribeInfoModel


@end

@interface JGJDescribeInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *desLable;

@end

@implementation JGJDescribeInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.desLable.font = [UIFont systemFontOfSize:AppFont26Size];
    
    self.desLable.textColor = AppFont999999Color;
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;

}

- (void)setDesInfoModel:(JGJDescribeInfoModel *)desInfoModel {

    _desInfoModel = desInfoModel;
    
    self.desLable.text = _desInfoModel.desInfo;

    if (![NSString isEmpty:_desInfoModel.changeColorInfo]) {
        
        [self.desLable markText:_desInfoModel.changeColorInfo withColor:AppFontEB4E4EColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
