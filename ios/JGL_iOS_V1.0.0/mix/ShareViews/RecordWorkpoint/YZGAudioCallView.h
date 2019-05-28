//
//  YZGAudioCallView.h
//  mix
//
//  Created by Tony on 16/3/3.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YZGAudioCallRecondType) {
    YZGAudioCallTypeDefualt = 0,
    YZGAudioCallTypeReconding,//正在录音1
    YZGAudioCallTypeStop,//取消2
    YZGAudioCallTypeTooShort,//太短3
    YZGAudioCallTypeTooLong//太长4
};

@class YZGAudioCallView;
@protocol YZGAudioCallViewDelegate <NSObject>
@optional
- (void)AudioCallViewChange:(YZGAudioCallView *)callView type:(YZGAudioCallRecondType )type;
@end
@interface YZGAudioCallView : UIView

@property (nonatomic , weak) id<YZGAudioCallViewDelegate> delegate;
@property (nonatomic,assign) YZGAudioCallRecondType yzgAudioCallRecondType;

/**
 *  显示出callView,使用默认的frame
 */
- (void)showAutioCallView;

/**
 *  显示出callView,需要传入frame
 */
- (void)showAutioCallViewWithFrame:(CGRect )frame;

/**
 *  隐藏callView
 */
- (void)hiddenAutioCallView;

/**
 *  停止录音
 */
- (void)stopRecording;

/**
 *  录制太长
 */
- (void)recordedTooLong;

/**
 *  录制太短
 */
- (void)recordedTooShort;

/**
 *  更新显示的音量级别
 *
 *  @param audioLevel 传入的音量级别
 */
- (void)updateAudioLevel:(NSInteger )audioLevel;
@end
