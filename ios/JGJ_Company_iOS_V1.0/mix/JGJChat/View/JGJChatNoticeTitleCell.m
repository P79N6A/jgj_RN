//
//  JGJChatNoticeTitleCell.m
//  mix
//
//  Created by Tony on 2016/11/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatNoticeTitleCell.h"

@interface JGJChatNoticeTitleCell  ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
@end

@implementation JGJChatNoticeTitleCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = TYColorHex(0xf1f1f1);
}

- (void)setChatListType:(JGJChatListType )chatListType proName:(NSString *)proNameStr{
    
    self.locationLabel.text = proNameStr;
    
    switch (chatListType) {
        case JGJChatListNotice:
        case JGJChatListLog:
            self.receiveLabel.text = @"本项目组所有成员";
            break;
        case JGJChatListSafe:
        case JGJChatListQuality:
            self.receiveLabel.text = [NSString stringWithFormat:@"%@相关的所有成员",proNameStr];
        default:
            break;
    }
}


- (void)setChatListType:(JGJChatListType )chatListType workProListModel:(JGJMyWorkCircleProListModel *)workProListModel{
    
    _workProListModel = workProListModel;
    
    self.locationLabel.text = _workProListModel.all_pro_name;
    
    BOOL isTeam = [_workProListModel.class_type isEqualToString:@"team"];
    
    self.locationTitleLabel.text = isTeam?@"当前项目:":@"当前班组:";
    
    switch (chatListType) {
        case JGJChatListNotice:
        case JGJChatListLog:
            self.receiveLabel.text = isTeam?@"本项目组所有成员":@"本班组所有成员";
            break;
        case JGJChatListSafe:
        case JGJChatListQuality:
            self.receiveLabel.text = [NSString stringWithFormat:@"%@相关的所有成员",self.locationLabel.text];
        default:
            break;
    }
}
@end
