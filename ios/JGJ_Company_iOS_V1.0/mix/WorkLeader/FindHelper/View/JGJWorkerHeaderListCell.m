//
//  JGJWorkerHeaderListCell.m
//  mix
//
//  Created by celion on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkerHeaderListCell.h"
#import "JGJCustomListView.h"
#import "UIImageView+WebCache.h"
#import "UILabel+GNUtil.h"
@interface JGJWorkerHeaderListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *roleLable;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *hometown;
@property (weak, nonatomic) IBOutlet UILabel *workyear;
@property (weak, nonatomic) IBOutlet UILabel *scale;
@property (weak, nonatomic) IBOutlet JGJCustomListView *customListWorkTypeView;
@property (weak, nonatomic) IBOutlet UILabel *contactFriends;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customListViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifiedFlagImageViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactfriendsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewToCusListViewTopDistance;

@end

@implementation JGJWorkerHeaderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.hometown.preferredMaxLayoutWidth = 50;
    [self.headPicImageView.layer setLayerCornerRadius:TYGetViewW(self.headPicImageView)/2];
    self.name.font = [UIFont systemFontOfSize:AppFont34Size];
    self.name.textColor = AppFont333333Color;
    self.roleLable.font = [UIFont systemFontOfSize:AppFont24Size];
    self.roleLable.textColor = AppFontf3c120Color;
    [self.roleLable.layer setLayerBorderWithColor:AppFontf3c120Color width:1 radius:2.5];
    
    self.hometown.font = [UIFont systemFontOfSize:AppFont24Size];
    self.hometown.textColor = AppFont666666Color;
    self.workyear.font = [UIFont systemFontOfSize:AppFont24Size];
    self.workyear.textColor = AppFont666666Color;
    self.scale.font = [UIFont systemFontOfSize:AppFont24Size];
    self.scale.textColor = AppFont666666Color;
}

- (void)setJlgFHLeaderDetailModel:(JLGFHLeaderDetailModel *)jlgFHLeaderDetailModel {

    _jlgFHLeaderDetailModel = jlgFHLeaderDetailModel;
    if (!_jlgFHLeaderDetailModel) {
        return;
    }
//    身份是否已验证
    self.verifiedFlagImageView.hidden = (jlgFHLeaderDetailModel.verified != 2);
    if (jlgFHLeaderDetailModel.verified != 2) {
        self.nameTopHeight.constant = self.headPicImageView.center.y - 12;
    } else {
        self.nameTopHeight.constant = 12;
    }
    self.name.text = jlgFHLeaderDetailModel.real_name;
    NSString *headPic = [JLGHttpRequest_Public stringByAppendingString:jlgFHLeaderDetailModel.head_pic];
    [self.headPicImageView sd_setImageWithURL:[NSURL URLWithString:headPic] placeholderImage:[UIImage imageNamed:@"leader_Defulat_Headpic"]];
    self.hometown.text = [NSString stringWithFormat:@"家乡:  %@", jlgFHLeaderDetailModel.hometown];
    
    NSString *scale = [NSString stringWithFormat:@"%ld", (long)jlgFHLeaderDetailModel.scale];
    self.scale.text = [NSString stringWithFormat:@"工人规模:%@", scale];
    [self.scale markText:scale withColor:AppFontd7252cColor];
     self.workyear.text = [NSString stringWithFormat:@"工龄:  %@年", jlgFHLeaderDetailModel.work_year];
    [self.workyear markText:jlgFHLeaderDetailModel.work_year withColor:AppFontd7252cColor];
    self.roleLable.text = @"班组长";
    self.roleLable.hidden = ![jlgFHLeaderDetailModel.roleType isEqualToString:@"2"]; //工人隐藏
    self.scale.hidden = [jlgFHLeaderDetailModel.roleType isEqualToString:@"1"]; //工人隐藏工人规模
    if (jlgFHLeaderDetailModel.friendcount == 0) {
        self.contactFriends.hidden = YES;
        self.lineViewToCusListViewTopDistance.constant = 0;
    } else {
        self.contactFriends.hidden = NO;
        self.lineViewToCusListViewTopDistance.constant = 33;
        NSString *friendCount = [NSString stringWithFormat:@"%ld", (long)jlgFHLeaderDetailModel.friendcount];
        self.contactFriends.text = [NSString stringWithFormat:@"你有%@个朋友认识他",   friendCount];
        [self.contactFriends markText:friendCount withColor:AppFontd7252cColor];
    }
    [self.customListWorkTypeView setCustomListViewDataSource:jlgFHLeaderDetailModel.main_filed lineMaxWidth:jlgFHLeaderDetailModel.lineMaxWidth];
    self.customListViewHeight.constant = self.customListWorkTypeView.totalHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
