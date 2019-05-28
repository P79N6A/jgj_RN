//
//  JGJNewWorkDetailPublshCell.m
//  mix
//
//  Created by celion on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewWorkDetailPublshCell.h"
#import "UILabel+GNUtil.h"
@interface JGJNewWorkDetailPublshCell ()
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UILabel *regionName;
@property (weak, nonatomic) IBOutlet UILabel *publishName;
@property (weak, nonatomic) IBOutlet UIButton *checkMapButton;

@property (weak, nonatomic) IBOutlet UILabel *proNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *publishNameTitle;
@end

@implementation JGJNewWorkDetailPublshCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    设置内容
    self.proName.font = [UIFont systemFontOfSize:AppFont30Size];
    UIFont *detailFont = [UIFont systemFontOfSize:AppFont28Size];
    self.proName.textColor = AppFont999999Color;
    self.publishName.font = detailFont;
    self.publishName.textColor = AppFont999999Color;
    self.regionName.font = detailFont;
    self.regionName.textColor = AppFont999999Color;
    [self.checkMapButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    self.checkMapButton.titleLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    [self.checkMapButton.layer setLayerBorderWithColor:AppFont999999Color width:1 radius:2];
    self.checkMapButton.clipsToBounds = YES;
//    设置标题
    self.proNameTitle.font = [UIFont systemFontOfSize:AppFont30Size];;
    self.proNameTitle.textColor = AppFont333333Color;
    self.publishNameTitle.font = [UIFont systemFontOfSize:AppFont30Size];;
    self.publishNameTitle.textColor = AppFont333333Color;
    self.regionName.preferredMaxLayoutWidth = TYGetUIScreenWidth - 100;
}

- (void)setJlgFindProjectModel:(JLGFindProjectModel *)jlgFindProjectModel {
    _jlgFindProjectModel = jlgFindProjectModel;
    self.proName.text = jlgFindProjectModel.proname;
    
    self.regionName.text = [NSString stringWithFormat:@"地址: %@", jlgFindProjectModel.proaddress?:@""];
    [self.regionName markText:@"地址:" withColor:AppFont333333Color];
    self.publishName.text = jlgFindProjectModel.fmname;
     self.checkMapButton.hidden = (jlgFindProjectModel.prolocation.count  != 2);
}

- (IBAction)checkMapButtonPressed:(UIButton *)sender {
    if (self.blockCheckMapButtonPressed) {
        self.blockCheckMapButtonPressed();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
