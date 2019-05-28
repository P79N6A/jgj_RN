//
//  JGJMoreLogCollectionViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMoreLogCollectionViewCell.h"

@implementation JGJMoreLogCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLable.layer.masksToBounds = YES;
    self.nameLable.layer.cornerRadius = 2.5;
    // Initialization code
}
-(void)setModel:(JGJGetLogTemplateModel *)model
{
    self.nameLable.text = model.cat_name;
}
@end
