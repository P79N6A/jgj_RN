//
//  JGJTagListCell.m
//  mix
//
//  Created by yj on 2018/4/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJTagListCell.h"

@interface JGJTagListCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagLable;

@end

@implementation JGJTagListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tagLable.textColor = AppFont333333Color;
    
    self.tagLable.font = [UIFont systemFontOfSize:AppFont28Size];
}

- (void)setTagModel:(JGJMemberImpressTagViewModel *)tagModel {
    
    _tagModel = tagModel;
    
    self.tagLable.text = tagModel.tag_name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
