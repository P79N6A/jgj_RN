//
//  JGJChatNoticeCell.m
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatNoticeCell.h"
#import "JGJCustomAlertView.h"
#import "NSString+AttributedStr.h"

@interface JGJChatNoticeCell ()

@property (weak, nonatomic) IBOutlet UIButton *noticeButton;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *noticeTitleLabel;

@end

@implementation JGJChatNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonSetInputView];
    
    self.cellH = 106.5;
    
    self.noticeButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    self.lineView.backgroundColor = self.noticeButton.titleLabel.textColor;
    
//    self.noticeButton.hidden = NO;
//    self.lineView.hidden = self.noticeButton.hidden;
}

- (void)commonSetInputView{
    self.inputView.placeholderFontSize = 12.0;
    self.inputView.placeholderColor = TYColorHex(0xcccccc);
    self.inputView.maxNumberOfWords = 500;
    self.inputView.canScorll = YES;
    self.inputView.canReturn = YES;
    //    2017-5-7 测试都开始提需求了
//    self.inputView.returnKeyType =UIReturnKeySend;
    __weak typeof(self) weakSelf = self;
    self.inputView.ty_textChange = ^(TYInputView *textView,NSString *text,NSString *changeText){
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(textChange:text:)]) {
            [weakSelf.delegate textChange:weakSelf text:text];
        }
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(textChange:text:lastText:)]) {
            [weakSelf.delegate textChange:weakSelf text:text lastText:changeText];
        }
    };
    
    //发送消息
    self.inputView.ty_textReturn = ^(TYInputView *textView){
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(textReturn:text:)]) {
            [weakSelf.delegate textReturn:weakSelf text:textView.text];
        }
    };
}

- (void)setChatListType:(JGJChatListType)chatListType{
    _chatListType = chatListType;

//    self.noticeButton.hidden = NO;
    NSString *placeholder = @"";
    if (chatListType == JGJChatListNotice) {
        placeholder = @"输入通知内容";
    }else if(chatListType == JGJChatListSafe){
        placeholder = @"描述安全隐患";
    }else if(chatListType == JGJChatListQuality){
        placeholder = @"描述质量";
    }else if(chatListType == JGJChatListLog){
        placeholder = @"输入日志内容";
//        self.noticeButton.hidden = YES;
    }
    
//    self.lineView.hidden = self.noticeButton.hidden;
    self.inputView.placeholder = [NSString stringWithFormat:@"请在此处%@",placeholder];
    self.inputView.placeholderFontSize = AppFont30Size;
    self.noticeTitleLabel.text = [NSString stringWithFormat:@"%@内容",placeholder];
}

- (IBAction)noticeBtnClick:(id)sender {
    
    NSString *titleStr = @"谁会收到?";
    NSString *messageStr = @"";
    
    if (self.chatListType == JGJChatListNotice) {
        messageStr = @"仅有项目组内成员会收到此通知";
    }else{
        messageStr = @"项目组内的成员和其他与项目有关的人都会收到此报告";
    }
    
    JGJCustomAlertView *customAlertView = [JGJCustomAlertView customAlertViewShowWithTitle:titleStr message:messageStr titleColor:TYColorHex(0x666666) messageColor:TYColorHex(0x999999) titleFontSize:17.0 messageFontSize:13.0 iknowFontSize:15.0];
    customAlertView.onClickedBlock = nil;
}
@end
