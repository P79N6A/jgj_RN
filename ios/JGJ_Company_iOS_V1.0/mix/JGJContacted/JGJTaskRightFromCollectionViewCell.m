//
//  JGJTaskRightFromCollectionViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskRightFromCollectionViewCell.h"

@implementation JGJTaskRightFromCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _replyButton.layer.masksToBounds = YES;
    _replyButton.layer.cornerRadius = 2.5;
    _replyButton.layer.borderColor = AppFontd7252cColor.CGColor;
    _replyButton.layer.borderWidth = .5;
    
    _reciveButton.layer.masksToBounds = YES;
    _reciveButton.layer.cornerRadius = 2.5;
    _reciveButton.layer.borderWidth = .5;
    _reciveButton.layer.borderColor = AppFontd7252cColor.CGColor;
    

}
-(void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel
{
    _jgjChatListModel = [JGJChatMsgListModel new];
    _jgjChatListModel = jgjChatListModel;
    _FromLable.text = [NSString stringWithFormat:@"来自:%@",jgjChatListModel.from_group_name?:@""];
    _FromLable.textColor = AppFont999999Color;
    
    if (_isClosedTeamVc || jgjChatListModel.IsCloseTeam) {//已关闭项目不像是这两个操作啊妞
        
        _replyButton.hidden = YES;
        _reciveButton.hidden = YES;
    }else{
        _replyButton.hidden = NO;
        _reciveButton.hidden = NO;
        
        if (_taskType) {
            if (!jgjChatListModel.is_can_deal) {
                //不可操作
                _reciveButton.userInteractionEnabled = NO;
                _reciveButton.layer.borderColor = AppFontccccccColor.CGColor;
                [_reciveButton setTitleColor:AppFontccccccColor forState:UIControlStateNormal];
                if ([_jgjChatListModel.task_status isEqualToString:@"1"]) {
                    [_reciveButton setTitle:@"待处理" forState:UIControlStateNormal];
                }else{
                    [_reciveButton setTitle:@"已完成" forState:UIControlStateNormal];
                }
                
            }else{
                //可操作
            [_reciveButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
            _reciveButton.userInteractionEnabled = YES;
            _reciveButton.layer.borderColor = AppFontd7252cColor.CGColor;
                if ([_jgjChatListModel.task_status isEqualToString:@"1"]) {
            [_reciveButton setTitle:@"待处理" forState:UIControlStateNormal];
                }else{
            [_reciveButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_reciveButton setTitle:@"已完成" forState:UIControlStateNormal];
                    
                }
            }
  
        }
    }
    if ([_jgjChatListModel.msg_type isEqualToString:@"task"]) {
        _replyButton.hidden = YES;
        _reciveButton.hidden = YES;
    }
}
- (IBAction)clickReplyButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickDetailLeftnumberButton:)]) {
        [self.delegate ClickDetailLeftnumberButton:_replyButton];
    }
}
- (IBAction)clickReciveButton:(id)sender {
    if (_isClosedTeamVc) {
        
    }else{
        if (_taskType) {
            }else{
            [_reciveButton setImage:[UIImage imageNamed:@"收到"] forState:UIControlStateNormal];
            [_reciveButton setTitle:@"已收到" forState:UIControlStateNormal];
            [_reciveButton setTitleColor:AppFontccccccColor forState:UIControlStateNormal];
            _reciveButton.userInteractionEnabled = NO;
        }
        if (self.delegate &&[self.delegate respondsToSelector:@selector(ClickDetailRightnumberButton:)]) {
            [self.delegate ClickDetailRightnumberButton:_reciveButton];
        }
    }
  
    
}
-(void)setHadClick:(NSString *)hadClick
{
    
    if (_taskType) {
        
        if ([[NSString stringWithFormat:@"%@",hadClick] isEqualToString:@"1"]) {

        }else{
            
        }
        
    }else{
        
        if ([[NSString stringWithFormat:@"%@",hadClick] isEqualToString:@"1"]) {
            [_reciveButton setImage:[UIImage imageNamed:@"reciveImage"] forState:UIControlStateNormal];
            [_reciveButton setTitle:@"已收到" forState:UIControlStateNormal];
            [_reciveButton setTitleColor:AppFontccccccColor forState:UIControlStateNormal];
            _reciveButton.userInteractionEnabled = NO;
            _reciveButton.layer.borderWidth = 0.5;
            _reciveButton.layer.borderColor = AppFontdbdbdbColor.CGColor;
            
        }
    }
    
}
//任务的样式
-(void)setTaskButtonTYpe
{
    [_reciveButton setImage:[UIImage imageNamed:@"reciveImage"] forState:UIControlStateNormal];
    [_reciveButton setTitle:@"待处理" forState:UIControlStateNormal];
    [_reciveButton setTitleColor:AppFontccccccColor forState:UIControlStateNormal];
    _reciveButton.userInteractionEnabled = NO;
    _reciveButton.layer.borderWidth = 0.5;
    _reciveButton.layer.borderColor = AppFontdbdbdbColor.CGColor;
    
    
}

@end
