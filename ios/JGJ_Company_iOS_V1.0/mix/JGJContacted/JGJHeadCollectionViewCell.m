//
//  JGJHeadCollectionViewCell.m
//  mix
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJHeadCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "JGJTime.h"
#import "UIButton+WebCache.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
#import "UILabel+JGJCopyLable.h"
#import "FDAlertView.h"
@implementation JGJHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _waitDoButton.layer.masksToBounds = YES;
    
    _waitDoButton.layer.cornerRadius = 2.5;
    
    _waitDoButton.layer.borderWidth = 1;
    
    [self.headButton addTarget:self action:@selector(clickHeadButton) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setModel:(JGJChatMsgListModel *)model
{
    _model = [JGJChatMsgListModel new];
    
    _model = model;

    _NameLable.font = [UIFont systemFontOfSize:16];
    
    _NameLable.textColor = AppFont628ae0Color;
    
    _NameLable.text = model.user_name?:@"";

//    if (model.chatListType == JGJChatListNotice) {
//        
//        _NameLable.text = [NSString stringWithFormat:@"%@\n%@",model.user_name,model.send_time?:@""];
//        
//        _NameLable.font = [UIFont systemFontOfSize:14];
//        
//        [_NameLable SetLinDepart:5];
//        
//        [_NameLable markText:model.send_time withFont:[UIFont systemFontOfSize:13] color:AppFont999999Color];
//        
//        self.TimeLable.hidden = YES;
//        
//    }
    
    UIColor *memberColor = [UIColor whiteColor];
    
    if (![NSString isEmpty:model.user_name]) {
        
        memberColor = [NSString modelBackGroundColor:model.user_name];
        
    }
    [self.headButton setMemberPicButtonWithHeadPicStr:model.head_pic memberName:model.user_name memberPicBackColor:memberColor];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
    
    _DepatLable.textColor = AppFontdbdbdbColor;
    
    if (model.chatListType == JGJChatListLog) {
        //施工日志
        _TimeLable.text =model.send_time?:@"";
 
    }else{
        
        _TimeLable.text =model.send_time?:@"";
    }
    

    
    if ([model.msg_type isEqualToString:@"task"]) {
        _TimeLable.hidden = YES;
        _waitDoButton.userInteractionEnabled = YES;
        if ([_model.task_status isEqualToString:@"1"]) {
            _waitDoButton.layer.borderColor = AppFonte83c76eColor.CGColor;
            [_waitDoButton setImage:[UIImage imageNamed:@"taskedit03"] forState:UIControlStateNormal];
            [_waitDoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -32, 0, 0)];

            [_waitDoButton setTitleColor:AppFonte83c76eColor forState:UIControlStateNormal];
            [_waitDoButton setTitle:@"已完成" forState:UIControlStateNormal];
        }else{
            _waitDoButton.layer.borderColor = AppFontFF9A35Color.CGColor;
            [_waitDoButton setTitle:@"待处理" forState:UIControlStateNormal];
            [_waitDoButton setTitleColor:AppFontFF9A35Color forState:UIControlStateNormal];
            [_waitDoButton setImage:[UIImage imageNamed:@"edit01"] forState:UIControlStateNormal];
            [_waitDoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -32, 0, 0)];
        }
        
    }else{
    _waitDoButton.hidden = YES;
    if ([model.msg_type isEqualToString:@"log"]) {
        _TimeLable.text = [NSString stringWithFormat:@"%@\n%@",model.create_time?:@"",model.week_day?:@""];
//    _TimeLable.text = [[_TimeLable.text stringByAppendingString:@"/n"] stringByAppendingString:[JGJTime getNowWeekday]];
    }
    }
    if (_closeTeam) {
        _waitDoButton.hidden = YES;
    }
    if (!_model.is_can_deal || model.IsCloseTeam) {
        if ([_model.task_status isEqualToString:@"1"]) {
            _waitDoButton.layer.borderColor = AppFonte83c76eColor.CGColor;

            [_waitDoButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_waitDoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            _waitDoButton.userInteractionEnabled = NO;
            [_waitDoButton setTitleColor:AppFonte83c76eColor forState:UIControlStateNormal];

        }else{
            [_waitDoButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_waitDoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            _waitDoButton.titleLabel.textAlignment = NSTextAlignmentCenter;

            _waitDoButton.userInteractionEnabled = NO;
            [_waitDoButton setTitleColor:AppFontFF9A35Color forState:UIControlStateNormal];
//            _waitDoButton.layer.borderColor = AppFontFF9A35Color.CGColor;
        }
        _waitDoButton.layer.borderColor = [UIColor clearColor].CGColor;

    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickNameLable)];
    _NameLable.userInteractionEnabled = YES;
    [_NameLable addGestureRecognizer:tap];
    

}
-(void)clickNameLable
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClicknameLable)]) {
        [self.delegate ClicknameLable];
    }

}
- (IBAction)clickNameButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClicknameLable)]) {
        [self.delegate ClicknameLable];
    }
}
- (IBAction)clickWaitDobutton:(id)sender {
    

    NSString *title ;
    if ([self.model.task_status isEqualToString:@"1"]) {
        title = @"你确定要将该任务修改为“待处理”状态吗？";
    }else{
        title = @"你确定要将该任务修改为“已完成”状态吗？";
        
    }
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:title delegate:self buttonTitles:@"取消",@"确定", nil];
    //    alert.tag = 1;
    [alert setMessageColor:AppFont333333Color fontSize:15];
    
    [alert show];
//    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:title message:@"请确认" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    aler.delegate = self;
//    [aler show];
}
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    }else{
        if (self.delegate &&[self.delegate respondsToSelector:@selector(ClickDetailRightnumberButton:)]) {
            [self.delegate ClickDetailRightnumberButton:_waitDoButton];
        }
        
    }
    
    alertView.delegate = nil;
    alertView = nil;
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 1:
//            if (self.delegate &&[self.delegate respondsToSelector:@selector(ClickDetailRightnumberButton:)]) {
//                [self.delegate ClickDetailRightnumberButton:_waitDoButton];
//            }
//
//            break;
//            
//        default:
//            break;
//    }
//
//}
-(void)clickHeadButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickDetailPublishManInfo)]) {
        [self.delegate clickDetailPublishManInfo];
    }
}
@end
