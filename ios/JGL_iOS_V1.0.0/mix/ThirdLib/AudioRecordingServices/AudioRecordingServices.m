//
//  AudioRecordingServices.h
//  Recording
//
//  Created by jieyuexi on 16-3-02.
//  Copyright (c) 2016年 tony All rights reserved.
//

#import "AudioRecordingServices.h"

#ifdef DEBUG
#define KAudioRecordLog(...) NSLog(@"\n\nTony调试\n函数:%s 行号:%d\n打印信息:%@\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define KAudioRecordLog(...) do { } while (0);
#endif

@implementation AudioRecordingServices
-(BOOL)isPlaying{
    return _audioPlayer.playing;
}

- (id)initWithDelegate:(id<AudioRecordingServicesDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        _isRecording = NO;
    }
    return self;
}


#pragma mark - 开始录音
- (void)startAudioRecording
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        KAudioRecordLog(@"开始时间 = %@", [AudioRecordingServices systemTime]);
        if (!_isRecording)
        {
            _isRecording = YES;
            
            _startTime = [NSMutableString stringWithString:[AudioRecordingServices systemTime]];
            //设置文件名和录音路径
            
            _fileName = [AudioRecordingServices systemTime];
            _filePath = [AudioRecordingServices getPathByFileName:_fileName ofType:@"wav"];
            
            //初始化录音
            NSURL * url = [[NSURL alloc] initFileURLWithPath:_filePath];
            _recorder = [[AVAudioRecorder alloc]initWithURL:url
                                                  settings:[AudioRecordingServices getAudioRecorderSettingDict]
                                                     error:nil];
            [_recorder setDelegate:self];
            [_recorder setMeteringEnabled:YES];
            [_recorder prepareToRecord];
            
            NSError *error ;
            //开始录音
            _audioSession = [AVAudioSession sharedInstance];
            [_audioSession setCategory: AVAudioSessionCategoryPlayAndRecord error:&error];
            
            [_audioSession setActive:YES error:nil];
            [_recorder record];
        }
   });
}

#pragma mark - 结束录音
- (void)stopAudioRecording
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _endTime = [NSMutableString stringWithString:[AudioRecordingServices systemTime]];
        KAudioRecordLog(@"结束时间 = %@", _endTime);
        _fileLength = [AudioRecordingServices returnUploadStartTime:_startTime endTime:_endTime];
        
        _isRecording = NO;
        
        [_recorder pause];
        [_audioSession setActive:NO error:nil];
        [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [_recorder stop];
        
        _fileSize  = [AudioRecordingServices getFileSize:_filePath] / 1000;
    });
}

#pragma mark - 更新测量值
- (NSInteger )updateMeters{
    [_recorder updateMeters];
    CGFloat avg = [_recorder averagePowerForChannel:0];
    CGFloat minValue = -60;
    CGFloat range = 60;
    CGFloat outRange = 100;
    if (avg < minValue) {
        avg = minValue;
    }
    NSInteger decibels = (avg + range) / range * outRange/10;

    decibels = MIN(7, decibels);
    decibels = MAX(decibels, 1);
    
    return decibels;
}

#pragma mark - 监听听筒or扬声器
- (void) handleNotification:(BOOL)state
{
    return;//不用监听，一直不黑屏
//    //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:state];
//    
//    if(state)//添加监听
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
//                                                   object:nil];
//    else//移除监听
//        [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                        name:@"UIDeviceProximityStateDidChangeNotification"
//                                                      object:nil];
}

#pragma mark - 处理监听触发事件 靠在耳朵旁边，就黑屏(可设置)
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES){
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                               error:nil];
    }
    else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                               error:nil];
    }

}

#pragma mark - 设置播放路径(如果开启自动播放,则不需调用play方法就可直接播放)
- (BOOL )setPlayAudioWithFilePath:(NSString *)audioFilePath
{
    if (_audioPlayer) {
        
        TYLog(@"存在播放器");
    }else{
    
        TYLog(@"不存在播放器");

    }
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:audioFilePath] error:nil];
    [_audioPlayer setDelegate:self];
    
    _currentPlayingPath = audioFilePath;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    BOOL bRet = [fileMgr fileExistsAtPath:audioFilePath];
    TYLog(@"文件路径:%@,是否存在:%d",audioFilePath,bRet);
    return [self play];
}

#pragma mark - 播放
- (BOOL )play
{

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:nil]; //设置输出方式
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //关闭红外
    [self handleNotification:YES];
    [_audioPlayer prepareToPlay];
    return [_audioPlayer play];
}


#pragma mark - 停止播放
- (void)stopPlay
{
    [_audioPlayer stop];
}

#pragma mark - 压缩文件(wav -> amr)
- (NSDictionary *)compressionAudioFileWith:(NSString *)audioFileName
{
    NSString * newName = [audioFileName stringByAppendingString:@"toAmr"];
    //转格式
    [VoiceConverter wavToAmr:[AudioRecordingServices getPathByFileName:audioFileName ofType:@"wav"] amrSavePath:[AudioRecordingServices getPathByFileName:newName ofType:@"amr"]];
    
    NSString * newFilePath = [AudioRecordingServices getPathByFileName:newName ofType:@"amr"];
    float      newFileSize = [AudioRecordingServices getFileSize:newFilePath] / 1000;
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [infoDic setObject:newName forKey:@"fileName"];
    [infoDic setObject:newFilePath forKey:@"filePath"];
    [infoDic setObject:[NSString stringWithFormat:@"%.0f", newFileSize] forKey:@"fileSize"];
    
    return infoDic;
}

#pragma mark - 解压文件(amr -> wav)
- (NSDictionary *)decompressionAudioFileWith:(NSString *)filePath fileName:(NSString *)fileName{
    //转格式
    [VoiceConverter amrToWav:filePath
                 wavSavePath:[AudioRecordingServices getPathByFileName:fileName
                                                                ofType:@"wav"]];
    
    NSString * newFilePath = [AudioRecordingServices getPathByFileName:fileName
                                                                 ofType:@"wav"];
    
    float      newFileSize = [AudioRecordingServices getFileSize:newFilePath] / 1000;
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [infoDic setObject:[fileName stringByAppendingPathExtension:@"wav"] forKey:@"fileName"];
    [infoDic setObject:newFilePath forKey:@"filePath"];
    [infoDic setObject:[NSString stringWithFormat:@"%.0f", newFileSize] forKey:@"fileSize"];
    
    return infoDic;
}

#pragma mark - 获取录音设置
+ (NSDictionary*)getAudioRecorderSettingDict
{
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithInt:-10],AVSampleRateConverterAlgorithmKey,
                                   [NSNumber numberWithFloat: 100.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    
    return recordSetting;
}



#pragma mark - 获取系统时间
+ (NSString *)systemTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddhhmmss"];

    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark - 获取时间差
+ (NSString *)returnUploadStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyyMMddhhmmss"];
    NSDate *d = [date dateFromString:startTime];
    
    NSTimeInterval late= [d timeIntervalSince1970]*1;
    
    NSDate* dat = [date dateFromString:endTime];

    NSTimeInterval now= [dat timeIntervalSince1970]*1;
    NSTimeInterval cha = now-late;
#if 0
    NSString * timeString;
    NSInteger ss = [[NSString stringWithFormat:@"%0.f", cha] integerValue];

    NSInteger hour = 0, minute = 0, second = 0;
    if (ss >= 3600)
    {
        hour = ss / 3600;
        minute = ss % 3600 / 60;
        second = ss % 3600 % 60;
    }else if (ss >= 60)
    {
        minute = ss / 60;
        second = ss % 60;

    }else if (ss < 60)
    {
        second = ss;
    }
    
    KAudioRecordLog(@"录音时长 %@:%@'%@\"", @(hour), @(minute), @(second));


    if (hour != 0)
        return timeString = [NSString stringWithFormat:@"%@:%@'%@\"", @(hour), @(minute), @(second)];
    else if (minute != 0)
        return timeString = [NSString stringWithFormat:@"%@'%@\"", @(minute), @(second)];
    else
        return timeString = [NSString stringWithFormat:@"%@\"", @(second)];
#else
    return [NSString stringWithFormat:@"%ld", (long)cha];
#endif
}

#pragma mark - 获取文件大小
+ (NSInteger)getFileSize:(NSString*)path
{
    NSFileManager * filemanager = [[NSFileManager alloc] init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else{
        return -1;
    }
}

#pragma mark - 通过名字及类型获得文件路径
/**
 *  通过名字及类型获得文件路径
 *
 *  @param fileName 文件名
 *  @param type     文件类型
 *
 *  @return 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)fileName ofType:(NSString *)type
{
    NSString* fileDirectory = [[[AudioRecordingServices getCacheDirectory]stringByAppendingPathComponent:fileName]stringByAppendingPathExtension:type];
    return fileDirectory;
}

#pragma mark - 获得缓存路径
+ (NSString*)getCacheDirectory
{
#if 0
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
#else
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Audio"];
    BOOL bRet = [fileMgr fileExistsAtPath:filePath];
    
    if (!bRet) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
#endif
}

#pragma mark - AVAudioPlayer Delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self handleNotification:NO];
    if (flag) [_audioPlayer prepareToPlay ];
    KAudioRecordLog(@"---------播放完毕");
    
    if (self.finishPlaying) {
        
        _finishPlaying(YES);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(isPlayEnd)]) {
        [self.delegate isPlayEnd];
    }
}

// 解码错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    KAudioRecordLog(@"---------解码错误！");
}

// 当音频播放过程中被中断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    KAudioRecordLog(@"-------中断,暂停播放");
    [_audioPlayer stop];
}

// 当中断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    KAudioRecordLog(@"--------中断结束，恢复播放");
    [_audioPlayer play];
}

#pragma mark - AVAudioRecorder Delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    KAudioRecordLog(@"audioRecorderDidFinishRecording ");
    if (self.delegate && [self.delegate respondsToSelector:@selector(getRecordAudioInfoDic:)])
    {
        NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [infoDic setObject:_fileName forKey:@"fileName"];
        [infoDic setObject:_filePath forKey:@"filePath"];
        [infoDic setObject:[NSString stringWithFormat:@"%@", _fileLength] forKey:@"fileTime"];
        [infoDic setObject:[NSString stringWithFormat:@"%.0f", _fileSize] forKey:@"fileSize"];
        
        [self.delegate getRecordAudioInfoDic:infoDic];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error //录制编码错误
{
    KAudioRecordLog(@"编码错误: %@", error);
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder; //录制开始中断
{
    KAudioRecordLog(@"录制发生中断");
    [self stopAudioRecording];
}
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags //录制已经中断
{
    KAudioRecordLog(@"录制已经中断: %ld", (unsigned long)flags );
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags
{
    KAudioRecordLog(@"录制结束中断: %ld", (unsigned long)flags);
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder
{
    KAudioRecordLog(@"录制结束中断");
}
@end
