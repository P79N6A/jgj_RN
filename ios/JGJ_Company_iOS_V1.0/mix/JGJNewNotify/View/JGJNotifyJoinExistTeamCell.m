//
//  JGJNotifyJoinExistTeamCell.m
//  JGJCompany
//
//  Created by yj on 16/11/10.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNotifyJoinExistTeamCell.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
@interface JGJNotifyJoinExistTeamCell ()
@property (weak, nonatomic) IBOutlet UIButton *multiSelectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@end

@implementation JGJNotifyJoinExistTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.multiSelectedBtn.layer setLayerCornerRadius:TYGetViewW(self.multiSelectedBtn) / 2.0];
    self.teamName.textColor = AppFont999999Color;
    self.teamName.font = [UIFont boldSystemFontOfSize:AppFont32Size];
    [self.multiSelectedBtn setImage:PNGIMAGE(@"MultiSelected") forState:UIControlStateSelected];
    [self.multiSelectedBtn setImage:PNGIMAGE(@"EllipseIcon") forState:UIControlStateNormal];
    
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJNotifyJoinExistTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJNotifyJoinExistTeamCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setTeamInfoModel:(JGJExistTeamInfoModel *)teamInfoModel {
    _teamInfoModel = teamInfoModel;
    if (_teamInfoModel) {
        self.teamName.text = teamInfoModel.group_name;
        self.multiSelectedBtn.selected = teamInfoModel.isSelected;
//        [self.teamName markText:teamInfoModel.team_name withColor:AppFont333333Color];
    }
}

- (void)setProlistModel:(JGJSyncProlistModel *)prolistModel {
    _prolistModel = prolistModel;
    if (prolistModel) {
        self.teamName.text = prolistModel.pro_name;
        self.multiSelectedBtn.selected = prolistModel.isSelected;
         self.teamName.textColor = AppFont333333Color;
    }
}
@end
