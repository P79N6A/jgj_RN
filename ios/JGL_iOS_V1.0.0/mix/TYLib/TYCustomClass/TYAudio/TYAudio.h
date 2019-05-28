//
//  TYAudio.h
//  mix
//
//  Created by Tony on 2016/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioRecordingServices.h"


typedef void(^TYAudioSuccess)(NSString *filePath);
typedef void(^TYAudioFail)();

@class TYAudio;
@protocol TYAudioDelegate <NSObject>

/**
 *  amrFilePath:amr文件的url路径
 *  fileName:amr文件的路径
 *  filePath:wav文件的路径
 *  fileName:amr文件的路径
 *  fileSize:文件的大小
 *  fileTime:文件的时间
 */
- (void)sendAudio:(TYAudio *)audio audioInfo:(NSDictionary *)audioInfo;

@end

@interface TYAudio : NSObject

@property (nonatomic , weak) id<TYAudioDelegate> delegate;

@property (nonatomic,weak) UIViewController *superVc;

@property (nonatomic,strong) NSMutableDictionary *audioInfo;//保存语音的信息

+(instancetype)shareTYAudio;

/**
 *  开始录音
 */
- (void)startAudioRecord;

/**
 *  录音的时候滑动
 *
 *  @param press       手势
 *  @param contentView 显示的view
 */
- (void)changeAudioRecord:(UILongPressGestureRecognizer *)press view:(UIView *)contentView;

/**
 *  结束录音
 */
- (void)endAudioRecord;


/**
 *  如果存在会隐藏
 */
- (void)hiddenCallView;

/**
 *  下载语音文件
 *
 *  @param audio   
 *  amrFilePath:amr文件的url路径
 *  fileName:amr文件的名字
 *  filePath:wav文件的路径
 *  fileName:amr文件的路径
 *  fileSize:文件的大小
 *  fileTime:文件的时间
 *  @param success 成功回调
 *  @param fail    失败回调
 */
- (void )downLoadVoice:(NSDictionary *)audio success:(TYAudioSuccess )success fail:(TYAudioFail )fail;
@end
