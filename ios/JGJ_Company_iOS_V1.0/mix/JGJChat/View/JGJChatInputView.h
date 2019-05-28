//
//  JGJChatInputView.h
//  mix
//
//  Created by Tony on 2016/8/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYInputView.h"

typedef enum : NSUInteger {
    ChatInputAudio = 0,
    ChatInputText
} ChatInputType;

typedef enum : NSUInteger {
    JGJChatInputViewKeyBoardChatType, //默认聊天类型
    
    JGJChatInputViewKeyBoardChangeStatusType, //隐藏切换状态按钮
    
    JGJChatInputViewKeyBoardHiddenChangeStatusAndAddImageType, //隐藏切换状态按钮，添加图片按钮
    
} JGJChatInputViewKeyBoardType;

typedef void(^JGJChatInputAddHeightBlock)(CGFloat addHeight);

@class JGJChatInputView;

typedef void(^JGJChatInputShowEmojiKeyboardBlock)(JGJChatInputView *);

@protocol JGJChatInputViewDelegate <NSObject>

@optional
- (void)changeHeight:(JGJChatInputView *)chatInputView addHeight:(CGFloat )addHeight;
- (void)sendText:(JGJChatInputView *)chatInputView text:(NSString *)text;
- (void)changeStatus:(JGJChatInputView *)chatInputView statusType:(ChatInputType )statusType;
- (void)sendAudio:(JGJChatInputView *)chatInputView audioInfo:(NSDictionary *)audioInfo;

- (void)sendPic:(JGJChatInputView *)chatInputView audioInfo:(NSDictionary *)audioInfo;

- (void)addBtnClick;

- (void)changeText:(JGJChatInputView *)chatInputView text:(NSString *)text;

- (void)deleteText:(JGJChatInputView *)chatInputView text:(NSString *)text;
@end

@interface JGJChatInputView : UIView
@property (nonatomic , weak) id<JGJChatInputViewDelegate> delegate;

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (nonatomic, copy) JGJChatInputAddHeightBlock chatInputAddHeightBlock;

@property (weak, nonatomic) IBOutlet TYInputView *textView;

@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@property (nonatomic,strong) NSMutableArray *at_uid_arr;

/** 是否正在切换键盘，正在切换键盘不能隐藏 */
@property (nonatomic, assign) BOOL switchingKeybaord;

/** 切换相册、拍照、我的名片底部MediaView */
@property (nonatomic, assign) BOOL switchingMediaViewKeybaord;

@property (nonatomic, assign) JGJChatInputViewKeyBoardType chatInputViewKeyBoardType;

@property (nonatomic, copy) NSString *placeholder;

/** 默认的输入文字类型 */
@property (nonatomic, assign) BOOL isDefaultChatInputViewType;

//点击表情弹出键盘
@property (nonatomic, copy) JGJChatInputShowEmojiKeyboardBlock emojiKeyboardBlock;

/** 表情键盘 */
@property (nonatomic, strong) HWEmotionKeyboard *emotionKeyboard;

/** 发送消息 */
- (void)sendMessage;

// 添加监听
- (void)addObserver;

// 移除监听
- (void)removeObserver;

@end
