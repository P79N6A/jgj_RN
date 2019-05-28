//
//  JGJTSearchProAddressDefaultCell.m
//  JGJCompany
//
//  Created by yj on 2017/5/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTSearchProAddressDefaultCell.h"

#import "UILabel+GNUtil.h"

@implementation JGJProAddressModel


@end

@interface JGJTSearchProAddressDefaultCell ()

@property (weak, nonatomic) IBOutlet UIButton *selButton;

@property (weak, nonatomic) IBOutlet UILabel *addressDetailLable;
@end

@implementation JGJTSearchProAddressDefaultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.selButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:2.5];
    self.addressDetailLable.textColor = AppFont999999Color;
    self.addressDetailLable.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProAddressModel:(JGJProAddressModel *)proAddressModel {

    _proAddressModel = proAddressModel;
    
    self.addressDetailLable.text = [NSString stringWithFormat:@"%@%@", _proAddressModel.addressTitle, proAddressModel.addressDetailTitle];
    
    [self.addressDetailLable markLineText:proAddressModel.addressDetailTitle withLineFont:[UIFont systemFontOfSize:AppFont24Size] withColor:AppFont333333Color lineSpace:3];
    
    self.addressDetailLable.textAlignment = NSTextAlignmentLeft;

}

- (IBAction)handleSelButtonPressedAction:(UIButton *)sender {
    
    if (self.handleSearchProAddressDefaultCellBlock) {
        self.handleSearchProAddressDefaultCellBlock(self);
    }
}


@end
