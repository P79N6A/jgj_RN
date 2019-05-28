//
//  JGJGroupSetMemberCell.m
//  mix
//
//  Created by yj on 2018/12/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJGroupSetMemberCell.h"

#import "UIButton+JGJUIButton.h"

#define JGJHeadTag 100

#define JGJSetMemberMargin 12

#define JGJSetMemberY 15

#define JGJNameHeight 18

@implementation JGJGroupSetMemberCellViewModel

@end

@interface JGJGroupSetMemberCell()

@property (nonatomic, strong) UIView *memberView;

@property (nonatomic, strong) NSMutableArray *memberViews;

@end

@implementation JGJGroupSetMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.memberViews = [NSMutableArray array];
    
    NSInteger headCount = [JGJGroupSetMemberCell headerCount];
    
    for (NSInteger indx = 0; indx < headCount; indx++) {
        
        JGJGroupSetMemberCellViewModel *subViewModel = [[JGJGroupSetMemberCellViewModel alloc] init];
        
        UIButton *headBtn = [[UIButton alloc] init];
        
        [headBtn addTarget:self action:@selector(selMemberBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [headBtn.layer setLayerBorderWithColor:AppFontccccccColor width:0.5 radius:2.5];
        
        headBtn.layer.masksToBounds = YES;
        
        headBtn.tag = JGJHeadTag + indx;
        
        subViewModel.headBtn = headBtn;
        
        [self.contentView addSubview:headBtn];
        
        UILabel *name = [[UILabel alloc] init];
        
        name.textAlignment = NSTextAlignmentCenter;
        
        name.textColor = AppFont666666Color;
        
        name.font = [UIFont systemFontOfSize:AppFont24Size];
        
        subViewModel.name = name;
        
        [self.contentView addSubview:name];
        
        UIImageView *adminFlag = [[UIImageView alloc] init];
        
        adminFlag.contentMode = UIViewContentModeLeft;
        
        subViewModel.adminFlag = adminFlag;
        
        [self.contentView addSubview:adminFlag];
        
        UIImageView *registerFlag = [[UIImageView alloc] init];
        
        registerFlag.contentMode = UIViewContentModeTopRight;
        
        subViewModel.registerFlag = registerFlag;
        
        [self.contentView addSubview:registerFlag];
        
        [self.memberViews addObject:subViewModel];
        
    }
}

- (void)setMembers:(NSArray *)members {
    
    _members = members;
    
    [self loadMembersHeaderImageView:members];
}

- (void)loadMembersHeaderImageView:(NSArray *)members {
    
    for (NSInteger indx = 0; indx < self.memberViews.count; indx++) {
        
        JGJGroupSetMemberCellViewModel *subViewModel = self.memberViews[indx];
        
        UIButton *headBtn = subViewModel.headBtn;
        
        headBtn.hidden = YES;
        
        UILabel *name = subViewModel.name;
        
        name.hidden = YES;
        
        UIImageView *adminFlag = subViewModel.adminFlag;
        
        adminFlag.hidden = YES;
        
        UIImageView *registerFlag = subViewModel.registerFlag;
        
        registerFlag.hidden = YES;
        
        if (self.members.count >= indx + 1) {
            
            JGJSynBillingModel *memberModel = self.members[indx];
            
            registerFlag.hidden = NO;
            
            adminFlag.hidden = NO;
            
            name.hidden = NO;
            
            headBtn.hidden = NO;
            
            //设置frame
            
            [self setFrameWithHeadBtn:headBtn name:name adminFlag:adminFlag registerFlag:registerFlag index:indx];
            
            //设置头像
            
            if (memberModel.isMangerModel) {
                
                NSString *mangerPicstr = memberModel.isRemoveModel ? memberModel.removeHeadPic : memberModel.addHeadPic;
                
                [headBtn setBackgroundImage:[UIImage imageNamed:mangerPicstr] forState:UIControlStateNormal];
                
            }else {
                
                [headBtn setMemberPicButtonWithHeadPicStr:memberModel.head_pic memberName:memberModel.real_name memberPicBackColor:memberModel.modelBackGroundColor membertelephone:memberModel.telephone];
            }
            
            headBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
            
            //姓名
            NSString *subName = [NSString cutWithContent:memberModel.name maxLength:4];
            
            name.text = subName;
            
            //管理员创建者标识
            
            [self handleAdminMember:memberModel adminFlag:adminFlag];
            
            //普通成员
            
            if (self.commonModel.memberType == JGJProMemberType) {
                
                [self handleRegisterMembers:memberModel registerFlag:registerFlag];
                
            } else if (self.commonModel.memberType == JGJProSourceMemberType) {
                
                //数据来源人
                
                [self hanldeSourceMember:memberModel registerFlag:registerFlag];
                
            }
            
        }
    }
    
}

- (void)setFrameWithHeadBtn:(UIButton *)headBtn name:(UILabel *)name adminFlag:(UIImageView *)adminFlag registerFlag:(UIImageView *)registerFlag index:(NSInteger)indx {
    
    CGFloat margin = JGJSetMemberMargin;
    
    CGFloat padding = 2;
    
    NSInteger headCount = [JGJGroupSetMemberCell headerCount];
    
    CGFloat headerImageHW = (TYGetUIScreenWidth - (headCount + 1) * margin) / headCount;
    
    NSInteger col = indx % headCount;
    
    headBtn.tag = JGJHeadTag + indx;
    
    CGFloat x = (headerImageHW + margin) * col + margin;
    
    //头像
    
    headBtn.x = x;
    
    headBtn.y = JGJSetMemberY;
    
    headBtn.width = headerImageHW;
    
    headBtn.height = headerImageHW;
    
    //姓名
    
    CGFloat headerImageHWOffset = 15;
    
    name.y = TYGetMaxY(headBtn) + 1;
    
    name.x = headBtn.x - headerImageHWOffset / 2.0;
    
    name.width = headBtn.width + headerImageHWOffset;
    
    name.height = JGJNameHeight;
    
    //管理员/创建者标记
    
    adminFlag.y = TYGetMinY(headBtn) - 6;
    
    adminFlag.x = headBtn.x - 3.5;
    
    adminFlag.width = headBtn.width;
    
    adminFlag.height = headBtn.height;
    
    //是否是注册成员标识
    
    registerFlag.y = margin - 7;
    
    registerFlag.x = TYGetMaxX(headBtn);
    
    registerFlag.width = 12;
    
    registerFlag.height = 12;
}

#pragma mark - 创建者、管理标识
- (void)handleAdminMember:(JGJSynBillingModel *)memberModel adminFlag:(UIImageView *)adminFlag {
    
    NSString  *adminFlagStr = nil;
    
    if ([memberModel.is_creater isEqualToString:@"1"]) {
        
        adminFlagStr = @"icon_creator";
        
    }else if (memberModel.is_agency && !memberModel.isMangerModel) {
        
        adminFlagStr = @"agency_member_icon";
        
    }else if (memberModel.is_admin) {
        
        adminFlagStr = @"icon_ administrator";
        
    } else {
        
        adminFlagStr = nil;
        
        adminFlag.hidden = YES;
        
    }
    
    adminFlag.image = [UIImage imageNamed:adminFlagStr];
    
}

#pragma mark - 处理是不是我们平台成员显示情况
- (void)handleRegisterMembers:(JGJSynBillingModel *)teamMemberModel registerFlag:(UIImageView *)registerFlag {
    
    if ([teamMemberModel.is_active isEqualToString:@"0"]) {
        
        registerFlag.image = [UIImage imageNamed:@"no_register"];
        
    }
    
}

#pragma mark - 来源人正在同步显示同步图标
- (void)hanldeSourceMember:(JGJSynBillingModel *)teamMemberModel registerFlag:(UIImageView *)registerFlag{
    
    if ([teamMemberModel.synced isEqualToString:@"0"]) {
        
        registerFlag.image = [UIImage imageNamed:@"source_syn_icon"];
        
    }

}

+ (NSInteger)headerCount {
    
    NSInteger headCount = 8;
    
    if (TYGetUIScreenWidth <= 320) {
        
        headCount = 6;
        
    }else if (TYGetUIScreenWidth > 320 && TYGetUIScreenWidth <= 375) {
        
        headCount = 7;
        
    }else if (TYGetUIScreenWidth > 375 && TYGetUIScreenWidth <= 414) {
        
        headCount = 8;
        
    }
    
    return headCount;
}

- (void)selMemberBtnPressed:(UIButton *)sender {
    
    NSInteger indx = sender.tag - JGJHeadTag;
    
    JGJSynBillingModel *memberModel = self.members[indx];
    
    if ([self.delegate respondsToSelector:@selector(selMemberWithCell:memberModel:)]) {
        
        [self.delegate selMemberWithCell:self memberModel:memberModel];
        
    }
}

+ (CGFloat)memberCellHeight {
    
    NSInteger headCount = [JGJGroupSetMemberCell headerCount];
    
    CGFloat height = (TYGetUIScreenWidth - (headCount + 1) * JGJSetMemberMargin) / headCount;
    
    return height + 2 * JGJSetMemberY + JGJNameHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
