//
//  JGJChatInputView.m
//  mix
//
//  Created by Tony on 2016/8/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatInputView.h"
#import "TYTextView.h"
#import "TYInputView.h"
#import "TYPermission.h"
#import "TYAudio.h"

#import <AVFoundation/AVFoundation.h>

#import <AudioToolbox/AudioToolbox.h>

#import "JGJMangerTool.h"

#import "AFNetworkReachabilityManager.h"

#import "JGJCusAddMediaView.h"

typedef enum : NSUInteger {
    
    JGJKeyboardDefaultStatusType,
    
    JGJKeyboardFaceStatusType,
    
} JGJKeyboardStatusType;

@interface JGJChatInputView ()
<
    UITextViewDelegate,
    TYAudioDelegate
>
{
    NSInteger _endState;//结束时候的状态，是否需要发送
}

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, assign) CGFloat textFieldOldHeight;

@property (nonatomic,strong) TYAudio *tyAudio;

@property (nonatomic,strong) NSMutableDictionary *audioInfo;//保存语音的信息

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonConstraintW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonConstraintR;

//@property (nonatomic, assign) BOOL recordPermissionGranted;

@property (weak, nonatomic) IBOutlet UIButton *switchEmotionButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeStatusButtonW;

@property (weak, nonatomic) IBOutlet UIButton *changeStatusButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageButtonW;

@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

@property (assign, nonatomic) JGJKeyboardStatusType statusType;

//定时测试
@property (strong, nonatomic) JGJMangerTool *timerTool;

//相册、拍照、我的名片
@property (strong, nonatomic) JGJCusAddMediaView *mediaView;

@end


@implementation JGJChatInputView

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

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = AppFontF6F6F6Color;
    
    [self.recordLabel.layer setLayerBorderWithColor:AppFontccccccColor width:0.5 radius:4];
    self.recordLabel.userInteractionEnabled = YES;
    //添加长按事件
    UILongPressGestureRecognizer *longPresssRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPresssRecognizer.minimumPressDuration = 0.1;
    [self.recordLabel addGestureRecognizer:longPresssRecognizer];
    
    
    [self switchStatus:[self viewWithTag:10]];
    
    //inputView
    self.textView.cornerRadius = 4.0;
    self.textView.maxNumberOfLines = 5;
    self.textView.placeholder = @"请输入内容";
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.placeholderColor = TYColorHex(0x999999);
    self.textFieldOldHeight = self.textView.frame.size.height;
    
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = TYColorHex(0xcccccc).CGColor;
    
    self.textView.font = [UIFont systemFontOfSize:AppFont32Size];
    
    __weak typeof(self) weakSelf = self;
    //改变高度
    self.textView.ty_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        [weakSelf getAddHeightByCurHeight:textHeight];
    };
    
    //发送消息
    self.textView.ty_textReturn = ^(TYInputView *textView){
        
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [textView.text stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {

        } else {
            [weakSelf sendText:textView];
        }
    };
    
    //文本改变
    self.textView.ty_textChange = ^(TYInputView *textView,NSString *text,NSString *changeText){
        //使用delegate
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(changeText:text:)]) {
            [weakSelf.delegate changeText:weakSelf text:changeText];
        }
        
        //是否数据框有文字，发送按钮变颜色
        weakSelf.emotionKeyboard.tabBar.isHaveText = ![NSString isEmpty:text];
        
    };
    
    //文本删除
    self.textView.ty_textDelete = ^(TYInputView *textView){
        //使用delegate
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(deleteText:text:)]) {
            [weakSelf.delegate deleteText:weakSelf text:textView.text];
        }
    };
    
    [self setKeyboardImage];
    
//    [self addObserver];
    
    self.textView.delegate = self;
    
//    //测试timer发消息
//    
//    [self testTimerSendMsg];
    
}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel{
    _workProListModel = workProListModel;
    
    //2.1.0添加修改
//    if ([self.workProListModel.class_type isEqualToString:@"singleChat"] || [self.workProListModel.class_type isEqualToString:@"groupChat"]) {
//        self.addButtonConstraintW.constant = 0;
//        self.addButtonConstraintR.constant = 0;
//    }
    
    self.addButtonConstraintW.constant = 0;
    self.addButtonConstraintR.constant = 0;
}

#pragma mark - 文字相关
#pragma mark 增加的高度
- (void)getAddHeightByCurHeight:(CGFloat )curHeight{
    CGFloat addHeight = (curHeight - self.textFieldOldHeight);
    
    //使用delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeHeight:addHeight:)]) {
        [self.delegate changeHeight:self addHeight:addHeight];
    }
    
    //使用block
    if (self.chatInputAddHeightBlock) {
        self.chatInputAddHeightBlock(curHeight);
    }
}

#pragma mark 发送文字消息
- (void)sendText:(TYInputView *)textView{
    
    if ([textView.text isEqualToString:@""]) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendText:text:)]) {
        
//之前替换了
        
//        [self.delegate sendText:self text:[textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        
        [self.delegate sendText:self text:textView.text];
    }
    
    textView.text = @"";
}

#pragma mark - 语音相关
#pragma mark 长按处理的事件
- (void)longPress:(UILongPressGestureRecognizer *)press {
    
    switch (press.state) {
           
        case UIGestureRecognizerStateBegan : {

            [self endEditing:YES];
            
            [self canStartAudioRecordRecord];
            break;
        }
        case UIGestureRecognizerStateChanged: {//change
            TYLog(@"change");
            UIViewController *superVc = (UIViewController *)self.delegate;
            [self.tyAudio changeAudioRecord:press view:superVc.view];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            TYLog(@"cancel, end");
            [self.tyAudio endAudioRecord];
            break;
        }
        case UIGestureRecognizerStateFailed: {
            TYLog(@"failed");
            break;
        }
        default: {
            break;
        }
    }
}

- (void)canStartAudioRecordRecord {
    
    __block BOOL firstUseMicrophone = NO;
    
    __weak typeof(self) weakSelf = self;
    
    [TYPermission requestRecordPermission:^(AVAudioSessionRecordPermission recordPermission) {
        
        if (recordPermission == AVAudioSessionRecordPermissionUndetermined) {
            
            firstUseMicrophone = YES;
            
        }else if (recordPermission == AVAudioSessionRecordPermissionGranted) {
            //第一次录音时，会请求麦克风权限。
            //1、用户抬离手指后同意访问麦克风，这种情况不继续录音，因为用户已经离开录音按钮了
            //2、用户保持手指按压录音按钮，用其他手指同意访问麦克风，则从获取授权的时间点开始录音
            if (!firstUseMicrophone) {

                [weakSelf.tyAudio startAudioRecord];
            }
        }
    }];

}


#pragma mark 
- (void)sendAudio:(TYAudio *)audio audioInfo:(NSDictionary *)audioInfo{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendAudio:audioInfo:)]) {
        [self.delegate sendAudio:self audioInfo:audioInfo];
    }
}


- (IBAction)switchStatus:(UIButton *)sender {
    sender.selected = !sender.selected;

    self.textView.hidden = !sender.selected;
    self.recordLabel.hidden = sender.selected;
    
    ChatInputType inputType = sender.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeStatus:statusType:)]) {
        [self.delegate changeStatus:self
                           statusType:inputType];
    }
    
    //表情按键切换
    if (inputType == ChatInputAudio) {
        
        self.statusType = JGJKeyboardDefaultStatusType;
        
        [self setKeyboardImage];
        
        if ([self.textView isFirstResponder]) {
            
            [self.textView resignFirstResponder];
            
        }
    }
    
}

- (IBAction)addBtnClick:(id)sender {
//    if ([self.workProListModel.class_type isEqualToString:@"group"]) {
//        return;
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addBtnClick)]) {
        [self.delegate addBtnClick];
    }
    [self.textView resignFirstResponder];
}


- (IBAction)addPicBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendPic:audioInfo:)]) {
        [self.delegate sendPic:self audioInfo:nil];
    }
    
    //这里可以注销键盘
    [self.textView resignFirstResponder];
    
    self.emotionKeyboard.y = TYGetUIScreenHeight;
}

#pragma mark - 懒加载
- (TYAudio *)tyAudio
{
    if (!_tyAudio) {
        _tyAudio = [TYAudio shareTYAudio];
        _tyAudio.delegate = self;
    }
    return _tyAudio;
}

- (NSMutableArray *)at_uid_arr
{
    if (!_at_uid_arr) {
        _at_uid_arr = [[NSMutableArray alloc] init];
    }
    return _at_uid_arr;
}

#pragma mark - 2.3.2添加表情

#pragma mark - 添加监听
- (void)addObserver {
    
    //    // 文字改变的通知
    //    [HWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self.textView];
    
    // 表情选中的通知
    [HWNotificationCenter addObserver:self selector:@selector(emotionDidSelect:) name:HWEmotionDidSelectNotification object:nil];
    
    // 删除文字的通知
    [HWNotificationCenter addObserver:self selector:@selector(emotionDidDelete) name:HWEmotionDidDeleteNotification object:nil];
    
}

//移除监听
- (void)removeObserver {
    
    [HWNotificationCenter removeObserver:self name:HWEmotionDidSelectNotification object:nil];
    
    [HWNotificationCenter removeObserver:self name:HWEmotionDidDeleteNotification object:nil];
}

#pragma mark - 监听方法
/**
 *  删除文字
 */
- (void)emotionDidDelete
{
    [self.textView deleteBackward];
}

/**
 *  表情被选中了
 */
- (void)emotionDidSelect:(NSNotification *)notification
{
    HWEmotion *emotion = notification.userInfo[HWSelectEmotionKey];
    
    [self.textView insertEmotion:emotion];
}

#pragma mark - 懒加载
- (HWEmotionKeyboard *)emotionKeyboard
{
    __weak typeof(self) weakSelf = self;
    
    if (!_emotionKeyboard) {
        
        self.emotionKeyboard = [[HWEmotionKeyboard alloc] init];
        
        self.emotionKeyboard.emotionKeyboardSendBlock = ^(HWEmotionKeyboard *emotionKeyboard) {
            
            NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            
            NSString *trimedString = [weakSelf.textView.text stringByTrimmingCharactersInSet:set];
            
            if ([trimedString length] == 0) {
                
            } else {
                
                [weakSelf sendText:weakSelf.textView];
            }
        };
        
        // 键盘的宽度
        self.emotionKeyboard.width = TYGetUIScreenWidth;
        
        self.emotionKeyboard.height = EmotionKeyboardHeight;
        
        self.emotionKeyboard.x = 0;
        
        self.emotionKeyboard.y = EmotionKeyboardY;
        
    }
    return _emotionKeyboard;
}

//- (JGJCusAddMediaView *)mediaView {
//
//    if (!_mediaView) {
//
//        _mediaView = [[JGJCusAddMediaView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, [JGJCusAddMediaView meidaViewHeight])];
//
//    }
//
//    return _mediaView;
//}

#pragma mark - 其他方法
/**
 *  切换键盘
 */
- (void)switchKeyboard
{
    
    if (self.textView.inputView == nil) { // 切换为自定义的表情键盘
        
//        self.textView.inputView = self.emotionKeyboard;
        
        [TYKey_Window addSubview:self.emotionKeyboard];
        
        if (self.textView.isFirstResponder) {
            
            [self.textView resignFirstResponder];
        }
        
//        self.textView.inputView = nil;
        
    } else { // 切换为系统自带的键盘
        
//        self.textView.inputView = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 弹出键盘
            [self.textView becomeFirstResponder];
            
        });
        
    }
    
    [self setKeyboardImage];
    
    // 开始切换键盘
    self.switchingKeybaord = YES;
    
    // 退出键盘
    [self.textView endEditing:YES];
    
    // 结束切换键盘
    self.switchingKeybaord = NO;
    
}

- (IBAction)switchButtonPressed:(UIButton *)sender {
    
//    [self switchKeyboard];
    
    self.statusType = self.statusType == JGJKeyboardFaceStatusType ? JGJKeyboardDefaultStatusType: JGJKeyboardFaceStatusType;
    
    [self setKeyboardImage];
    
    //显示emoji键盘
    if (self.emojiKeyboardBlock && self.statusType == JGJKeyboardFaceStatusType) {
        
        self.emojiKeyboardBlock(self);
    }
    
    //切换表情键盘去掉语音状态
    self.recordLabel.hidden = YES;
    
    self.textView.hidden = NO;
    
    //切换语音按键
    if (self.statusType == JGJKeyboardFaceStatusType) {
        
        self.changeStatusButton.selected = YES;
        
    }
}

- (void)setStatusType:(JGJKeyboardStatusType)statusType {
    
    _statusType = statusType;
    
    switch (_statusType) {
        case JGJKeyboardDefaultStatusType:{
            
            self.switchingKeybaord = NO;
            
            [self.textView becomeFirstResponder];
            
            [self setKeyboardImage];
        }
            break;
            
        case JGJKeyboardFaceStatusType:{
            
            UIViewController *curVc = [self getCurrentViewControllerWithCurView:self];
            
            [curVc.view addSubview:self.emotionKeyboard];
            
            self.switchingKeybaord = YES;
            
            if (self.textView.isFirstResponder) {
                
                [self.textView resignFirstResponder];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.statusType = JGJKeyboardDefaultStatusType;
}

- (void)setChatInputViewKeyBoardType:(JGJChatInputViewKeyBoardType)chatInputViewKeyBoardType {
    
    _chatInputViewKeyBoardType = chatInputViewKeyBoardType;

    switch (chatInputViewKeyBoardType) {
            
//        case JGJChatInputViewKeyBoardChatType:
//
//            break;
        
        case JGJChatInputViewKeyBoardChangeStatusType:{
            
            self.changeStatusButton.hidden = YES;
            
            self.changeStatusButtonW.constant = 0;
            
            self.textView.maxTextLineHeight = 110;
            
            self.textView.maxNumberOfWords = 400;
            
            //质量安全任务注册表情键盘
            [self addObserver];
        }
            
            break;
            
        case JGJChatInputViewKeyBoardHiddenChangeStatusAndAddImageType:{
            
            self.changeStatusButton.hidden = YES;
            
            self.changeStatusButtonW.constant = 0;
            
            self.addImageButton.hidden = YES;
            
            self.addImageButtonW.constant = 0;
            
            self.textView.maxTextLineHeight = 110;
            
            self.textView.maxNumberOfWords = 400;
            
            //质量安全任务注册表情键盘
            [self addObserver];
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = placeholder;
        
    self.textView.placeholder = placeholder;
    
}

- (void)setIsDefaultChatInputViewType:(BOOL)isDefaultChatInputViewType {
    
    _isDefaultChatInputViewType = isDefaultChatInputViewType;
    
    //切换为默认的键盘
    if (_isDefaultChatInputViewType) {
        
//        self.textView.inputView = nil;
        
        self.statusType = JGJKeyboardDefaultStatusType;
        
        [self setKeyboardImage];
        
    }
    
}

#pragma mark - 设置键盘图片
- (void) setKeyboardImage {
    
    NSString *emotion = self.statusType == JGJKeyboardDefaultStatusType ? @"emotion": @"Chat_keyboard";
    
    [self.switchEmotionButton setImage:[UIImage imageNamed:emotion] forState:UIControlStateNormal];
}

#pragma mark - 发送消息
- (void)sendMessage {
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *trimedString = [self.textView.text stringByTrimmingCharactersInSet:set];
    
    if ([NSString isEmpty:trimedString]) {
        
        return;
    }
    
    [self sendText:self.textView];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    //这个判断相当于是textfield中的点击return的代理方法
    if ([text isEqualToString:@"\n"]) {
        
        if ([self netCanUse]) {
            
            return NO;
        }
        
        [self sendMessage];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)netCanUse {
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    BOOL isReachableStatus = status == AFNetworkReachabilityStatusNotReachable;
    
    if (isReachableStatus) {
        
        [TYShowMessage showPlaint:@"当前网络不可用"];
        
    }
    
    return isReachableStatus;
}

/** 获取当前View的控制器对象 */
- (UIViewController *)getCurrentViewControllerWithCurView:(UIView *)curView{
    UIResponder *next = [curView nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)testTimerSendMsg {
    
    if (!_timerTool) {
        
        _timerTool = [[JGJMangerTool alloc] init];
        
        _timerTool.timeInterval = 3;
        
        [_timerTool startTimer];
    }

    TYWeakSelf(self);
    
    _timerTool.toolTimerBlock = ^{
      
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        
        NSString *timeID = [NSString stringWithFormat:@"%.lf", time];
        
        weakself.textView.text = [NSString stringWithFormat:@"%@", timeID];
        
        [weakself sendText:weakself.textView];
        
    };
}

@end
