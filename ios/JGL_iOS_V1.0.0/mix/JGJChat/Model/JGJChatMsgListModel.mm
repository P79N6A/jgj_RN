//
//  JGJChatMsgListModel.m
//  mix
//
//  Created by Tony on 2016/8/31.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatMsgListModel.h"
#import "NSObject+MJCoding.h"
#import "TYUIImage.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"
#import "NSString+File.h"
#import "AudioRecordingServices.h"
#import "JGJChatListBaseCell.h"
#import "JGJImage.h"

#import "YYText.h"

#import "JGJChatMsgListModel+JGJWCDB.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "UILabel+GNUtil.h"

NSString *const chatMsgTimeFormat = @"yyyy-MM-dd HH:mm:ss";


@implementation JGJChatOtherMsgListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [JGJChatMsgListModel class]};
}
@end

@implementation JGJChatUserInfoModel


@end

@implementation JGJChatMsgExtendContentModel

@end

@implementation JGJChatMsgExtendMsgContentModel

@end

@implementation JGJChatMsgExtendModel

@end



static const CGFloat kChatListAudioMinWith = 55.0;

@interface JGJChatMsgListModel ()<WCTTableCoding>

@property (nonatomic, strong) JGJChatUserInfoModel *userModel;

@end

@implementation JGJChatMsgListModel

@synthesize msg_type = _msg_type;

@synthesize voice_long = _voice_long;

@synthesize wcdb_user_info = _wcdb_user_info;

- (void)setWcdb_user_info:(NSString *)wcdb_user_info {
    
    _wcdb_user_info = wcdb_user_info;
    
    if (!_user_info && ![NSString isEmpty:wcdb_user_info]) {
        
        self.user_info = [JGJChatUserInfoModel mj_objectWithKeyValues:[wcdb_user_info mj_JSONObject]];
        
        if (self.user_info) {
            
            self.user_name = self.user_info.real_name;
            
            self.telephone = self.user_info.telephone;
            
            self.send_name = self.user_info.real_name;
        }
        
    }
    
}

-(NSString *)wcdb_user_info {
    
    if ([NSString isEmpty:_wcdb_user_info] && _user_info) {
        
        _wcdb_user_info = [_user_info mj_JSONString];
    }
    
    return _wcdb_user_info;
}

- (NSString *)user_name {
    
    if ([NSString isEmpty:_user_name]) {
        
        if (self.user_info && [NSString isEmpty:_user_name]) {
            
            self.user_name = self.user_info.real_name;
            
            self.telephone = self.user_info.telephone;
            
            self.send_name = self.user_info.real_name;
            
        }
    }
    
    return _user_name;
}

-(JGJChatUserInfoModel *)user_info {
    
    if (![NSString isEmpty:self.wcdb_user_info]) {
        
         _user_info = [JGJChatUserInfoModel mj_objectWithKeyValues:[self.wcdb_user_info mj_JSONObject]];
        
        NSString *head_pic = [TYUserDefaults objectForKey:JLGHeadPic];
        
        NSString *myuid = [TYUserDefaults objectForKey:JLGUserUid];
        
        if (![NSString isEmpty:head_pic] && [_user_info.uid isEqualToString:myuid]) {
            
            if (![_user_info.head_pic isEqualToString:head_pic]) {
                
                _user_info.head_pic = head_pic;
            }
        }else {
            
            //其他用户如果头像被修改就用最新的修改头像
            
            if (![NSString isEmpty:self.modify_head_pic]) {
                
                _user_info.head_pic = self.modify_head_pic;
                
            }
            
        }
    }

    return _user_info;
}

- (JGJChatMsgExtendModel *)extend {
    
    if (!_extend) {
        
        _extend = [JGJChatMsgExtendModel mj_objectWithKeyValues:[self.wcdb_extend mj_JSONObject]];
        
    }
    
    return _extend;
}

#pragma mark - 转换成数据库排序用的
- (void)setMsg_id:(NSString *)msg_id {
    
    _msg_id = msg_id;
    
    self.wcdb_msg_id = [self.msg_id longLongValue];
    
}

#pragma mark - 定义绑定到数据库表的类
WCDB_IMPLEMENTATION(JGJChatMsgListModel)

#pragma mark - 定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(JGJChatMsgListModel, primary_key)

WCDB_SYNTHESIZE(JGJChatMsgListModel, local_id)

WCDB_SYNTHESIZE(JGJChatMsgListModel, msg_id)

WCDB_SYNTHESIZE(JGJChatMsgListModel, wcdb_msg_id)

WCDB_SYNTHESIZE(JGJChatMsgListModel, group_id)

WCDB_SYNTHESIZE(JGJChatMsgListModel, class_type)

WCDB_SYNTHESIZE(JGJChatMsgListModel, origin_group_id)

WCDB_SYNTHESIZE(JGJChatMsgListModel, origin_class_type)

WCDB_SYNTHESIZE(JGJChatMsgListModel, send_time)

WCDB_SYNTHESIZE(JGJChatMsgListModel, server_head_pic)

WCDB_SYNTHESIZE(JGJChatMsgListModel, local_head_pic)

WCDB_SYNTHESIZE(JGJChatMsgListModel, msg_sender)

WCDB_SYNTHESIZE(JGJChatMsgListModel, send_name)

WCDB_SYNTHESIZE(JGJChatMsgListModel, msg_text)

WCDB_SYNTHESIZE(JGJChatMsgListModel, msg_type)

WCDB_SYNTHESIZE(JGJChatMsgListModel, recall_time)

WCDB_SYNTHESIZE(JGJChatMsgListModel, unread_members_num)

WCDB_SYNTHESIZE(JGJChatMsgListModel, readed_members_num)

WCDB_SYNTHESIZE(JGJChatMsgListModel, sendType)

WCDB_SYNTHESIZE(JGJChatMsgListModel, msg_total_type)

WCDB_SYNTHESIZE(JGJChatMsgListModel, wcdb_user_info)

WCDB_SYNTHESIZE(JGJChatMsgListModel, msg_src)

WCDB_SYNTHESIZE(JGJChatMsgListModel, pic_w_h)

WCDB_SYNTHESIZE(JGJChatMsgListModel, assetlocalIdentifier)

WCDB_SYNTHESIZE(JGJChatMsgListModel, is_received)

WCDB_SYNTHESIZE(JGJChatMsgListModel, is_readed)

WCDB_SYNTHESIZE(JGJChatMsgListModel, user_unique)

WCDB_SYNTHESIZE(JGJChatMsgListModel, voice_long)
WCDB_SYNTHESIZE(JGJChatMsgListModel, extend_int)
// cc添加
WCDB_SYNTHESIZE(JGJChatMsgListModel, group_name)
WCDB_SYNTHESIZE(JGJChatMsgListModel, url)
WCDB_SYNTHESIZE(JGJChatMsgListModel, role_type)

WCDB_SYNTHESIZE(JGJChatMsgListModel, isplayed)
WCDB_SYNTHESIZE(JGJChatMsgListModel, detail)
WCDB_SYNTHESIZE(JGJChatMsgListModel, work_message)
WCDB_SYNTHESIZE(JGJChatMsgListModel, at_message)
WCDB_SYNTHESIZE(JGJChatMsgListModel, status)
WCDB_SYNTHESIZE(JGJChatMsgListModel, modify)
WCDB_SYNTHESIZE(JGJChatMsgListModel, bill_id)
WCDB_SYNTHESIZE(JGJChatMsgListModel, title)
WCDB_SYNTHESIZE(JGJChatMsgListModel, can_recive_client)

//点击他的资料后用户的最新头像

WCDB_SYNTHESIZE(JGJChatMsgListModel, modify_head_pic)
//工作、招聘
WCDB_SYNTHESIZE(JGJChatMsgListModel, job_detail)

//聊天延展字段

WCDB_SYNTHESIZE(JGJChatMsgListModel, wcdb_extend)

//用于存储招工、招聘

WCDB_SYNTHESIZE(JGJChatMsgListModel, msg_text_other)

//#pragma mark - 设置主键
WCDB_PRIMARY_AUTO_INCREMENT(JGJChatMsgListModel, primary_key)

//#pragma mark - 设置索引
WCDB_INDEX(JGJChatMsgListModel, "_index", group_id)

WCDB_INDEX(JGJChatMsgListModel, "_index", class_type)

WCDB_INDEX(JGJChatMsgListModel, "_index", wcdb_msg_id)

WCDB_INDEX(JGJChatMsgListModel, "_index", send_time)

-(BOOL)isAutoIncrement {

    return YES;
}

- (NSMutableAttributedString *)htmlStr {
    
    NSString * htmlString;

    if (self.chatListType == JGJChatListIntegralType || self.chatListType == JGJChatListLocalGroupChatType || self.chatListType == JGJChatListWorkGroupChatType || self.chatListType == JGJChatListPostCensorType) {
        
        htmlString = self.detail;
    }else if (self.chatListType == JGJChatListUnKonownMsgType) {
        
        htmlString = @"当前版本暂不支持查看此消息，请升级为最新版本查看";
    }
    else {
        
        htmlString = self.msg_text;
    }
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];//行间距
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;

    
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length])];//设置段落样式
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AppFont32Size] range:NSMakeRange(0, [attrStr length])];//设置段落样式
    return attrStr;
}

- (NSString *)group_name {
    
    if (![NSString isEmpty:_group_name]) {
        
        return _group_name;
    }
    return [JGJChatMsgDBManger getTheProjectNameWithGroup_id:self.group_id class_type:self.class_type];
}

- (JGJChatMsgType)msg_total_type {
    
    if ([self.sys_msg_type isEqualToString:@"normal"]) {
        
        _msg_total_type = JGJChatNormalMsgType; //普通消息类型
        
    }else if ([self.sys_msg_type  isEqualToString:@"work"]) {
        
        _msg_total_type = JGJChatWorkMsgType; //工作消息类型
        
    }else if ([self.sys_msg_type  isEqualToString:@"activity"]) {
        
        _msg_total_type = JGJChatActivityMsgType; //活动消息类型
        
    }else if ([self.sys_msg_type  isEqualToString:@"recruit"]) {
        
        _msg_total_type = JGJChatRecruitMsgType; //招聘消息类型
        
    }else if ([self.sys_msg_type  isEqualToString:@"newFriends"]) {
        
        _msg_total_type = JGJChatNewFriendsMsgType; //新的好友类型
        
    }
    else if ([self.sys_msg_type isEqualToString:@"system"]) {
        
        _msg_total_type = JGJChatMsgSystemType; //系统消息。加人、签到等
        
    }
    
    return _msg_total_type;
}

+ (NSDictionary *)objectClassInArray{
    
    return @{@"read_info" : [ChatMsgList_Read_info class]};
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        _token = [NSString isEmpty:[TYUserDefaults objectForKey:JLGUserUid]]?@"":[TYUserDefaults objectForKey:JLGUserUid];
        
        _user_unique = _token;
        
    }

    return self;
}

- (void)setMsg_type:(NSString *)msg_type{
    _msg_type = msg_type;
    
    if ([_msg_type isEqualToString:@"text"]) {
        self.chatListType = JGJChatListText;
    }else if([_msg_type isEqualToString:@"voice"]){
        self.chatListType = JGJChatListAudio;
    }else if([_msg_type isEqualToString:@"notice"]){
        self.chatListType = JGJChatListNotice;
    }else if([_msg_type isEqualToString:@"safe"]){
        self.chatListType = JGJChatListSafe;
    }else if([_msg_type isEqualToString:@"quality"]){
        self.chatListType = JGJChatListQuality;
    }else if([_msg_type isEqualToString:@"memberJoin"] || [_msg_type isEqualToString:@"memberjoin"]){
        self.chatListType = JGJChatListMemberJoin;
    }else if([_msg_type isEqualToString:@"billRecord"]){
        self.chatListType = JGJChatListRecord;
    }else if([_msg_type isEqualToString:@"log"]){
        self.chatListType = JGJChatListLog;
    }else if([_msg_type isEqualToString:@"signIn"]){
        self.chatListType = JGJChatListSign;
    }else if([_msg_type isEqualToString:@"recall"]){
        self.chatListType = JGJChatListRecall;
    }else if([_msg_type isEqualToString:@"pic"]){
        self.chatListType = JGJChatListPic;
    }else if([_msg_type isEqualToString:@"proDetail"]){
        self.chatListType = JGJChatListProDetailType;
    }else if ([_msg_type isEqualToString:@"addGroupFriend"]) {
        self.chatListType = JGJChatListAddGroupFriendType;
    }
    // v3.4 cc添加
    else if ([_msg_type isEqualToString:@"oss"]) {// 云盘推送
        
        self.chatListType = JGJChatListOssType;
        
    }
    else if ([_msg_type isEqualToString:@"meeting"]) {// 会议
        
        self.chatListType = JGJChatListMeeting;
        
    }else if ([_msg_type isEqualToString:@"syncGroupToGroup"]) {//记工同步请求
        
        self.chatListType = JGJChatListSyncGroupToGroupType;
        
    }else if ([_msg_type isEqualToString:@"syncNoticeTarget"]) {//记工同步通知
        
        self.chatListType = JGJChatListSyncNoticeTargetType;
        
    }else if ([_msg_type isEqualToString:@"syncedSyncGroupToGroup"]) {//对你同步项目
        
        self.chatListType = JGJChatListSyncedSyncGroupToGroupType;
        
    }else if ([_msg_type isEqualToString:@"syncProject"]) {//被要求同步项目
        
        self.chatListType = JGJChatListSyncProjectType;
        
    }else if ([_msg_type isEqualToString:@"task"]) {// 任务
        
        self.chatListType = JGJChatListTaskType;
    }else if ([_msg_type isEqualToString:@"inspect"]) {// 检查
        
        self.chatListType = JGJChatListInspectType;
    }else if ([_msg_type isEqualToString:@"agreeFriends"]) {// 好友请求通过
        
        self.chatListType = JGJChatListAgreeFriendsType;
    }else if ([_msg_type isEqualToString:@"agreeFriendsNotice"]) {// 我同意 别人好友请求
        
        self.chatListType = JGJChatListAgreeFriendsType;
    }else if ([_msg_type isEqualToString:@"join"]) {// 加入班组请求
        
        self.chatListType = JGJChatListJoinType;
    }else if ([_msg_type isEqualToString:@"approval"]) {// 审批
        
        self.chatListType = JGJChatListApproveType;
    }else if ([_msg_type isEqualToString:@"remove"]) {// 被移除班组
        
        self.chatListType = JGJChatListRemoveType;
        
    }else if ([_msg_type isEqualToString:@"delmember"]) { //移除成员自己这边系统消息，显示样式
        
        self.chatListType = JGJChatListDelmemberType;
        
    }else if ([_msg_type isEqualToString:@"close"]) {// 收到关闭项目或者班组推送
        
        self.chatListType = JGJChatListCloseType;
    }else if ([_msg_type isEqualToString:@"reopen"]) {// 收到项目重启推送
        
        self.chatListType = JGJChatListReopenType;
    }else if ([_msg_type isEqualToString:@"switchgroup"]) {// 收到转让管理员权限
        
        self.chatListType = JGJChatListSwitchgroupType;
    }else if ([_msg_type isEqualToString:@"cancellSyncBill"]) {// 取消同步项目（记工）
        
        self.chatListType = JGJChatListCancellSyncBillType;
        
    }else if ([_msg_type isEqualToString:@"cancellSyncProject"]) {//// 取消同步项目（记工）
        
        self.chatListType = JGJChatListCancellSyncProjectType;
        
    }else if ([_msg_type isEqualToString:@"refuseSyncBill"]) {//拒绝同步记工
        
        self.chatListType = JGJChatListRefuseSyncBillType;
        
    }else if ([_msg_type isEqualToString:@"demandSyncBill"]) {// 要求同步记工
        
        self.chatListType = JGJChatListDemandSyncBillType;
        
    }else if ([_msg_type isEqualToString:@"syncBillToYou"]) {//记工同步通知
        
        self.chatListType = JGJChatListSyncBillToYouType;
        
    }else if ([_msg_type isEqualToString:@"createNewTeam"]) {//创建新项目组
        
        self.chatListType = JGJChatListCreateNewTeamType;
        
    }else if ([_msg_type isEqualToString:@"joinTeam"]) {//被加入新项目组
        
        self.chatListType = JGJChatListJoinTeamType;
    }else if ([_msg_type isEqualToString:@"refuseSyncProject"]) {//拒绝同步项目
        
        self.chatListType = JGJChatListRefuseSyncProjectType;
    }else if ([_msg_type isEqualToString:@"syncProjectToYou"]) {//对你同步项目(同步记工)
        
        self.chatListType = JGJChatListSyncProjectToYouType;
        
    }else if ([_msg_type isEqualToString:@"demandSyncProject"]) {//要求同步项目
        
        self.chatListType = JGJChatListDemandSyncProjectType;
    }else if ([_msg_type isEqualToString:@"agreeSyncProject"]) {//同意同步项目
        
        self.chatListType = JGJChatListAgreeSyncProjectType;
    }else if ([_msg_type isEqualToString:@"agreeSyncProjectToYou"]) {//同意对你同步项目的类型
        
        self.chatListType = JGJChatListAgreeSyncProjectToYouType;
    }
    else if ([_msg_type isEqualToString:@"agreeSyncBill"]) {//同意同步记工
        
        self.chatListType = JGJChatListagreeSyncBillType;
        
    }else if ([_msg_type isEqualToString:@"upgradegroupchat"]) { //本班组由群聊升级而来,
        
        self.chatListType = JGJChatListUpgradeGroupChatType;
    }else if ([_msg_type isEqualToString:@"evaluate"]) { //评价,
        
        self.chatListType = JGJChatListEvaluateType;
    }else if ([_msg_type isEqualToString:@"present_integral"]) { //积分,
        
        self.chatListType = JGJChatListIntegralType;
    }else if ([_msg_type isEqualToString:@"dismissGroup"]) { //群主解散群通知
        
        self.chatListType = JGJChatListDismissGroupType;
    }else if ([_msg_type isEqualToString:@"friend"]) { //好友注册通知
        
        self.chatListType = JGJChatListFriendType;
    }else if ([_msg_type isEqualToString:@"local_group_chat"]) { //加入当地群
        
        self.chatListType = JGJChatListLocalGroupChatType;
    }else if ([_msg_type isEqualToString:@"work_group_chat"]) { //加入工种群
        
        self.chatListType = JGJChatListWorkGroupChatType;
    }else if ([_msg_type isEqualToString:@"bottomDefaultSpace"]) { //空白cell
        
        self.chatListType = JGJChatListBottomDefaultSpaceType;
    }else if ([_msg_type isEqualToString:@"modifyname"]) { //空白cell
        
        self.chatListType = JGJChatListModifyNameType;
    }else if ([_msg_type isEqualToString:@"activity"]) { //活动消息
        
        self.chatListType = JGJChatListActivityType;
        
    }else if ([_msg_type isEqualToString:@"authpass"]) {
        
        self.chatListType = JGJChatListAuthpassType;
    }else if ([_msg_type isEqualToString:@"authfail"]) {
       
        self.chatListType = JGJChatListAuthfailType;
        
    }else if ([_msg_type isEqualToString:@"authexpired"]) {
        
        self.chatListType = JGJChatListAuthexpiredType;
    }else if ([_msg_type isEqualToString:@"authdue"]) {
        
        self.chatListType = JGJChatListAuthdueType;
    }else if ([_msg_type isEqualToString:@"workremind"]) {
        
        self.chatListType = JGJChatListWorkremindType;
        
    }else if ([_msg_type isEqualToString:@"feedback"]) {
        
        self.chatListType = JGJChatListFeedbackType;
        
    }else if ([_msg_type isEqualToString:@"group_bill"]) {//出勤公示
        
        self.chatListType = JGJChatListBillRecord;
        
    }
    else if ([_msg_type isEqualToString:@"postcard"]) { //服务器名片消息
        
        self.chatListType = JGJChatPostcardType;
        
    }else if ([_msg_type isEqualToString:@"recruitment"]) { //服务器招工消息
        
        self.chatListType = JGJChatRecruitmentType;
    }else if ([_msg_type isEqualToString:@"auth"]) {
        
        self.chatListType = JGJChatAuthType;
        
    }else if ([_msg_type isEqualToString:@"link"]) {// 链接消息
        
        self.chatListType = JGJChatListLinkType;
        
    }
    else if ([_msg_type isEqualToString:@"post_censor"]) {// 帖子违规消息
        
        self.chatListType = JGJChatListPostCensorType;
        
    }
    else if ([_msg_type isEqualToString:@"projectinfo"]) {// 招聘小助手里面的招工情况
        
        self.chatListType = JGJChatListProjectInfoType;
    }
    
    else {// 未知类型
     
        self.chatListType = JGJChatListUnKonownMsgType;
    }
    
    // 获取本地名片或者招工类型
    if ([_local_msg_type isEqualToString:@"local_postcard"]) { //本地名片消息

        self.chatListType = JGJChatLocalPostcardType;

    }else if ([_local_msg_type isEqualToString:@"local_recruitment"]) { //本地招工消息

        self.chatListType = JGJChatLocalRecruitmentType;

    }else if ([_local_msg_type isEqualToString:@"local_verified"]) { //本地招工消息
        
        self.chatListType = JGJChatLocaLVerifiedType;
        
    }

}
- (NSString *)msg_type{
    if (_msg_type) {
        
        return  _msg_type;
    }
    //如果没有就通过listType转换
    if (self.chatListType == JGJChatListText) {
        
        _msg_type = @"text";
    }else if(self.chatListType == JGJChatListAudio){
        
        _msg_type = @"voice";
    }else if(self.chatListType == JGJChatListNotice){
        
        _msg_type = @"notice";
    }else if(self.chatListType == JGJChatListSafe){
        _msg_type = @"safe";
    }else if(self.chatListType == JGJChatListQuality){
        _msg_type = @"quality";
    }else if(self.chatListType == JGJChatListMemberJoin){
        _msg_type = @"memberJoin";
    }else if(self.chatListType == JGJChatListRecord){
        _msg_type = @"billRecord";
    }else if(self.chatListType == JGJChatListLog){
        _msg_type = @"log";
    }else if(self.chatListType == JGJChatListSign){
        
        _msg_type = @"signIn";
    }else if(self.chatListType == JGJChatListRecall){
        
        _msg_type = @"recall";
        
    }else if(self.chatListType == JGJChatListPic){
        
        _msg_type = @"pic";
    }
    //v3.4 cc添加
    else if (self.chatListType == JGJChatListOssType) {// 会议
        
        _msg_type = @"oss";
        
    }
    else if (self.chatListType == JGJChatListMeeting) {
        
        _msg_type = @"meeting";
        
    }else if (self.chatListType == JGJChatListSyncGroupToGroupType) {//记工同步请求
        
        _msg_type = @"syncGroupToGroup";
        
    }else if (self.chatListType == JGJChatListSyncNoticeTargetType) {//记工同步通知
        
        _msg_type = @"syncNoticeTarget";
        
    }else if (self.chatListType == JGJChatListSyncedSyncGroupToGroupType) {//对你同步项目
        
        _msg_type = @"syncedSyncGroupToGroup";
        
    }else if (self.chatListType == JGJChatListSyncProjectType) {//被要求同步项目
        
        _msg_type = @"syncProject";
    }else if (self.chatListType == JGJChatListTaskType) {//任务
        
        _msg_type = @"task";
    }else if (self.chatListType == JGJChatListInspectType) {// 检查
        
       _msg_type = @"inspect";
    }else if (self.chatListType == JGJChatListAgreeFriendsType) {// 好友请求通过
        
        _msg_type = @"agreeFriends";
    }else if (self.chatListType == JGJChatListAgreeFriendsType) {// 我同意 别人好友请求
        
        _msg_type = @"agreeFriendsNotice";
    }
    else if (self.chatListType == JGJChatListJoinType) {// 加入新班组
        
        _msg_type = @"join";
    }else if (self.chatListType == JGJChatListApproveType) {// 审批
        
        _msg_type = @"approval";
    }else if (self.chatListType == JGJChatListRemoveType) {// 被移除班组
        
        _msg_type = @"remove";
    }else if (self.chatListType == JGJChatListCloseType) {// 收到关闭项目或者班组推送
        
        _msg_type = @"close";
    }else if (self.chatListType == JGJChatListReopenType) {// 收到项目重启推送
        
        _msg_type = @"reopen";
    }else if (self.chatListType == JGJChatListSwitchgroupType) {// 收到转让管理员权限
        
        _msg_type = @"switchgroup";
    }else if (self.chatListType == JGJChatListCancellSyncBillType) {// 取消同步项目（记工）
        
        _msg_type = @"cancellSyncBill";
        
    }else if (self.chatListType == JGJChatListCancellSyncProjectType) {//// 取消同步项目（记工）
        
        _msg_type = @"cancellSyncProject";
        
    }else if (self.chatListType == JGJChatListRefuseSyncBillType) {//拒绝同步记工
        
        _msg_type = @"refuseSyncBill";
        
    }else if (self.chatListType == JGJChatListDemandSyncBillType) {// 要求同步记工
        
        _msg_type = @"demandSyncBill";
        
    }else if (self.chatListType == JGJChatListSyncBillToYouType) {//记工同步通知
        
        _msg_type = @"syncBillToYou";
        
    }else if (self.chatListType == JGJChatListCreateNewTeamType) {//创建新项目组
        
        _msg_type = @"createNewTeam";
        
    }else if (self.chatListType == JGJChatListJoinTeamType) {//被加入新项目组
        
        _msg_type = @"joinTeam";
    }else if (self.chatListType == JGJChatListRefuseSyncProjectType) {//拒绝同步项目
        
        _msg_type = @"refuseSyncProject";
    }else if (self.chatListType == JGJChatListSyncProjectToYouType) {//对你同步项目(同步记工)
        
        _msg_type = @"syncProjectToYou";
        
    }else if (self.chatListType == JGJChatListAgreeSyncProjectToYouType) {//同意对你同步项目的类型
        
        _msg_type = @"agreeSyncProjectToYou";
        
    }else if (self.chatListType == JGJChatListDemandSyncProjectType) {//要求同步项目
        
        _msg_type = @"demandSyncProject";
    }else if (self.chatListType == JGJChatListAgreeSyncProjectType) {//同意同步项目
        
        _msg_type = @"agreeSyncProject";
    }else if (self.chatListType == JGJChatListagreeSyncBillType) {//同意同步记工
        
        _msg_type = @"agreeSyncBill";
    }else if (self.chatListType == JGJChatListEvaluateType) { //评价,
        
        _msg_type = @"evaluate";
    }else if (self.chatListType == JGJChatListIntegralType) { //积分,
        
        _msg_type = @"present_integral";
    }else if (self.chatListType == JGJChatListDismissGroupType) { //群主解散群通知
        
        _msg_type = @"dismissGroup";
    }else if (self.chatListType == JGJChatListUpgradeGroupChatType) { //本班组由群聊升级而来,
        
        _msg_type = @"upgradegroupchat";
    }else if (self.chatListType == JGJChatListFriendType) { //好友注册通知
        
        _msg_type = @"friend";
    }else if (self.chatListType == JGJChatListLocalGroupChatType) { //加入当地群
        
        _msg_type = @"local_group_chat";
    }else if (self.chatListType == JGJChatListWorkGroupChatType) { //加入工种群
        
        _msg_type = @"work_group_chat";
    }else if (self.chatListType == JGJChatListBottomDefaultSpaceType) { //空白cell
        
        _msg_type = @"bottomDefaultSpace";
    }else if (self.chatListType == JGJChatListModifyNameType) { //修改项目名称
        
        _msg_type = @"modifyname";
    }else if (self.chatListType == JGJChatListActivityType) { //活动消息
        
        _msg_type = @"activity";
    }
    
    return _msg_type;
}

- (BOOL)isDefaultText{
    
    //这些都是系统消息，样式
    
    if ([self isSysMgs]) {
        
        return YES;
        
    }else if(self.chatListType == JGJChatListMemberJoin || self.chatListType == JGJChatListDelmemberType || self.chatListType == JGJChatListRecall || self.chatListType == JGJChatListAddGroupFriendType || self.chatListType == JGJChatListSign || self.chatListType == JGJChatListJoinType || self.chatListType == JGJChatListRemoveType || self.chatListType == JGJChatListCloseType || self.chatListType == JGJChatListReopenType || self.chatListType == JGJChatListSwitchgroupType  || self.msg_total_type == JGJChatMsgSystemType || self.chatListType == JGJChatListAgreeFriendsType || self.chatListType == JGJChatListAddGroupFriendType || self.chatListType == JGJChatListUpgradeGroupChatType) {
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}

#pragma mark - 普通型消息类型
- (BOOL)is_normal_msg {
    
    NSArray *msg_typs = @[@"text", @"voice", @"notice", @"safe", @"quality", @"log", @"pic", @"proDetail",@"recruitment",@"postcard",@"link",@"auth"];
    
    _is_normal_msg = [msg_typs containsObject:_msg_type.lowercaseString];
    
    return _is_normal_msg;
}

-(BOOL)isSysMgs {
    
    NSArray *sys = @[@"createchat", @"createteam",@"creategroup",@"addgroupfriend",@"agreefrinotice",@"agreefriends",@"agreefriendsnotice",@"agreefriendsnot",@"modifyname",@"setadmin",@"switchgroup",@"codejoin",@"memberjoin",@"delmember",@"prodetail",@"recall",@"signin",@"upgradegroupchat",@"chatlocate"];
    
    BOOL is_sys = [sys containsObject:_msg_type.lowercaseString];
    
    return is_sys;
    
}

- (NSString *)msg_text {
    
    NSString *msg = _msg_text;
   
    NSString *real_name = self.user_info.real_name;
    
    NSString *myuid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if (self.isDefaultText && ![NSString isEmpty:real_name]) {
        
        if ([self.msg_type isEqualToString:@"recall"]) { //系统消息撤回类型
            
            if ([self.msg_sender isEqualToString:myuid]) {
                
                _msg_text = @"你 撤回一条消息";
                
            }else {
                
                _msg_text = [NSString stringWithFormat:@"%@ %@", real_name,@"撤回一条消息"];
                
            }
            
        }else if ([self.msg_type isEqualToString:@"signIn"]) {
            
            if ([self.msg_sender isEqualToString:myuid]) {
                
                _msg_text = @"你已签到";
                
            }else {
                
                _msg_text = [NSString stringWithFormat:@"%@ %@", real_name,@"已签到"];
            }
            
        }
        
    }
    
    return msg;
}

- (JGJChatFindJobModel *)msg_prodetail {
    
    if (![NSString isEmpty:_job_detail]) {
        
        NSDictionary *dic = [_job_detail mj_keyValues];
        
        _msg_prodetail = [JGJChatFindJobModel mj_objectWithKeyValues:dic];
        
    }
    
    return _msg_prodetail;
}

- (JGJChatRecruitMsgModel *)recruitMsgModel {
    
    if (![NSString isEmpty:_msg_text_other] && ([self.msg_type isEqualToString:@"recruitment"] || [self.msg_type isEqualToString:@"postcard"] || [self.msg_type isEqualToString:@"auth"])) {
        
        NSDictionary *dic = [_msg_text_other mj_keyValues];
        
        _recruitMsgModel = [JGJChatRecruitMsgModel mj_objectWithKeyValues:dic];
        
    }
    
    return _recruitMsgModel;
}

- (JGJChatShareLinkModel *)shareMenuModel {
    
    if ([NSString isEmpty:_msg_text_other]) { return nil;}
    
    if ([self.msg_type isEqualToString:@"link"]) {
        
        NSDictionary *dic = [_msg_text_other mj_keyValues];
        
        _shareMenuModel = [JGJChatShareLinkModel mj_objectWithKeyValues:dic];
        
    }
    
    return _shareMenuModel;
}

- (JGJChatListBelongType )belongType{
    
    if (_belongType) {
        
        return _belongType;
        
    }
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];

    if (self.msg_total_type == JGJChatWorkMsgType && !self.is_normal) {
        
        return JGJChatListBelongOther;
        
    }else {
        
        if ([myUid isEqualToString:self.msg_sender]) {
            
            return JGJChatListBelongMine;
            
        }else {
            
            return [self.is_out_member boolValue]?JGJChatListBelongGroupOut:JGJChatListBelongOther;
            
        }
    }
    
}

- (NSString *)head_pic {
    
    return _head_pic?:@"";
}



- (void)setPicImage:(UIImage *)picImage{
    NSData *data=UIImageJPEGRepresentation(picImage, 1.0);
    
    if (data.length>100*1024) {//如果图片大于100k就转换
        NSData *picData = [TYUIImage imageData:picImage];
        _picImage = [UIImage imageWithData:picData];
    }else{
        _picImage = picImage;
    }
}
#define ProDetailContentViewH 225

#define ProDetailTopViewH 80

#define ProDetailBottomViewH 90

#define ProDetailMemberDesH 21

#define ChatBottomPadding 23

#define ChatVertifyViewH 103

#define CellMaxWidth TYIS_IPHONE_5_OR_LESS?202:(TYIS_IPHONE_6 || TYIST_IPHONE_X ? 220 : 260)

- (CGFloat)cellHeight {
    
    CGFloat height = 0.0;
    
    if (![NSString isFloatZero:_cellHeight]) {

        return _cellHeight;
    }

    if (self.chatListType == JGJChatListRecord) {

        return CGFLOAT_MIN;
    }
    
    //项目信息高度
    if (self.chatListType == JGJChatListProDetailType) {
        
        height = ProDetailContentViewH;
        if (!self.msg_prodetail.prodetailactive && self.msg_prodetail.searchuser) {
            
            height -= ProDetailTopViewH;
        }else if (!self.msg_prodetail.searchuser && self.msg_prodetail.prodetailactive) {
            
            height -= ProDetailBottomViewH;
            if ([NSString isEmpty:self.msg_prodetail.searchuser.title]) {
                
                height -= ProDetailMemberDesH;
            }
        }else if (!self.msg_prodetail.searchuser && !self.msg_prodetail.prodetailactive) {
            
            height = 0;
        }
        
        BOOL isVerified = NO;
        
        //没有照招工信息，只有未认证
        
        if (![NSString isEmpty:self.msg_prodetail.verified]) {
            
            isVerified = ![self.msg_prodetail.verified isEqualToString:@"3"];
            
        }
        
        if (isVerified) {
            
            //不等于3，没有认证加上认证高度
            
            height += ChatVertifyViewH;
            
        }
        
        return height;
    }
    
    // 得到语音高度
    if (self.chatListType == JGJChatListAudio) {
        
        return [self getAudioCellHeightWithChatListModel:self];
    }
    
    if (self.isDefaultText) {
        
        height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 108 content:self.msg_text font:AppFont24Size] + ChatBottomPadding + 10; //10是偏移
        
        return height;
        
    }else if (self.belongType == JGJChatListBelongMine) {
        
        if (self.chatListType == JGJChatListPic) {
            
            height = self.imageSize.height + 33;
            
        }else{
            
            height = [self getCellHeightWithChatListModel:self];
            
        }
    }else if (self.chatListType == JGJChatListPic) {
        
        height = self.imageSize.height + 33;
        
    }else if ((self.msg_total_type == JGJChatWorkMsgType || self.msg_total_type == JGJChatActivityMsgType || self.msg_total_type == JGJChatRecruitMsgType) && !self.is_normal) {// 工作推送,招聘消息推送,活动消息推送 ,普通聊天is_normal是YES
        
        height = [self getWorkingTypeMsgHeight];
        
    }else {
            
        height = [self getCellHeightWithChatListModel:self];
            
    }
    
    if (self.chatListType == JGJChatAuthType) {
        
        if (self.belongType != JGJChatListBelongMine) {
            
            height = 73.0;
            
        }else {
            
            height = 0.0;
        }
        
    }
    
    if (self.chatListType == JGJChatListLinkType) {
        
        height = 31.0 + 14 + 20 + 13;
        
        CGFloat titleHeight = 0.0;
        CGFloat describeHeight = 0.0;
        CGFloat urlHeight = 0.0;
        if (![NSString isEmpty:self.shareMenuModel.title]) {

            CGSize size =  [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 64 - 76 - 30 - 7, CGFLOAT_MAX) content:self.shareMenuModel.title font:16];
            titleHeight = ceil(size.height) + 1;
            UIFont *font = [UIFont systemFontOfSize:16];
            if (titleHeight >= 2 * font.lineHeight) {
                
                titleHeight = 2 * font.lineHeight + 5;
            }
            
        }
        
        if (![NSString isEmpty:self.shareMenuModel.describe]) {
            
            CGSize size =  [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 64 - 76 - 92 - 7, CGFLOAT_MAX) content:self.shareMenuModel.describe font:12];
            describeHeight = ceil(size.height) + 1;
            
            UIFont *font = [UIFont systemFontOfSize:AppFont24Size];
            
            if (describeHeight >= 3 * font.lineHeight) {
                
                describeHeight = 3 * font.lineHeight + 5;
            }
            
            if (describeHeight < 45.0) {
                
                describeHeight = 45.0;
            }
            
        }
        
        if (![NSString isEmpty:self.shareMenuModel.url]) {
            
            CGSize size =  [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 64 - 76 - 92 - 7, CGFLOAT_MAX) content:self.shareMenuModel.describe font:12];
            urlHeight = ceil(size.height) + 1;
            
            UIFont *font = [UIFont systemFontOfSize:AppFont24Size];
            
            if (urlHeight >= 3 * font.lineHeight) {
                
                urlHeight = 3 * font.lineHeight + 5;
            }
            
            if (urlHeight < 45.0) {
                
                urlHeight = 45.0;
            }
        }
        
        // 标题和内容都不存在 只显示链接
        if ([NSString isEmpty:self.shareMenuModel.describe] && [NSString isEmpty:self.shareMenuModel.title]) {
            
            height = height + urlHeight;
            
        }else {
            
            height = height + titleHeight;
            
            if (![NSString isEmpty:self.shareMenuModel.describe]) {
                
                height = height + 7;
            }
            
            if (![NSString isEmpty:self.shareMenuModel.title]) {// 内容不为空 优先显示内容
                
                height = height + describeHeight;
                
            }else {
                
                height = height + urlHeight;
            }
            
        }
        
    }
    
    //本地名片消息
    if ([self.local_msg_type isEqualToString:@"local_postcard"]) {
        
        // 是否认证
        BOOL isVerified = NO;
        if (![NSString isEmpty:self.recruitMsgModel.verified]) {
            
            isVerified = [self.recruitMsgModel.verified isEqualToString:@"3"];
            
        }
        if (isVerified) {
            
            if (self.is_send_success) {
                
                height = 0.0;
                
            }else {
                
                height = 10 + 103 + 5;
                height = height + 20;
            }
            
        }else {
            
            if (self.is_send_success) {
                
                height = 10 + 11 + 45 + 5;
                
            }else {
                
                height = 10 + 103 + 46 + 45 + 5;
                
            }
            height = height + 20;
        }
        
        
        
    }else if ([self.local_msg_type isEqualToString:@"local_recruitment"]) {
        
        // 是否认证
        BOOL isVerified = NO;
        if (![NSString isEmpty:self.recruitMsgModel.verified]) {
            
            isVerified = [self.recruitMsgModel.verified isEqualToString:@"3"];
            
        }
        if (isVerified) {
            
            if (self.is_send_success) {
                
                height = 0.0;
                
            }else {
                
                height = 10 + 68 + 5;
                height = height + 20;
            }
            
        }else {
            
            if (self.is_send_success) {
                
                height = 10 + 11 + 45 + 5;
                height = height + 20;
                
            }else {
                
                height = 10 + 68 + 46 + 45 + 5;
                height = height + 20;
            }
            
        }
        
        
        
    }else if ([self.local_msg_type isEqualToString:@"local_verified"]) {
        
        // 是否认证
        BOOL isVerified = NO;
        if (![NSString isEmpty:self.recruitMsgModel.verified]) {
            
            isVerified = [self.recruitMsgModel.verified isEqualToString:@"3"];
            
        }
        
        if (isVerified) {
            
            height = 0;
            
        }else {
            
            height = 85;
        }
        
    }else if ([self.msg_type isEqualToString:@"postcard"]) {// 名片消息
        
        height = 145 + 13 - 3;
        
        // 信息
        NSMutableString *userInfoString = [NSMutableString string];
        JGJChatRecruitMsgModel *model = self.recruitMsgModel;
        if (![NSString isEmpty:model.nationality]) {
            
            [userInfoString appendFormat:@"%@",model.nationality];
        }
        if (![NSString isEmpty:model.work_year] && [model.work_year integerValue] > 0) {
            if ([NSString isEmpty:userInfoString]) {
                [userInfoString appendFormat:@"工龄 %@ 年",model.work_year];
            } else {
                [userInfoString appendFormat:@" 工龄 %@ 年",model.work_year];
            }

        }
        if (![NSString isEmpty:model.scale] && [model.scale integerValue] > 0) {
            if ([NSString isEmpty:userInfoString]) {
                [userInfoString appendFormat:@"队伍 %@ 人",model.scale];
            } else {
                [userInfoString appendFormat:@" 队伍 %@ 人",model.scale];
            }
            
        }
        
        if ([NSString isEmpty:userInfoString]) {
            
            height = height - 11 - 8;
            
        }
        
    }else if ([self.msg_type isEqualToString:@"recruitment"]) {// 招工消息
        
        CGFloat contentH = 0.0;
        if (self.recruitMsgModel.classes.cooperate_type.type_id == 4) {// 突击队
            
            NSString *balanceway = self.recruitMsgModel.classes.balance_way;
            
            NSString *unitStr = [NSString stringWithFormat:@"元/%@", balanceway];
            
            NSString *money = self.recruitMsgModel.classes.money;
            
            CGFloat conver_money = [NSString stringWithFormat:@"%@", money].doubleValue;
            
            if (conver_money >= 10000) {
                
                money = [self unitConverWithMoney:money];
            }
            
            NSString *max_money = self.recruitMsgModel.classes.max_money;
            
            CGFloat conver_max_money = [NSString stringWithFormat:@"%@", max_money].doubleValue;
            
            if (conver_max_money >= 10000) {
                
                max_money = [self unitConverWithMoney:max_money];
            }
            
            NSString *merMoney = money;
            
            if (![NSString isEmpty:self.recruitMsgModel.classes.max_money]) {
                
                if (![self.recruitMsgModel.classes.max_money isEqualToString:@"0"]) {
                    
                    merMoney = [NSString stringWithFormat:@"%@~%@",money, max_money];
                }
                
            }
            
            NSString *total_scale = self.recruitMsgModel.classes.total_scale;
            CGFloat conver_total_scale = [NSString stringWithFormat:@"%@", total_scale].doubleValue;
            
            if (conver_total_scale >= 10000) {
                
                total_scale = [self unitConverWithMoney:total_scale];
            }
            
            NSString *time = self.recruitMsgModel.classes.work_begin;
            
            if ([NSString isEmpty:time]) {
                
                time = @"";
            }
            
            
            NSString *contentS = @"";
            if ([money isEqualToString:@"0"] || [NSString isEmpty:money]) {
                
                unitStr = @"面议";
                
                contentS = [NSString stringWithFormat:@"开工时间：%@\n工钱：%@", time?:@"",unitStr];
                
            }else {
                
                NSString *unit = [NSString stringWithFormat:@"元/人/%@", balanceway];
                
                contentS = [NSString stringWithFormat:@"开工时间：%@\n工钱：%@ %@",time?:@"", merMoney, unit];
                
            }
            
            CGFloat verbTypeW = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 15) content:self.recruitMsgModel.classes.cooperate_type.type_name font:12].width;
        
            CGFloat verbTreatmentInfoH = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 64 - 76 - 36 - verbTypeW font:12 lineSpace:5 content:contentS];
            contentH = verbTreatmentInfoH;
            
        }else {
            
            contentH = 12;
        }
        
        height = 70 + 16 + contentH;
    }
    
    _cellHeight = height;
    
    return _cellHeight;
}

//金额转换
- (NSString *)unitConverWithMoney:(NSString *)money {
    
    if ([NSString isEmpty:money]) {
        
        return @"0";
    }
    
    double moneyF = [NSString stringWithFormat:@"%@", money].doubleValue;
    
    double m = (moneyF / 1000.0);
    
    double converMoney = [NSString stringWithFormat:@"%.2lf",m / 10.0].doubleValue;
    
    NSString *moneyceil = [NSString stringWithFormat:@"%.2lf", converMoney];
    
    moneyceil = [moneyceil stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    if (![NSString isEmpty:moneyceil] && moneyceil.length > 2 && [moneyceil containsString:@"."]) {
        
        NSString *lastZero = [moneyceil substringFromIndex:moneyceil.length - 1];
        
        if ([lastZero isEqualToString:@"0"]) {
            
            moneyceil = [moneyceil substringToIndex:moneyceil.length - 1];
        }
        
    }
    
    moneyceil = (moneyF >= 1000) ? [NSString stringWithFormat:@"%@万", moneyceil] : money;
    
    return moneyceil;
}

- (CGFloat)workCellHeight {
    
    CGFloat height = 0.0;
    if (![NSString isFloatZero:_workCellHeight]) {
        
        return _workCellHeight;
    }
    height = [self getWorkingTypeMsgHeight];
    _workCellHeight = height;
    
    return _workCellHeight;
}

- (CGFloat)getWorkingTypeMsgHeight {
    
    __block CGFloat height = 0.0;
    if (self.msg_total_type == JGJChatActivityMsgType) { //活动消息高度
        
        if (self.chatListType == JGJChatListIntegralType || self.chatListType == JGJChatListWorkGroupChatType || self.chatListType == JGJChatListLocalGroupChatType || self.chatListType == JGJChatListPostCensorType) {

            CGSize size =  [self.htmlStr boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
            
            height = ceil(size.height) + 1 + 105 + 10 + 5;
            
            if (self.chatListType == JGJChatListPostCensorType) {
                
                height = height - 25;
            }
            
        }else if (self.chatListType == JGJChatListUnKonownMsgType) {
            
            NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc] initWithString:@"当前版本暂不支持查看此消息，请升级为最新版本查看"];
            CGSize size =  [muStr boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
            height = ceil(size.height) + 1 + 55 + 10 + 5;
        }else {
            
            UIFont *font = [UIFont systemFontOfSize:AppFont32Size];
            
            height = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 50 font:AppFont32Size lineSpace:5 content:self.detail];
            
            if (height >= 5 * font.lineHeight) {
                
                height = 5 * font.lineHeight + 15;
            }else {
                
                height = height + 15;
            }
            
            CGFloat imageH = 0.563 * (TYGetUIScreenWidth - 20);
            
            height += imageH + 50 + 10 + 44 + 10;
            if (self.detail.length == 0) {
                
                height -= 10;
            }
        }
        
        
    }else if (self.msg_total_type == JGJChatWorkMsgType){
        
        if (self.chatListType == JGJChatListQuality || self.chatListType == JGJChatListSafe || self.chatListType == JGJChatListNotice || self.chatListType == JGJChatListMeeting || self.chatListType == JGJChatListLog || self.chatListType == JGJChatListTaskType || self.chatListType == JGJChatListInspectType || self.chatListType == JGJChatListApproveType || self.chatListType == JGJChatListMeeting || self.chatListType == JGJChatListOssType || self.chatListType ==  JGJChatListFriendType) {// 质量 安全等通知类型 25 为cell底部查看详情按钮高度
            
            if (self.chatListType == JGJChatListOssType) {// 云盘
                
                CGSize size =  [self.htmlStr boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
                
                height = ceil(size.height) + 1 + 105 + 10 + 5;
                
                
            }else {
                
                if (self.chatListType == JGJChatListApproveType || self.chatListType == JGJChatListMeeting) {
                    
                    CGSize size =  [self.htmlStr boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
                    
                    height = ceil(size.height) + 1 + 80 + 10 + 25 + 5;
                    
                }else {
                    
                    if ([self.status isEqualToString:@"4"]) {
                        
                        CGSize size =  [self.htmlStr boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
                        
                        height = ceil(size.height) + 1 + 55 + 10 + 25 + 5;
                        
                    }else {
                        
                        CGSize size =  [self.htmlStr boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
                        
                        height = ceil(size.height) + 1 + 80 + 10 + 25 + 5;
                    }
                                        
                }
                
            }

        }else if (self.chatListType == JGJChatListCancellSyncBillType || self.chatListType == JGJChatListCancellSyncProjectType || self.chatListType == JGJChatListRefuseSyncBillType || self.chatListType == JGJChatListRefuseSyncProjectType || self.chatListType == JGJChatListDemandSyncBillType ||  self.chatListType == JGJChatListDemandSyncProjectType || self.chatListType == JGJChatListSyncBillToYouType || self.chatListType == JGJChatListSyncProjectToYouType || self.chatListType == JGJChatListAgreeSyncProjectType || self.chatListType == JGJChatListagreeSyncBillType || self.chatListType == JGJChatListCreateNewTeamType || self.chatListType == JGJChatListJoinTeamType || self.chatListType == JGJChatListEvaluateType || self.chatListType == JGJChatListAgreeSyncProjectToYouType) {// 同步项目类型
            
            if (self.chatListType == JGJChatListDemandSyncProjectType || self.chatListType == JGJChatListDemandSyncBillType || self.chatListType == JGJChatListSyncProjectToYouType || self.chatListType == JGJChatListSyncBillToYouType || self.chatListType == JGJChatListagreeSyncBillType || self.chatListType == JGJChatListAgreeSyncProjectType || self.chatListType == JGJChatListEvaluateType || self.chatListType == JGJChatListAgreeSyncProjectToYouType) {
            
                CGSize size =  [self.htmlStr boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
                
                height = ceil(size.height) + 1 + 25 + 80 + 15 + 5;
                
            }else {
                
                CGSize size =  [self.htmlStr boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
                
                height = ceil(size.height) + 1 + 15 + 80 + 5;
            }
                        
        }else if (self.chatListType == JGJChatListJoinType || self.chatListType == JGJChatListReopenType || self.chatListType == JGJChatListRemoveType || self.chatListType == JGJChatListCloseType || self.chatListType == JGJChatListSwitchgroupType || self.chatListType == JGJChatListDismissGroupType) {// 加入新班组类型
            
            if (self.chatListType == JGJChatListJoinType || self.chatListType == JGJChatListReopenType || self.chatListType == JGJChatListSwitchgroupType) {
                
                CGSize size =  [self.htmlStr boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
                
                height = ceil(size.height) + 1 + 10 + 80 + 5 + 25;
                
            }else {
                
                CGSize size =  [self.htmlStr boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
                
                height = ceil(size.height) + 1 + 10 + 80 + 5;
            }
            
            
        }else if (self.chatListType == JGJChatListBottomDefaultSpaceType) {// 底部空白cell
            
            height = 100.0;
            
        }else if (self.chatListType == JGJChatListUnKonownMsgType) {// 未知类型
            
            CGSize size =  [self.htmlStr boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
            height = ceil(size.height) + 1 + 55 + 10 + 5;
        }
        else {
            
            height = 0.0;
        }
        
    }else if (self.msg_total_type == JGJChatRecruitMsgType) {// 招聘消息高度
        
        if (self.chatListType == JGJChatListBottomDefaultSpaceType) {// 底部空白cell
            
            height = 100.0;
            
        }else if (self.chatListType == JGJChatListUnKonownMsgType) {// 未知类型
            
            height = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 70 - 78 font:AppFont32Size lineSpace:4 content:@"当前版本暂不支持查看此消息，请升级为最新版本查看"] + 40 + 24;
            
        }else if (self.chatListType == JGJChatListProjectInfoType) {
            
            CGFloat situationTitleConstraintH = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 70 - 78 font:16 lineSpace:5 content:self.title];
            
            CGFloat systemInfoConstraintH;
            if ([NSString isEmpty:self.extend.msg_content.system_msg]) {
                
                systemInfoConstraintH = 0.0;
            }else {
                
                systemInfoConstraintH = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 70 - 78 font:13 lineSpace:5 content:[NSString stringWithFormat:@"系统提示:%@",self.extend.msg_content.system_msg]];
            }
            
            height = 45 + 30 + 16 + situationTitleConstraintH + systemInfoConstraintH + 181;
            
            if ([NSString isEmpty:self.extend.msg_content.pro_name]) {
                
                height = height - 23;
                
            }

            
        }
        else {
            
            if (self.chatListType == JGJChatListFeedbackType) {
                
                height = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 70 - 78 font:AppFont32Size lineSpace:4 content:self.detail] + 105 + 10 + 5 - 30;
            }else {
                
                height = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 70 - 78 font:AppFont32Size lineSpace:4 content:self.detail] + 105 + 10 + 5;
            }
            
            
        }
        
    }
    return height;
}

//去除标签的方法
- (NSString *)getNormalStringFilterHTMLString:(NSString *)htmlStr{
    
    NSString *normalStr = htmlStr.copy;
    //判断字符串是否有效
    if (!normalStr || normalStr.length == 0 || [normalStr isEqual:[NSNull null]]) return nil;
    
    //过滤正常标签
    NSRegularExpression *regularExpression=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    normalStr = [regularExpression stringByReplacingMatchesInString:normalStr options:NSMatchingReportProgress range:NSMakeRange(0, normalStr.length) withTemplate:@""];
    
    return normalStr;
}


- (CGFloat)getAudioCellHeightWithChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    CGFloat height = 0.0;
    
    if (self.chatListType == JGJChatListAudio) {
        
        height = 71;
        
    }
    
    return height;
    
}

- (CGFloat)getCellHeightWithChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    CGFloat height = 67;
    
    //仅有文字
    height = [self getMsgHeightWithChatListModel:chatListModel] + 30  + ChatBottomPadding;

    height = (height < 67 ? 67 : height);
    
    //得到质量安全等高度

    if (chatListModel.chatListType == JGJChatListNotice || chatListModel.chatListType == JGJChatListSafe || chatListModel.chatListType == JGJChatListLog || chatListModel.chatListType == JGJChatListSign ||chatListModel.chatListType == JGJChatListQuality || self.msg_src.count > 0) {

        height = [self getMultipleSelImageWithChatListModel:chatListModel];

    }
    
    return height;
    
}

#pragma mark - 获取消息高度
- (CGFloat)getMsgHeightWithChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    CGFloat maxW =  CellMaxWidth;
    
    YYTextContainer  *contentContarer = [YYTextContainer new];
    
    //限制宽度
    contentContarer.size = CGSizeMake(maxW, CGFLOAT_MAX);
    
    if ([NSString isEmpty:chatListModel.msg_text]) {
        
        chatListModel.msg_text = @"";
    }
    
    NSMutableAttributedString  *contentAttr = [self getAttr:chatListModel.msg_text];
    
    contentAttr.yy_lineSpacing = 4.0;
    
    YYTextLayout *contentLayout = [YYTextLayout layoutWithContainer:contentContarer text:contentAttr];
    
    CGFloat height = contentLayout.textBoundingSize.height;
    
    //获取普通文字宽度
   self.norMsgWidth = contentLayout.textBoundingSize.width;
    
    return height;
}

- (CGFloat)getMultipleSelImageWithChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    CGFloat padding = 60 + 40;
    
    CGFloat height = padding; //上下距离
    
    CGFloat contentMaxW = CellMaxWidth;
    
    if (chatListModel.msg_src.count == 1) {
        
        height = contentMaxW + padding;
        
        if (self.belongType != JGJChatListBelongMine) {
            
            height += 3;
        }
        
    }else if (chatListModel.msg_src.count > 1) {
        
        //2张以上的图片
        CGFloat ImageWH = (contentMaxW - kChatListCollectionCellMargin*4.0) / 3.0;
        
        NSInteger rowNum = (chatListModel.msg_src.count - 1) / 3 + 1;
        
        height = rowNum*(ImageWH + kChatListCollectionCellMargin);
        
        height += padding;
    }
    
    if (![NSString isEmpty:self.msg_text]) {
        
        YYTextContainer  *contentContarer = [YYTextContainer new];
        
        //限制宽度
        contentContarer.size = CGSizeMake(contentMaxW, CGFLOAT_MAX);
        
        contentContarer.maximumNumberOfRows = 0;
        
        NSMutableAttributedString  *contentAttr = [self getAttr:self.msg_text];
        
        YYTextLayout *contentLayout = [YYTextLayout layoutWithContainer:contentContarer text:contentAttr];
        
        CGFloat msgTextHeight = contentLayout.textBoundingSize.height;
        
        height += msgTextHeight > 25 ? 55 : 25;
        
    }
    
    return height;
    
}

- (CGFloat)cellWidth {
    
    if ([NSString isFloatZero:_cellWidth]) {
        
        
        switch (self.chatListType) {
                
            case JGJChatSynInfoType:{
                
                _cellWidth = TYGetUIScreenWidth - 63;
            }
                
                break;
                
            case JGJChatListSafe:
            case JGJChatListNotice:
            case JGJChatListMeeting:
            case JGJChatListLog:
            case JGJChatListQuality:{
                
                _cellWidth = TYGetUIScreenWidth - 63;
            }
                
                break;
                
            case JGJChatListText:{
                
                YYTextContainer  *contentContarer = [YYTextContainer new];
                
                //限制宽度
                contentContarer.size = CGSizeMake(CellMaxWidth, CGFLOAT_MAX);
                
                contentContarer.maximumNumberOfRows = 0;
                
                NSMutableAttributedString  *contentAttr = [self getAttr:self.msg_text];
                
                YYTextLayout *contentLayout = [YYTextLayout layoutWithContainer:contentContarer text:contentAttr];
                
                //头部尾部间距
                _cellWidth = contentLayout.textBoundingSize.width + 30;
            }
                break;
                
            case JGJChatListAudio:{
                
                CGFloat audioTime = [self.voice_long floatValue];
                _cellWidth = kChatListAudioMinWith + ceil(audioTime/60.0 * (CellMaxWidth - kChatListAudioMinWith));
            }
                break;
                
            default:
                break;
        }
        
    }
    
    if ([NSString isFloatZero:_cellWidth]) {
        
        _cellWidth = CellMaxWidth;
        
    }
    
    if ((self.msg_total_type == JGJChatRecruitMsgType || self.msg_total_type == JGJChatWorkMsgType) && !self.is_normal) {// 工作 招聘类型单独给 v3.4 CC添加
        
        _cellWidth = TYGetUIScreenWidth - 63;
        
    }
    
    if (self.chatListType == JGJChatListIntegralType || self.chatListType == JGJChatListWorkGroupChatType || self.chatListType == JGJChatListLocalGroupChatType || self.chatListType == JGJChatListPostCensorType) {
        
        _cellWidth = TYGetUIScreenWidth - 60 - 68;
    }
    
    if ([self.class_type isEqualToString:@"work"]) {
        
        _cellWidth = TYGetUIScreenWidth - 60 - 68;
        
    }
    
    if (self.msg_total_type == JGJChatRecruitMsgType) {// 招聘类型
        
        _cellWidth = TYGetUIScreenWidth - 60 - 68;
        
    }
    return _cellWidth;
}

- (NSMutableAttributedString*)getAttr:(NSString*)attributedString {
    
    if ([NSString isEmpty:attributedString]) {
        
        attributedString = @"";
    }
    
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithString:attributedString];
    
    //对齐方式 这里是 两边对齐
//    resultAttr.yy_alignment = NSTextAlignmentJustified;
    //设置行间距
//    resultAttr.yy_lineSpacing = 2;
    //设置字体大小
    resultAttr.yy_font = [UIFont systemFontOfSize:AppFont32Size];
    //可以设置某段字体的大小
    //[resultAttr yy_setFont:[UIFont boldSystemFontOfSize:CONTENT_FONT_SIZE] range:NSMakeRange(0, 3)];
    //设置字间距
    //resultAttr.yy_kern = [NSNumber numberWithFloat:1.0];
    
    return resultAttr;
    
}

- (CGSize)imageSize {
    
    _imageSize = CGSizeMake(195, 187);
    if (self.pic_w_h.count == 2) {
        
        CGFloat imageH  = [[self.pic_w_h firstObject] floatValue];
        CGFloat imageW = [[self.pic_w_h lastObject] floatValue];
        _imageSize = CGSizeMake(imageW, imageH);
        
        _imageSize = [JGJImage getFitImageSize:self.pic_w_h maxImageSize:CGSizeMake(195, 187)];
    }
    
    return _imageSize;
}

@end

@implementation ChatMsgList_Read_info

+ (NSDictionary *)objectClassInArray{
    return @{@"unread_user_list" : [ChatMsgList_Read_User_List class], @"readed_user_list" : [ChatMsgList_Read_User_List class]};
}

@end


@implementation ChatMsgList_Read_User_List

- (UIColor *)nameColor {
    
    if (!_nameColor) {
        NSArray *colorArray = @[TYColorHex(0xf4b860),TYColorHex(0xf19937),TYColorHex(0x5ea3f8),TYColorHex(0xc48fe1),TYColorHex(0xeb6e48)];
        NSInteger index = arc4random() % 5;
        _nameColor = colorArray[index];
    }
    return _nameColor;
}

@end




@implementation JGJChatOfflineMsgModel

+(NSDictionary *)mj_objectClassInArray {
    
    return @{@"list" : @"JGJChatMsgListModel"};
}

@end

@implementation JGJApsMsgModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"msg_type" :@"content-available"};
    
}

@end
