//
//  JGJSystemNoticeTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/11/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSystemNoticeTableViewCell.h"

#import "UIButton+JGJUIButton.h"

#import "UIButton+WebCache.h"

#import "UIImageView+WebCache.h"

#import "UILabel+GNUtil.h"
@implementation JGJSystemNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.departLine.backgroundColor = AppFontf1f1f1Color;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJAllNoticeModel *)model
{
    NSString *noticeType;
    NSString *nrmalNoticeType;
    UIColor *typeColor;

    if ([model.reply_type isEqualToString:@"notice"]) {
       noticeType = @"[通知] ";
        nrmalNoticeType = @"通知 ";
        typeColor = AppFont4b70c1Color;

        
    }else if ([model.reply_type isEqualToString:@"log"])
    {
    
        noticeType = @"[日志] ";
        nrmalNoticeType = @"日志 ";
        typeColor = AppFonte88a36Color;


    }else if ([model.reply_type isEqualToString:@"task"])
    {
        noticeType = @"[任务] ";
        nrmalNoticeType = @"任务 ";
        typeColor = AppFont4dab75Color;

    }else if ([model.reply_type isEqualToString:@"safe"])
    {
        noticeType = @"[安全] ";
        nrmalNoticeType = @"安全 ";
        typeColor = AppFonta26bdaColor;

    }else if ([model.reply_type isEqualToString:@"quality"])
    {
        noticeType = @"[质量] ";
        nrmalNoticeType = @"质量 ";
        typeColor = AppFont45a1b1Color;

    }else if ([model.reply_type isEqualToString:@"meeting"]){
        
        noticeType = @"[会议] ";
        nrmalNoticeType = @"会议 ";
        typeColor = AppFont99bc30Color;

    }else{
        noticeType = @"";
        nrmalNoticeType = @"";
        typeColor = AppFont628ae0Color;
        
    }
    
    UIColor *memberColor = [UIColor whiteColor];
    
    if (![NSString isEmpty:model.user_info.real_name]) {
        
        memberColor = [NSString modelBackGroundColor:model.user_info.real_name];
        
    }
    [self.headBtn setMemberPicButtonWithHeadPicStr:model.user_info.head_pic memberName:model.user_info.real_name memberPicBackColor:memberColor];
    
    self.headBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    [self.headBtn.layer setLayerCornerRadius:JGJCornerRadius / 2.0];

    self.namelable.text = model.user_info.real_name;
    
    self.replylable.text = model.reply_text?:@"";
    
    self.timeLable.text = model.create_time?:@"";
    
    if (model.reply_msg.count > 0) {
        
        self.replylable.text = [NSString stringWithFormat:@"[图片]%@",model.reply_text?:@""];
        
    }
    [self.replylable markText:@"[图片]" withColor:AppFont999999Color];
    if (model.msg_src.count <= 0) {
        
        self.contentWidthConstance.constant = 0;
        self.contentLable.numberOfLines = 1;
        
    }else{
        
        [self.contenImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@media/simages/m/%@",JLGHttpRequest_UpLoadPicUrl_center_image,model.msg_src[0]?:@""]]];
        self.contentLable.numberOfLines = 2;
        
    }
    
//    model.pub_name = @"刘远强";
    
    if ([NSString isEmpty:model.msg_text]) {
        
        self.contentLable.text = [@"" stringByAppendingString: [[[model.user_info.real_name?:@"" stringByAppendingString:@"：" ] stringByAppendingString:@"发了一个"] stringByAppendingString:nrmalNoticeType?:@""] ];

    }else{
    
        self.contentLable.text =[[[noticeType?:@"" stringByAppendingString:model.pub_name?:@""] stringByAppendingString:@"："]stringByAppendingString: model.msg_text?:@""];
    }
    
    self.contentLable.textColor = AppFont666666Color;
    
    [self.contentLable markMoreText:model.pub_name?:@"" withColor:AppFont333333Color];

    [self.contentLable markMoreText:model.msg_text?:@"" withColor:AppFont666666Color];
    
    [self.contentLable markMoreText:noticeType?:@"" withColor:typeColor];
    
    self.namelable.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickNameLable:)];
    
    [self.namelable addGestureRecognizer:tap];
    
    //删除的消息
    
    if (model.is_delete) {
        
        self.replylable.text = model.reply_text?:@"";
        
        self.replylable.textColor = AppFont999999Color;
        
    }

}
- (IBAction)clickHeadBtn:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHedPickBtn:)]) {
        
        [self.delegate clickHedPickBtn:button.tag];
    }
}
-(void)clickNameLable:(UIGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickreplyUserNameLable:)]) {
        [self.delegate clickreplyUserNameLable:recognizer.view.tag];
    }
}
@end
