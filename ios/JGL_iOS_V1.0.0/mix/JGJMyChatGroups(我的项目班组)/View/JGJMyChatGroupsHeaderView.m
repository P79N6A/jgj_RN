//
//  JGJMyChatGroupsHeaderView.m
//  mix
//
//  Created by yj on 2019/3/6.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMyChatGroupsHeaderView.h"

#import "JGJAvatarView.h"

@interface JGJMyChatGroupsHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *groupName;

@property (weak, nonatomic) IBOutlet UILabel *myCreat;

@property (weak, nonatomic) IBOutlet UILabel *agency;

@property (weak, nonatomic) IBOutlet UIButton *changeGroupBtn;

@property (weak, nonatomic) IBOutlet JGJAvatarView *avatarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupNameCenterY;

@property (weak, nonatomic) IBOutlet UIView *redDotView;

@end

@implementation JGJMyChatGroupsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

-(void)setupView {
    
    self.backgroundColor = AppFontffffffColor;
    
    [self.myCreat.layer setLayerBorderWithColor:AppFont3179CBColor width:0.5 radius:8.0];
    
    [self.agency.layer setLayerBorderWithColor:AppFontDD8631Color width:0.5 radius:8.0];
    
    self.changeGroupBtn.titleLabel.numberOfLines = 0;
    
    NSString *btnTitle = @"新建/切换\n项目班组";
    
    [self.changeGroupBtn setTitle:btnTitle forState:UIControlStateNormal];
    
    [self.redDotView.layer setLayerCornerRadius:TYGetViewH(self.redDotView) / 2.0];
    
    self.groupName.font = [UIFont boldSystemFontOfSize:AppFont32Size];
    
    self.redDotView.backgroundColor = AppFontEB4E4EColor;
    
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    self.groupName.text = proListModel.group_info.group_name;
    
    self.redDotView.hidden = [JGJChatMsgDBManger getHomeAllUnreadMsgCount] == 0;
    
    //显示头像
    
    if (proListModel.group_info.members_head_pic.count > 0) {
        
        [self.avatarView getRectImgView:proListModel.group_info.members_head_pic];
        
    }
    
    //设置我创建的、我代班的、已设代班状态
    
    [self setSenorCreatFlagWithProListModel:proListModel];
}


#pragma mark - 设置黄金、或者创建图标
- (void)setSenorCreatFlagWithProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    CGFloat layerW = 0.5;
    
    [self.myCreat.layer setLayerBorderWithColor:AppFont3179CBColor width:layerW radius:8.0];
    
    self.myCreat.textColor = AppFont3179CBColor;
    
    [self.agency.layer setLayerBorderWithColor:AppFontDD8631Color width:layerW radius:8.0];
    
    self.agency.textColor = AppFontDD8631Color;
    
    BOOL is_agency = proListModel.group_info.is_agency_group;
    
    BOOL is_myAgency_group = proListModel.group_info.is_myAgency_group;
    
    BOOL isMyCreat = [proListModel.group_info.myself_group isEqualToString:@"1"];
    
//    is_agency = YES;
//
//    is_myAgency_group = YES;
//
//    isMyCreat = NO;
    
    NSString *creater = @"我创建的";
    
    NSString *myAgency = @"我代班的";
    
    NSString *settedAgency = @"已设代班";
    
    NSString *creatImageStr = @"";
    
    NSString *agencyImageStr = @"";
    //    111 101 000 100 010  001 011
    //    000  001  010 011 100 101 110 111
    if (is_agency && is_myAgency_group && isMyCreat) {
        
        creatImageStr = creater;
        
        agencyImageStr = myAgency; //我创建的、我是代班
        
    }else if (is_agency && !is_myAgency_group && isMyCreat) {
        
        creatImageStr = creater;
        
        agencyImageStr = settedAgency; //我创建的、我不是代班
        
    }else if (!is_agency && !is_myAgency_group && !isMyCreat) { //不是我创建的也没有代班
        
        creatImageStr = @"";
        
        agencyImageStr = @"";
        
    }else if (is_agency && !is_myAgency_group && !isMyCreat) { //不是我创建的已设置代班
        
        creatImageStr = @"";
        
        //        creatImageStr = @"setted_agency_icon";
        
        agencyImageStr = @"";
        
    }else if (!is_agency && is_myAgency_group && !isMyCreat) { //不是我创建的我是代班
        
        creatImageStr = myAgency;
        
        agencyImageStr = @"";
        
        [self.myCreat.layer setLayerBorderWithColor:AppFontDD8631Color width:layerW radius:8.0];
        
        self.myCreat.textColor = AppFontDD8631Color;
        
    }else if (!is_agency && !is_myAgency_group && isMyCreat) { //只是我创建的
        
        creatImageStr = creater;
        
        agencyImageStr = @"";
        
    }else if (!is_agency && is_myAgency_group && isMyCreat) { //只是我创建的,我是代班
        
        creatImageStr = creater;
        
        agencyImageStr = myAgency; //我创建的、我是代班
        
    }else if (is_agency && is_myAgency_group && !isMyCreat) { //只是我创建的,我是代班
        
        creatImageStr = myAgency;
        
        agencyImageStr = @""; //我创建的、我是代班
        
        [self.myCreat.layer setLayerBorderWithColor:AppFontDD8631Color width:layerW radius:8.0];
        
        self.myCreat.textColor = AppFontDD8631Color;
    }
    
    if (![NSString isEmpty:creatImageStr]) {
        
//        self.myCreatImageView.image = [UIImage imageNamed:creatImageStr];
        
        self.myCreat.text = creatImageStr;
    }
    
//    self.myCreatImageView.hidden = [NSString isEmpty:creatImageStr];
    
    self.myCreat.hidden = [NSString isEmpty:creatImageStr];
    
    if (![NSString isEmpty:agencyImageStr]) {
        
//        self.agencyImageView.image = [UIImage imageNamed:agencyImageStr];
        
        self.agency.text = agencyImageStr;
    }
    
//    self.agencyImageView.hidden = [NSString isEmpty:agencyImageStr];
    
    self.agency.hidden = [NSString isEmpty:agencyImageStr];
    
    self.groupNameCenterY.constant = -8;
    
    if ([NSString isEmpty:creatImageStr] && [NSString isEmpty:agencyImageStr]) {
        
        self.groupNameCenterY.constant = 0;
    }
    
}

- (IBAction)switchProPressed:(UIButton *)sender {
    
    if (self.switchBlock) {
        
        self.switchBlock();
    }
    
}


+(CGFloat)headerHeight {
    
    return 60.0;
}

@end
