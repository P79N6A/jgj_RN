//
//  JGJCusSwitchMsgCell.m
//  mix
//
//  Created by yj on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCusSwitchMsgCell.h"

@interface JGJCusSwitchMsgCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UISwitch *msgSwitch;
@end
@implementation JGJCusSwitchMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLable.textColor = AppFont000000Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommonModel:(JGJChatDetailInfoCommonModel *)commonModel {
    _commonModel = commonModel;
    self.titleLable.text = _commonModel.title;
    self.msgSwitch.on = _commonModel.isOpen;
}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    _workProListModel = workProListModel;
    if (_workProListModel.isClosedTeamVc || _workProListModel.workCircleProType == WorkCircleExampleProType) {
        self.msgSwitch.on = NO;
        self.msgSwitch.enabled = NO;
    }
}

- (IBAction)handleMsgSwitchAction:(UISwitch *)sender {
    self.commonModel.isOpen = sender.on;
    if ([self.delegate respondsToSelector:@selector(cusSwitchMsgCell:switchType:)]) {
        [self.delegate cusSwitchMsgCell:self switchType:self.commonModel.switchMsgType];
    }
}

- (void)setIsAllScreenWShow:(BOOL)isAllScreenWShow {
    
    _isAllScreenWShow = isAllScreenWShow;
    
    self.trailing.constant = _isAllScreenWShow ? 0 : 12;
    
    self.leading.constant = _isAllScreenWShow ? 0 : 12;
}

@end
