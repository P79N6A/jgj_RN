
//
//  JGJMsgSendContentView.m
//  mix
//
//  Created by Json on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMsgSendContentView.h"
#import "JGJMultipleAvatarView.h"
#import "JGJSingleAvatarView.h"
#import "YYTextView.h"
#import "UIImageView+WebCache.h"

static CGFloat const textViewH = 35.0;
extern NSInteger maxCountPerRow;
extern CGFloat const contentWidthRatio;

@interface JGJMsgSendContentView ()<YYTextViewDelegate>
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, weak) YYTextView *textView;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat maxTextViewH;
@property (nonatomic, assign) NSInteger maxTextViewLines;
@property (nonatomic, weak) UIButton *sendButton;
@end

@implementation JGJMsgSendContentView

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = AppFont999999Color;
        _textLabel.font = [UIFont systemFontOfSize:AppFont30Size];
        _textLabel.numberOfLines = 2;
    }
    return _textLabel;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // titleLabel
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
        titleLabel.textColor = AppFont000000Color;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.right.mas_equalTo(self).offset(-20);
            make.top.mas_equalTo(self).offset(25);
        }];
        // 分割线宽度
        CGFloat lineWidth = 0.5;
        
        // bottomView
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = AppFontdbdbdbColor;
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(45.0);
        }];

        /* buttons */
        UIFont *buttonFont = [UIFont systemFontOfSize:AppFont30Size];
        UIColor *buttonBgColor = AppFontfafafaColor;
        
        // 取消按钮
        UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        cancelButton.backgroundColor = buttonBgColor;
        [cancelButton setTitleColor:AppFont333333Color forState:(UIControlStateNormal)];
        cancelButton.titleLabel.font = buttonFont;
        [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        [bottomView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(bottomView);
            make.top.mas_equalTo(bottomView).offset(lineWidth);
        }];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];

        // 发送按钮
        UIButton *sendButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [sendButton setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
        sendButton.titleLabel.font = buttonFont;
        [sendButton setTitle:@"发送" forState:(UIControlStateNormal)];
        sendButton.backgroundColor = buttonBgColor;
        [bottomView addSubview:sendButton];
        self.sendButton = sendButton;

        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cancelButton.mas_right).offset(lineWidth);
            make.right.bottom.mas_equalTo(bottomView);
            make.top.mas_equalTo(cancelButton);
            make.width.mas_equalTo(cancelButton);
        }];
        [sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
        
        // textView
        YYTextView *textView = [[YYTextView alloc] init];
        textView.tintColor = AppFontEB4E4EColor;
        textView.backgroundColor = AppFontEBEBEBColor;
        textView.layer.borderWidth = lineWidth;
        textView.layer.borderColor = AppFontccccccColor.CGColor;
        textView.layer.cornerRadius = 2;
        textView.clipsToBounds = YES;
        textView.delegate = self;
        textView.placeholderText = @"留言";
        textView.placeholderFont = [UIFont systemFontOfSize:15.0];
        textView.placeholderTextColor = AppFont999999Color;
        textView.font = textView.placeholderFont;
        
        UIEdgeInsets insets = textView.textContainerInset;
        CGFloat verticalInset = 10;
        insets.top = verticalInset;
        textView.textContainerInset = insets;
        
        [self addSubview:textView];
        self.textView = textView;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.right.mas_equalTo(self).offset(-20);
            make.bottom.mas_equalTo(bottomView.mas_top).offset(-25);
            make.height.mas_equalTo(textViewH);
        }];
        _maxTextViewLines = 2;
        _maxTextViewH = ceil(textView.font.lineHeight * _maxTextViewLines + textView.textContainerInset.top + textView.textContainerInset.bottom);
        
        
        
        // line
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = AppFontdbdbdbColor;
        [self addSubview:lineView];
        self.lineView = lineView;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(textView);
            make.height.mas_equalTo(lineWidth);
        }];
        
    
        
        
    }
    return self;
}

- (void)addContentLabel
{
    [self addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.textView);
        make.bottom.mas_equalTo(self.textView.mas_top).offset(-10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.textLabel.mas_top).offset(-10);
    }];
}

- (void)addImageView
{
    [self addSubview:self.imageView];
    CGFloat imageWidthRatio = 0.6;
    CGFloat imageWH = TYGetUIScreenWidth * contentWidthRatio * imageWidthRatio;
    imageWH = MIN(160, imageWH);
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(imageWH);
        make.bottom.mas_equalTo(self.textView.mas_top).offset(-10);
        make.centerX.mas_equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imageView.mas_top).offset(-10);
    }];
}



#pragma mark - 按钮点击

- (void)cancelButtonClicked
{
    if (self.cancelAction) {
        self.cancelAction();
    }
}

- (void)sendButtonClicked
{
    if (self.ensureAction) {
        self.ensureAction();
    }
}

#pragma mark - setter方法

- (void)setConversations:(NSArray<JGJChatGroupListModel *> *)conversations
{
    _conversations = conversations;
    if (conversations.count == 0) return;
    if (conversations.count > 1) {
        // 设置标题和发送按钮标题
        self.titleLabel.text = @"分别发送给:";
        // 添加多头像控件
        JGJMultipleAvatarView *mulAvatarView = [[JGJMultipleAvatarView alloc] init];
        NSMutableArray *imageURLs = [NSMutableArray array];
        for (JGJChatGroupListModel *conversation in conversations) {
            if ([NSString isEmpty:conversation.local_head_pic]) continue;
            [imageURLs addObject:conversation.local_head_pic];
        }
        mulAvatarView.imageURLs = imageURLs;
        [self addSubview:mulAvatarView];
        
        // 设置mulAvatarView约束
        NSInteger rows = (mulAvatarView.imageURLs.count - 1) / maxCountPerRow + 1;
        CGFloat inset = [JGJMultipleAvatarView inset];
        CGFloat height = rows * mulAvatarView.avatarWH + inset * (rows - 1);
        
        [mulAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.right.mas_equalTo(self).offset(-20);
            make.bottom.mas_equalTo(self.lineView.mas_top).offset(-10);
            make.height.mas_equalTo(height);
        }];
        [mulAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
    } else {
        // 设置标题和发送按钮标题
        self.titleLabel.text = @"发送给:";
        // 添加单头像控件
        JGJSingleAvatarView *singleAvatarView = [[JGJSingleAvatarView alloc] init];
        JGJChatGroupListModel *conversation = conversations.firstObject;
        singleAvatarView.imageURL = conversation.local_head_pic;
        singleAvatarView.name = conversation.group_name;
        [self addSubview:singleAvatarView];
        [singleAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.right.mas_equalTo(self).offset(-20);
            make.bottom.mas_equalTo(self.lineView.mas_top).offset(-10);
        }];
        [singleAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
    }
    // 设置发送按钮标题
    NSString *buttonTitle = self.showSendNumber ? [NSString stringWithFormat:@"发送(%zd)",conversations.count] : @"发送";
    [self.sendButton setTitle:buttonTitle forState:(UIControlStateNormal)];
}

- (void)setMessage:(JGJChatMsgListModel *)message
{
    JGJChatListType msgType = message.chatListType;
    switch (msgType) {
        case JGJChatListText:{
            [self addContentLabel];
            self.textLabel.text = message.msg_text;
        }
            break;
        case JGJChatListLinkType:{
            [self addContentLabel];
            self.textLabel.text = [NSString stringWithFormat:@"[链接]%@",message.shareMenuModel.describe];
        }
            break;
        case JGJChatPostcardType:{
            [self addContentLabel];
            self.textLabel.text = [NSString stringWithFormat:@"[找活名片]%@",message.user_info.real_name];
        }
            break;
        case JGJChatListPic:{
            [self addImageView];
            if (message.picImage) {
                self.imageView.image = message.picImage;
            } else {
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_IP,message.msg_src.firstObject]] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


#pragma mark - YYTextViewDelegate

- (void)textViewDidChange:(YYTextView *)textView
{
    //
    if (self.textViewDidChange) {
        self.textViewDidChange(textView.text);
    }
    
    CGFloat contentSizeH = textView.contentSize.height;
    if (contentSizeH <= textViewH) {
        // 防止刚输入内容时,contentSizeH小于textView初始高度,textView高度突然变小(小于初始高度)
        contentSizeH = textViewH;
    } else {
        contentSizeH = MIN(contentSizeH, _maxTextViewH);
    }

    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentSizeH);
    }];
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 防止输入过程中由于contentOffset变化造成输入内容忽上忽下的效果
    if (scrollView.contentSize.height < _maxTextViewH) {
        scrollView.contentOffset = CGPointZero;
    }
}


@end
