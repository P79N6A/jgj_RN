//
//  JGJChatOutVoiceCell.m
//  mix
//
//  Created by Tony on 2018/7/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatOutVoiceCell.h"
#import "AudioRecordingServices.h"
#import "NSString+File.h"
#import "NSString+Extend.h"
@interface JGJChatOutVoiceCell ()<AudioRecordingServicesDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *voiceImages;
@property (weak, nonatomic) IBOutlet UILabel *voiceTimes;
@property (weak, nonatomic) IBOutlet UILabel *voiceRed;// 消息红点

@property (weak, nonatomic) IBOutlet UIView *tapToPlayVoice;


@end
@implementation JGJChatOutVoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _voiceRed.clipsToBounds = YES;
    _voiceRed.layer.cornerRadius = 4;
    
    UITapGestureRecognizer *mytap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    mytap.delegate = self;
    mytap.numberOfTapsRequired = 1;
    mytap.numberOfTouchesRequired = 1;
    [self.tapToPlayVoice addGestureRecognizer:mytap];
}


- (void)tapView:(UITapGestureRecognizer *)tap {

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickVoiceCellWithChatMsgModel:)]) {

        [self.delegate clickVoiceCellWithChatMsgModel:self.jgjChatListModel];
    }
    
}


- (void)startVoiceAnimation {
    
    [_voiceImages startAnimating];
}

- (void)stopVoiceAnimation {
    
    [_voiceImages stopAnimating];
}

#pragma mark - 子类使用
- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
        
    if (jgjChatListModel.belongType == JGJChatListBelongMine) {
        
        _voiceImages.image = IMAGE(@"Chat_listAudio_Mine3");
        _voiceImages.animationImages = @[[UIImage imageNamed:@"Chat_listAudio_Mine1"],[UIImage imageNamed:@"Chat_listAudio_Mine2"],[UIImage imageNamed:@"Chat_listAudio_Mine3"]];
        
        _voiceTimes.textColor = [UIColor whiteColor];
        
    }else {
        
        _voiceImages.image = IMAGE(@"Chat_listAudio_Other3");
        _voiceImages.animationImages = @[[UIImage imageNamed:@"Chat_listAudio_Other1"],[UIImage imageNamed:@"Chat_listAudio_Other2"],[UIImage imageNamed:@"Chat_listAudio_Other3"]];
        _voiceTimes.textColor = AppFont999999Color;
        _voiceRed.hidden = jgjChatListModel.isplayed;
    }
    _voiceImages.animationDuration = 2;
    
    _voiceTimes.text = [NSString stringWithFormat:@"%@\"", jgjChatListModel.voice_long?:@""];
    
    
}
@end
