//
//  JGJAddAccountTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddAccountTableViewCell.h"

@implementation JGJAddAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _deleteButton.layer.cornerRadius = 2.5;
    _deleteButton.layer.masksToBounds = YES;
    _deleteButton.layer.borderColor = AppFont666666Color.CGColor;
    _deleteButton.layer.borderWidth = 1;
    _useingLable.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
       if (selected) {
        self.contentView.backgroundColor = AppFontfdf1e0Color;
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];

    
    }
    
    // Configure the view for the selected state
}
- (IBAction)clickDeleteButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickDeleteButtonAndIndexpathRow:)]) {
        [self.delegate clickDeleteButtonAndIndexpathRow:self.tag];
    }
}
-(void)setAccountModel:(JGJAccountListModel *)accountModel
{
    _accountModel = accountModel;
    if ([accountModel.pay_type isEqualToString:@"2"])
    {
        [_imageViewTy setImage:[UIImage imageNamed:@"alipayIcon"]];
    }
   else {
        [_imageViewTy setImage:[UIImage imageNamed:@"Combined Shape"]];
    }

    _accountTypeLable.text = accountModel.account_name;
//    if (self.selected) {
//        _useingLable.hidden = NO;
//    }else{
    _useingLable.hidden = YES;
//    }

}
@end
