//
//  JGJComTitleCell.m
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJComTitleCell.h"

#import "UILabel+GNUtil.h"

@implementation JGJComTitleCellDesModel

@end

@interface JGJComTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *des;

@end

@implementation JGJComTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.textColor = AppFont333333Color;
    
    self.title.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.des.textColor = AppFont333333Color;
    
    self.des.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.contentView.backgroundColor = AppFontfafafaColor;
}

- (void)setDesModel:(JGJComTitleCellDesModel *)desModel {
    
    _desModel = desModel;
    
    self.title.text = _desModel.title;
    
    self.des.text = _desModel.des;
    
    self.des.textColor = AppFont333333Color;
    
    UIColor *color = ![NSString isEmpty:_desModel.changeColorStr] ? AppFontEB4E4EColor : AppFont333333Color;
    
    [self.des markText:_desModel.changeColorStr?:@"" withColor:color];
    
    if (_desModel.changeColors.count > 0) {
        
        [self.des markattributedTextArray:_desModel.changeColors color:AppFontEB4E4EColor font:[UIFont systemFontOfSize:AppFont30Size] isGetAllText:YES];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
