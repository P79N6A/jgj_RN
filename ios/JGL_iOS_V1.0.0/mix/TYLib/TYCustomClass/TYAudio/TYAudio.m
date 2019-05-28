//
//  TYAudio.m
//  mix
//
//  Created by Tony on 2016/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYAudio.h"
#import "NSString+Extend.h"
#import "NSString+File.h"
#import "YZGAudioCallView.h"

static const CGFloat kTYAudioDifferenceValue = 50;//用于判断2个点之间的像素

@interface TYAudio ()
<
    YZGAudioCallViewDelegate,
    AudioRecordingServicesDelegate
>
{
    //语音
    NSTimer *_timer;//定时器定时修改音量的值
    NSInteger _timerTime;//定时器的时长
    CGPoint _tempPoint;//用于判断是否上划
    NSInteger _endState;//结束时候的状态，是否需要发送
    
    AudioRecordingServices *_audioRecordingServices;
}

@property (nonatomic,strong) YZGAudioCallView *callView;
@end

static TYAudio *_tyAudio;

@implementation TYAudio


+(instancetype)shareTYAudio{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _tyAudio = [[self alloc] init];
    });

    return _tyAudio;
}

- (id)init{
 
    self = [super init];
    if (self) {
        _audioRecordingServices = [[AudioRecordingServices alloc] initWithDelegate:self];
    }
    return self;
}

- (void)startAudioRecord{
    _endState = 1;
    
    [self.callView showAutioCallView];
    [_audioRecordingServices startAudioRecording];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
}

- (void)endAudioRecord{
    
    [_timer invalidate];
    _timer = nil;
    _timerTime = 0;
    
    //最后先结束录音，因为保存文件需要时间
    [_audioRecordingServices stopAudioRecording];
}

- (void)changeAudioRecord:(UILongPressGestureRecognizer *)press view:(UIView *)contentView{
    CGPoint point = [press locationInView:contentView];
    if (point.y < _tempPoint.y - kTYAudioDifferenceValue) {//上划
        _endState = 0;//修改状态
        
        if (!CGPointEqualToPoint(point, _tempPoint) && point.y < _tempPoint.y - 8) {//修改坐标
            _tempPoint = point;
        }
    } else if (point.y > _tempPoint.y + kTYAudioDifferenceValue) {//下划
        _endState = 1;//修改状态
        
        if (!CGPointEqualToPoint(point, _tempPoint) && point.y > _tempPoint.y + 8) {//修改坐标
            _tempPoint = point;
        }
    }
}

#pragma mark - 语音的代理回调方法
- (void)getRecordAudioInfoDic:(NSDictionary *)audioInfo{
    self.audioInfo = [audioInfo mutableCopy];
    
    [self endPress];
}

- (void)endPress {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isDelay = NO;//是否延迟消失
        NSInteger fileTime = [self.audioInfo[@"fileTime"] integerValue];
        if (_endState == 1) {
            if (fileTime > 59) {
                TYLog(@"不正常:时间太长");
                isDelay = YES;
                self.callView.yzgAudioCallRecondType = YZGAudioCallTypeTooLong;
                self.audioInfo[@"amrFilePath"] = [_audioRecordingServices compressionAudioFileWith:self.audioInfo[@"fileName"]][@"filePath"];
                
                //发送语音
                [self sendAudio];
            }else if(fileTime < 1){
                TYLog(@"不正常:时间太短");
                isDelay = YES;
                self.callView.yzgAudioCallRecondType = YZGAudioCallTypeTooShort;
            }else{
                TYLog(@"正常:发送出去");
                
                self.audioInfo[@"amrFilePath"] = [_audioRecordingServices compressionAudioFileWith:self.audioInfo[@"fileName"]][@"filePath"];
                
                //发送语音
                [self sendAudio];
            }
        }
        
        if (isDelay) {//如果时间不在范围内，则显示对应的状态
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hiddenCallView];
            });
        }else{
            [self hiddenCallView];
        }
    });
}

- (void)sendAudio{
    
    //设置语音的时间
    CGFloat fileTime = [self.audioInfo[@"fileTime"] floatValue];
    
    //time范围,20~60s
    CGFloat audioLayoutTime = MAX(20, fileTime);
    audioLayoutTime = MIN(60, audioLayoutTime);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendAudio:audioInfo:)]) {
        [self.delegate sendAudio:self audioInfo:self.audioInfo];
    }
}

- (void )downLoadVoice:(NSDictionary *)audio success:(TYAudioSuccess )success fail:(TYAudioFail )fail{
    //如果没有wav的文件才下载
    if ([NSString isEmpty:self.audioInfo[@"filePath"]]) {
        [JLGHttpRequest_AFN downloadWithUrl:self.audioInfo[@"amrFilePath"] success:^(NSString *fileURL,NSString *fileName) {
            NSDictionary *dic = [_audioRecordingServices decompressionAudioFileWith:fileURL fileName:fileName];
            [NSString removeFileByPath:fileURL];
            
            NSString *filePath = dic[@"filePath"];
            
            [TYNotificationCenter postNotificationName:JGJChatListDownVoiceSuccess object:self];
            if (success) {
                success(filePath);
            }
        } fail:^{
            TYLog(@"下载失败");
            if (fail) {
                fail();
            }
        }];
    }
}


- (void)hiddenCallView{
    if (self.callView) {
        [self.callView hiddenAutioCallView];
        self.callView = nil;
    }

}


#pragma mark - 修改显示的图片
- (void)changeImage {
    if (_timerTime >= 600) {
        _timerTime = 0;
        [_audioRecordingServices stopAudioRecording];
    }
    
    _timerTime++;
    self.callView.yzgAudioCallRecondType = _endState == 0?YZGAudioCallTypeStop:YZGAudioCallTypeReconding;
    
    if (_endState != 0) {
        [self.callView updateAudioLevel:[_audioRecordingServices updateMeters]];
    }
}

#pragma mark - 懒加载
- (YZGAudioCallView *)callView
{
    if (!_callView) {
        _callView = [[YZGAudioCallView alloc] init];
        _callView.delegate = self;
    }
    return _callView;
}

@end
