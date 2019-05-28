//
//  YZGAudioCallView.m
//  mix
//
//  Created by Tony on 16/3/3.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGAudioCallView.h"

@interface YZGAudioCallView ()

@property (weak, nonatomic) IBOutlet UILabel *audioTipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *audioLevelImage;
@property (weak, nonatomic) IBOutlet UIImageView *audioShortImage;
@property (weak, nonatomic) IBOutlet UIImageView *audioCancelImage;
@property (weak, nonatomic) IBOutlet UIImageView *audioRecorderImage;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@end

@implementation YZGAudioCallView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.yzgAudioCallRecondType = YZGAudioCallTypeDefualt;
}


- (void)showAutioCallView{
    //设置frame
    CGFloat callViewWH = TYGetUIScreenWidth*0.4;//宽高
    CGFloat callViewX = (TYGetUIScreenWidth - callViewWH)/2;
    CGFloat callViewY = (TYGetUIScreenHeight - callViewWH)/2;
    CGRect callViewFrame = TYSetRect(callViewX, callViewY, callViewWH, callViewWH);
    [self showAutioCallViewWithFrame:callViewFrame];
}

- (void)showAutioCallViewWithFrame:(CGRect )frame{
    self.frame = frame;
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self layoutIfNeeded];//改了约束
        [self.layer setLayerCornerRadius:frame.size.width/15];
    }
    self.yzgAudioCallRecondType = YZGAudioCallTypeReconding;
}

- (void)hiddenAutioCallView{
    if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        TYLog(@"录音界面消失");
        self.hidden = YES;
        [self removeFromSuperview];
    }
}

- (void)setYzgAudioCallRecondType:(YZGAudioCallRecondType)yzgAudioCallRecondType{
    _yzgAudioCallRecondType = yzgAudioCallRecondType;
    
    [self showAudioType:yzgAudioCallRecondType];
    if (self.delegate && [self.delegate respondsToSelector:@selector(AudioCallViewChange:type:)]) {
        [self.delegate AudioCallViewChange:self type:yzgAudioCallRecondType];
    }
}

- (void)showAudioType:(YZGAudioCallRecondType )recondType{
    if (recondType == YZGAudioCallTypeReconding) {
        self.audioShortImage.hidden = YES;
        self.audioCancelImage.hidden = YES;
        
        self.audioLevelImage.hidden = NO;
        self.audioRecorderImage.hidden = NO;
        
        self.audioTipLabel.text = @"手指上划，取消发送";
    }else if(recondType == YZGAudioCallTypeStop){
        self.audioShortImage.hidden = YES;
        self.audioCancelImage.hidden = NO;
        
        self.audioLevelImage.hidden = YES;
        self.audioRecorderImage.hidden = YES;
        
        self.audioTipLabel.text = @"松开手指，取消发送";
    }else if(recondType == YZGAudioCallTypeTooLong || recondType == YZGAudioCallTypeTooShort){
        self.audioShortImage.hidden = NO;
        self.audioCancelImage.hidden = YES;
        
        self.audioLevelImage.hidden = YES;
        self.audioRecorderImage.hidden = YES;
        self.audioTipLabel.text = [NSString stringWithFormat:@"说话时间%@",recondType == YZGAudioCallTypeTooLong?@"太长":@"太短"];
    }else if(recondType == YZGAudioCallTypeDefualt){
        self.audioShortImage.hidden = YES;
        self.audioCancelImage.hidden = YES;
        
        self.audioLevelImage.hidden = YES;
        self.audioRecorderImage.hidden = YES;
        self.audioTipLabel.text = @"";
    }
}

#pragma mark - 停止录音
- (void)stopRecording{
    if (self.yzgAudioCallRecondType != YZGAudioCallTypeStop) {
        self.yzgAudioCallRecondType = YZGAudioCallTypeStop;
    }
}

#pragma mark - 录制太长
- (void)recordedTooLong{
    if (self.yzgAudioCallRecondType != YZGAudioCallTypeTooLong) {
        self.yzgAudioCallRecondType = YZGAudioCallTypeTooLong;
    }
}

#pragma mark - 录制太短
- (void)recordedTooShort{
    if (self.yzgAudioCallRecondType != YZGAudioCallTypeReconding) {
        self.yzgAudioCallRecondType = YZGAudioCallTypeReconding;
    }
}

#pragma mark - 更新显示的音量级别
- (void)updateAudioLevel:(NSInteger )audioLevel{
    if (self.yzgAudioCallRecondType != YZGAudioCallTypeReconding) {
        return;
    }
    
    self.audioLevelImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"audio_level%@",@(audioLevel)]];
}

@end
