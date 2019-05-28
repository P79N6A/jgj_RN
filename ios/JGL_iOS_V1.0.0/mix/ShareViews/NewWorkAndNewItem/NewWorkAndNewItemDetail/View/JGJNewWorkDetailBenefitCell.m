//
//  JGJNewWorkDetailBenefitCell.m
//  mix
//
//  Created by celion on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewWorkDetailBenefitCell.h"
#import "JGJCustomListView.h"

@interface JGJNewWorkDetailBenefitCell ()
@property (weak, nonatomic) IBOutlet UILabel *benefitTitle;
@property (weak, nonatomic) IBOutlet JGJCustomListView *customView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customViewHeight;

@end
@implementation JGJNewWorkDetailBenefitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.benefitTitle.font = [UIFont systemFontOfSize:AppFont30Size];
    self.benefitTitle.textColor = AppFont333333Color;
}

- (void)setJlgFindProjectModel:(JLGFindProjectModel *)jlgFindProjectModel {
    _jlgFindProjectModel = jlgFindProjectModel;
    self.customView.contentFontSize = AppFont24Size;
    [self.customView setLableLayerColor:AppFontd7252cColor width:0.5 textBackGroundColor:[UIColor whiteColor] textColor:AppFontd7252cColor];
    [self.customView setCustomListViewDataSource:jlgFindProjectModel.welfare lineMaxWidth:TYGetUIScreenWidth - 85];
    self.customViewHeight.constant= self.customView. totalHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
