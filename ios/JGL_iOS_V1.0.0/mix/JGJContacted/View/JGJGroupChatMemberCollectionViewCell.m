//
//  JGJGroupChatMemberCollectionViewCell.m
//  mix
//
//  Created by YJ on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGroupChatMemberCollectionViewCell.h"
#import "UIView+GNUtil.h"
#import "UIButton+WebCache.h"
#import "NSString+Extend.h"
#import "UIButton+JGJUIButton.h"

#import "UILabel+GNUtil.h"

@interface JGJGroupChatMemberCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end
@implementation JGJGroupChatMemberCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
//    [UIView maskLayerTarget:self.headButton roundCorners:UIRectCornerAllCorners cornerRad:CGSizeMake(JGJCornerRadius, JGJCornerRadius)];
    [self.headButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont46Size];
    [self.headButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.headButton.backgroundColor = [UIColor whiteColor];
}

-(void)setMemberModel:(JGJSynBillingModel *)memberModel {
    _memberModel = memberModel;
    self.name.text = _memberModel.real_name;
    [self.headButton setTitle:@"" forState:UIControlStateNormal];
    [self.headButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.headButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.headButton.backgroundColor = [UIColor whiteColor];
    if (!memberModel.isAddModel && !memberModel.isRemoveModel) {
         [self.headButton setMemberPicButtonWithHeadPicStr:_memberModel.head_pic memberName:_memberModel.real_name memberPicBackColor:_memberModel.modelBackGroundColor];
    }else if (memberModel.isAddModel) {
        [self.headButton setBackgroundImage:[UIImage imageNamed:memberModel.addHeadPic] forState:UIControlStateNormal];
    }else if (memberModel.isRemoveModel) {
        [self.headButton setBackgroundImage:[UIImage imageNamed:memberModel.removeHeadPic] forState:UIControlStateNormal];
    }
//    [self handleAddRemoveTeamMember:memberModel];
    
    [self.name markText:self.searchValue withColor:AppFontEB4E4EColor];
}

#pragma mark - 处理添加和移除成员情况
- (void)handleAddRemoveTeamMember:(JGJSynBillingModel *)memberModel {
    if (![NSString isEmpty:memberModel.addHeadPic]) {
        [self.headButton setBackgroundImage:[UIImage imageNamed:memberModel.addHeadPic] forState:UIControlStateNormal];
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMemberModel:)];
//        tapGestureRecognizer.numberOfTapsRequired = 1;//单击
//        [self.headButton addGestureRecognizer:tapGestureRecognizer];
//        self.headButton.userInteractionEnabled = YES;
        [self.headButton setTitle:@"" forState:UIControlStateNormal];
        self.headButton.backgroundColor = [UIColor whiteColor];
    }
    if (![NSString isEmpty:memberModel.removeHeadPic]) {
        [self.headButton setBackgroundImage:[UIImage imageNamed:memberModel.removeHeadPic] forState:UIControlStateNormal];
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMemberModel:)];
//        tapGestureRecognizer.numberOfTapsRequired = 1;//单击
//        [self.headButton addGestureRecognizer:tapGestureRecognizer];
//        self.headButton.userInteractionEnabled = YES;
        [self.headButton setTitle:@"" forState:UIControlStateNormal];
        self.headButton.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - 处理添加成员事件
- (void)addMemberModel:(UITapGestureRecognizer *)tapGestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(handleJGJGroupChatMemberCollectionViewCell:commonModel:)]) {
        [self.delegate handleJGJGroupChatMemberCollectionViewCell:self commonModel:self.commonModel];
    }
}

#pragma mark -移除多个成员
- (void)removeMemberModel:(UITapGestureRecognizer *)tapGestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(handleJGJGroupChatMemberCollectionViewCell:commonModel:)]) {
        [self.delegate handleJGJGroupChatMemberCollectionViewCell:self commonModel:self.commonModel];
    }
}

@end
