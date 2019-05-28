//
//  JGJChatListOtherPicCell.m
//  JGJCompany
//
//  Created by Tony on 2016/12/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListOtherPicCell.h"
#import "JGJChatListPicView.h"
#import "CAShapeLayer+ViewMask.h"

@interface JGJChatListOtherPicCell ()

@property (weak, nonatomic) IBOutlet JGJChatListPicView *picView;

@end

@implementation JGJChatListOtherPicCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPicView:)];
    
    tap.numberOfTapsRequired = 1;
    
    [self.picView addGestureRecognizer:tap];
    
    self.picView.userInteractionEnabled = YES;
    
    //    CAShapeLayer *layer = [CAShapeLayer createLeftMaskLayerWithView:self.picView];
    //    self.picView.layer.mask = layer;
    
    self.picView.backgroundColor = AppFontf1f1f1Color;
}

- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    self.picView.tableView = self.tableView;
    self.picView.jgjChatListModel = jgjChatListModel;
    [self layoutIfNeeded];
}

- (void)checkPicView:(UITapGestureRecognizer *)tap {
    
    CGSize size = self.picView.jgjChatListModel.imageSize;
    
    CGPoint point = [tap locationInView:self.picView];
    
    CGFloat maxW = size.width;
    
    if (self.picView.jgjChatListModel.sendType != JGJChatListSendSuccess) {
        
        return;
    }
    
    if (point.x <= maxW && point.y < size.height) {
        
        NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
        
        if ([self.otherPicDelegate respondsToSelector:@selector(chatListOtherPicCell:)]) {
            
            [self.otherPicDelegate chatListOtherPicCell:self];
        }
        
    }
}
@end
