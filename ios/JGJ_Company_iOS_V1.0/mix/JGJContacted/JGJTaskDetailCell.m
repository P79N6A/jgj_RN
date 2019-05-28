//
//  JGJTaskDetailCell.m
//  mix
//
//  Created by yj on 2019/3/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJTaskDetailCell.h"

#import "JGJNineSquareView.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

#import "JGJCoreTextLable.h"

@interface JGJTaskDetailCell ()<JGJNineSquareViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet JGJCoreTextLable *contentLable;

@property (weak, nonatomic) IBOutlet JGJNineSquareView *thumbnailImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumnailImageViewH;

@property (weak, nonatomic) IBOutlet UIButton *userNameBtn;

@property (nonatomic, strong) JGJCoreTextModel *coreTextModel;

@end

@implementation JGJTaskDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.timeLable.textColor = AppFont999999Color;
    
    self.contentLable.textColor = AppFont999999Color;
    
    self.contentLable.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 20;
    
    self.thumbnailImageView.delegate = self;
    
    [self.userNameBtn setTitleColor:AppFont4990e2Color forState:UIControlStateNormal];
}

- (void)setListModel:(JGJQualityDetailReplayListModel *)listModel {
    
    _listModel = listModel;
    
    [self.userNameBtn setTitleColor:AppFont4990e2Color forState:UIControlStateNormal];
    
    [self.userNameBtn setTitle:listModel.user_info.real_name forState:UIControlStateNormal];
    
    self.timeLable.text = listModel.create_time;
    
    NSString *line = @"";
    if (![NSString isEmpty:listModel.reply_status_text] && ![NSString isEmpty:listModel.reply_text]) {
        
        line = @"\n";
    }
    
    NSString *replyMsg = [NSString stringWithFormat:@"%@%@%@", listModel.reply_status_text?:@"",line, listModel.reply_text];
    
    self.contentLable.text = replyMsg;
    
    //    self.coreTextModel.changeColor = AppFont999999Color;
    
    if (![NSString isEmpty:listModel.reply_status_text]) {
        
        self.coreTextModel.changeStr = listModel.reply_status_text;
        
        self.coreTextModel.changeStrFont = [UIFont systemFontOfSize:AppFont30Size];
        
    }else {
        
        self.coreTextModel.changeStr = @"";
        
    }
    
    if (![NSString isEmpty:replyMsg]) {
        
        self.contentLable.lineSpace = 5;
        
        [self.contentLable setContentTextlinkAttCoreTextModel:self.coreTextModel contentText:replyMsg];
        
    }
    
    //这里在10.3计算不准确，但是可以设置间距
    CGFloat height = [self.contentLable stringWithContentWidth:TYGetUIScreenWidth - 20 font:AppFont30Size lineSpace:5 changeStr:listModel.reply_status_text changeColor:AppFont999999Color];
    
    
    height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 20 content:self.contentLable.text font: AppFont30Size lineSpace:5];
    
    //    self.contentLableH.constant = [NSString isEmpty:self.contentLable.text] ? CGFLOAT_MIN : height;
    
    [self.thumbnailImageView imageCountLoadHeaderImageView:listModel.msg_src headViewWH:80.0 headViewMargin:5.0];
    
    self.thumbnailImageView.hidden = listModel.msg_src.count == 0;
    
    CGFloat thumnailImageViewH = listModel.msg_src.count == 0 ? CGFLOAT_MIN : [JGJNineSquareView nineSquareViewHeight:listModel.msg_src headViewWH:80.0 headViewMargin:5];
    
    self.thumnailImageViewH.constant = thumnailImageViewH;
    
    // 强制更新
    [self  layoutIfNeeded];
    
//    listModel.taskHeight =  CGRectGetMinY(self.contentLable.frame) + 21 + thumnailImageViewH + height;
//
//    if ([NSString isEmpty:self.contentLable.text]) {
//
//        listModel.taskHeight -= 10;
//    }
    
}

- (void)nineSquareView:(JGJNineSquareView *)squareView squareImages:(NSArray *)squareImages didSelectedIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(taskDetailCell:imageViews:didSelectedIndex:)]) {
        
        [self.delegate taskDetailCell:self imageViews:squareImages didSelectedIndex:index];
    }
    
}

- (IBAction)checkUserInfo:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(taskDetailCell:didSelectedUserInfoModel:)]) {
        
        [self.delegate taskDetailCell:self didSelectedUserInfoModel:self.listModel];
        
    }
    
}

@end
