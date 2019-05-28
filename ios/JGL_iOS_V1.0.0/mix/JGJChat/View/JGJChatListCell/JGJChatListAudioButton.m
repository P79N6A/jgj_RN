//
//  JGJChatListAudioButton.m
//  mix
//
//  Created by Tony on 2016/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//


#import "JGJChatListAudioButton.h"
#import "NSString+Extend.h"
#import "NSString+File.h"
#import "JGJChatMsgListModel.h"

#define kJGChatlistAudioMineImgsArr @[@"Chat_listAudio_Mine1",@"Chat_listAudio_Mine2",@"Chat_listAudio_Mine3"]

#define kJGChatlistAudioOtherImgsArr @[@"Chat_listAudio_Other1",@"Chat_listAudio_Other2",@"Chat_listAudio_Other3"]

@interface JGJChatListAudioButton ()
{
    //语音
//    NSTimer *_timer;//定时器定时修改音量的值
    NSInteger _timerTime;//定时器的时长
    CGPoint _tempPoint;//用于判断是否上划
    NSInteger _endState;//结束时候的状态，是否需要发送
    
    AudioRecordingServices *_audioRecordingServices;
}
@property (strong, nonatomic) NSMutableArray *audioImgsArr;

@property (strong, nonatomic) NSMutableDictionary *audioInfo;

@property (nonatomic,strong) JGJChatMsgListModel *jgjChatListModel;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation JGJChatListAudioButton

- (void)setAudioType:(ChatListAudioType )audioType audioInfo:(NSDictionary *)audioInfo chatListModel:(JGJChatMsgListModel *)chatListModel{
    
    if (!_audioRecordingServices) {
        _audioRecordingServices = [[AudioRecordingServices alloc] init];
        _audioRecordingServices.delegate = self;
    }

    self.audioImgsArr = (audioType == ChatListAudioMine?kJGChatlistAudioMineImgsArr:kJGChatlistAudioOtherImgsArr).mutableCopy;
    self.audioInfo = audioInfo.mutableCopy;
    
    audioType == ChatListAudioMine?[self setStatus:TYAlignmentStatusRight]:[self setStatus:TYAlignmentStatusLeft];
    UIColor *buttonColor = audioType == ChatListAudioMine?[UIColor whiteColor]:TYColorHex(0x999999);
    [self setTitleColor:buttonColor forState:UIControlStateNormal];
    
    NSString *titleStr = [NSString stringWithFormat:@"%@\"",audioInfo[@"fileTime"]];
    [self setTitle:titleStr forState:UIControlStateNormal];

    UIImage *buttonImage = [UIImage imageNamed:[self.audioImgsArr lastObject]];
    [self setImage:buttonImage forState:UIControlStateNormal];
    
    self.jgjChatListModel = chatListModel;
}

- (void)playAutioBtnClick:(id)sender {
    
    if (self.playBeginBlock) {
        
        self.playBeginBlock();
    }
    self.tag = 10;

}

- (void)palyAudio{
    
    //如果没有wav的文件才下载,下载万以后开始播放
    NSString *filePath = self.audioInfo[@"filePath"];
    if ([NSString isEmpty:filePath] || [filePath rangeOfString:@".wav"].location == NSNotFound) {
        [JLGHttpRequest_AFN downloadWithUrl:self.audioInfo[@"amrFilePath"] success:^(NSString *fileURL,NSString *fileName) {
            NSDictionary *dic = [_audioRecordingServices decompressionAudioFileWith:fileURL fileName:fileName];
            [NSString removeFileByPath:fileURL];
            
            self.audioInfo[@"filePath"] = dic[@"filePath"];
            self.jgjChatListModel.voice_filePath = self.audioInfo[@"filePath"];
            
            //更新本地缓存
            [TYNotificationCenter postNotificationName:JGJChatListDownVoiceSuccess object:self.jgjChatListModel];
            
            [self startPlay];
        } fail:^{
            TYLog(@"下载失败");
        }];
    }else{//有就直接播放
        [self startPlay];
    }
}

- (void)startPlay{

    
    self.tag = 10;
    [self.timer setFireDate:[NSDate date]];
    
}

- (void)stopPlay{
    
    [self.timer invalidate];
    _timer = nil;
    UIImage *buttonImage = [UIImage imageNamed:[self.audioImgsArr lastObject]];
    [self setImage:buttonImage forState:UIControlStateNormal];
    
}

#pragma mark - 修改显示的图片
- (void)changePlayImage {
    
    NSInteger tag;
    tag = self.tag/10;
    
    NSString *picString = self.audioImgsArr[tag - 1];
    [self setImage:[UIImage imageNamed:picString] forState:UIControlStateNormal];
    tag == 3?tag = 1:++tag;
    self.tag = tag*10;
}

#pragma mark - 播放完毕
- (void)isPlayEnd{
    if (self.playEndBlock) {
        self.playEndBlock();
    }
}

- (NSMutableArray *)audioImgsArr
{
    if (!_audioImgsArr) {
        _audioImgsArr = [[NSMutableArray alloc] init];
    }
    return _audioImgsArr;
}

- (NSTimer *)timer {
    
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(changePlayImage) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end
