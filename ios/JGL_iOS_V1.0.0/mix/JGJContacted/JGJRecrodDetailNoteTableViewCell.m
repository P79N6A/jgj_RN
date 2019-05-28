//
//  JGJRecrodDetailNoteTableViewCell.m
//  mix
//
//  Created by Tony on 2017/9/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecrodDetailNoteTableViewCell.h"

#import "UILabel+GNUtil.h"
@implementation JGJRecrodDetailNoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel
{
    self.titleLable.text = @"备注(该备注信息仅自己可见)";
    [self.titleLable markText:@"(该备注信息仅自己可见)" withFont:[UIFont systemFontOfSize:13] color:AppFont999999Color];
    if ([yzgGetBillModel.notes_txt length] == 0) {
        
        self.contentLable.text = @"无";
    }else {
        
        self.contentLable.text = yzgGetBillModel.notes_txt;
    }

}
@end
