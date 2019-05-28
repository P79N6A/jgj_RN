//
//  JGJChatNoDataDefaultView.m
//  mix
//
//  Created by Tony on 2016/11/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatNoDataDefaultView.h"

@interface JGJChatNoDataDefaultView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageTypeView;

@property (weak, nonatomic) IBOutlet UILabel *labelType;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,copy) NSDictionary *chatTypeDic;
@end

@implementation JGJChatNoDataDefaultView
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
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
    self.helpButton.layer.masksToBounds = YES;
    self.helpButton.layer.cornerRadius = 5;
    self.helpButton.layer.borderColor = AppFont666666Color.CGColor;
    self.helpButton.layer.borderWidth = 0.5;
    [self.helpButton addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJChatNoDataDefaultViewClickHelpBtn)]) {
        [self.delegate JGJChatNoDataDefaultViewClickHelpBtn];
    }

}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.contentView.backgroundColor = backgroundColor;
}

- (void)setChatListType:(JGJChatListType)chatListType{
    _chatListType = chatListType;
    //使用masonry的BUG
    self.contentView.frame = self.bounds;
    
    NSArray *chatTypeArr = self.chatTypeDic[[NSString stringWithFormat:@"%@",@(_chatListType)]];
    
    if (chatListType == JGJChatListSign) {
        self.labelType.text = [chatTypeArr firstObject];
    }else{
        self.labelType.text = [NSString stringWithFormat:@"还没有人发%@",(NSString *)[chatTypeArr firstObject]?:@""];
    }
     if (chatListType == JGJChatListLog){
         self.labelType.text = @"暂无日志信息";
         self.helpButton.hidden = NO;

     }else{
         self.labelType.text = @"暂无记录哦~";
         self.helpButton.hidden = YES;

     }
    
    self.imageTypeView.image = [UIImage imageNamed:(NSString *)[chatTypeArr lastObject]?:@""];
}

- (BOOL )needAddViewWithListType:(JGJChatListType)chatListType{
    BOOL needAdd = NO;

    NSArray *chatTypeArr = self.chatTypeDic[[NSString stringWithFormat:@"%@",@(chatListType)]];
    
    if (chatTypeArr && chatTypeArr.count) {
        needAdd = YES;
    }
    
    return needAdd;
}

#pragma mark - lazy
- (NSDictionary *)chatTypeDic
{
    if (!_chatTypeDic) {
        _chatTypeDic = @{
                         [NSString stringWithFormat:@"%@",@(JGJChatListNotice)]:@[@"通知",@"NoDataDefault_NoManagePro"],
                         [NSString stringWithFormat:@"%@",@(JGJChatListLog)]:@[@"工作日志",@"NoDataDefault_NoManagePro"],
                         [NSString stringWithFormat:@"%@",@(JGJChatListSafe)]:@[@"安全",@"NoDataDefault_NoManagePro"],
                         [NSString stringWithFormat:@"%@",@(JGJChatListQuality)]:@[@"质量",@"NoDataDefault_NoManagePro"],
                         [NSString stringWithFormat:@"%@",@(JGJChatListSign)]:@[@"还没有任何人签到",@"NoDataDefault_NoManagePro"]
                         };
    }
    return _chatTypeDic;
}

@end
