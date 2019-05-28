//
//  JGJChatListBaseVc+VoiceAndPicService.m
//  mix
//
//  Created by Tony on 2018/9/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseVc+VoiceAndPicService.h"
#import "JGJChatMsgDBManger.h"
#import "JGJChatListOtherCell.h"
@implementation JGJChatListBaseVc (VoiceAndPicService)

#pragma mark - JGJChatMsgBaseCellDelegate
- (void)clickVoiceCellWithChatMsgModel:(JGJChatMsgListModel *)msgModel {
    
    NSLog(@"点击语音消息");
    __weak typeof(self) weakSelf = self;
    if (msgModel) {
        
        JGJChatListOtherCell *voiceCell = nil;
        for (UITableViewCell *cell in [self.tableView visibleCells]) {
            
            if ([cell isKindOfClass:[JGJChatListOtherCell class]]) {
                
                JGJChatListOtherCell *tempVoiceCell = (JGJChatListOtherCell *)cell;
                if (tempVoiceCell.jgjChatListModel.msg_id == msgModel.msg_id) {
                    
                    voiceCell = (JGJChatListOtherCell *)cell;
                    _currentVoiceCell = voiceCell;
                    break;
                }
            }
        }
        
        if (voiceCell) {
            
            //如果点击的cell的语音文件没有播放，则开始播放，同时开启语音播放动画。
            if (![self.audioRecordingServices isPlaying]) {
                
                _lastVoiceCell = voiceCell;
                [self palyAudioWithMsgModel:msgModel voiceCell:voiceCell];
                self.audioRecordingServices.finishPlaying = ^(BOOL isFinished) {
                    
                    [voiceCell.audioButton stopPlay];

                    if (isFinished) {
                        
                        [weakSelf playNextUnReadVoiceWithMessageEntity:msgModel];
                    }
                };
            }
            //如果正在播放，且与当前的文件名不同，停止播放当前的播放效果，播放另外一条
            else if ([self.audioRecordingServices isPlaying] && ![msgModel.voice_filePath isEqualToString:self.audioRecordingServices.currentPlayingPath]) {
                
                [_lastVoiceCell.audioButton stopPlay];
                _lastVoiceCell = voiceCell;
                [self.audioRecordingServices stopPlay];
                [self palyAudioWithMsgModel:msgModel voiceCell:voiceCell];
                
                self.audioRecordingServices.finishPlaying = ^(BOOL isFinished) {
                    
                    [voiceCell.audioButton stopPlay];

                };
            }
            // 处理当前正在播放语音，停止当前的语音播放
            else if ([self.audioRecordingServices isPlaying] && [msgModel.voice_filePath isEqualToString:self.audioRecordingServices.currentPlayingPath]) {
                
                [_lastVoiceCell.audioButton stopPlay];
                _lastVoiceCell = voiceCell;
                [self.audioRecordingServices stopPlay];
                [voiceCell.audioButton stopPlay];
            }
        }
    }
    
}


//递归查找下一条未读语音消息
- (void)playNextUnReadVoiceWithMessageEntity:(JGJChatMsgListModel *)msgModel {
    
    __weak typeof(self) weakSelf = self;
    if (msgModel) {
        
        //找到msgModel在数据源里面的位置
        NSIndexPath *index = [NSIndexPath indexPathForRow:[self.dataSourceArray indexOfObject:msgModel] inSection:0];
        if (index) {
            
            // 这里做个开关 只寻找当前位置之后的15条消息内的语音
            NSInteger maxIndex = (self.dataSourceArray.count - (index.row + 1)) > 14 ?  14 : self.dataSourceArray.count;
            for (NSInteger i = index.row + 1; i < maxIndex; i++) {
                
                // 取出下一条 消息
                JGJChatMsgListModel *nextMsgModel = self.dataSourceArray[i];
                // 判断是语音消息
                if (nextMsgModel.chatListType == JGJChatListAudio && nextMsgModel.belongType == JGJChatListBelongOther) {
                    
                    if (nextMsgModel.isplayed) {// 下一条已经播放过，则停止递归
                        
                        return;
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        //取到下一条的cell
                        JGJChatListOtherCell *voiceBaseCell = nil;
                        for (UITableView *cell in [self.tableView visibleCells]) {
                            if ([cell isKindOfClass:[JGJChatListOtherCell class]]) {
                                
                                JGJChatListOtherCell *tempBaseCell  = (JGJChatListOtherCell *)cell;
                                //找到对应的cell
                                if (tempBaseCell.jgjChatListModel.msg_id == nextMsgModel.msg_id) {
                                    voiceBaseCell = (JGJChatListOtherCell *)cell;
                                    _currentVoiceCell = voiceBaseCell;
                                }
                            }
                        }
                        [voiceBaseCell.audioButton startPlay];
                        _lastVoiceCell = voiceBaseCell;
                        
                        if (![weakSelf.audioRecordingServices isPlaying]) {
                            
                            [self palyAudioWithMsgModel:nextMsgModel voiceCell:voiceBaseCell];
                        }
                        
                        self.audioRecordingServices.finishPlaying = ^(BOOL isFinished) {
                            
                            [voiceBaseCell.audioButton stopPlay];
                            if (isFinished) {
                                
                                [weakSelf playNextUnReadVoiceWithMessageEntity:nextMsgModel];
                                
                            }
                        };
                        
                    });
                    
                    break;
                }
            }
        }else {
            
            TYLog(@"没有可播放的语音");
        }
    }
}

- (void)palyAudioWithMsgModel:(JGJChatMsgListModel *)jgjChatListModel voiceCell:(JGJChatListOtherCell *)voiceCell{
    
    if (jgjChatListModel.msg_src.count == 0) {
        
        return;
    }

    //如果没有wav的文件才下载,下载万以后开始播放
    NSString *filePath = jgjChatListModel.voice_filePath;
    if ([NSString isEmpty:filePath] || [filePath rangeOfString:@".wav"].location == NSNotFound) {
        
        [JLGHttpRequest_AFN downloadWithUrl:jgjChatListModel.msg_src[0] success:^(NSString *fileURL,NSString *fileName) {
            
            NSDictionary *dic = [self.audioRecordingServices decompressionAudioFileWith:fileURL fileName:fileName];
            [NSString removeFileByPath:fileURL];
            
            jgjChatListModel.voice_filePath = dic[@"filePath"];
            
            //更新本地缓存
            [self.audioRecordingServices setPlayAudioWithFilePath:jgjChatListModel.voice_filePath];
            
            jgjChatListModel.isplayed = YES;
            _currentVoiceCell.jgjChatListModel = jgjChatListModel;
            [JGJChatMsgDBManger updateMsgRowPropertyWithJGJChatMsgListModel:jgjChatListModel propertyListType:JGJChatMsgDBUpdateIsPlayVoicePropertyType];
            [voiceCell.audioButton startPlay];
            
        } fail:^{
            
            TYLog(@"下载失败");
        }];
        
    }else{
        
        //有就直接播放
        [self.audioRecordingServices setPlayAudioWithFilePath:jgjChatListModel.voice_filePath];
        jgjChatListModel.isplayed = YES;
        _currentVoiceCell.jgjChatListModel = jgjChatListModel;
        [JGJChatMsgDBManger updateMsgRowPropertyWithJGJChatMsgListModel:jgjChatListModel propertyListType:JGJChatMsgDBUpdateIsPlayVoicePropertyType];
        [voiceCell.audioButton startPlay];
    }
}
@end
