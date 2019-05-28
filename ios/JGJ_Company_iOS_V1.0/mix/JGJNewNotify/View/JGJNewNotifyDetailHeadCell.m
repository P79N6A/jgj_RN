//
//  JGJNewNotifyDetailHeadCell.m
//  mix
//
//  Created by yj on 16/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewNotifyDetailHeadCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+GNUtil.h"
#import "TYPhone.h"
#import "UIButton+JGJUIButton.h"
@interface JGJNewNotifyDetailHeadCell ()
@property (weak, nonatomic) IBOutlet UILabel *headInfoLable;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *headNameButton;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLable;
@property (weak, nonatomic) IBOutlet UIButton *telephoneButton;

@end
@implementation JGJNewNotifyDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView.layer setLayerCornerRadius:JGJCornerRadius];
    self.headInfoLable.textColor = AppFont999999Color;
    self.headInfoLable.font = [UIFont systemFontOfSize:AppFont30Size];
    [self.telephoneButton setEnlargeEdgeWithTop:10.0 right:170.0 bottom:0.0 left:10.0];
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJNewNotifyDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJNewNotifyDetailHeadCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setNotifyModel:(JGJNewNotifyModel *)notifyModel {
    _notifyModel = notifyModel;
    self.headInfoLable.text = notifyModel.mergeStr;
    [self.headInfoLable markText:notifyModel.user_name withFont:[UIFont systemFontOfSize:AppFont30Size] color:AppFont333333Color];
    [self.headNameButton setTitle:notifyModel.user_name forState:UIControlStateNormal];
    self.telephoneLable.text = notifyModel.telphone;
    NSString *headImageUrlString = nil;
    if (notifyModel.members_head_pic.count > 0) {
        headImageUrlString = notifyModel.members_head_pic[0];
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[JLGHttpRequest_Public stringByAppendingString:headImageUrlString]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"] options:SDWebImageRefreshCached];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleCallButtonPressed:(UIButton *)sender {
    [TYPhone callPhoneByNum:self.notifyModel.telphone view:self];
}
@end
