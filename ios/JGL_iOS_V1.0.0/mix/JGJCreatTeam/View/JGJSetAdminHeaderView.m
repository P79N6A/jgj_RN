//
//  JGJSetAdminHeaderView.m
//  JGJCompany
//
//  Created by yj on 16/11/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSetAdminHeaderView.h"

@interface JGJSetAdminHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *adminNumDesLable;
@property (weak, nonatomic) IBOutlet UIButton *adminLimitButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation JGJSetAdminHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    self.adminNumDesLable.textColor = AppFont666666Color;
    self.contentView.backgroundColor = AppFontf1f1f1Color;
}

- (void)setTeamInfo:(JGJTeamInfoModel *)teamInfo {
    _teamInfo = teamInfo;
    self.adminNumDesLable.text = [NSString stringWithFormat:@"%@ (%@/%@)",@"已有管理员", teamInfo.admins_num,teamInfo.members_num];
}

- (IBAction)handleAdminHeaderViewButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(adminHeaderViewDidSelected:)]) {
        [self.delegate adminHeaderViewDidSelected:self];
    }
}
@end
