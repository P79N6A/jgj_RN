//
//  JGJChatMsgBaseCell.m
//  mix
//
//  Created by yj on 2018/7/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgBaseCell.h"

#import "AFNetworkReachabilityManager.h"

@interface JGJChatMsgBaseCell()

@property (weak, nonatomic) IBOutlet JGJBaseOutMsgView *outMsgView;

@property (weak, nonatomic) IBOutlet JGJBaseMyMsgView *myMsgView;

@end

@implementation JGJChatMsgBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    [self subClassInit];
}


- (void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel {

    _jgjChatListModel = jgjChatListModel;

    JGJChatListBelongType belongType = self.jgjChatListModel.belongType;

    [self subClassSetWithModel:jgjChatListModel];

    self.outMsgView.jgjChatListModel = jgjChatListModel;
//    if (belongType == JGJChatListBelongMine) {
//
//        self.myMsgView.jgjChatListModel = jgjChatListModel;
//
//    }else {
//
//        self.outMsgView.jgjChatListModel = jgjChatListModel;
//    }

    self.myMsgView.popImageView.userInteractionEnabled = YES;
    
    self.myMsgView.contentLabel.userInteractionEnabled = YES;
}


#pragma mark - 子类用的
- (void)subClassInit{
    //添加长按手势
    [self addLongTapHandler];
}

-(void)addLongTapHandler {
    
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longHandleTap:)];
    
    [self.myMsgView.containView addGestureRecognizer:touch];

}

-(void)longHandleTap:(UIGestureRecognizer*) recognizer {
    
    if (recognizer.state==UIGestureRecognizerStateBegan&&![recognizer.view isKindOfClass:[UITextView class]]) {
        
        // 菜单已经打开不需重复操作
        UIMenuController *shareMenu = [UIMenuController sharedMenuController];
        if (shareMenu.isMenuVisible)return;
        
        if ([self.super_textView isFirstResponder]) {
            
            self.super_textView.inputNextResponder = self;//关键代码
            
        }else{
            
            [self becomeFirstResponder];
            
        }

        NSMutableArray *menuControlArr = [NSMutableArray array];
        //如果是文本就添加复制
        if (self.jgjChatListModel.chatListType == JGJChatListText&&![recognizer.view isKindOfClass:[UITextView class]] && self.jgjChatListModel.sendType != JGJChatListSendFail) {
            
            UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyClick:)];
            
            [menuControlArr addObject:copyItem];
            
        }
        
        //如果是失败了才重发和删除
        if (self.jgjChatListModel.sendType == JGJChatListSendFail) {
            
            UIMenuItem *resendItem = [[UIMenuItem alloc] initWithTitle:@"重新发送" action:@selector(resendClick:)];
            [menuControlArr addObject:resendItem];
            
            UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteClicked:)];
            [menuControlArr addObject:deleteItem];
            
        }
        
        
        //如果自己的消息并且没有超过2分钟
        NSInteger cell_local_id_int = [self.jgjChatListModel.local_id integerValue];
        NSInteger now_locl_id_int   = [[self localID] integerValue];
        
        BOOL moreThan2Min = (now_locl_id_int - cell_local_id_int) < 120*1000;
        BOOL isMine = self.jgjChatListModel.belongType == JGJChatListBelongMine;
        
        BOOL isCanRevo = [self.jgjChatListModel.msg_type isEqualToString:@"text"] || [self.jgjChatListModel.msg_type isEqualToString:@"voice"] || [self.jgjChatListModel.msg_type isEqualToString:@"pic"];
        
        //![NSString isEmpty:self.jgjChatListModel.msg_id] 历史数据或者已成功发送的数据
        if (isMine && moreThan2Min&&![NSString isEmpty:self.jgjChatListModel.msg_id]&&![recognizer.view isKindOfClass:[UITextView class]] && isCanRevo) {
            UIMenuItem *revocationItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revocationClicked:)];
            [menuControlArr addObject:revocationItem];
        }
        
        //设置当前Cell为FirstResponder
        if (!self.super_textView) {
            
            [self becomeFirstResponder];
            
            //保留TextView为FirstResponder，同时其负责Menu显示
        }else {
            
            self.super_textView.targetCell = self;
        }
        
        [shareMenu setMenuItems:menuControlArr];
        
        [shareMenu setTargetRect:self.myMsgView.containView.frame inView:self.myMsgView.containView.superview];
        
        [shareMenu setMenuVisible:YES animated: YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHideCallback:) name:UIMenuControllerDidHideMenuNotification object:shareMenu];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidShowCallback:) name:UIMenuControllerDidShowMenuNotification object:shareMenu];
        
    }
}

- (void)menuDidHideCallback:(NSNotification *)notify {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
    
    ((UIMenuController *)notify.object).menuItems = nil;
    
    self.super_textView.targetCell = nil;
    
    if ([self.delegate respondsToSelector:@selector(chatListBaseCell:showMenu:)]) {
        
        [self.delegate chatListBaseCell:self showMenu:NO];
    }
    
}

- (void)menuDidShowCallback:(NSNotification *)notify {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidShowMenuNotification object:nil];
    
    if ([self.delegate respondsToSelector:@selector(chatListBaseCell:showMenu:)]) {
        
        [self.delegate chatListBaseCell:self showMenu:YES];
    }
    
}

#pragma mark - 长按手势
-(BOOL)canBecomeFirstResponder {
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(action ==@selector(copyClick:)){
        
        return YES;
        
    }else if (action==@selector(resendClick:)){
        
        return YES;
        
    }else if (action==@selector(deleteClicked:)){
        
        return YES;
    }else if (action==@selector(revocationClicked:)){
        
        return YES;
        
    }
    //    return NO;
    return [super canPerformAction:action withSender:sender];
}

//复制
-(void)copyClick:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.myMsgView.contentLabel.text;
}

//重发
- (void)resendAlertClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"重发该消息?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *resendAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self resendClick:nil];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:resendAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

-(void)resendClick:(id)sender {
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    BOOL isReachableStatus = status == AFNetworkReachabilityStatusNotReachable;
    
    if (isReachableStatus) {
        
        [TYShowMessage showPlaint:@"当前网络不可用"];
        
        return;
        
    }
    
    if ([self.delegate respondsToSelector:@selector(chatListBaseCell:showMenuType:)]) {
        
        [self.delegate chatListBaseCell:self showMenuType:JGJShowMenuResendType];
    }
    
    self.super_textView.inputNextResponder = nil;
}
//删除
-(void)deleteClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(chatListBaseCell:showMenuType:)]) {
        
        [self.delegate chatListBaseCell:self showMenuType:JGJShowMenuDelType];
    }
    
    self.super_textView.inputNextResponder = nil;
}


//撤回
-(void)revocationClicked:(id)sender {
    
    NSInteger cell_local_id_int = [self.jgjChatListModel.local_id integerValue];
    NSInteger now_locl_id_int = [[self localID] integerValue];
    
    BOOL moreThan2Min = (now_locl_id_int - cell_local_id_int) < 120*1000;
    BOOL isMine = self.jgjChatListModel.belongType == JGJChatListBelongMine;
    if (isMine && !moreThan2Min&&self.jgjChatListModel.sendType != JGJChatListSendFail) {
        [TYShowMessage showPlaint:@"不能撤回2分钟之前发送的消息"];
        return;
    }
    
    self.jgjChatListModel.msg_text = @"你撤回一条消息";
    
    self.jgjChatListModel.chatListType = JGJChatListRecall;
    
    self.jgjChatListModel.cellHeight = 0; //撤回后重新计算高度
    
    if ([self.delegate respondsToSelector:@selector(chatListBaseCell:showMenuType:)]) {
        
        [self.delegate chatListBaseCell:self showMenuType:JGJShowMenuReCallType];
        
    }
    
    NSString *parameters = @{@"ctrl":@"message",
                             @"action":@"recallMessage",
                             @"msg_id":self.jgjChatListModel.msg_id,
                             @"msg_type":self.jgjChatListModel.msg_type
                             }.copy;
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        
        
    } failure:nil];
    
    self.super_textView.inputNextResponder = nil;
}

//#pragma mark - 子类使用
- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{

    
}

- (NSString *)localID{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeID = [NSString stringWithFormat:@"%.lf", time];
    
    return timeID;
}


@end
