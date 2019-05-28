//
//  JGJMyChatGroupsBottomView.m
//  mix
//
//  Created by yj on 2019/3/6.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMyChatGroupsBottomView.h"

#import "JGJCommonButton.h"

#import "JSBadgeView.h"

@interface JGJMyChatGroupsBottomView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *chatMsg;

@property (weak, nonatomic) IBOutlet UILabel *workReplyMsg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatMsgW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatMsgH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workReplyW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workReplyH;


@property (weak, nonatomic) IBOutlet JGJCommonButton *chatBtn;

@property (weak, nonatomic) IBOutlet JGJCommonButton *workReplyBtn;

@end

@implementation JGJMyChatGroupsBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupView];
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        
        [self setupView];
        
    }
    
    return self;
}

-(void)setupView {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    [self.chatMsg.layer setLayerCornerRadius:self.chatMsgH.constant / 2.0];
    
    [self.workReplyMsg.layer setLayerCornerRadius:self.workReplyH.constant / 2.0];
    
    self.contentView.backgroundColor = AppFontfafafaColor;
    
    self.chatBtn.backgroundColor = AppFontfafafaColor;
    
    self.workReplyBtn.backgroundColor = AppFontfafafaColor;
    
    self.chatMsg.backgroundColor = AppFontEF272FColor;
    
    self.workReplyMsg.backgroundColor = AppFontEF272FColor;
    
    self.chatMsg.hidden = YES;
    
    self.workReplyMsg.hidden = YES;
    
    [self.chatBtn setTitleColor:AppFont000000Color forState:UIControlStateNormal];
    
    [self.workReplyBtn setTitleColor:AppFont000000Color forState:UIControlStateNormal];
    
}

- (IBAction)chatMsgBtnPressed:(UIButton *)sender {
    
    if (self.chatActionBlock) {
        
        self.chatActionBlock();
    }
    
}

- (IBAction)workReplyBtnPressed:(UIButton *)sender {
    
    if (self.workReplyActionBlock) {
        
        self.workReplyActionBlock();
    }
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
        
    NSInteger unread_msg_count = [proListModel.chat_unread_msg_count integerValue];
    
    NSString *unread_msg_countStr = proListModel.chat_unread_msg_count;
    
    if (unread_msg_count > 99) {
        
        unread_msg_countStr = @"99+";
    }
    
    self.chatMsg.text = unread_msg_countStr?:@"0";

    self.chatMsg.hidden = [NSString isEmpty:unread_msg_countStr] || [unread_msg_countStr isEqualToString:@"0"];
    
    //设置未读数圆角大小
    [self setUpdateConstantW:self.chatMsgW constantH:self.chatMsgH unreadedMsg:self.chatMsg unread_msg_count:unread_msg_countStr];
    
    
    NSInteger work_message_num = [proListModel.work_message_num integerValue];
    
    NSString *workMessage = proListModel.work_message_num;
    
    if (work_message_num > 99) {
        
        workMessage = @"99+";
    }
    
    self.workReplyMsg.text = workMessage?:@"0";

    self.workReplyMsg.hidden = [NSString isEmpty:workMessage] || [workMessage isEqualToString:@"0"];
    
    //设置未读数圆角大小
    
    [self setUpdateConstantW:self.workReplyW constantH:self.workReplyH unreadedMsg:self.workReplyMsg unread_msg_count:workMessage];
    
}

- (void)setUpdateConstantW:(NSLayoutConstraint *)constantW constantH:(NSLayoutConstraint *)constantH unreadedMsg:(UILabel *)unreadedMsg unread_msg_count:(NSString *)unread_msg_count {
    
    CGFloat msgSmallWH = 18;
    
    CGFloat msgLargeWH = 28;
    
    if (![NSString isEmpty:unread_msg_count]) {
        
        if (unread_msg_count.length <= 1) {
            
            constantH.constant = msgSmallWH;
            
            constantW.constant = msgSmallWH;
            
            [unreadedMsg.layer setLayerCornerRadius:msgSmallWH / 2.0];
            
        }else {
            
            constantH.constant = msgSmallWH;
            
            constantW.constant = msgLargeWH;
            
            [unreadedMsg.layer setLayerCornerRadius:msgSmallWH / 2.0];
        }
        
    }
    
}

+(CGFloat)bottomViewHeight {
    
    return 60;
}

@end
