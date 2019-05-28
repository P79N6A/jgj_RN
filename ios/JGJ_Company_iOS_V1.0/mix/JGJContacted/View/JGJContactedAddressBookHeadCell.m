//
//  JGJContactedAddressBookHeadCell.m
//  mix
//
//  Created by yj on 17/1/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJContactedAddressBookHeadCell.h"
@interface JGJContactedAddressBookHeadCell ()
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *headTitle;
@end
@implementation JGJContactedAddressBookHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headTitle.textColor = AppFont333333Color;
    self.headTitle.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeadModel:(JGJSynBillingModel *)headModel {
    _headModel = headModel;
    [self.headButton setImage:[UIImage imageNamed:_headModel.head_pic] forState:UIControlStateNormal];
    self.headTitle.text = headModel.name;
}

@end
