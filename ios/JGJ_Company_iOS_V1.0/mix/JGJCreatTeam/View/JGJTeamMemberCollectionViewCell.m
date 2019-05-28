//
//  JGJTeamMemberCollectionViewCell.m
//  mix
//
//  Created by yj on 16/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTeamMemberCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extend.h"
#import "UIView+GNUtil.h"
#import "UIButton+WebCache.h"
#import "UIButton+JGJUIButton.h"

#import "UILabel+GNUtil.h"

@interface JGJTeamMemberCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *delMemberModelButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewTop;
@property (weak, nonatomic) IBOutlet UIImageView *createrFlagImageView;
@end

@implementation JGJTeamMemberCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [UIView maskLayerTarget:self.headButton roundCorners:UIRectCornerAllCorners cornerRad:CGSizeMake(5, 5)];
    [self.headButton.layer setLayerBorderWithColor:AppFontccccccColor width:0.5 radius:JGJCornerRadius];
    self.headButton.layer.masksToBounds = YES;
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont46Size];
    [self.headButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.headButton.backgroundColor = [UIColor whiteColor];
}

- (void)setTeamMemberModel:(JGJSynBillingModel *)teamMemberModel {
    _teamMemberModel = teamMemberModel;
    [self handleTeamMemberHeader:teamMemberModel];
    
    self.delMemberModelButton.hidden = YES;
    
//    JGJAddProSourceMemberControllerType, //添加数据来源人
//    JGJAddProNormalMemberControllerType //添加普通成员
    if (self.memberFlagType == ShowAddTeamMemberFlagType) {
        [self handleAddTeamMember:teamMemberModel];
    } else if (self.memberFlagType == ShowAddAndRemoveTeamMemberFlagType) {
        [self handleAddRemoveTeamMember:teamMemberModel];
    }
    
    if (self.commonModel.memberType == JGJProMemberType) {
        [self handleRegisterMembers:teamMemberModel];
    } else if (self.commonModel.memberType == JGJProSourceMemberType) {
        [self hanldeSourceMember:teamMemberModel];
    }
 //创建者和普通管理员
    NSString  *creatImageStr = nil;
    self.createrFlagImageView.hidden = NO;
    if ([teamMemberModel.is_creater isEqualToString:@"1"]) {
        creatImageStr = @"icon_creator";
    }else if (teamMemberModel.is_admin) {
        creatImageStr = @"icon_ administrator";
    }else {
        creatImageStr = @"";
        self.createrFlagImageView.hidden = YES;
    }
    self.createrFlagImageView.image = [UIImage imageNamed:creatImageStr];
    
    [self.name markText:self.searchValue withColor:AppFontEB4E4EColor];
    
}

#pragma mark - 处理头部是显示头像还是名
- (void)handleTeamMemberHeader:(JGJSynBillingModel *)teamMemberModel {
    
    NSString *subName = [NSString cutWithContent:teamMemberModel.name maxLength:4];
    
    self.name.text = subName;

    [self.headButton setMemberPicButtonWithHeadPicStr:teamMemberModel.head_pic memberName:teamMemberModel.real_name memberPicBackColor:teamMemberModel.modelBackGroundColor membertelephone:teamMemberModel.telphone];
}

#pragma mark - 处理添加成员情况
- (void)handleAddTeamMember:(JGJSynBillingModel *)teamMemberModel {
    if (![NSString isEmpty:teamMemberModel.addHeadPic]) {
        [self.headButton setBackgroundImage:[UIImage imageNamed:teamMemberModel.addHeadPic] forState:UIControlStateNormal];
        self.delMemberModelButton.hidden = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTeamModel:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;//单击
        [self.headButton addGestureRecognizer:tapGestureRecognizer];
//        self.headButton.userInteractionEnabled = YES;
        [self.headButton setTitle:@"" forState:UIControlStateNormal];
        self.headButton.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - 处理是不是我们平台成员显示情况
- (void)handleRegisterMembers:(JGJSynBillingModel *)teamMemberModel {
    if ([teamMemberModel.is_active isEqualToString:@"0"]) {
        [self.delMemberModelButton setImage:[UIImage imageNamed:@"no_register"] forState:UIControlStateNormal];
        self.delMemberModelButton.hidden = NO;
    }
}

#pragma mark - 来源人正在同步显示同步图标
- (void)hanldeSourceMember:(JGJSynBillingModel *)teamMemberModel {
    if ([teamMemberModel.synced isEqualToString:@"0"]) {
        [self.delMemberModelButton setImage:[UIImage imageNamed:@"source_syn_icon"] forState:UIControlStateNormal];
        self.delMemberModelButton.hidden = NO;
    }
}

#pragma mark - 处理添加和移除成员情况
- (void)handleAddRemoveTeamMember:(JGJSynBillingModel *)teamMemberModel {
    if (![NSString isEmpty:teamMemberModel.addHeadPic]) {
        [self.headButton setBackgroundImage:[UIImage imageNamed:teamMemberModel.addHeadPic] forState:UIControlStateNormal];
        self.delMemberModelButton.hidden = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTeamModel:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;//单击
        [self.headButton addGestureRecognizer:tapGestureRecognizer];
//        self.headButton.userInteractionEnabled = YES;
        [self.headButton setTitle:@"" forState:UIControlStateNormal];
        self.headButton.backgroundColor = [UIColor whiteColor];
    }
    if (![NSString isEmpty:teamMemberModel.removeHeadPic]) {
        [self.headButton setBackgroundImage:[UIImage imageNamed:teamMemberModel.removeHeadPic] forState:UIControlStateNormal];
        self.delMemberModelButton.hidden = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTeamModel:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;//单击
        [self.headButton addGestureRecognizer:tapGestureRecognizer];
//        self.headButton.userInteractionEnabled = YES;
        [self.headButton setTitle:@"" forState:UIControlStateNormal];
        self.headButton.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    _commonModel = commonModel;
    self.delMemberModelButton.hidden = _commonModel.isHiddenDeleteFlag;
}

#pragma mark - 处理添加成员事件
- (void)addTeamModel:(UITapGestureRecognizer *)tapGestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCollectionViewCellAddTeamMember:)]) {
        [self.delegate handleJGJTeamMemberCollectionViewCellAddTeamMember:self.teamMemberModel];
    }
//    项目组使用区分添加人员类型
    if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCollectionViewCellRemoveMember:)]) {
        [self.delegate handleJGJTeamMemberCollectionViewCellAddMember:self.commonModel];
    }
}

#pragma mark -移除多个成员
- (void)removeTeamModel:(UITapGestureRecognizer *)tapGestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCollectionViewCellRemoveTeamMember:)]) {
        [self.delegate handleJGJTeamMemberCollectionViewCellRemoveTeamMember:self.commonModel.teamMemberModels];
    }
//    项目组使用区分删除人员类型
    if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCollectionViewCellRemoveMember:)]) {
        [self.delegate handleJGJTeamMemberCollectionViewCellRemoveMember:self.commonModel];
    }
}

#pragma mark -移除单个成员 、点击不是我们成员弹框
- (IBAction)removeIndividualTeamModel:(UIButton *)sender {
//    显示成员时弹框使用 点击非平台，正在同步,移除人员
    BOOL isClicked = [self.teamMemberModel.is_active isEqualToString:@"0"] || self.delMemberModelButton.isHidden || [self.teamMemberModel.synced isEqualToString:@"0"];
    if (isClicked) {
        if ([self.delegate respondsToSelector:@selector(handleJGJUnRegisterTeamModel:)]) {
            self.commonModel.teamModelModel = self.teamMemberModel;
            [self.delegate handleJGJUnRegisterTeamModel:self.commonModel];
        }
    } else if ([self.delegate respondsToSelector:@selector(handleJGJRemoveIndividualTeamModel:)]) {
//    移除单个成员
        [self.delegate handleJGJRemoveIndividualTeamModel:self.teamMemberModel];
    }
}

@end
