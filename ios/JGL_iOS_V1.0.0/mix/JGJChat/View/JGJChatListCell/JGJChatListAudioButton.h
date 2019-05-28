//
//  JGJChatListAudioButton.h
//  mix
//
//  Created by Tony on 2016/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYMoreButton.h"
#import "AudioRecordingServices.h"

typedef void(^PlayEndBlock)(void);
typedef void(^PlayBeginBlock)(void);

typedef enum : NSUInteger {
    ChatListAudioDefualt = 0,
    ChatListAudioMine,
    ChatListAudioOther
} ChatListAudioType;

@class JGJChatMsgListModel;
@interface JGJChatListAudioButton : TYMoreButton
<
    AudioRecordingServicesDelegate
>

@property (nonatomic,copy) PlayEndBlock playEndBlock;
@property (nonatomic,copy) PlayBeginBlock playBeginBlock;

- (void)setAudioType:(ChatListAudioType )audioType audioInfo:(NSDictionary *)audioInfo chatListModel:(JGJChatMsgListModel *)chatListMode;

- (void)playAutioBtnClick:(id)sender;

- (void)startPlay;
/*
 * 停止播放 //2.1.0-yj
 */
- (void)stopPlay;
@end
