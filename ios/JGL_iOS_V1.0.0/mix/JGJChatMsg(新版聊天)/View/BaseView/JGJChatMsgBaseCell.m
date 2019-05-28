//
//  JGJChatMsgBaseCell.m
//  mix
//
//  Created by yj on 2018/7/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgBaseCell.h"

#import "AFNetworkReachabilityManager.h"

@interface JGJChatMsgBaseCell()

@property (weak, nonatomic) IBOutlet JGJBaseOutMsgView *outMsgView;

@property (weak, nonatomic) IBOutlet JGJBaseMyMsgView *myMsgView;

@end

@implementation JGJChatMsgBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
}


- (void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel {

    _jgjChatListModel = jgjChatListModel;

    JGJChatListBelongType belongType = self.jgjChatListModel.belongType;

    [self subClassSetWithModel:jgjChatListModel];

    self.outMsgView.jgjChatListModel = jgjChatListModel;


    self.myMsgView.popImageView.userInteractionEnabled = YES;
    
    self.myMsgView.contentLabel.userInteractionEnabled = YES;
}

//#pragma mark - 子类使用
- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{

    
}




@end
