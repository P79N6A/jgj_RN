//
//  JGJFreshFriendListCell.m
//  mix
//
//  Created by yj on 17/2/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJFreshFriendListCell.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"

@interface JGJFreshFriendListCell ()
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *msgLable;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end

@implementation JGJFreshFriendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLable.textColor = AppFont333333Color;
    self.msgLable.textColor = AppFont999999Color;
    self.nameLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.msgLable.font = [UIFont systemFontOfSize:AppFont24Size];
    [self.addButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:JGJCornerRadius / 2.0];
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont36Size];
    
    self.addButton.userInteractionEnabled = NO;
}

- (void)setFriendListModel:(JGJFreshFriendListModel *)friendListModel {
    _friendListModel = friendListModel;
    UIColor *headColor = [UIColor whiteColor];
    if (![NSString isEmpty:_friendListModel.real_name]) {
        headColor = [NSString modelBackGroundColor:_friendListModel.real_name];
    }
    [self.headButton setMemberPicButtonWithHeadPicStr:_friendListModel.head_pic memberName:_friendListModel.real_name memberPicBackColor:headColor];
    self.nameLable.text = friendListModel.real_name;
    self.msgLable.text = friendListModel.msg_text;
    [self handleFriendListModel:friendListModel];
}

- (void)handleFriendListModel:(JGJFreshFriendListModel *)friendListModel {
    //    JGJFriendListUnAddMsgType, //1：未加入
    //    JGJFriendListAddedMsgType, //2:已加入
    //    JGJFriendListOverdueMsgType, //3：过期
    JGJFriendListMsgType listMsgType = friendListModel.status;
    UIColor *msglayerColor = AppFontd7252cColor;
    CGFloat layerWidth = 0.5;
    NSString *buttonTitle = @"查看";
    UIColor *buttonTitleColor = AppFontd7252cColor;
    switch (listMsgType) {
        case JGJFriendListUnAddMsgType: {
            msglayerColor = AppFontd7252cColor;
            layerWidth = 0.5;
            buttonTitle = @"查看";
            buttonTitleColor = AppFontd7252cColor;
            
        }
            break;
        case JGJFriendListAddedMsgType: {
            msglayerColor = [UIColor whiteColor];
            layerWidth = 0;
            buttonTitle = @"已添加";
            buttonTitleColor = AppFont999999Color;
        }
            
            break;
        case JGJFriendListOverdueMsgType: {
            msglayerColor = [UIColor whiteColor];
            layerWidth = 0;
            buttonTitle = @"已过期";
            buttonTitleColor = AppFont999999Color;
        }
            break;
        default:
            break;
    }
    [self.addButton.layer setLayerBorderWithColor:msglayerColor width:layerWidth radius:JGJCornerRadius];
    [self.addButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.addButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    
    //    [self.addButton setEnlargeEdgeWithTop:10 right:0 bottom:10 left:20];
    
}


//- (IBAction)handleAddFriendButtonPressed:(UIButton *)sender {
//    BOOL isCanAdd = self.friendListModel.status == JGJFriendListUnAddMsgType;
//    if (!isCanAdd) {
//        return;
//    }
//    if ([self.friendListCellDelegate respondsToSelector:@selector(JGJFreshFriendListWithCell:didSelectedFriendListModel:)]) {
//        [self.friendListCellDelegate JGJFreshFriendListWithCell:self didSelectedFriendListModel:self.friendListModel];
//    }
//}


@end
