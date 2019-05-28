//
//  JGJGroupChatSelelctedMemberHeadView.m
//  mix
//
//  Created by yj on 16/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGroupChatSelelctedMemberHeadView.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
@interface JGJGroupChatSelelctedMemberHeadView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedButtonW;

@end
@implementation JGJGroupChatSelelctedMemberHeadView


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
    self.backgroundColor = [UIColor whiteColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderVeiw:)];
    [self addGestureRecognizer:tap];
    self.nameLable.textColor = AppFont333333Color;
}

#pragma mark - 点击选中当前项目全体人员
- (void)handleTapHeaderVeiw:(UIGestureRecognizer *)tap {
    self.selectedButton.selected = !self.selectedButton.selected;
    if ([self.delegate respondsToSelector:@selector(JGJGroupChatSelelctedMemberHeadView:groupListModel:)]) {
        [self.delegate JGJGroupChatSelelctedMemberHeadView:self groupListModel:self.groupListModel];
    }
}

- (void)setGroupListModel:(JGJMyWorkCircleProListModel *)groupListModel {
    _groupListModel = groupListModel;
//    NSString *proName = @"";
//    if ([_groupListModel.class_type isEqualToString:@"group"] && ![NSString isEmpty:_groupListModel.pro_name]) {
//        proName = _groupListModel.pro_name;
//    }
    
    NSString *groupMember = @"";
    if (self.chatType == JGJSingleChatType) {
        groupMember = [NSString stringWithFormat:@"(%@)", groupListModel.members_num];
    }
    self.nameLable.text = [NSString stringWithFormat:@"%@ %@", _groupListModel.group_name, groupMember];
    [self.nameLable markText:groupMember withColor:AppFont999999Color];
    self.selectedButton.hidden = self.chatType == JGJSingleChatType;
    self.selectedButtonW.constant = self.chatType == JGJSingleChatType ? 12 : 40;
}

- (IBAction)handleSelectedMemberButtonPressed:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    if ([self.delegate respondsToSelector:@selector(JGJGroupChatSelelctedMemberHeadView:groupListModel:)]) {
//        [self.delegate JGJGroupChatSelelctedMemberHeadView:self groupListModel:self.groupListModel];
//    }
}


@end
