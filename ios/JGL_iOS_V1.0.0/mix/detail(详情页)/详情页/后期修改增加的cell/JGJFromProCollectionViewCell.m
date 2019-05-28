//
//  JGJFromProCollectionViewCell.m
//  mix
//
//  Created by Tony on 2017/7/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJFromProCollectionViewCell.h"
#import "UILabel+GNUtil.h"
@implementation JGJFromProCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickChangeButton:(id)sender {
}
- (void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel
{
    _jgjChatListModel = [JGJChatMsgListModel new];
    _jgjChatListModel = jgjChatListModel;
    _FromLable.text = [NSString stringWithFormat:@"来自: %@  ",jgjChatListModel.from_group_name?:@""];
//    _FromLable.textColor = AppFont999999Color;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapchangePro)];
    
    _FromLable.userInteractionEnabled = YES;
    
    [_FromLable addGestureRecognizer:tap];
    
    _FromLable.numberOfLines = 2;
    
     NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:self.FromLable.text];
    
    [attri addAttribute:NSForegroundColorAttributeName value:AppFont999999Color range:NSMakeRange(0, 3)];
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"箭头-拷贝-6"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -2, 8, 12);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    [attri appendAttributedString:string];
    
    self.FromLable.attributedText = attri;
    

    
}
- (void)tapchangePro
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapFromLable)]) {
        [self.delegate tapFromLable];
    }
}

@end
