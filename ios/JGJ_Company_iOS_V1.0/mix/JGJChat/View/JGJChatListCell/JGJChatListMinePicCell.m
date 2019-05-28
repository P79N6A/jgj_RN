//
//  JGJChatListMinePicCell.m
//  JGJCompany
//
//  Created by Tony on 2016/12/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListMinePicCell.h"
#import "JGJChatListPicView.h"
#import "CAShapeLayer+ViewMask.h"

@interface JGJChatListMinePicCell ()

@property (weak, nonatomic) IBOutlet JGJChatListPicView *picView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendBtnTrail;

@end

@implementation JGJChatListMinePicCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.picView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPicView:)];
    
    tap.numberOfTapsRequired = 1;
    
    [self.contentView addGestureRecognizer:tap];

//    CAShapeLayer *layer = [CAShapeLayer createRightMaskLayerWithView:self.picView];
//    self.picView.layer.mask = layer;
    
    self.picView.backgroundColor = AppFontf1f1f1Color;
}

- (void)checkPicView:(UITapGestureRecognizer *)tap  {
    
    CGSize size = self.picView.jgjChatListModel.imageSize;
    
    CGPoint point = [tap locationInView:self.contentView];
    
    CGFloat maxW = size.width;
    
    CGFloat offset = maxW + 40 + 27;
    
    CGFloat pointW = TYGetUIScreenWidth - point.x;
    
    CGFloat isContainPoint = (pointW < offset + 40) && point.x < TYGetUIScreenWidth - 50;
    
    //点击失败的图标范围内
    
    if (self.picView.jgjChatListModel.sendType != JGJChatListSendSuccess) {
        
        if (self.picView.jgjChatListModel.sendType == JGJChatListSendFail && isContainPoint) {
            
            [self resendFailMsgClick];
            
        }
        
        return;
    }
    
    if (pointW <= offset && point.y < size.height) {
        
        NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
        
        if ([self.picCellDelegate respondsToSelector:@selector(chatListMinePicCell:)]) {
            
            [self.picCellDelegate chatListMinePicCell:self];
        }
        
    }
    
}



- (void)chatListPicView:(JGJChatListPicView *)picView didSelectedImageView:(UIImageView *)picImageView {

    if ([self.picCellDelegate respondsToSelector:@selector(chatListMinePicCell:)]) {
        
        [self.picCellDelegate chatListMinePicCell:self];
    }
}

- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    
    self.picView.tableView = self.tableView;
    
    self.picView.jgjChatListModel = jgjChatListModel;
    
    if (jgjChatListModel.sendType == JGJChatListSendSuccess) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPicView:)];
        
        tap.numberOfTapsRequired = 1;
        
        [self.picView addGestureRecognizer:tap];
        
    }else if (jgjChatListModel.sendType == JGJChatListSendFail) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPicView:)];
        
        tap.numberOfTapsRequired = 1;
        
        [self.picView addGestureRecognizer:tap];
        
    }
    
    [self layoutIfNeeded];
}

@end
