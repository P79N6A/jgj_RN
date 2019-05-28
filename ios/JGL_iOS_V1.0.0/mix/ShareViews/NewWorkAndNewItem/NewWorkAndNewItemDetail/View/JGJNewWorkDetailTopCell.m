//
//  JGJNewWorkDetailTopCell.m
//  mix
//
//  Created by celion on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewWorkDetailTopCell.h"
#import "JGJLabel.h"

@interface JGJNewWorkDetailTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *proTitle;
@property (weak, nonatomic) IBOutlet UILabel *reviewCnt;
@property (weak, nonatomic) IBOutlet JGJLabel *jgjTextWorktype;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jgjTextWorkTypeHeight;
@end

@implementation JGJNewWorkDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.proTitle.font = [UIFont boldSystemFontOfSize:AppFont32Size];
    self.proTitle.textColor = AppFont333333Color;
    self.reviewCnt.font = [UIFont systemFontOfSize:AppFont24Size];
    self.reviewCnt.textColor = AppFont999999Color;
}

- (void)setJlgFindProjectModel:(JLGFindProjectModel *)jlgFindProjectModel {
    _jlgFindProjectModel = jlgFindProjectModel;
    if (!jlgFindProjectModel) return;
    self.proTitle.text = jlgFindProjectModel.protitle;
    self.reviewCnt.text = [NSString stringWithFormat:@"%@    浏览次数:%ld", jlgFindProjectModel.ctime_txt, (long)jlgFindProjectModel.review_cnt];
    self.jgjTextWorkTypeHeight.constant = jlgFindProjectModel.strViewH;
    self.jgjTextWorktype.attributedText = jlgFindProjectModel.attributedStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
