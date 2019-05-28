//
//  JGJActivityMsgCell.m
//  mix
//
//  Created by yj on 2018/7/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJActivityMsgCell.h"

#import "JGJCusYyLable.h"
#import "NSDate+Extend.h"
@interface JGJActivityMsgCell()

@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;

@property (weak, nonatomic) IBOutlet JGJCusYyLable *act_title;

@property (weak, nonatomic) IBOutlet JGJCusYyLable *act_des;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actImageViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *act_titleH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskingH;

@property (weak, nonatomic) IBOutlet UILabel *checkTitle;
@property (weak, nonatomic) IBOutlet UILabel *activity_time;
@property (weak, nonatomic) IBOutlet UIView *bottomContainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *des_contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeWidth;
@property (weak, nonatomic) IBOutlet UIImageView *maskingView;

@end

@implementation JGJActivityMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.activity_time.clipsToBounds = YES;
    self.activity_time.layer.cornerRadius = 5;
    
    self.act_title.numberOfLines = 2;
    self.act_des.numberOfLines = 5;
    
    self.act_des.font = [UIFont systemFontOfSize:AppFont32Size];
    
    self.checkTitle.textColor = AppFont000000Color;
    
    self.act_des.preferredMaxLayoutWidth = TYGetUIScreenWidth - 50;
    self.act_title.preferredMaxLayoutWidth = TYGetUIScreenWidth - 50;
    
    self.act_title.textContainerInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.act_des.textContainerInset = UIEdgeInsetsMake(15, 15, 0, 15);
    
    self.act_title.userInteractionEnabled = NO;
    self.activityImageView.userInteractionEnabled = NO;
    self.act_des.userInteractionEnabled = NO;
}

#pragma mark - 子类使用
- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    
    self.act_des.text = jgjChatListModel.detail;
    
    self.act_title.text = jgjChatListModel.title;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 3.0;
    shadow.shadowOffset = CGSizeMake(1, 1);
    shadow.shadowColor = [UIColor blackColor];
    NSAttributedString *attributeText = [[NSAttributedString alloc] initWithString:self.act_title.text attributes:@{NSShadowAttributeName:shadow}];
    self.act_title.attributedText = attributeText;
    
    self.activity_time.text = [NSDate chatShowDateWithTimeStamp:jgjChatListModel.send_time];
    
    CGFloat activity_timeWidth = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 20) content:self.activity_time.text font:AppFont30Size].width;
    
    self.timeWidth.constant = activity_timeWidth + 15;
    
    CGFloat des_height = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 50 font:AppFont32Size lineSpace:5 content:jgjChatListModel.detail];
    UIFont *font = [UIFont systemFontOfSize:AppFont32Size];
    if (jgjChatListModel.detail.length == 0) {
        
        des_height = 0;
        
    }else if (des_height >= 5 * font.lineHeight) {
        
        des_height = 5 * font.lineHeight + 15;
    }else {
        
        des_height = + des_height + 15;
    }
    
    [self jgj_updateConstraint:self.des_contentHeight withConstant:des_height];
    
    NSURL *imgUrl = [NSURL new];
    
    if (jgjChatListModel.msg_src.count != 0) {
        
        imgUrl = [NSURL URLWithString:[JLGHttpRequest_IP_center stringByAppendingString:jgjChatListModel.msg_src.firstObject]];
    }
    
    [self.activityImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"defaultPic"]];
    CGFloat imageH = 0.563 * (TYGetUIScreenWidth - 20);
    [self jgj_updateConstraint:self.actImageViewHeight withConstant:imageH];
    
    self.act_title.backgroundColor = [UIColor clearColor];
    [self.act_des setContent:jgjChatListModel.detail lineSpace:5];
    self.act_des.backgroundColor = [UIColor whiteColor];
    self.act_title.textColor = AppFontfafafaColor;
    self.act_des.textColor = AppFont666666Color;
    self.act_title.font = [UIFont boldSystemFontOfSize:AppFont32Size];
    
    if (jgjChatListModel.title.length != 0) {
        
        CGFloat titleH = [JGJCusYyLable stringWithContent:jgjChatListModel.title width:TYGetUIScreenWidth - 50 font:AppFont32Size lineSpace:0];
        if (titleH >= 2 * font.lineHeight) {
            
            titleH = 2 * font.lineHeight + 10;
        }else {
            
            titleH = titleH + 15;
        }
        [self jgj_updateConstraint:self.act_titleH withConstant:titleH];
        [self jgj_updateConstraint:self.maskingH withConstant:titleH + 20];
    }
    self.maskingView.alpha = 0.6;
}


- (void)jgj_updateConstraint:(NSLayoutConstraint *)constraint withConstant:(CGFloat)constant
{
    if (constraint.constant == constant) {
        
        return;
    }
    
    constraint.constant = constant;
}

@end

