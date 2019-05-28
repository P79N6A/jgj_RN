//
//  JGJChatListOtherCell.m
//  mix
//
//  Created by Tony on 2016/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListOtherCell.h"
#import "UIImage+Color.h"

#define kJGChatlistAudioMineImgsArr @[@"Chat_listAudio_Mine1",@"Chat_listAudio_Mine2",@"Chat_listAudio_Mine3"]

#define kJGChatlistAudioOtherImgsArr @[@"Chat_listAudio_Other1",@"Chat_listAudio_Other2",@"Chat_listAudio_Other3"]

@interface JGJChatListOtherCell ()

@property (weak, nonatomic) IBOutlet UIView *redPointView;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation JGJChatListOtherCell

- (void)subClassInit{
    
    //添加长按手势
    [self addLongTapHandler];
    
    [self.redPointView.layer setLayerCornerRadiusWithRatio:0.5];
    self.redPointView.backgroundColor = JGJMainColor;
    self.redPointView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    self.audioButton.playBeginBlock = ^(void){
        self.redPointView.hidden = YES;
        //代理方法
        if (weakSelf.otherCellDelegate && [weakSelf.otherCellDelegate respondsToSelector:@selector(playAudioBegin:chatListModel:)]) {
            [weakSelf.otherCellDelegate playAudioBegin:weakSelf.indexPath chatListModel:weakSelf.jgjChatListModel];
        }
    };
    
    self.bottomLineView.backgroundColor = AppFontf1f1f1Color;
}

- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    [super subClassSetWithModel:jgjChatListModel];
    
    if (jgjChatListModel.chatListType == JGJChatListAudio) {
        //如果是已读，就隐藏红点，如果未读，就判断是否播放过
        BOOL isRead = jgjChatListModel.isplayed ;
        self.redPointView.hidden = isRead?:jgjChatListModel.isplayed;
    }else{
        
        
        self.redPointView.hidden = YES;
    }
}
@end
