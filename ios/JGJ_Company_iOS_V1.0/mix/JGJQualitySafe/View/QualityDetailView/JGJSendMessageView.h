//
//  JGJSendMessageView.h
//  mix
//
//  Created by yj on 2017/6/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJSendMessageViewAddImageType = 1, //添加图片
    
    JGJSendMessageViewReplyButtonType //添加文字图片

} JGJSendMessageViewType;

@class JGJSendMessageView;
typedef void(^SendMessageBlock)(JGJSendMessageView *, NSString *);

typedef void(^SendSuccessMessageBlock)(JGJSendMessageView *, NSString *);

@protocol JGJSendMessageViewDelegate <NSObject>

- (void)sendMessageView:(JGJSendMessageView *)messageView sendMessageViewButtonType:(JGJSendMessageViewType) buttonType;

@end

@interface JGJSendMessageView : UIView

@property (nonatomic, copy) SendMessageBlock sendMessageBlock;

@property (nonatomic, copy) SendSuccessMessageBlock sendSuccessMessageBlock;

+ (instancetype)sendMessageView;

@property (nonatomic, weak) id <JGJSendMessageViewDelegate> delegate;

//回复的消息数据库存储的消息
@property (nonatomic, copy) NSString *replyMessage;

@property (nonatomic, assign) NSUInteger maxContentWords;
@end
