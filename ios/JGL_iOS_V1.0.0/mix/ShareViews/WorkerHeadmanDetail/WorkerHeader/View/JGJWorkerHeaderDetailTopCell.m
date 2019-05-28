//
//  JGJWorkerHeaderDetailTopCell.m
//  mix
//
//  Created by celion on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#define Padding 10
#import "JGJWorkerHeaderDetailTopCell.h"
#import "UIImageView+WebCache.h"
#import "JGJCustomListView.h"
#import "UILabel+GNUtil.h"
@interface JGJWorkerHeaderDetailTopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *identificationImageView;
@property (weak, nonatomic) IBOutlet UILabel *workAge; //工龄
@property (weak, nonatomic) IBOutlet UILabel *workerScale; //工人规模
@property (weak, nonatomic) IBOutlet UILabel *location;//所在地
@property (weak, nonatomic) IBOutlet UILabel *hometown;//家乡
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workClassViewH;

@property (weak, nonatomic) IBOutlet JGJCustomListView *customListView;
@end

@implementation JGJWorkerHeaderDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headerImageView.layer setLayerCornerRadius:TYGetViewW(self.headerImageView)/2];
    self.location.font = [UIFont systemFontOfSize:AppFont24Size];
    self.hometown.font = [UIFont systemFontOfSize:AppFont24Size];
    self.workAge.font = [UIFont systemFontOfSize:AppFont28Size];
    self.workerScale.font = [UIFont systemFontOfSize:AppFont28Size];
    self.name.font = [UIFont systemFontOfSize:AppFont34Size];
    self.name.textColor = AppFont333333Color;
    self.location.textColor = AppFont999999Color;
    self.hometown.textColor = AppFont999999Color;
    self.workAge.textColor = AppFont666666Color;
    self.workerScale.textColor = AppFont666666Color;
}

- (void)setJlgFHLeaderDetailModel:(JLGFHLeaderDetailModel *)jlgFHLeaderDetailModel {
    _jlgFHLeaderDetailModel = jlgFHLeaderDetailModel;
    if (jlgFHLeaderDetailModel == nil) {
        return;
    }
    NSString *headPic = [JLGHttpRequest_Public stringByAppendingFormat:@"%@", jlgFHLeaderDetailModel.head_pic];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headPic] placeholderImage:[UIImage imageNamed:@"leader_Defulat_Headpic"]];
    self.name.text = jlgFHLeaderDetailModel.real_name;
    self.identificationImageView.hidden = (jlgFHLeaderDetailModel.verified != 2);
      NSString *scale = [NSString stringWithFormat:@"%ld", jlgFHLeaderDetailModel.scale];
    self.workerScale.text = [NSString stringWithFormat:@"工人规模:%@", scale];
    self.workerScale.hidden = [jlgFHLeaderDetailModel.roleType isEqualToString:@"1"];//工人隐藏规模
    [self.workerScale markText:scale withColor:[UIColor redColor]];

    self.workAge.text = [NSString stringWithFormat:@"工  龄:%@年", jlgFHLeaderDetailModel.work_year?:@"0"];
    [self.workAge markText:jlgFHLeaderDetailModel.work_year?:@"0" withColor:[UIColor redColor]];
    
    self.hometown.text = [NSString stringWithFormat:@"家乡:%@", jlgFHLeaderDetailModel.hometown?:@""];
    self.location.text = [NSString stringWithFormat:@"所在地:%@", jlgFHLeaderDetailModel.current_addr?:@""];
    [self.location markText:@"所在地:" withColor:AppFont666666Color];
     [self.hometown markText:@"家乡:" withColor:AppFont666666Color];
    [self.customListView setCustomListViewDataSource:jlgFHLeaderDetailModel.main_filed lineMaxWidth:jlgFHLeaderDetailModel.lineMaxWidth];
    self.workClassViewH.constant = self.customListView.totalHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
