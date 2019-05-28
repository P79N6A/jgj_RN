//
//  JGJChatListCellTopTimeView.m
//  mix
//
//  Created by Tony on 2016/8/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListCellTopTimeView.h"
#import "NSString+Extend.h"
#import "NSString+AttributedStr.h"
#import "JGJTime.h"

#import "NSDate+Extend.h"

#define kChatListNormalColor        TYColorHex(0x666666)
#define kChatListHighlightColor     TYColorHex(0x628ae0)

@interface JGJChatListCellTopTimeView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation JGJChatListCellTopTimeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
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


-(void)setupView{
    self.backgroundColor = AppFontf1f1f1Color;
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = AppFontf1f1f1Color;

    //添加单击手势
    UITapGestureRecognizer *lSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.leftLabel addGestureRecognizer:lSingleTap];
    
    UITapGestureRecognizer *rSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.rightLabel addGestureRecognizer:rSingleTap];
}

- (void)singleTap:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topTimeViewSelected:)]) {
        [self.delegate topTimeViewSelected:self];
    }
}


- (void)setTopTimeModel:(JGJChatListCellTopTimeModel *)topTimeModel{
    _topTimeModel = topTimeModel;

    JGJChatListBelongType belongType = topTimeModel.belongType;
    if (topTimeModel.belongType == JGJChatListBelongMine) {//我的
        [self setMineData];
        [self.leftLabel setContentHuggingPriority:250.f forAxis:UILayoutConstraintAxisHorizontal];
    }else if(belongType == JGJChatListBelongOther || belongType == JGJChatListBelongGroupOut){//别人发的
        [self setOtherData];
        [self.leftLabel setContentHuggingPriority:252.f forAxis:UILayoutConstraintAxisHorizontal];
    }

}

- (void)setMineData{
//    self.rightLabel.userInteractionEnabled = NO;
    
    if ([NSString isEmpty:_topTimeModel.highlightString]) {//没有点击文字
        self.leftLabel.text = @"";
        self.leftLabel.hidden = YES;
    }else {
        self.leftLabel.hidden = NO;
        self.leftLabel.userInteractionEnabled = YES;
        NSAttributedString *attributedString = [self addUnderLineWithStr:_topTimeModel.highlightString color:kChatListHighlightColor needUnderLine:NO];
    
        self.leftLabel.attributedText = attributedString;
        
        //单聊已读
        BOOL isChangeColor = [self.topTimeModel.chatMsgListModel.class_type isEqualToString:@"singleChat"] && (self.topTimeModel.chatMsgListModel.read_info.unread_user_num.integerValue == 0);
        
        if (isChangeColor) {
            
            self.leftLabel.textColor = kChatListNormalColor;
            
            self.leftLabel.attributedText = [[NSAttributedString alloc] initWithString:_topTimeModel.highlightString];
        }
    }
    
    self.leftLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.textAlignment = NSTextAlignmentRight;

//    self.rightLabel.text = _topTimeModel.normalString;
#pragma mark - 这里是喔添加的代码
    

    NSString *topTimeDes = [NSDate chatMsgListShowDateWithTimeStamp:_topTimeModel.chatMsgListModel.send_time];
    
    self.rightLabel.text = topTimeDes;
    
    self.rightLabel.textColor = kChatListNormalColor;
}

- (void)setOtherData{
//    self.leftLabel.userInteractionEnabled = NO;
    
    if ([NSString isEmpty:_topTimeModel.highlightString]) {//没有点击文字
        self.rightLabel.text = @"";
        self.rightLabel.hidden = YES;
        
    }else{
        self.rightLabel.hidden = NO;
        self.rightLabel.userInteractionEnabled = YES;
        NSAttributedString *attributedString = [self addUnderLineWithStr:_topTimeModel.highlightString color:kChatListHighlightColor needUnderLine:NO];
        
        self.rightLabel.attributedText = attributedString;
    }
    
    
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    self.rightLabel.textAlignment = NSTextAlignmentLeft;
    self.leftLabel.text = _topTimeModel.normalString;
//    self.leftLabel.text = [JGJTime acordingTimeStrRetrunTime:_topTimeModel.chatMsgListModel.date];

    self.leftLabel.textColor = kChatListNormalColor;
}

- (NSAttributedString *)addUnderLineWithStr:(NSString *)str color:(UIColor *)color needUnderLine:(BOOL )needUnderLine{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange strRange = {0,[attributedStr length]};
    
    if (needUnderLine) {
        //添加下划线
        [attributedStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    }
    
    //添加颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:strRange];
    
    return attributedStr.copy;
}
@end

@implementation JGJChatListCellTopTimeModel
@end
