//
//  JGJQuaSafeOrderDefaultView.m
//  JGJCompany
//
//  Created by yj on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeOrderDefaultView.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

#import "JGJCustomAlertView.h"

@implementation JGJQuaSafeOrderDefaultViewModel


@end

@interface JGJQuaSafeOrderDefaultView ()

@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;

@property (weak, nonatomic) IBOutlet UIButton *desButton;

@property (weak, nonatomic) IBOutlet UILabel *desLable;

@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (weak, nonatomic) IBOutlet UIButton *tryUseButton;


@end

@implementation JGJQuaSafeOrderDefaultView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJQuaSafeOrderDefaultView" owner:self options:nil] lastObject];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    [self.desButton setTitleColor:AppFontFF0000Color forState:UIControlStateNormal];
    
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.actionButton.layer setLayerBorderWithColor:AppFontFF0000Color width:0.5 radius:JGJCornerRadius];
    
    self.desButton.backgroundColor = [UIColor whiteColor];
    
    self.desLable.textColor = AppFontB9B9B9Color;
    
    [self.tryUseButton.layer setLayerBorderWithColor:TYColorHex(0xFBB717) width:0.5 radius:JGJCornerRadius];
    
    self.tryUseButton.hidden = YES;
    
}

- (void)setInfoModel:(JGJQuaSafeOrderDefaultViewModel *)infoModel {

    _infoModel = infoModel;
    
    if (![NSString isEmpty:infoModel.desButtonTitle]) {
        
        [self.desButton setTitle:infoModel.desButtonTitle forState:UIControlStateNormal];
    }
    
    if (![NSString isEmpty:infoModel.actionButtonTitle]) {
        
        [self.actionButton setTitle:infoModel.actionButtonTitle forState:UIControlStateNormal];
    }
    
    if (![NSString isEmpty:infoModel.desInfo]) {
        
        self.desLable.text = infoModel.desInfo;
    }
    
    if (infoModel.desInfoFontSize > 0) {
        
        self.desLable.font = [UIFont systemFontOfSize:infoModel.desInfoFontSize];
        
    }
    
    if (infoModel.desInfoFontColor) {
        
        self.desLable.textColor = infoModel.desInfoFontColor;
    }
    
    if (infoModel.actionButtonFontColor) {

        [self.actionButton setTitleColor:infoModel.actionButtonFontColor forState:UIControlStateNormal];
    }
    
    if (infoModel.desButtonFontColor) {
        
        [self.desButton setTitleColor:infoModel.desButtonFontColor forState:UIControlStateNormal];
    }
    
    self.lineView.hidden = infoModel.isHiddenlineView;
    
    self.actionButton.hidden = infoModel.isHiddenActionButton;
    
    if (![NSString isEmpty:infoModel.changeColorDes]) {
        
        [self.desLable markText:infoModel.changeColorDes withColor:AppFontEB4E4EColor];
    }
    
    if (infoModel.isCenter) {
        
        [self.contentDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
          
            make.centerY.mas_equalTo(self.mas_centerY).mas_offset(20);
        }];
    }

}

#pragma mark - 处理按钮问题
- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    
    _workProListModel = workProListModel;
    
    self.tryUseButton.hidden = workProListModel.is_buyed;
    
}

- (IBAction)handleButtonPressed:(UIButton *)sender {
    
    JGJQuaSafeOrderDefaultViewButtonType buttonType = sender.tag - 100;
    
    if (self.handleQuaSafeOrderDefaultViewBlock) {
        
        self.handleQuaSafeOrderDefaultViewBlock(buttonType, self);
    }
    
}

- (IBAction)tryUseButtonPressed:(UIButton *)sender {
    
    JGJCustomAlertView *alertView = [JGJCustomAlertView customAlertViewShowWithMessage:@"恭喜你获得30天黄金服务版免费体验权"];
    alertView.message.font = [UIFont systemFontOfSize:AppFont34Size];
    
    [alertView.confirmButton setTitle:@"确认升级版本" forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;
    
    alertView.onClickedBlock = ^{
        
       [weakSelf trySeniorVersionRequest];
        
    };
    
}

#pragma mark - 试用黄金服务版请求
- (void)trySeniorVersionRequest {
    
    NSDictionary *parameters = @{@"class_type" : self.workProListModel.class_type?:@"team",
                                 @"group_id" : self.workProListModel.group_id?:@""
                                 };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/order/donateSeniorCloud" parameters:parameters success:^(id responseObject) {
        
        if (self.handleQuaSafeOrderDefaultViewBlock) {
            self.handleQuaSafeOrderDefaultViewBlock(QuaSafeOrderDefaultViewTryUseActionButtonType, self);
        }
        
        self.workProListModel.is_buyed = YES;
        
        self.workProListModel.is_senior = @"1";
        
        [TYShowMessage showSuccess:@"升级成功"];
        
    } failure:^(NSError *error) {
        
    }];
}

@end
