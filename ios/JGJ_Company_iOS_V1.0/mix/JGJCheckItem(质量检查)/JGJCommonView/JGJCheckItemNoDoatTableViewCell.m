//
//  JGJCheckItemNoDoatTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/12/4.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckItemNoDoatTableViewCell.h"

@implementation JGJCheckItemNoDoatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topView.backgroundColor = AppFontf1f1f1Color;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContent:(NSString *)Content
{
    self.contentLable.text = Content ?:@"";

}
@end
