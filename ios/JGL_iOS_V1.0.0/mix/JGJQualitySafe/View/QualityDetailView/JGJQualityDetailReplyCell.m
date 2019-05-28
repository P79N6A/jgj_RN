//
//  JGJQualityDetailReplyCell.m
//  mix
//
//  Created by yj on 2017/6/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityDetailReplyCell.h"

#import "JGJNineSquareView.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

#import "JGJCoreTextLable.h"

@interface JGJQualityDetailReplyCell ()<JGJNineSquareViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet JGJCoreTextLable *contentLable;

@property (weak, nonatomic) IBOutlet JGJNineSquareView *thumbnailImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLableH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumnailImageViewH;

@property (weak, nonatomic) IBOutlet UIButton *userNameBtn;

@property (nonatomic, strong) JGJCoreTextModel *coreTextModel;

@end

@implementation JGJQualityDetailReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLable.textColor = TYColorHex(0X4990e2);
    
    self.timeLable.textColor = AppFont999999Color;
    
    self.contentLable.textColor = AppFont999999Color;
    
    self.contentLable.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 20;
    
    self.thumbnailImageView.delegate = self;
    
    [self.userNameBtn setTitleColor:AppFont4990e2Color forState:UIControlStateNormal];
    
}

- (void)setListModel:(JGJQualityDetailReplayListModel *)listModel {

    _listModel = listModel;
    
    self.nameLable.text = listModel.user_info.real_name;
    
//    NSString *myUserId = [TYUserDefaults objectForKey:JLGUserUid];
    
    [self.userNameBtn setTitleColor:AppFont4990e2Color forState:UIControlStateNormal];
    
//    if ([listModel.user_info.uid isEqualToString:myUserId]) {
//        
//        [self.userNameBtn setTitleColor:AppFont666666Color forState:UIControlStateNormal];
//        
//    }
    
    [self.userNameBtn setTitle:listModel.user_info.real_name forState:UIControlStateNormal];
    
    self.timeLable.text = listModel.create_time;

    NSString *line = @"";
    if (![NSString isEmpty:listModel.reply_status_text] && ![NSString isEmpty:listModel.reply_text]) {
        
        line = @"\n";
    }
    
    NSString *replyMsg = [NSString stringWithFormat:@"%@%@%@", listModel.reply_status_text,line, listModel.reply_text];
    
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
    
    listModel.cellHeight =  CGRectGetMinY(self.contentLable.frame) + 21 + thumnailImageViewH + height;
    
    if ([NSString isEmpty:self.contentLable.text]) {
        
        listModel.cellHeight -= 10;
    }
    
}

- (void)nineSquareView:(JGJNineSquareView *)squareView squareImages:(NSArray *)squareImages didSelectedIndex:(NSInteger)index {

    if ([self.delegate respondsToSelector:@selector(qualityDetailReplyCell:imageViews:didSelectedIndex:)]) {
        
        [self.delegate qualityDetailReplyCell:self imageViews:squareImages didSelectedIndex:index];
    }

}

- (IBAction)checkUserInfo:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(qualityDetailReplyCell:didSelectedUserInfoModel:)]) {
        
        [self.delegate qualityDetailReplyCell:self didSelectedUserInfoModel:self.listModel];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (JGJCoreTextModel *)coreTextModel {
    
    if (!_coreTextModel) {
        
        _coreTextModel = [JGJCoreTextModel new];
    }
    
    return _coreTextModel;
}

@end
