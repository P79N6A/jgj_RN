//
//  JGJNotifySynProCell.m
//  mix
//
//  Created by yj on 2018/4/28.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNotifySynProCell.h"

#import "NSDate+Extend.h"

@interface JGJNotifySynProCell ()

@property (weak, nonatomic) IBOutlet UILabel *detail;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UIButton *synBillingButton;

//拒绝和查看类型
@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (weak, nonatomic) IBOutlet UIButton *delButton;

@property (weak, nonatomic) IBOutlet UIImageView *notifyTypeFlagImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;

@end

@implementation JGJNotifySynProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.timeLable.textColor = AppFontccccccColor;
    
    self.title.textColor = AppFont333333Color;
        
    self.detail.textColor = AppFont666666Color;
    
    self.detail.font = [UIFont systemFontOfSize:AppFont28Size];
    
    [self.synBillingButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:2.5];
    
    [self.statusButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:2.5];
    
    self.detail.preferredMaxLayoutWidth = 123;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
    _notifyModel = notifyModel;
    
    NSString *buttonTitle = @"拒绝";
    
    self.title.text = notifyModel.title;

    self.timeLable.text = [NSDate showDateWithTimeStamp:notifyModel.date?:@""];
    
    self.synBillingButton.hidden = notifyModel.isSuccessSyn || notifyModel.isRefused;
    
    self.statusButton.hidden = notifyModel.isSuccessSyn || notifyModel.isRefused;

    switch (notifyModel.notifyType) {
            
        case SyncedSyncProjectType: //同步记工通知

        case syncedSyncGroupToGroup:{ //同步记工记账通知

            buttonTitle = @"查看";
            
            self.synBillingButton.hidden = YES;
        }

            break;
            
        default:
            break;
    }
    
    
    [self handleSynedWithNotifyModel:notifyModel];
    
    [self handleRefuseWithNotifyModel:notifyModel];
    
    [self handleCellHeightWithNotifyModel:notifyModel];
    
    [self.statusButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    self.detail.text = notifyModel.info;
    
}

#pragma mark - 处理已拒绝
- (void)handleRefuseWithNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
    if (notifyModel.isRefused) {
        
        self.notifyTypeFlagImageView.image = [UIImage imageNamed:@"yjj_icon"];
        
    }
    
}

#pragma mark - 处理已同步
- (void)handleSynedWithNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
    if (notifyModel.isSuccessSyn) {
     
        self.notifyTypeFlagImageView.image = [UIImage imageNamed:@"ytb_icon"];
    }

}

- (void)handleCellHeightWithNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
    CGFloat bottom = 46;
    
    if (notifyModel.isSuccessSyn || notifyModel.isRefused) {
        
        bottom = 12;
        
    }
    
    self.bottomConstant.constant = bottom;
}

- (IBAction)buttonPressed:(UIButton *)sender {
    
    NotifyCellButtonType type = sender.tag - 100;
    
    //记工同步通知类型 更改按钮类型

    if (self.notifyModel.notifyType == syncedSyncGroupToGroup && type != NotifyCellDeleteButtonType) {
        
        type = NotifyCellSyncedSyncGroupToGroup;
        
    }
    
    if ([self.delegate respondsToSelector:@selector(handleSynProCellNotifyModel:buttonType:)]) {
        
        [self.delegate handleSynProCellNotifyModel:self.notifyModel buttonType:type];
    }
    
}

+ (CGFloat)synCellShinkHeightWithNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
    CGFloat height = 46;
    
    if (notifyModel.isRefused || notifyModel.isSuccessSyn) {
        
        height = 33;
    }
    
    return height;
}

@end
