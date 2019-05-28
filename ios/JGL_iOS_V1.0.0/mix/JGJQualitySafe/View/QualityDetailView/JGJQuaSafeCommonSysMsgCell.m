//
//  JGJQuaSafeCommonSysMsgCell.m
//  JGJCompany
//
//  Created by yj on 2017/12/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCommonSysMsgCell.h"

#import "UILabel+GNUtil.h"

@implementation JGJQuaSafeCommonSysMsgCellModel


@end

@interface JGJQuaSafeCommonSysMsgCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLable;

@end

@implementation JGJQuaSafeCommonSysMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLable.textColor = AppFont333333Color;
    
    self.titleLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.subTitleLable.textColor = AppFont999999Color;
    
    self.subTitleLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    self.titleLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 87;
}

- (void)setCommonSysMsgCellModel:(JGJQuaSafeCommonSysMsgCellModel *)commonSysMsgCellModel {
    
    _commonSysMsgCellModel = commonSysMsgCellModel;
    
    NSString *title = [NSString stringWithFormat:@"%@\n%@", commonSysMsgCellModel.title,commonSysMsgCellModel.changeColorStr?:@""];
    
    self.titleLable.text = title;
    
    if (![NSString isEmpty:commonSysMsgCellModel.changeColorStr]) {
        
//        [self.titleLable markText:commonSysMsgCellModel.changeColorStr withColor:AppFont999999Color];
        
        [self.titleLable markLineText:commonSysMsgCellModel.changeColorStr withLineFont:self.titleLable.font withColor:AppFont999999Color lineSpace:1];
    }
    
    self.subTitleLable.text = commonSysMsgCellModel.subTitle;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
