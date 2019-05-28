//
//  JGJProiClodInsuffRemindCell.m
//  JGJCompany
//
//  Created by yj on 2017/8/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiClodInsuffRemindCell.h"

#import "NSDate+Extend.h"

@interface JGJProiClodInsuffRemindCell ()

@property (weak, nonatomic) IBOutlet UILabel *detailLable;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@property (weak, nonatomic) IBOutlet UIButton *orderButton;

@property (weak, nonatomic) IBOutlet UIButton *delButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderButtonH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTitleBottom;

@end

@implementation JGJProiClodInsuffRemindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.orderButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:2.5];
    
    [self.orderButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    self.orderButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    
    self.titleLable.textColor = AppFont333333Color;
    
    self.titleLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.detailLable.textColor = AppFont666666Color;
    
    self.detailLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    self.timeLable.textColor = AppFont999999Color;
    
    self.timeLable.font = [UIFont systemFontOfSize:AppFont24Size];
    
    self.detailLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 123;
}

//- (void)layoutSubviews {
//
//    [super layoutSubviews];
//    
//    self.detailLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 123;
//    
//    [super layoutSubviews];
//
//}

- (void)setNotifyModel:(JGJNewNotifyModel *)notifyModel {

    _notifyModel = notifyModel;
    
    
    
    self.titleLable.text = _notifyModel.title;
    
    if (![NSString isEmpty:_notifyModel.info]) {
        
       _notifyModel.info = [_notifyModel.info stringByReplacingOccurrencesOfString:@"续订" withString:@"续期"];
    }

    self.detailLable.text = _notifyModel.info;
    
    NSString *dateString = [NSDate dateTimesTampToString:_notifyModel.date format:@"YYYY-MM-dd"];
    
    NSDate *date = [NSDate dateFromString:dateString withDateFormat:@"YYYY-MM-dd"];
    
    if (date.isToday) {
        
        dateString = [NSDate dateTimesTampToString:notifyModel.date format:@"HH:mm"];
    }
    
    self.timeLable.text = dateString;
    
    self.orderButton.hidden = notifyModel.isSuccessSyn;
    
    NSString *buttonTitle = @"";

    if (notifyModel.notifyType == CloudExpiredNotice || notifyModel.notifyType == ServiceExpiredNotice) {

        buttonTitle = @"申请";
        
    }else if (notifyModel.notifyType == Cloud_lack) {
        
        buttonTitle = @"申请";
        
    }else {
    
        buttonTitle = @"";
    }

    [self.orderButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    CGFloat bottom = 46;
    
    if (notifyModel.isSuccessSyn) {

        bottom = 12;

    }
    
    self.detailTitleBottom.constant = bottom;
    
}

- (IBAction)delButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(handleJGJProiClodInsuffRemindCellWithNotifyModel:buttonType:)]) {
        
        [self.delegate handleJGJProiClodInsuffRemindCellWithNotifyModel:self.notifyModel buttonType:ProiClodInsuffRemindCellDelButtonType];
    }
    
}


- (IBAction)orderButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(handleJGJProiClodInsuffRemindCellWithNotifyModel:buttonType:)]) {
        
        [self.delegate handleJGJProiClodInsuffRemindCellWithNotifyModel:self.notifyModel buttonType:ProiClodInsuffRemindCellOrderButtonType];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
