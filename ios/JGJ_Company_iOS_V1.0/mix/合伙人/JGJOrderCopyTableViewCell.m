//
//  JGJOrderCopyTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJOrderCopyTableViewCell.h"

@implementation JGJOrderCopyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}
- (void)initView{
    _CopyOrderNButton.layer.masksToBounds = YES;
    _CopyOrderNButton.layer.cornerRadius = 2;
    _CopyOrderNButton.layer.borderWidth = .5;
    _CopyOrderNButton.layer.borderColor = AppFontEB4E4EColor.CGColor;

}
- (IBAction)clickCopyNumButton:(id)sender {
    if ([NSString isEmpty:self.orderNumlable.text]) {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.orderNumlable.text;
    [TYShowMessage showSuccess:@"复制成功"];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderListModel:(JGJOrderListModel *)orderListModel
{

    _orderNumlable.text = orderListModel.order_sn;
}
@end
