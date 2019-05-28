//
//  JGJWaitTaskThumCell.m
//  JGJCompany
//
//  Created by yj on 2017/6/12.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWaitTaskThumCell.h"

#import "JGJQualityMsgListImageView.h"

#import "UIImageView+WebCache.h"

#import "NSString+Extend.h"

#import "UIButton+JGJUIButton.h"

#define thumbnailImageViewWH  (TYGetUIScreenWidth - 30 - 105) / 4.0

@interface JGJWaitTaskThumCell ()


@property (strong, nonatomic) NSMutableArray *thumbnails;

@property (weak, nonatomic) IBOutlet JGJQualityMsgListImageView *thumImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailImageViewH;

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UILabel *finishTimeLable;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end

@implementation JGJWaitTaskThumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.finishTimeLable.layer setLayerCornerRadius:2.5];
    CGFloat padding = 10;
    NSMutableArray *thumbnails = [NSMutableArray new];
    self.thumbnails = thumbnails;
    for (NSInteger indx = 0; indx < 4; indx ++) {
        
        UIImageView *thumbnailImageView = [[UIImageView new] init];
        
        thumbnailImageView.tag = 100 + indx;
        
        thumbnailImageView.backgroundColor = [UIColor whiteColor];
        
        [thumbnails addObject:thumbnailImageView];
        
        [self.thumImageView addSubview:thumbnailImageView];
    }
    
    [thumbnails mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:10 tailSpacing:10];
    
    [thumbnails mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).mas_offset(15);
        
        make.width.mas_equalTo(thumbnailImageViewWH);
        
        make.height.mas_equalTo(thumbnailImageViewWH);
        
    }];
    
    [self.headButton.layer setLayerCornerRadius:2.5];
    
    [self.selectedBtn setImage:[UIImage imageNamed:@"OldSelected"] forState:UIControlStateSelected];
    
    self.finishTimeLable.textColor = [UIColor whiteColor];
}

- (void)setTaskModel:(JGJTaskModel *)taskModel {

    _taskModel = taskModel;
    
    self.selectedBtn.selected = taskModel.isSelectedTask;
    
    BOOL isHiddenImageView = ![NSString isEmpty:_taskModel.task_content];
    
    if ([taskModel.principal_user_info.uid isEqualToString:@"0"]) {
        
        [self.headButton setBackgroundImage:[UIImage imageNamed:@"wait_task_member_icon"] forState:UIControlStateNormal];
        
    }else {
        
        UIColor *memberColor = [NSString modelBackGroundColor:taskModel.principal_user_info.real_name];
        
        [self.headButton setMemberPicButtonWithHeadPicStr:taskModel.principal_user_info.head_pic memberName:taskModel.principal_user_info.real_name memberPicBackColor:memberColor membertelephone:@""];
        
    }
    
    self.thumImageView.hidden = isHiddenImageView;
    
    NSString *thumbnailsurl = @"";
    
    for (UIImageView *imageView in self.thumbnails) {
        
        NSInteger index = imageView.tag - 100;
        imageView.hidden = ![NSString isEmpty:_taskModel.task_content];
        if (_taskModel.msg_src.count > 3) {
            
            if (index == 3) {
                
                imageView.image = [UIImage imageNamed:@"more_ thumbnail_Icon"];
                
                break;
                
            }else {
                
                thumbnailsurl = _taskModel.msg_src[index];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:[JLGHttpRequest_UpLoadPicUrl_center_image stringByAppendingString:thumbnailsurl]] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
                
            }
            
        }else if(index < _taskModel.msg_src.count){
            
            thumbnailsurl = _taskModel.msg_src[index];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[JLGHttpRequest_UpLoadPicUrl_center_image stringByAppendingString:thumbnailsurl]] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
        }else {
            
            imageView.hidden = YES;
        }
        
    }
    
    [self setTimeBackGround:taskModel];
    
    _taskModel.taskHeight = thumbnailImageViewWH + 35;
    
    if (taskModel.msg_src.count > 0 && ![NSString isEmpty:taskModel.task_finish_time]) {
        
        _taskModel.taskHeight = thumbnailImageViewWH + 70.0;
        
    }else if (taskModel.msg_src.count > 0 && [NSString isEmpty:taskModel.task_finish_time]) {
    
        _taskModel.taskHeight = thumbnailImageViewWH + 35;
        
    }
    
}


#pragma mark - 设置文字背景色
- (void)setTimeBackGround:(JGJTaskModel *)taskModel {
    
    self.finishTimeLable.hidden = NO;
    
    self.finishTimeLable.text = [NSString stringWithFormat:@"完成期限 %@", taskModel.task_finish_time];
    
    if ([taskModel.task_finish_time_type isEqualToString:@"0"] || [NSString isEmpty:taskModel.task_finish_time]) {
        
        self.finishTimeLable.backgroundColor = AppFont999999Color;
        
        self.finishTimeLable.hidden = YES;
        
        [self.thumbnails mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(15);
            
            make.width.mas_equalTo(thumbnailImageViewWH);
            
            make.height.mas_equalTo(thumbnailImageViewWH);
            
        }];
        
    }else if ([taskModel.task_finish_time_type isEqualToString:@"1"]) {
        
        self.finishTimeLable.backgroundColor = AppFontEB4E4EColor;
        
    }else if ([taskModel.task_finish_time_type isEqualToString:@"2"]) {
        
        self.finishTimeLable.backgroundColor = AppFontF9A00FColor;
    }else if ([taskModel.task_finish_time_type isEqualToString:@"3"]) {
        
        self.finishTimeLable.backgroundColor = AppFont83C76EColor;
    }else {
        
        self.finishTimeLable.backgroundColor = AppFont666666Color;
    }
    
    CGFloat finishTimeLableW = [NSString stringWithContentSize:CGSizeMake(160, 40) content:self.finishTimeLable.text font:AppFont24Size].width;
    [self.finishTimeLable mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(finishTimeLableW + 20);
    }];
    
    [self.finishTimeLable layoutIfNeeded];
    
}

- (IBAction)changeTaskStatus:(UIButton *)sender {
    
    if (self.handleWaitTaskThumCellBlock) {
        
        self.handleWaitTaskThumCellBlock(self);
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
