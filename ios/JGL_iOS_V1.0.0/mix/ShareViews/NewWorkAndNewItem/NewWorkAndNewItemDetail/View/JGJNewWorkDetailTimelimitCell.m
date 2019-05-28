//
//  JGJNewWorkDetailTimelimitCell.m
//  mix
//
//  Created by celion on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewWorkDetailTimelimitCell.h"

@interface JGJNewWorkDetailTimelimitCell ()
@property (weak, nonatomic) IBOutlet UILabel *protimelimit;
@property (weak, nonatomic) IBOutlet UILabel *totalarea;
@property (weak, nonatomic) IBOutlet UILabel *prodescription;

@property (weak, nonatomic) IBOutlet UILabel *protimelimitTitle;
@property (weak, nonatomic) IBOutlet UILabel *totalareaTitle;
@property (weak, nonatomic) IBOutlet UILabel *prodesscriptionTitle;

@end
@implementation JGJNewWorkDetailTimelimitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIFont *font = [UIFont systemFontOfSize:AppFont30Size];
    UIFont *detailFont = [UIFont systemFontOfSize:AppFont28Size];
    self.protimelimit.font = detailFont;
    self.protimelimit.textColor = AppFont999999Color;
    self.totalarea.font = detailFont;
    self.totalarea.textColor = AppFont999999Color;
    self.prodescription.font = detailFont;
    self.prodescription.textColor = AppFont999999Color;
    
    self.protimelimitTitle.font = font;
    self.protimelimitTitle.textColor = AppFont333333Color;
    self.totalareaTitle.font = font;
    self.totalareaTitle.textColor = AppFont333333Color;
    self.prodesscriptionTitle.font = font;
    self.prodesscriptionTitle.textColor = AppFont333333Color;
    self.prodescription.preferredMaxLayoutWidth = TYGetUIScreenWidth - 24;
}

- (void)setJlgFindProjectModel:(JLGFindProjectModel *)jlgFindProjectModel {
    _jlgFindProjectModel = jlgFindProjectModel;
    self.protimelimit.text = jlgFindProjectModel.timelimit;
    self.totalarea.text = [NSString stringWithFormat:@"%@㎡",   jlgFindProjectModel.total_area];
    if (jlgFindProjectModel.prodescrip != nil && jlgFindProjectModel.prodescrip.length != 0) {
        self.prodescription.text = jlgFindProjectModel.prodescrip;
    } else {
        self.prodescription.text = @"暂无项目描述";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
