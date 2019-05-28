//
//  JGJChatOutPicCell.m
//  mix
//
//  Created by yj on 2018/7/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatOutPicCell.h"

#import "JGJChatListPicView.h"

@interface JGJChatOutPicCell()

@property (weak, nonatomic) IBOutlet JGJChatListPicView *picView;

@end

@implementation JGJChatOutPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 子类使用
- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    
    self.picView.jgjChatListModel = jgjChatListModel;
        
    self.picView.backgroundColor = AppFontf1f1f1Color;
}


@end
