//
//  JGJAccountHeaderTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAccountHeaderTableViewCell.h"

@implementation JGJAccountHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changAccount)];
    _otherAccount.userInteractionEnabled = YES;
    [_otherAccount addGestureRecognizer:tap];

}
- (void)changAccount
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeAccountFrom)]) {
        [self.delegate changeAccountFrom];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJAccountListModel *)model
{
    _model = model;
    if ([model.pay_type isEqualToString:@"2"])
    {
        [_imageview setImage:[UIImage imageNamed:@"alipayIcon"]];
    }
    else {
        [_imageview setImage:[UIImage imageNamed:@"Combined Shape"]];
    }
    _phoneNumLable.text = model.account_name;
    

}
@end
