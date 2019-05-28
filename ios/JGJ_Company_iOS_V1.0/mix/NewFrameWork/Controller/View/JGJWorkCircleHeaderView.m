//
//  JGJWorkCircleHeaderView.m
//  mix
//
//  Created by yj on 16/8/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkCircleHeaderView.h"
#import "UILabel+GNUtil.h"
#import "JSBadgeView.h"
@interface JGJWorkCircleHeaderView ()
//@property (weak, nonatomic) IBOutlet UILabel *myWorkCircleLable;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *myselfGroupImageView;
@property (strong, nonatomic) JSBadgeView *badgeView ;
@property (weak, nonatomic) IBOutlet UIView *addBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *otherGroupMsgFlagView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myselfGroupImageViewW;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *pronameButton;

@end

@implementation JGJWorkCircleHeaderView

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

//    self.myWorkCircleLable.textColor = AppFont333333Color;
//    
//    self.myWorkCircleLable.font = [UIFont boldSystemFontOfSize:AppFont28Size];
    
    self.pronameButton.titleLabel.font = [UIFont systemFontOfSize:AppFont34Size];
    
    [self.pronameButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    self.addBackgroundView.backgroundColor = [UIColor whiteColor];
    
    self.lineView.backgroundColor = AppFontdbdbdbColor;
    
    self.otherGroupMsgFlagView.backgroundColor = TYColorHex(0XFF0000);
    
    [self.otherGroupMsgFlagView.layer setLayerCornerRadius:TYGetViewH(self.otherGroupMsgFlagView) / 2.0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCheckProAction)];
    
    tap.numberOfTapsRequired = 1;
    
    [self.addBackgroundView addGestureRecognizer:tap];
    
    self.pronameButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    if ([proListModel.group_info.myself_group isEqualToString:@"0"]) {
        
        self.myselfGroupImageView.hidden = YES;
        self.myselfGroupImageViewW.constant = 12;
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(self).mas_offset(12);
            
            make.trailing.mas_equalTo(self).mas_offset(-12);
        }];
    }else {
        
        self.myselfGroupImageView.hidden = NO;
        self.myselfGroupImageViewW.constant = 62.0;
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(self).mas_offset(28);
            
            make.trailing.mas_equalTo(self).mas_offset(-12);
        }];
    }
    
    
    self.otherGroupMsgFlagView.hidden = [proListModel.other_group_unread_msg_count integerValue] == 0;
    
    if ([proListModel.group_info.is_senior isEqualToString:@"1"]) {
        
        [self.pronameButton setImage:[UIImage imageNamed:@"pro_hight_level"] forState:UIControlStateNormal];
        
        self.pronameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        
    }else {
    
        [self.pronameButton setImage:nil forState:UIControlStateNormal];
        
        self.pronameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
//    self.myWorkCircleLable.text = proListModel.group_info.all_pro_name;
    [self.pronameButton setTitle:proListModel.group_info.all_pro_name forState:UIControlStateNormal];
    
}

#pragma mark - 创建班组按钮按下
- (IBAction)creatGroupButtonPressed:(UIButton *)sender {
    if (self.workCircleHeaderViewBlock) {
        self.workCircleHeaderViewBlock(WorkCircleHeaderViewCreatGroupButtonType);
    }
}

- (void)handleCheckProAction {

    if (self.workCircleHeaderViewBlock) {
        self.workCircleHeaderViewBlock(WorkCircleDefaultCellCheckProButtonType);
    }

}

#pragma mark - 扫码加入
- (IBAction)checkProButtonPressed:(UIButton *)sender {
    if (self.workCircleHeaderViewBlock) {
        self.workCircleHeaderViewBlock(WorkCircleDefaultCellCheckProButtonType);
    }
}

- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.pronameButton alignment:JSBadgeViewAlignmentTopRight];
        _badgeView.badgeBackgroundColor = TYColorHex(0xef272f);
        _badgeView.badgeTextFont = [UIFont systemFontOfSize:AppFont24Size];
        _badgeView.badgeStrokeColor = [UIColor redColor];
    }
    return _badgeView;
}
@end
