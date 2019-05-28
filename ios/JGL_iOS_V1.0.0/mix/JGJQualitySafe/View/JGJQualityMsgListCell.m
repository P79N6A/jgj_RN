//
//  JGJQualityMsgListCell.m
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityMsgListCell.h"

#import "JGJQualityMsgListImageView.h"

#import "UIButton+JGJUIButton.h"

#import "NSString+Extend.h"

#import "UIImageView+WebCache.h"

#import "UILabel+GNUtil.h"

@interface JGJQualityMsgListCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *levelLable;

@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet UILabel *finishTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *taskStatusLable;

@property (weak, nonatomic) IBOutlet JGJQualityMsgListImageView *thumbnailImageView;

@property (strong ,nonatomic) NSMutableArray *thumbnails;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailImageViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLableH;

@property (weak, nonatomic) IBOutlet UIView *contentBottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBottomViewH;

//负责人
@property (weak, nonatomic) IBOutlet UILabel *prinLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishLeading;

@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;


@end

@implementation JGJQualityMsgListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.levelLable.textColor = AppFont999999Color;
    
    self.finishTimeLable.textColor = AppFont999999Color;
    
    self.taskStatusLable.textColor = AppFont999999Color;
    
    self.timeLable.textColor = AppFont999999Color;
    
    self.thumbnailImageView.backgroundColor = [UIColor whiteColor];
    
    self.contentLable.backgroundColor = [UIColor whiteColor];
    
    [self.headButton.layer setLayerCornerRadius:2.5];
    
    self.bottomLineView.backgroundColor = AppFontf1f1f1Color;
    
    self.contentLable.textColor = AppFont333333Color;
    
    self.contentLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 20;
    
    CGFloat padding = 10;
    CGFloat thumbnailImageViewWH = (TYGetUIScreenWidth - 40) / 4.0;
    NSMutableArray *thumbnails = [NSMutableArray new];
    self.thumbnails = thumbnails;
    for (NSInteger indx = 0; indx < 4; indx ++) {
        
        UIImageView *thumbnailImageView = [[UIImageView new] init];
        
        thumbnailImageView.tag = 100 + indx;
        
        thumbnailImageView.backgroundColor = [UIColor whiteColor];
        
        [thumbnails addObject:thumbnailImageView];
        
        [self.thumbnailImageView addSubview:thumbnailImageView];
    }
    
    [thumbnails mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:10 tailSpacing:10];
    
    [thumbnails mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.thumbnailImageView .mas_top).mas_offset(0);
        
        make.width.height.mas_equalTo(thumbnailImageViewWH);
        
    }];
}

- (void)setListModel:(JGJQualitySafeListModel *)listModel {

    _listModel = listModel;
    
    UIColor *memberColor = [NSString modelBackGroundColor:listModel.real_name];
    
    [self.headButton setMemberPicButtonWithHeadPicStr:listModel.head_pic memberName:listModel.real_name memberPicBackColor:memberColor membertelephone:listModel.telephone];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont32Size];
    
    NSString *realName = [NSString cutWithContent:listModel.real_name maxLength:4];
    
    self.nameLable.text = realName;
    
    self.timeLable.text = listModel.update_time;
    
    self.contentLable.text = listModel.msg_text;
    
    if (![NSString isEmpty:listModel.user_info.real_name] ) {
     
        NSString *prinName = [NSString cutWithContent:listModel.user_info.real_name maxLength:4];
        
        self.prinLable.text = [NSString stringWithFormat:@"由%@负责",prinName];
        
        [self.prinLable markText:prinName withColor:AppFont4990e2Color];
        
    }else {
    
       self.prinLable.text = @"";
    }
    
    NSString *severity = @"";
    
    self.levelLable.textColor = [UIColor whiteColor];
    
    CGFloat finishTimeLableLeading = 0;
    
    if ([listModel.severity isEqualToString:@"2"]) {
        
        severity = @"[严重]";
        
        self.levelLable.textColor = AppFontd7252cColor;
        
        finishTimeLableLeading = 10;
    }
    
    self.finishLeading.constant = finishTimeLableLeading;
    
    self.levelLable.text = severity;
    
    self.finishTimeLable.text = [NSString stringWithFormat:@"%@ %@", ([NSString isEmpty:listModel.finish_time] ? @"": @"整改完成期限: "), listModel.finish_time];
    
    self.taskStatusLable.text = listModel.statu_text;
    
    UIColor *statuColor = AppFont999999Color;
    
    UIColor *finishTimeColor = AppFont333333Color;
    
//    if ([listModel.finish_time_status isEqualToString:@"1"]) {
//
//        finishTimeColor = AppFontEB4E4EColor;
//
//    }else if ([listModel.finish_time_status isEqualToString:@"2"]) {
//
//        finishTimeColor =  TYColorHex(0xf9a00f);
//
//    }else {
//
//        finishTimeColor = AppFont999999Color;
//    }
    
    self.taskStatusLable.textColor = statuColor;
    
    self.finishTimeLable.textColor = finishTimeColor;
    
//    [self.thumbnailImageView qualityMsgListImageViews:listModel.msg_src];
    
    NSString *thumbnailsurl = @"";
    
    for (UIImageView *imageView in self.thumbnails) {
        
        NSInteger index = imageView.tag - 100;
        imageView.hidden = NO;
        if (listModel.msg_src.count > 3) {
            
            if (index == 3) {
                
                imageView.image = [UIImage imageNamed:@"more_ thumbnail_Icon"];
                
                break;
                
            }else {
                
                thumbnailsurl = listModel.msg_src[index];
                
                NSString *clipStr = [NSString stringWithFormat:@"%@%@/%@/", JLGHttpRequest_UpLoadPicUrl_center_image,@"media/simages/m", thumbnailsurl];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:clipStr] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
                
            }
            
        }else if(index < listModel.msg_src.count){
            
            thumbnailsurl = listModel.msg_src[index];
            
            NSString *clipStr = [NSString stringWithFormat:@"%@%@/%@/", JLGHttpRequest_UpLoadPicUrl_center_image,@"media/simages/m", thumbnailsurl];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:clipStr] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
            
        }else {
            
            imageView.hidden = YES;
        }
        
    }
    
    CGFloat thumbnailImageViewWH = (TYGetUIScreenWidth - 40) / 4.0 ;
    
    CGFloat thumbnailImageViewHeight = listModel.msg_src.count == 0 ? CGFLOAT_MIN : thumbnailImageViewWH;
    
    self.thumbnailImageViewH.constant = thumbnailImageViewHeight;
    
//    // 计算当前cell的高度
    
    CGFloat bottomHeight = 77.5;
    
    self.contentBottomViewH.constant = 46.5;
    
    self.contentBottomView.hidden = NO;
    if ([NSString isEmpty:listModel.finish_time] && [NSString isEmpty:listModel.statu_text]) {
        
        bottomHeight -= 46.5;
        
        self.contentBottomViewH.constant = 0;
        
        self.contentBottomView.hidden = YES;
    }
    
    CGFloat contentHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 20 content:self.contentLable.text font:AppFont30Size];
    
    UIFont *contentFont = self.contentLable.font;
    
    CGFloat maxH = contentFont.lineHeight * 2;
    
    maxH = contentHeight > maxH ? maxH : contentHeight;
    
    maxH += 15;
    
    if ([NSString isEmpty:listModel.msg_text]) {
    
        maxH = CGFLOAT_MIN;
    }
    // 强制更新
    [self.contentLable  layoutIfNeeded];
    
    [self.thumbnailImageView  layoutIfNeeded];
    
    listModel.cellHeight = 68 + bottomHeight + thumbnailImageViewHeight + maxH ;
    
    [self alertImageViewWithListModel:listModel];
}

- (void)alertImageViewWithListModel:(JGJQualitySafeListModel *)listModel {
    
    NSString *show_bell = @"";
    
    self.alertImageView.hidden = NO;
    
    UIColor *statuColor = AppFont999999Color;
    
    if ([listModel.show_bell isEqualToString:@"1"]) {
        
        show_bell = @"tip_red_icon";
        
        statuColor = AppFontEB4E4EColor; //红
        
    }else if ([listModel.show_bell isEqualToString:@"2"]) {
        
        show_bell = @"tip_yellow_icon";
        
        statuColor = TYColorHex(0xf9a00f); //黄
        
    }else if ([listModel.show_bell isEqualToString:@"3"]) {
        
        show_bell = @"tip_green_icon";
        
        statuColor = TYColorHex(0x83c76e); //绿
        
    }else {
        
        self.alertImageView.hidden = YES;
    }
    
     self.taskStatusLable.textColor = statuColor;
    
    self.alertImageView.image = [UIImage imageNamed:show_bell];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
