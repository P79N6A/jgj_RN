//
//  JGJWaitTaskCell.m
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWaitTaskCell.h"

#import "JGJQualityMsgListCell.h"

#import "JGJQualityMsgListImageView.h"

#import "UIButton+JGJUIButton.h"

#import "NSString+Extend.h"

#import "UIImageView+WebCache.h"

#import "UILabel+GNUtil.h"

#define Padding  10

#define ThumbnailImageViewWH (TYGetUIScreenWidth - Padding * 7) / 4.0

#define MaxLayoutWidth  TYGetUIScreenWidth - 40

@interface JGJWaitTaskCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *levelLable;

@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet UILabel *finishTimeLable;

@property (weak, nonatomic) IBOutlet JGJQualityMsgListImageView *thumbnailImageView;

@property (strong ,nonatomic) NSMutableArray *thumbnails;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailImageViewH;

@property (weak, nonatomic) IBOutlet UIView *contentBottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBottomViewH;

//负责人
@property (weak, nonatomic) IBOutlet UILabel *prinLable;

@property (weak, nonatomic) IBOutlet UIView *contentInfoView;


@end

@implementation JGJWaitTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.levelLable.textColor = AppFont999999Color;
    
    self.finishTimeLable.textColor = AppFont999999Color;
    
    self.timeLable.textColor = AppFont999999Color;
    
    self.thumbnailImageView.backgroundColor = [UIColor whiteColor];
    
    self.contentLable.backgroundColor = [UIColor whiteColor];
    
    [self.headButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    
    self.bottomLineView.backgroundColor = AppFontf1f1f1Color;
    
    self.contentLable.textColor = AppFont333333Color;
    
    self.contentLable.preferredMaxLayoutWidth = MaxLayoutWidth;
    
    CGFloat padding = 10;
    CGFloat thumbnailImageViewWH = ThumbnailImageViewWH;
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
    
    [self.contentInfoView.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
}

- (void)setTaskModel:(JGJTaskModel *)taskModel {

    _taskModel = taskModel;
    
    UIColor *memberColor = [NSString modelBackGroundColor:taskModel.pub_user_info.real_name];
    
    [self.headButton setMemberPicButtonWithHeadPicStr:taskModel.pub_user_info.head_pic memberName:taskModel.pub_user_info.real_name memberPicBackColor:memberColor membertelephone:taskModel.pub_user_info.telephone];
    
    if ([taskModel.task_status isEqualToString:@"1"]) {
        
        taskModel.waitTaskCellType = WaitTaskCellCompleteType;
        
    }else {
        
        taskModel.waitTaskCellType = WaitTaskCellDefaultType;
    }
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    
//    self.nameLable.text = taskModel.pub_user_info.real_name;
    
    self.nameLable.text = [NSString cutWithContent:taskModel.pub_user_info.real_name maxLength:4];
    
    self.timeLable.text = taskModel.create_time;
    
    self.contentLable.text = taskModel.task_content;
    
    if (![NSString isEmpty:taskModel.principal_user_info.real_name] ) {
        
        NSString *realname = [NSString cutWithContent:taskModel.principal_user_info.real_name maxLength:4];

        self.prinLable.text = [NSString stringWithFormat:@"由%@负责",realname];
        
        [self.prinLable markText:realname withColor:AppFont4990e2Color];
        
    }else {
        
        self.prinLable.text = @"";
    }
    
    NSString *severity = @"";
    
    self.levelLable.textColor = [UIColor whiteColor];
    
    self.finishTimeLable.text = [NSString stringWithFormat:@"%@ %@", ([NSString isEmpty:taskModel.task_finish_time] ? @"": @"整改完成期限: "), taskModel.task_finish_time];
    
    self.levelLable.hidden = NO;
    
    //紧急和非常紧急的颜色
    NSString *levelFlag = @"";
    UIColor *levelColor = AppFont333333Color;
    if ([taskModel.task_level isEqualToString:@"1"]) {
        
        self.levelLable.hidden = YES;
        
        levelColor = [UIColor whiteColor];
        
    }else if ([taskModel.task_level isEqualToString:@"2"]) {
        
        levelFlag = @"[紧急]";
        
        levelColor = TYColorHex(0XF9A00F);
        
    }else if ([taskModel.task_level isEqualToString:@"3"]) {
        
        levelFlag = @"[非常紧急]";
        
        levelColor = AppFontEB4E4EColor;
    }else {
        
        self.levelLable.hidden = YES;
        
        levelColor = [UIColor whiteColor];
    }


    UIColor *finishTimeColor = AppFont999999Color;
    
    if ([taskModel.task_finish_time_type isEqualToString:@"0"]) {
        
        finishTimeColor = AppFont999999Color;
        
    }else if ([taskModel.task_finish_time_type isEqualToString:@"1"]) {
        
        finishTimeColor = AppFontEB4E4EColor;
        
    }else if ([taskModel.task_finish_time_type isEqualToString:@"2"]) {
        
        finishTimeColor =  AppFontF9A00FColor;
        
    }else if ([taskModel.task_finish_time_type isEqualToString:@"3"]) {

        finishTimeColor = AppFont83C76EColor;
        
    }else {
        
        finishTimeColor = AppFont999999Color;
        
    }

    self.levelLable.text = levelFlag;
    
    self.levelLable.textColor = levelColor;
    
    self.finishTimeLable.textColor = finishTimeColor;
    
    //    [self.thumbnailImageView qualityMsgListImageViews:listModel.msg_src];
    
    NSString *thumbnailsurl = @"";
    
    for (UIImageView *imageView in self.thumbnails) {
        
        NSInteger index = imageView.tag - 100;
        imageView.hidden = NO;
        if (taskModel.msg_src.count > 3) {
            
            if (index == 3) {
                
                imageView.image = [UIImage imageNamed:@"more_ thumbnail_Icon"];
                
                break;
                
            }else {
                
                thumbnailsurl = taskModel.msg_src[index];
                
                NSString *clipStr = [NSString stringWithFormat:@"%@%@/%@/", JLGHttpRequest_UpLoadPicUrl_center_image,@"media/simages/m", thumbnailsurl];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:clipStr] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
                
            }
            
        }else if(index < taskModel.msg_src.count){
            
            thumbnailsurl = taskModel.msg_src[index];
            
            NSString *clipStr = [NSString stringWithFormat:@"%@%@/%@/", JLGHttpRequest_UpLoadPicUrl_center_image,@"media/simages/m", thumbnailsurl];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:clipStr] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
            
        }else {
            
            imageView.hidden = YES;
        }
        
    }
    
    CGFloat thumbnailImageViewWH = ThumbnailImageViewWH ;
    
    CGFloat thumbnailImageViewHeight = taskModel.msg_src.count == 0 ? CGFLOAT_MIN : thumbnailImageViewWH;
    
    self.thumbnailImageViewH.constant = thumbnailImageViewHeight;
    
// 计算当前cell的高度
    
    CGFloat bottomHeight = 77.5;
    
    self.contentBottomViewH.constant = 46.5;
    
    self.contentBottomView.hidden = NO;
    
    //已完成、和没有时间状态一般没有减少
    if (([NSString isEmpty:taskModel.task_finish_time] && [taskModel.task_level isEqualToString:@"1"]) || (taskModel.waitTaskCellType == WaitTaskCellCompleteType)) {
        
        bottomHeight -= 46.5;
        
        self.contentBottomViewH.constant = 0;
        
        self.contentBottomView.hidden = YES;
    }
    
    CGFloat contentHeight = [NSString stringWithContentWidth:MaxLayoutWidth content:self.contentLable.text font:AppFont30Size];
    
    UIFont *contentFont = self.contentLable.font;
    
    CGFloat maxH = contentFont.lineHeight * 2;
    
    maxH = contentHeight > maxH ? maxH : contentHeight;
    
    maxH += 15;
    
    if ([NSString isEmpty:taskModel.task_content]) {
        
        maxH = CGFLOAT_MIN;
    }
    // 强制更新
    [self.contentLable  layoutIfNeeded];
    
    [self.thumbnailImageView  layoutIfNeeded];
    
    taskModel.taskHeight = 68 + bottomHeight + thumbnailImageViewHeight + maxH ;
    
    //根据类型改变颜色
    [self cellTypeChangeFontTaskModelColor:taskModel];
}

- (void)cellTypeChangeFontTaskModelColor:(JGJTaskModel *)taskModel {

    self.contentLable.textColor = AppFont333333Color;
    
    self.nameLable.textColor = AppFont333333Color;
        
    CGFloat oldAlpha = 1.0;
    
    CGFloat alpha = 0.5;
    
    self.headButton.alpha = oldAlpha;
    
    self.thumbnailImageView.alpha = oldAlpha;
    
    self.nameLable.alpha = oldAlpha;
    
    self.prinLable.alpha = oldAlpha;
    
    self.contentLable.alpha = oldAlpha;
    
    self.timeLable.alpha = oldAlpha;

    if (taskModel.waitTaskCellType == WaitTaskCellCompleteType) {
        
        if (![NSString isEmpty:taskModel.principal_user_info.real_name] ) {
            
            self.prinLable.text = [NSString stringWithFormat:@"由%@负责",taskModel.principal_user_info.real_name];
            
            [self.prinLable markText:taskModel.principal_user_info.real_name withColor:AppFont999999Color];
            
        }else {
            
            self.prinLable.text = @"";
        }
        
        self.contentLable.textColor = AppFont999999Color;
        
        self.finishTimeLable.textColor = AppFont999999Color;
        
        self.nameLable.textColor = AppFont999999Color;
        
        self.levelLable.textColor = AppFont999999Color;
        
        self.headButton.alpha = alpha;
        
        self.thumbnailImageView.alpha = alpha;
        
        self.nameLable.alpha = alpha;
        
        self.prinLable.alpha = alpha;
        
        self.contentLable.alpha = alpha;
        
        self.timeLable.alpha = alpha;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
