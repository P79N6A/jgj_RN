//
//  JGJChatListDefaultTextCell.m
//  mix
//
//  Created by Tony on 2016/9/1.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListDefaultTextCell.h"
#import "JGJCustomLable.h"

@interface JGJChatListDefaultTextCell ()

@property (weak, nonatomic) IBOutlet JGJCustomLable *msgLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgLabelConstraintW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgLabelConstraintH;
@property (weak, nonatomic) IBOutlet UILabel *contentBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBackViewW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBackViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contenBackCenterX;

@end

@implementation JGJChatListDefaultTextCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.msgLabel.layer setLayerCornerRadius:5.0];
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    self.msgLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.contentBackView.layer setLayerCornerRadius:5.0];
}

- (void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel{
    _jgjChatListModel = jgjChatListModel;
    self.msgLabel.text = jgjChatListModel.msg_text;
    
    if ([jgjChatListModel.msg_type isEqualToString:@"chatlocate"]) {
        self.contentBackView.backgroundColor = [UIColor clearColor];
        self.msgLabel.textColor = AppFont999999Color;
    } else {
        self.contentBackView.backgroundColor = TYColorHex(0XC0C0C0);
        self.msgLabel.textColor = AppFontffffffColor;
    }

    
    //添加边距
    CGSize titleSize = [self.msgLabel.text boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 108, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AppFont24Size]} context:nil].size;
    
    CGFloat maxW = titleSize.width + 20;
    
    CGFloat maxH = titleSize.height + 5;
    
    self.msgLabelConstraintH.constant = maxH;
    
    self.msgLabelConstraintW.constant = maxW;
    
    self.contentBackViewW.constant = maxW + 10;
    
    self.contentBackViewH.constant = maxH;
    
    self.msgLabel.textAlignment = NSTextAlignmentCenter;
    
    self.contenBackCenterX.constant = 0;
    
    if (titleSize.height > 40) {
        
        self.msgLabel.textAlignment = NSTextAlignmentLeft;
        
        self.contenBackCenterX.constant -= 5;
    }
}

@end
