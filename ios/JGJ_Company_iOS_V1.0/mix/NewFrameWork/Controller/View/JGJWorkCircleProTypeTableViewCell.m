//
//  JGJWorkCircleProTypeTableViewCell.m
//  JGJCompany
//
//  Created by yj on 17/3/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWorkCircleProTypeTableViewCell.h"
#import "JGJWorkCircleProListCollectionViewCell.h"

#import "JSBadgeView.h"

#import "JGJAvatarView.h"

#define GroupListImageIcons @[@"mul_record_icon", @"account_books_icon", @"icon_Sign_in", @"icon_knowledge_base", @"icon_notice", @"icon_quality", @"icon_security", @"icon_Team_management"]

#define GroupListDescs @[@"批量记工", @"记工账本", @"签到", @"资料库", @"通知", @"质量", @"安全", @"班组管理"]


@interface JGJWorkCircleProTypeTableViewCell ()<

    JGJWorkCircleProListCollectionViewCellDelegate
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;

@property (strong, nonatomic)NSArray *infoModels;

@property (weak, nonatomic) IBOutlet UIImageView *closedProFlagView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

//切圆角view
@property (weak, nonatomic) IBOutlet UIView *cutCircularView;

//transform动画view
@property (weak, nonatomic) IBOutlet UIView *transView;

@property (weak, nonatomic) IBOutlet UIImageView *senorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myCreatImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupName;

@property (weak, nonatomic) IBOutlet UILabel *groupChatInfoLable;

@property (weak, nonatomic) IBOutlet UILabel *groupChatInfoCountLable;

@property (weak, nonatomic) IBOutlet UILabel *workReplyLable;

@property (weak, nonatomic) IBOutlet UILabel *workReplyCountLable;

@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (weak, nonatomic) IBOutlet UIButton *workReplyButton;

@property (weak, nonatomic) IBOutlet UIView *contentChatView;

@property (weak, nonatomic) IBOutlet UIView *contentReplyView;


@property (weak, nonatomic) IBOutlet UIView *msgFlagView;

@property (strong, nonatomic) JSBadgeView *chatBadgeView;

@property (strong, nonatomic) JSBadgeView *replyBadgeView ;

@property (weak, nonatomic) IBOutlet JGJAvatarView *avatarView;

@property (weak, nonatomic) IBOutlet UIImageView *myCreatFlagView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupNameCenterY;


@end

@implementation JGJWorkCircleProTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonSet];
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *CellID = @"Cell";
    JGJWorkCircleProTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJWorkCircleProTypeTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)commonSet {
    [self.collectionView registerNib:[UINib nibWithNibName:@"JGJWorkCircleProListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellID];
    
    CGFloat itemWH = TYGetUIScreenWidth / 4.0;
    
    self.layout.itemSize = CGSizeMake(itemWH, SelItemHeight);
    self.layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    
    CGFloat fontSize = TYIS_IPHONE_5 ? AppFont26Size : AppFont30Size;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    self.groupChatInfoLable.font = font;
    
    self.workReplyLable.font = font;
    
    self.groupChatInfoLable.textColor = AppFont333333Color;
    
    self.workReplyLable.textColor = AppFont333333Color;
    
    self.groupName.font = [UIFont boldSystemFontOfSize:AppFont34Size];
    
    self.workReplyCountLable.font = [UIFont boldSystemFontOfSize:fontSize];
    
    self.groupChatInfoCountLable.font = [UIFont boldSystemFontOfSize:fontSize];
    
    [self.contentChatView.layer setLayerCornerRadius:2.5];
    
    [self.contentReplyView.layer setLayerCornerRadius:2.5];
    
    self.contentChatView.backgroundColor = TYColorHex(0xEBEBEB);
    
    self.contentReplyView.backgroundColor = TYColorHex(0xEBEBEB);
    
    self.msgFlagView.backgroundColor = TYColorHex(0XFF0000);
    
    [self.msgFlagView.layer setLayerCornerRadius:TYGetViewH(self.msgFlagView) / 2.0];
    
//    [self.chatButton addTarget:self action:@selector(chatButtonTouchDownPressed:) forControlEvents:UIControlEventTouchDown];
//
//    [self.workReplyButton addTarget:self action:@selector(workReplyButtonTouchDownPressed:) forControlEvents:UIControlEventTouchDown];
    
    self.replyBadgeView.hidden = YES;
    
    self.chatBadgeView.hidden = YES;
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {

    _proListModel = proListModel;
    
//    proListModel.work_message_num = @"0";
//    
//    proListModel.group_info.unread_msg_count = @"0";
    
    //是否隐藏关闭项目标签
    self.closedProFlagView.hidden = !proListModel.group_info.isClosedTeamVc;
    
    self.msgFlagView.hidden = [JGJChatMsgDBManger getHomeAllUnreadMsgCount] == 0;
    
    NSInteger unread_msg_count = [proListModel.chat_unread_msg_count integerValue];
    
    NSString *unread_msg_countStr = proListModel.chat_unread_msg_count;
    
    if (unread_msg_count > 99) {
        
        unread_msg_countStr = @"99+";
    }
    
    self.groupChatInfoCountLable.text = unread_msg_countStr?:@"0";
    
    self.chatBadgeView.badgeText = unread_msg_countStr?:@"0";
    
    if (unread_msg_count != 0) {
        
        self.chatBadgeView.hidden = NO;
        
        self.groupChatInfoCountLable.hidden = YES;
        
    }else {
        
        self.chatBadgeView.hidden = YES;
        
        self.groupChatInfoCountLable.hidden = NO;
    }
    
    self.groupChatInfoLable.text = @"群聊消息";
    
    NSInteger work_message_num = [proListModel.work_message_num integerValue];
    
    NSString *workMessage = proListModel.work_message_num;
    
    if (work_message_num > 99) {
        
        workMessage = @"99+";
    }
    
    self.workReplyCountLable.text = workMessage?:@"0";
    
    self.replyBadgeView.badgeText = workMessage?:@"0";
    
    if (work_message_num != 0) {
        
        self.replyBadgeView.hidden = NO;

        self.workReplyCountLable.hidden = YES;
        
    }else {
        
        self.replyBadgeView.hidden = YES;
        
        self.workReplyCountLable.alpha = 1;
    }
    
    self.workReplyLable.text = @"工作回复";
    
    self.groupName.text = proListModel.group_info.pro_name;
    
    [self setBadgeOffsetWithProListModel:proListModel];
    
    if (proListModel.group_info.members_head_pic.count > 0) {
        
        [self.avatarView getRectImgView:proListModel.group_info.members_head_pic];
        
    }
    
    [self setSenorCreatFlagWithProListModel:proListModel];
}

#pragma mark - 设置黄金、或者创建图标
- (void)setSenorCreatFlagWithProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    BOOL isMyCreat = [proListModel.group_info.myself_group isEqualToString:@"1"];
    
    self.myCreatImageView.hidden = !isMyCreat;
    
    self.groupNameCenterY.constant = isMyCreat ? 10 : 0;
    
}

- (void)setBadgeOffsetWithProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    CGFloat replyOffset = -20;
    
    CGFloat chatOffset = -20;
    
    if ([self.replyBadgeView.badgeText isEqualToString:@"99+"]) {
        
        if (TYIS_IPHONE_6) {
            
            replyOffset = -25;
            
        }else if (TYIS_IPHONE_6P) {
            
            replyOffset = -30;
        }
        
        _replyBadgeView.badgePositionAdjustment = CGPointMake(replyOffset, 20);
    }
    
    if ([self.chatBadgeView.badgeText isEqualToString:@"99+"]) {
        
        if (TYIS_IPHONE_6) {
            
            chatOffset = -25;
            
        }else if (TYIS_IPHONE_6P) {
            
            chatOffset = -30;
        }
        
        _chatBadgeView.badgePositionAdjustment = CGPointMake(chatOffset, 20);
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.infoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJWorkCircleProListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    JGJWorkCircleMiddleInfoModel *infoModel = self.infoModels[indexPath.row];
    cell.delegate = self;
    cell.infoModel = infoModel;
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJWorkCircleMiddleInfoModel *infoModel = self.infoModels[indexPath.row];
    
    infoModel.isHightlight = YES;
    
    JGJWorkCircleProListCollectionViewCell* cell = (JGJWorkCircleProListCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.infoModel = infoModel;
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJWorkCircleMiddleInfoModel *infoModel = self.infoModels[indexPath.row];
    
    infoModel.isHightlight = NO;
    
    JGJWorkCircleProListCollectionViewCell* cell = (JGJWorkCircleProListCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.infoModel = infoModel;

    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    JGJWorkCircleMiddleInfoModel *infoModel = self.infoModels[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(JGJWorkCircleProTypeTableViewCell:didSelectedType:)]) {
        
        [self.delegate JGJWorkCircleProTypeTableViewCell:self didSelectedType:infoModel];
    }
    
}

- (NSArray *)infoModels {
    
    if (!self.proListModel) {
        
        return @[];
    }
    
    JGJMyWorkCircleProListModel *proModel = self.proListModel;
    NSArray *teamIsExistMsgs = @[proModel.unread_quality_count?:@"",
                                 proModel.unread_safe_count?:@"",
                                 proModel.unread_inspect_count?:@"",//检查
                                 proModel.unread_task_count?:@"",
                                 proModel.unread_notice_count?:@"",
                                 
                                 proModel.unread_sign_count?:@"",
                                 proModel.unread_meeting_count?:@"",//会议
                                 proModel.unread_approval_count?:@"",
                                 proModel.unread_log_count?:@"",
                                 proModel.unread_weath_count?:@"",
                                 
                                 @"",
                                 @"",
                                 @"",
                                 
                                 @"0",
                                 proModel.unread_billRecord_count?:@"",
                                 @"0",
                                 @"0"
                                 ];

    
    NSArray *imageIcons = ProListImageIcons;
    
    NSArray *descs = ProListDescs;
    
    NSArray *unReadMsgs = teamIsExistMsgs;
    
    NSMutableArray *infos = [NSMutableArray array];
    
    for (int i = 0; i < imageIcons.count; i ++) {
        
        JGJWorkCircleMiddleInfoModel *infoModel = [[JGJWorkCircleMiddleInfoModel alloc] init];
        
        infoModel.InfoImageIcon = imageIcons[i];
        
        infoModel.isHiddenUnReadMsgFlag = [unReadMsgs[i] integerValue] == 0;
        
        infoModel.desc = descs[i];
        
        infoModel.cellType = i;
        
        [infos addObject:infoModel];
    }
    
    _infoModels = infos;
    
    return _infoModels;
}

#pragma mark - JGJWorkCircleProListCollectionViewCellDelegate
- (void)workCircleProListCollectionViewCell:(JGJWorkCircleProListCollectionViewCell *)cell didSelectedType:(JGJWorkCircleMiddleInfoModel *)infoModel {

    if ([self.delegate respondsToSelector:@selector(JGJWorkCircleProTypeTableViewCell:didSelectedType:)]) {
        
        [self.delegate JGJWorkCircleProTypeTableViewCell:self didSelectedType:infoModel];
    }

}

- (void)chatButtonTouchDownPressed:(UIButton *)sender {
    
    self.groupChatInfoCountLable.alpha = 0.5;
    
    self.groupChatInfoLable.alpha = 0.5;
}

- (IBAction)chatButtonPressed:(UIButton *)sender {
    
    self.groupChatInfoCountLable.alpha = 1.0;
    
    self.groupChatInfoLable.alpha = 1.0;
    
    if ([self.delegate respondsToSelector:@selector(proTypeTableViewCell:buttonType:)]) {
        
        [self.delegate proTypeTableViewCell:self buttonType:ProTypeHeaderChatButtonType];
    }
}

- (void)workReplyButtonTouchDownPressed:(UIButton *)sender {
    
    self.workReplyCountLable.alpha = 0.5;
    
    self.workReplyLable.alpha = 0.5;
}

- (IBAction)workReplyButtonPressed:(UIButton *)sender {
    
    self.workReplyCountLable.alpha = 1.0;
    
    self.workReplyLable.alpha = 1.0;
    
    if ([self.delegate respondsToSelector:@selector(proTypeTableViewCell:buttonType:)]) {
        
        [self.delegate proTypeTableViewCell:self buttonType:ProTypeHeaderWorkReplyButtonType];
    }
}

- (IBAction)switchButtonProPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(proTypeTableViewCell:buttonType:)]) {
        
        [self.delegate proTypeTableViewCell:self buttonType:ProTypeHeaderSwitchProButtonType];
    }
}

- (JSBadgeView *)chatBadgeView {
    if (!_chatBadgeView) {
        _chatBadgeView = [[JSBadgeView alloc] initWithParentView:self.contentChatView alignment:JSBadgeViewAlignmentTopRight];
        _chatBadgeView.badgeBackgroundColor = TYColorHex(0xef272f);
        _chatBadgeView.badgeTextFont = [UIFont systemFontOfSize:AppFont24Size];
        _chatBadgeView.badgeStrokeColor = [UIColor redColor];
        _chatBadgeView.userInteractionEnabled = NO;
        _chatBadgeView.badgePositionAdjustment = CGPointMake(-20, 20);
    }
    return _chatBadgeView;
}

- (JSBadgeView *)replyBadgeView {
    if (!_replyBadgeView) {
        _replyBadgeView = [[JSBadgeView alloc] initWithParentView:self.contentReplyView alignment:JSBadgeViewAlignmentTopRight];
        _replyBadgeView.badgeBackgroundColor = TYColorHex(0xef272f);
        _replyBadgeView.badgeTextFont = [UIFont systemFontOfSize:AppFont24Size];
        _replyBadgeView.badgeStrokeColor = [UIColor redColor];
        _replyBadgeView.userInteractionEnabled = NO;
        _replyBadgeView.badgePositionAdjustment = CGPointMake(-20, 20);
    }
    return _replyBadgeView;
}

@end
