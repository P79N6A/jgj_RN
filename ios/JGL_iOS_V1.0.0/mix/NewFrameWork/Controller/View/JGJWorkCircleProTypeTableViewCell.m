//
//  JGJWorkCircleProTypeTableViewCell.m
//  JGJCompany
//
//  Created by yj on 17/3/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWorkCircleProTypeTableViewCell.h"

#import "JSBadgeView.h"

#import "JGJAvatarView.h"

@interface JGJWorkCircleProTypeTableViewCell ()<

    JGJWorkCircleProListCollectionViewCellDelegate
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;

@property (strong, nonatomic)NSArray *infoModels;

@property (weak, nonatomic) IBOutlet UIImageView *closedProFlagView;

//transform动画view
@property (weak, nonatomic) IBOutlet UIView *transView;

@property (weak, nonatomic) IBOutlet UIImageView *agencyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myCreatImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupName;

@property (weak, nonatomic) IBOutlet UILabel *groupChatInfoLable;

@property (weak, nonatomic) IBOutlet UILabel *chatCountLable;

@property (weak, nonatomic) IBOutlet UILabel *workReplyLable;

@property (weak, nonatomic) IBOutlet UILabel *replyCountLable;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (weak, nonatomic) IBOutlet UIView *contentChatView;

@property (weak, nonatomic) IBOutlet UIView *contentReplyView;

@property (weak, nonatomic) IBOutlet UIView *msgFlagView;

@property (strong, nonatomic) JSBadgeView *chatBadgeView;

@property (strong, nonatomic) JSBadgeView *replyBadgeView ;

@property (weak, nonatomic) IBOutlet JGJAvatarView *avatarView;

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
    
    CGFloat itemW = TYGetUIScreenWidth / 4.0;
    
    self.collectionViewLayout.itemSize = CGSizeMake(itemW, SelItemHeight);
    
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    self.collectionViewLayout.minimumInteritemSpacing = 0;
    
    self.collectionViewLayout.minimumLineSpacing = 0;
    
    CGFloat fontSize = TYIS_IPHONE_5 ? AppFont24Size : AppFont30Size;
    

    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    self.groupChatInfoLable.font = font;
    
    self.workReplyLable.font = font;
    
    self.groupChatInfoLable.textColor = AppFont333333Color;
    
    self.workReplyLable.textColor = AppFont333333Color;
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    self.transView.backgroundColor = AppFontf1f1f1Color;
    
    [self.transView.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.groupName.font = [UIFont boldSystemFontOfSize:AppFont34Size];
    
    self.replyCountLable.font = [UIFont boldSystemFontOfSize:fontSize];
    
    self.chatCountLable.font = [UIFont boldSystemFontOfSize:fontSize];
    
    self.contentChatView.backgroundColor = TYColorHex(0xEBEBEB);
    
    self.contentReplyView.backgroundColor = TYColorHex(0xEBEBEB);
    
    [self.contentChatView.layer setLayerCornerRadius:2.5];
    
    [self.contentReplyView.layer setLayerCornerRadius:2.5];

    self.msgFlagView.backgroundColor = AppFontEB4E4EColor;
    
    [self.msgFlagView.layer setLayerCornerRadius:TYGetViewH(self.msgFlagView) / 2.0];
    
//    [self.chatButton addTarget:self action:@selector(chatButtonTouchDownPressed:) forControlEvents:UIControlEventTouchDown];
//    
//    [self.replyButton addTarget:self action:@selector(workReplyButtonTouchDownPressed:) forControlEvents:UIControlEventTouchDown];
    
    self.replyBadgeView.hidden = YES;
    
    self.chatBadgeView.hidden = YES;
    
    [self.myCreatImageView.layer setLayerCornerRadius:3];
    
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {

    _proListModel = proListModel;
    
    //是否隐藏关闭项目标签
    self.closedProFlagView.hidden = !proListModel.group_info.isClosedTeamVc;
    
    NSString *closeType = @"Chat_closedGroup";
    
    if ([proListModel.group_info.class_type isEqualToString:@"team"]) {
        
        closeType = @"pro_closedFlag_icon";
    }
    
    self.closedProFlagView.image = [UIImage imageNamed:closeType];
    
    self.msgFlagView.hidden = [JGJChatMsgDBManger getHomeAllUnreadMsgCount] == 0;

    NSInteger unread_msg_count = [proListModel.chat_unread_msg_count integerValue];
    
    NSString *unread_msg_countStr = proListModel.chat_unread_msg_count;
    
    if (unread_msg_count > 99) {
        
        unread_msg_countStr = @"99+";
    }
    
   
    self.chatCountLable.text = unread_msg_countStr?:@"0";
    
    self.chatBadgeView.badgeText = unread_msg_countStr?:@"0";
    
    if (unread_msg_count != 0) {

        self.chatBadgeView.hidden = NO;

        self.chatCountLable.hidden = YES;

    }else {
        
        self.chatBadgeView.hidden = YES;
        
        self.chatCountLable.hidden = NO;
    }

    self.groupChatInfoLable.text = @"群聊消息";

    NSInteger work_message_num = [proListModel.work_message_num integerValue];

    NSString *workMessage = proListModel.work_message_num;
    
    if (work_message_num > 99) {
        
        workMessage = @"99+";
    }
    
    self.replyCountLable.text = workMessage?:@"0";
    
    self.replyBadgeView.badgeText = workMessage?:@"0";
    
    if (work_message_num != 0) {
        
        self.replyBadgeView.hidden = NO;
        
        self.replyCountLable.hidden = YES;
        
    }else {
        
        self.replyBadgeView.hidden = YES;
        
        self.replyCountLable.hidden = NO;
    }
    
    self.workReplyLable.text = @"工作回复";
    
    self.groupName.text = proListModel.group_info.group_name;
    
    [self setSenorCreatFlagWithProListModel:proListModel];
    
    
    [self setBadgeOffsetWithProListModel:proListModel];
    
    if (proListModel.group_info.members_head_pic.count > 0) {
        
        [self.avatarView getRectImgView:proListModel.group_info.members_head_pic];
        
    }

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

#pragma mark - 设置黄金、或者创建图标
- (void)setSenorCreatFlagWithProListModel:(JGJMyWorkCircleProListModel *)proListModel {

    BOOL is_agency = proListModel.group_info.is_agency_group;
    
    BOOL is_myAgency_group = proListModel.group_info.is_myAgency_group;
    
    BOOL isMyCreat = [proListModel.group_info.myself_group isEqualToString:@"1"];
    
    NSString *creatImageStr = @"";
    
    NSString *agencyImageStr = @"";
//    111 101 000 100 010  001 011
//    000  001  010 011 100 101 110 111
    if (is_agency && is_myAgency_group && isMyCreat) {
        
        creatImageStr = @"myCreat_Pro_icon";
        
        agencyImageStr = @"my_agency_icon"; //我创建的、我是代班
        
    }else if (is_agency && !is_myAgency_group && isMyCreat) {
        
        creatImageStr = @"myCreat_Pro_icon";
        
        agencyImageStr = @"setted_agency_icon"; //我创建的、我不是代班
        
    }else if (!is_agency && !is_myAgency_group && !isMyCreat) { //不是我创建的也没有代班
        
        creatImageStr = @"";
        
        agencyImageStr = @"";
        
    }else if (is_agency && !is_myAgency_group && !isMyCreat) { //不是我创建的已设置代班
        
        creatImageStr = @"";
        
//        creatImageStr = @"setted_agency_icon";
        
        agencyImageStr = @"";
        
    }else if (!is_agency && is_myAgency_group && !isMyCreat) { //不是我创建的我是代班
        
        creatImageStr = @"my_agency_icon";
        
        agencyImageStr = @"";
        
    }else if (!is_agency && !is_myAgency_group && isMyCreat) { //只是我创建的
        
        creatImageStr = @"myCreat_Pro_icon";
        
        agencyImageStr = @"";
        
    }else if (!is_agency && is_myAgency_group && isMyCreat) { //只是我创建的,我是代班
        
        creatImageStr = @"myCreat_Pro_icon";
        
        agencyImageStr = @"my_agency_icon"; //我创建的、我是代班
        
    }else if (is_agency && is_myAgency_group && !isMyCreat) { //只是我创建的,我是代班
        
        creatImageStr = @"my_agency_icon";
        
        agencyImageStr = @""; //我创建的、我是代班
        
    }
    
    if (![NSString isEmpty:creatImageStr]) {
        
        self.myCreatImageView.image = [UIImage imageNamed:creatImageStr];
        
    }
    
    self.myCreatImageView.hidden = [NSString isEmpty:creatImageStr];
    
    if (![NSString isEmpty:agencyImageStr]) {
        
        self.agencyImageView.image = [UIImage imageNamed:agencyImageStr];
        
    }
    
    self.agencyImageView.hidden = [NSString isEmpty:agencyImageStr];
    
    self.groupNameCenterY.constant = 10;
    
    if ([NSString isEmpty:creatImageStr] && [NSString isEmpty:agencyImageStr]) {
        
        self.groupNameCenterY.constant = 0;
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
    
    BOOL is_myCreater = [proModel.group_info.myself_group isEqualToString:@"1"];
    
    BOOL isTeam = [self.proListModel.group_info.class_type isEqualToString:@"team"];
    
    BOOL is_agency_author = proModel.group_info.is_myAgency_group && !isTeam; //是否具有代理权限
    
    BOOL is_myset_agency = proModel.group_info.is_agency_group && is_myCreater; //是否具有代理权限

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
                                 @"0",
                                 @"0",
                                 @"0"
                                 ];
    
    //初始没有代班长 unread_bill_count
    NSMutableArray *groupIsExistMsgs = @[@"0",
                                         @"0",
                                  proModel.unread_billRecord_count?:@"",//出勤公示
                                  proModel.unread_sign_count?:@"",
                                  proModel.unread_notice_count?:@"",
                                  proModel.unread_quality_count?:@"",
                                  proModel.unread_safe_count?:@"",
                                  proModel.unread_log_count?:@"",
                                  @"0", @"0"].mutableCopy;
    
    NSArray *imageIcons = isTeam ? ProListImageIcons : GroupListImageIcons;
    
    NSArray *descs = isTeam ? ProListDescs : GroupListDescs;
    
    if (is_agency_author) {    //我是代班长的情况
        
        imageIcons = AgencyGroupListImageIcons;
        
        descs = AgencyGroupListDescs;
        
        NSMutableArray *agencyInfos = @[@"0",@"0", @"0",@"0"].mutableCopy;
        
        [agencyInfos addObjectsFromArray:groupIsExistMsgs];
        
        groupIsExistMsgs = agencyInfos;
        
    }else if (is_myset_agency) { //我设置的代班长
        
        imageIcons = MySetAgencyListImageIcons;
        
        descs = MySetAgencyListDescs;
        
        if (groupIsExistMsgs.count > 0) {
            
            [groupIsExistMsgs insertObject:@"0" atIndex:1];
            
        }
    }
    
    NSArray *unReadMsgs = isTeam ? teamIsExistMsgs : groupIsExistMsgs;
    
    NSMutableArray *infos = [NSMutableArray array];
    
    for (int i = 0; i < imageIcons.count; i ++) {
        
        JGJWorkCircleMiddleInfoModel *infoModel = [[JGJWorkCircleMiddleInfoModel alloc] init];
        
        infoModel.InfoImageIcon = imageIcons[i];
        
        if (i < unReadMsgs.count) {
            
            infoModel.isHiddenUnReadMsgFlag = [unReadMsgs[i] integerValue] == 0;
            
        }
        
        if (i < descs.count) {
            
            infoModel.desc = descs[i];
        }
        
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

- (IBAction)chatButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(proTypeTableViewCell:buttonType:)]) {
        
        [self.delegate proTypeTableViewCell:self buttonType:ProTypeHeaderChatButtonType];
    }
}

- (void)chatButtonTouchDownPressed:(UIButton *)sender {
    
    self.groupChatInfoLable.alpha = 0.5;
    
    self.chatCountLable.alpha = 0.5;
}

- (void)workReplyButtonTouchDownPressed:(UIButton *)sender {
    
    self.replyCountLable.alpha = 0.5;
    
    self.workReplyLable.alpha = 0.5;
}


- (IBAction)workReplyButtonPressed:(id)sender {
    
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
