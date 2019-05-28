//
//  JGJSynProPopMessageCell.m
//  mix
//
//  Created by yj on 16/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSynProPopMessageCell.h"
#import "UILabel+GNUtil.h"
@interface JGJSynProPopMessageCell ()
@property (weak, nonatomic) IBOutlet UILabel *messageLable;
@end

@implementation JGJSynProPopMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageLable.textColor = AppFont999999Color;
}

- (void)setMergecheckModel:(JGJSynMergecheckModel *)mergecheckModel {
    _mergecheckModel = mergecheckModel;
    self.messageLable.text = [NSString stringWithFormat:@"%@ 下 %@ 将会合并到你的 %@ 中", mergecheckModel.from_pro_name, mergecheckModel.from_team_name, mergecheckModel.to_pro_name];
    NSArray *textArray = @[mergecheckModel.from_pro_name, mergecheckModel.from_team_name, mergecheckModel.to_pro_name];
    [self.messageLable markattributedTextArray:textArray color:AppFont333333Color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
