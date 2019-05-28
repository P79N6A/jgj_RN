//
//  JGJQuaSafeCheckRecordPathCell.m
//  JGJCompany
//
//  Created by yj on 2017/11/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckRecordPathCell.h"

#import "JGJNineSquareView.h"

@interface JGJQuaSafeCheckRecordPathCell () <JGJNineSquareViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *statusLable;

@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet JGJNineSquareView *thumbnailView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLableH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLableBottom;

@property (weak, nonatomic) IBOutlet UIButton *expandButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLableH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLableTop;
@end

@implementation JGJQuaSafeCheckRecordPathCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.thumbnailView.delegate = self;
    
    self.timeLable.textColor = AppFont999999Color;
    
    self.timeLable.backgroundColor = [UIColor whiteColor];
    
    self.contentLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 118;
        
    self.contentLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.thumbnailView.backgroundColor = [UIColor whiteColor];
    
    self.rightTopLineView.backgroundColor = AppFontccccccColor;
    
    self.rightBottomLineView.backgroundColor = AppFontccccccColor;
    
    self.expandButton.adjustsImageWhenHighlighted = NO;
}

- (void)setListModel:(JGJInspectPlanRecordPathReplyModel *)listModel {
    
    _listModel = listModel;
    
    [self setContentWithListModel:listModel];
    
//    [self setContentFrameWithListModel:listModel];
    
}

- (void)setContentWithListModel:(JGJInspectPlanRecordPathReplyModel *)listModel {
    
    NSString *username = [NSString cutWithContent:listModel.user_info.real_name maxLength:4];
    
    self.nameLable.text = [NSString stringWithFormat:@"%@ %@", username,listModel.user_info.telephone];
    
    self.timeLable.text = listModel.update_time;
    
    self.contentLable.text = listModel.comment;

    [self setStatusWithListModel:listModel];
    
    [self.thumbnailView imageCountLoadHeaderImageView:listModel.imgs headViewWH:80 headViewMargin:5];
    
    [self confExpandImageView:listModel];
    
    self.contentLable.hidden = !listModel.isExpand;
    
    self.thumbnailView.hidden = !listModel.isExpand;
    
}

- (void)setStatusWithListModel:(JGJInspectPlanRecordPathReplyModel *)replyModel {
    
    UIColor *statusColor = AppFont999999Color;
    
    NSString *status = @"";
    
    if ([replyModel.status isEqualToString:@"0"]) {
        
        status = @"[未检查]";
        
    }else if ([replyModel.status isEqualToString:@"1"]) {
        
        statusColor = AppFontFF0000Color;
        
        status = @"[待整改]";
        
    }else if ([replyModel.status isEqualToString:@"2"]) {
        
        status = @"[不用检查]";
        
    }else if ([replyModel.status isEqualToString:@"3"]) {
        
        statusColor = AppFont83C76EColor;
        
        status = @"[通过]";
    }
    
    self.statusLable.textColor = statusColor;
    
    self.statusLable.text = status;
}

- (void)setContentFrameWithListModel:(JGJInspectPlanRecordPathReplyModel *)listModel {
    
    self.contentLableH.constant = listModel.contentHeight;
    
    self.contentLableBottom.constant = 7;
    
    self.contentLableTop.constant = 65;
    
    //微调缩略图到时间的间隔
    if ([NSString isEmpty:listModel.comment]) {
        
        self.contentLableBottom.constant = 0;
        
        self.contentLableTop.constant = 45;
    }
    
    self.thumbnailViewBottom.constant = 15;
    
    if (listModel.imgs.count == 0) {
        
        self.thumbnailViewBottom.constant = 0;
    }
    
    self.timeLableH.constant = 18;
}

- (IBAction)expandButtonPressed:(UIButton *)sender {
    
    self.listModel.isExpand = !self.listModel.isExpand;
        
    if (!self.listModel.isExpand) {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
    }else {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(0);
    }
    
    if ([self.delegate respondsToSelector:@selector(JGJQuaSafeCheckRecordPathCell:listModel:)]) {
        
        [self.delegate JGJQuaSafeCheckRecordPathCell:self listModel:self.listModel];
    }
    
}

- (void)confExpandImageView:(JGJInspectPlanRecordPathReplyModel *)listModel {
    
    if (self.listModel.isExpand) {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
    }else {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)nineSquareView:(JGJNineSquareView *)squareView squareImages:(NSArray *)squareImages didSelectedIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(JGJQuaSafeCheckRecordPathCell:imageViews:didSelectedIndex:)]) {
        
        [self.delegate JGJQuaSafeCheckRecordPathCell:self imageViews:squareImages didSelectedIndex:index];
    }
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self setContentFrameWithListModel:self.listModel];
    
    [self.contentView layoutIfNeeded];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
