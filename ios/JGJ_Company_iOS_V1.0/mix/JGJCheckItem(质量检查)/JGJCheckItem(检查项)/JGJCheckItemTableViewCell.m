//
//  JGJCheckItemTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/11/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckItemTableViewCell.h"

@implementation JGJCheckItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews
{
        [super layoutSubviews];
        
        for (UIView *subView in self.subviews) {
            if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
                ((UIView *)[subView.subviews firstObject]).backgroundColor = AppFontEB4E4EColor;
                for (UIButton *button in subView.subviews) {
                    
                    if ([button isKindOfClass:[UIButton class]]) {
                        
                        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
                        
                    }
                }
                
                
            }
            
        }
    


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJCheckItemListDetailModel *)model
{
    self.titleLable.text = model.name?:@"";

}

@end
