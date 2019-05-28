//
//  AudioRecordingServices.h
//  Recording
//
//  Created by jieyuexi on 16-3-02.
//  Copyright (c) 2016年 tony All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "VoiceConverter.h"

@protocol AudioRecordingServicesDelegate <NSObject>
@optional

/**
 *  代理回调方法
 *
 *  @param audioInfo 录音文件信息字典
 */
- (void)getRecordAudioInfoDic:(NSDictionary *)audioInfo;


/**
 *  播放完毕
 *
 */
- (void)isPlayEnd;
@end


typedef void(^FinishPlaying)(BOOL isFinished);

@interface AudioRecordingServices : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    AVAudioRecorder * _recorder;//录音
    AVAudioPlayer   * _audioPlayer;//播放
    AVAudioSession  * _audioSession;//音频会话,用于选择音频会话类别
    BOOL              _isRecording;
    
    NSString        * _fileName;
    NSString        * _filePath;
    NSString        * _fileLength;
    float             _fileSize;
    
    NSMutableString * _startTime;
    NSMutableString * _endTime;
}

@property (nonatomic, assign)id<AudioRecordingServicesDelegate> delegate;
@property (nonatomic, copy) FinishPlaying finishPlaying;
@property (nonatomic, copy) NSString *currentPlayingPath;
/**
 *  是否正在播放
 *
 *  @return YES:正在播放,NO:没有播放
 */
- (BOOL)isPlaying;

/**
 *  获取缓存路径
 *
 *  @return 缓存路径
 */
+ (NSString*)getCacheDirectory;

/**
 *  初始化方法
 *
 *  @param delegate 指定代理
 *
 *  @return 音频处理类对象
 */
- (id)initWithDelegate:(id<AudioRecordingServicesDelegate>)delegate;

/**
 *  开始录音
 */
- (void)startAudioRecording;

/**
 *  结束录音
 */
- (void)stopAudioRecording;

/**
 *  更新测量值(音量值)
 */
- (NSInteger )updateMeters;

/**
 *  播放录音
 *
 *  @param audioFilePath 文件路径名称
 *
 */
- (BOOL )setPlayAudioWithFilePath:(NSString *)audioFilePath;

/**
 *  播放停止
 */
- (void)stopPlay;

/**
 *  完成音频从WAV格式到AMR格式的转换(压缩)
 *
 *  @param audioFileName 待压缩WAV格式音频名称
 *
 *  @return 压缩后Amr音频信息字典
 */
- (NSDictionary *)compressionAudioFileWith:(NSString *)audioFileName;

/**
 *  完成音频从AMR格式到WAV格式的转换(解压)
 *  @param fileName 待解压AMR格式音频的路径
 *  @param fileName 待解压AMR格式音频名称
 *
 *  @return 解压后Wav音频信息字典
 */
- (NSDictionary *)decompressionAudioFileWith:(NSString *)filePath fileName:(NSString *)fileName;
@end
