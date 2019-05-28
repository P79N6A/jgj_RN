//
//  CommonModel.m
//  mix
//
//  Created by celion on 16/3/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "CommonModel.h"
#import "MJExtension.h"
#import "NSDate+Extend.h"
#import "MyCalendarObject.h"
#import "NSString+Extend.h"

#import "JGJLocationManger.h"

#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "JGJAvatarView.h"

#import "JGJCusYyLable.h"

@implementation CommonModel

@end

@implementation JGJSynBillingUnitQuanTplModel



@end

@implementation JGJSynBillingNewTplModel



@end

@implementation MyWorkLeaderZone
- (NSString *)headpic{
    if ([NSString isEmpty:_headpic]) {
        _headpic = @"";
    }
    return _headpic;
}

- (NSString *)verifiedString {
    NSString *verifiedStr = nil;
    switch (self.verified) {
        case -1:
            verifiedStr = @"认证失败";
            break;
        case 0:
            verifiedStr = @"立即认证";
            break;
        case 1:
            verifiedStr = @"认证中";
            break;
        case 2:
            verifiedStr = @"已认证";
            break;
        default:
            break;
    }
    return verifiedStr;
}

- (NSString *)roleString {
    NSString *verifiedStr = @"当前身份:班组长/工头";
    return verifiedStr;
}

@end

@implementation MyWorkZone

- (NSString *)statusString {
    NSString *status = nil;
    switch (self.work_staus) {
        case NoWorkType:
            status = @"没工作";
            break;
        case WorkingType:
            status = @"开工中";
            break;
        case WorkedAndFindingType:
            status = @"已开工也找新工作";
            break;
        default:
            break;
    }
    return status;
}

- (NSString *)verifiedString {
    NSString *verifiedStr = nil;
    switch (self.verified) {
        case -1:
            verifiedStr = @"认证失败";
            break;
        case 0:
            verifiedStr = @"立即认证";
            break;
        case 1:
            verifiedStr = @"认证中";
            break;
        case 2:
            verifiedStr = @"已认证";
            break;
        default:
            break;
    }
    
    return verifiedStr;
}

- (NSString *)headpic{
    if ([NSString isEmpty:_headpic]) {
        _headpic = @"";
    }
    return _headpic;
}

- (NSString *)roleString {
    NSString *verifiedStr = @"当前身份:工人";
    return verifiedStr;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"realname" : @"real_name"};
}

- (NSString *)realname {
    if (![NSString isEmpty:_realname]) {
        
        [TYUserDefaults setObject:_realname forKey:JGJUserName];
        
    }else if (![NSString isEmpty:_user_name]){
        
        [TYUserDefaults setObject:_user_name forKey:JGJUserName];
        
    }else if (![NSString isEmpty:_nickname]) {
        
        [TYUserDefaults setObject:_nickname forKey:JGJUserName];
        
    }
    return _realname;
}

@end

@implementation JGJSynBillingModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
                @"addFrom" : @"add_from"
             };
}

- (NSString *)nameDes {
    
    if ([NSString isEmpty:_nameDes]) {
        
        NSMutableString *nameStr = [NSMutableString string];
        
        for (NSInteger index = 0; index < self.name.length; index++) {
            
            [nameStr appendString:@"*"];
        }
        
        _nameDes = nameStr;
    }
    
    return _nameDes;
}

- (void)setReal_name:(NSString *)real_name {
    _real_name = real_name;
    _name  = _real_name;
 }

- (void)setName:(NSString *)name {
    _name = name;
    _real_name = _name;
}

- (void)setTelephone:(NSString *)telephone {
    _telephone = telephone;
    if (_telephone.length > 0) {
        _telephone = [_telephone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        _telephone = [_telephone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        _telph = _telephone;
    }
}

- (void)setTelph:(NSString *)telph {
    _telph = telph;
    if (_telph.length > 0) {
        _telph = [_telph stringByReplacingOccurrencesOfString:@"-" withString:@""];
        _telph = [_telph stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        _telephone = _telph;
    }
}

//2.0添加的班组详情和项目组详情
- (void)setTelphone:(NSString *)telphone {
    _telphone = telphone;
    if (![NSString isEmpty:_telphone]) {
        self.telph = _telphone;
        self.telephone = _telphone;
    }
}

- (UIColor *)modelBackGroundColor {
    if (!_modelBackGroundColor) {        
        _modelBackGroundColor = [NSString modelBackGroundColor:self.real_name];
    }
    return _modelBackGroundColor;
}

- (BOOL)isEqual:(JGJSynBillingModel *)object {
    if ([self.telephone isEqualToString:object.telephone]) {
        
        return YES;
    } else {
    
        return NO;
    }
//    return [self.telephone isEqualToString:object.telephone];
}

- (CGFloat)work_manger_height {
    
    if ([NSString isFloatZero:_work_manger_height]) {
        
        CGFloat maxW = TYGetUIScreenWidth - 43 - 27;
        
        if (!self.is_comment && !self.is_check_accounts) {
            
            maxW = TYGetUIScreenWidth - 43 - 27;
            
        }else if (self.is_comment ^ self.is_check_accounts) {
            
            maxW = TYGetUIScreenWidth - 43 - 90;
            
        }else if (self.is_comment && self.is_check_accounts) {
            
            maxW = TYGetUIScreenWidth - 43 - 153;
            
        }else {
            
            maxW = TYGetUIScreenWidth - 43 - 153;
        }
        
        maxW -= 10;
        
        if (self.is_show_indexes) {
            
            maxW -= 28;
        }
        
        NSString *des = [NSString stringWithFormat:@"你在%@为他干活", self.proname];
        
        if (!JLGisMateBool) {
            
            des = [NSString stringWithFormat:@"他在%@干活", self.proname];
            
        }
        
        _work_manger_height = [NSString stringWithContentWidth:maxW content:des font:AppFont24Size];
        
    }
    
    return _work_manger_height;
}

- (CGFloat)friend_source_height {
    
    if ([NSString isFloatZero:_friend_source_height]) {
        
        CGFloat maxW = TYGetUIScreenWidth - 75.0 - 85.0;
        
        UIFont *font = [UIFont systemFontOfSize:AppFont24Size];
        
        _friend_source_height = [NSString stringWithContentWidth:maxW content:self.comment font:AppFont24Size];
        
        _friend_source_height += 75 - font.lineHeight;
    }
    
    return _friend_source_height;
}

MJCodingImplementation
@end

@implementation JGJSynBillingCommonModel

@end
@implementation SortFindResultModel

MJCodingImplementation
@end
@implementation JGJAddressBookModel

@end
@implementation JGJSyncProlistModel

@end
@implementation JGJShowTimeModel
- (instancetype)init{
    self = [super init];
    if (self) {
        self.isShowWorkTime = YES;
    }
    return self;
}

- (CGFloat )endTime{
    _endTime = _endTime?:self.limitTime;
    return _endTime;
}
@end

@implementation JGJCalendarModel

- (NSString *)orientation {

    if (!_orientation) {
        NSString *spaceString = @"  ";
        if (TYIS_IPHONE_5_OR_LESS) {
            spaceString = @"   ";
        }
        if (TYIS_IPHONE_6) {
            spaceString = @"           ";
        }
        if (TYIS_IPHONE_6P) {
            spaceString = @"                 ";
        }
        _orientation = [NSString stringWithFormat:@"喜神-%@%@财神-%@%@福神-%@", self.xishen, spaceString, self.caishen, spaceString, self.fushen];
    }
    return _orientation;
}

- (NSString *)yi {
    _yi = [_yi stringByReplacingOccurrencesOfString:@"," withString:@"  "];
    return _yi;
}

- (NSString *)ji {
    
    _ji = [_ji stringByReplacingOccurrencesOfString:@"," withString:@"  "];
    return _ji;
}

- (NSString *)jishiTitle {
    NSString *spaceString = @" ";
    if (TYIS_IPHONE_5_OR_LESS) {
        spaceString = @" ";
    }
    if (TYIS_IPHONE_6) {
        spaceString = @"  ";
    }
    if (TYIS_IPHONE_6P) {
        spaceString = @"   ";
    }
    _jishiTitle = @"子,丑,寅,卯,辰,巳,午,未,申,酉,戌,亥";
    _jishiTitle = [_jishiTitle stringByReplacingOccurrencesOfString:@"," withString:spaceString];
    return _jishiTitle;
}

-(NSInteger)timeinterval {
    
    if (!_timeinterval) {
        
        NSDate *currentDate = [NSDate date];
        NSDate *desDate = [NSDate dateFromString:self.all_date withDateFormat:@"yyyy-MM-dd"];
        _timeinterval = [NSDate getDaysFrom:desDate withToDate:currentDate];
    }
    return _timeinterval;
}

- (NSString *)jieqi {

    NSDateComponents *component = [[NSDateComponents alloc] init];
    NSArray *separDates = [self.all_date componentsSeparatedByString:@"-"];
    component.year = [separDates[0] integerValue];
    component.month = [separDates[1] integerValue];
    component.day = [separDates[2] integerValue];
    NSString *solarFesString = [MyCalendarObject getGregorianHolidayWith:component];
    NSString *lunarFesString = [MyCalendarObject getChineseHolidayWith:component.month day:component.day];
    _jieqi = (solarFesString != nil || solarFesString.length != 0) ? solarFesString : lunarFesString;
    return _jieqi;
}

@end

@implementation JGJTodayRecomModel
MJExtensionCodingImplementation
@end

@implementation JGJBillEditProNameModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"proId" : @"id" };
}
@end

#pragma mark -  帮助中心模型
@implementation JGJHelpCenterModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"JGJHelpCenterListModel"};
}
@end

@implementation JGJHelpCenterListModel
- (void)setContent:(NSString *)content {
    _content = content;
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithData:[_content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType                                                                                                                           } documentAttributes:nil error:nil];
    _content = attribute.string;
}
@end

#pragma mark - 我的项目模型
@implementation JGJMyWorkCircleModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"JGJMyWorkCircleProListModel"};
}

- (void)setList:(NSArray<JGJMyWorkCircleProListModel *> *)list {
    _list = list;
    for (JGJMyWorkCircleProListModel *proListModel in _list) {
        proListModel.pro_id = self.pro_id;
        proListModel.count = _list.count;
        proListModel.pro_name = self.pro_name;
        proListModel.workCircleProType = WorkCircleTrueProTye; //区分示例项目和真实项目
        if ([proListModel.class_type isEqualToString:@"group"]) {
            self.isExistGroup = YES; //判断是否存存在项目组，个人端项目存在全是项目组时布局
            proListModel.isExistGroup = YES;
        }
    }
}

MJCodingImplementation
@end

@implementation JGJClosedGroupModel

- (BOOL)canOpen {
    return [self.myself_group isEqualToString:@"1"];
}
MJExtensionCodingImplementation
@end

@implementation JGJMyWorkCircleProListModel

- (instancetype)init{
    self = [super init];
    if (self) {
        _token = [NSString isEmpty:[TYUserDefaults objectForKey:JLGPhone]]?@"":[TYUserDefaults objectForKey:JLGPhone];
    }
    return self;
}

//- (JGJSynBillingModel *)agency_group_user {
//    
//    JGJSynBillingModel *agency = [[JGJSynBillingModel alloc] init];
//    agency.is_expire = self.is_expire;
//    agency.uid = self.agency_uid;
//    agency.start_time = self.start_time;
//    agency.end_time = self.end_time;
//    
//    return agency;
//}

//- (NSString *)unread_msg_count {
//    NSInteger msgCount = _unread_msg_count.intValue;
//    if (msgCount < 0) {
//        _unread_msg_count = @"0";
//    } else {
//        _unread_msg_count = msgCount > 99 ? @"99+" : _unread_msg_count;
//    }
//    return _unread_msg_count;
//}

- (void)setUnread_msg_count:(NSString *)unread_msg_count
{
    NSInteger msgCount = unread_msg_count.intValue;
    
    if (msgCount < 0) {
        _unread_msg_count = @"0";
    } else {
        _unread_msg_count = msgCount > 99 ? @"99+" : [unread_msg_count copy];
    }
    // 设置unreadMsgCount属性
    self.unreadMsgCount = msgCount;
}



- (BOOL)isEqual:(JGJMyWorkCircleProListModel *)object {
    return [self.group_id isEqualToString:object.group_id];
}

- (NSString *)classTypeDesc {
    if ([self.class_type isEqualToString:@"group"]) {
//        _classTypeDesc = [self.myself_group isEqualToString:@"1"] ? @"班组管理" : @"班组信息";
        _classTypeDesc = @"班组设置";
    } else {
//        _classTypeDesc = [self.myself_group isEqualToString:@"1"] ? @"项目组管理" : @"项目组信息";
        _classTypeDesc = @"项目设置";
    }
    return _classTypeDesc;
}

- (NSString *)class_typeIdKey {
    return [self.class_type isEqualToString:@"team"] ? @"team_id" : @"group_id";
}

#pragma mark - is_closed是后面接口添加，原我们已经使用isClosedTeamVc
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"class_typeIdValue" : @"team_id",
             @"class_typeIdValue" : @"group_id",
             @"isClosedTeamVc" : @"is_closed"
             };
}

- (JGJTeamMangerVcType)teamMangerVcType {
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if ([self.class_type isEqualToString:@"group"]) { //班组详情页区分
        _teamMangerVcType = [self.myself_group isEqualToString:@"1"] ? JGJCreaterTeamMangerVcType : JGJNormalMemberTeamInfoVcType;
    } else {
        if (self.is_source_member && !self.is_admin) {
            _teamMangerVcType = JGJSourceMemberType; //来源人
        } else if([self.myself_group isEqualToString:@"1"]) { //普通成员或者管理者
            _teamMangerVcType = JGJProMangerType;
        } else if (self.is_admin && !self.is_source_member) { //只要是管理员就可以添加删除成员
            _teamMangerVcType = JGJNormalProMangerType;
        }else if (self.is_admin && self.is_source_member){
            _teamMangerVcType = JGJNormalProMangerAndSourceMemberType; //两种成员身份普通管理员和数据来源人点击
        }else if ([self.agency_uid isEqualToString:myUid])
        
            _teamMangerVcType = JGJAgencyMemberType; //代理人
            
        else {
            _teamMangerVcType = JGJProInfoType; //普通成员
        }
    }
    
    
    
    return _teamMangerVcType;
}

#pragma mark - 是否是我自己创建的班组
- (NSString *)myself_group {
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    BOOL is_my_creat = [myUid isEqualToString:self.creater_uid];
    
    return [NSString stringWithFormat:@"%@",@(is_my_creat)] ;
    
}

- (NSString *)proDetailButtontitle {
    if ([self.class_type isEqualToString:@"group"]) { //班组详情页区分
        _proDetailButtontitle = [self.myself_group isEqualToString:@"1"] ? @"关闭班组" : @"退出班组";
    } else {
        if (self.is_source_member) {
            _proDetailButtontitle = @"关闭同步";
        } else { //普通成员或者管理者
            _proDetailButtontitle = [self.myself_group isEqualToString:@"1"] ? @"关闭项目" :  @"退出项目组";
        }
    }
    return _proDetailButtontitle;
}

//这里主要是处理班组和项目组，首页均用的是group_id
- (NSString *)group_id {
    if (![NSString isEmpty:_team_id]) {
        _group_id = _team_id;
    }
    return _group_id;
}

- (NSString *)team_id {
    if (![NSString isEmpty:_group_id]) {
        _team_id = self.group_id;
    }
    return _team_id;
}
- (NSString *)group_name {
    
    
    if ([self.class_type isEqualToString:@"singleChat"] || [self.class_type isEqualToString:@"groupChat"]) {
        return _group_name;
    }
    if (![NSString isEmpty:_team_name]) {
        _group_name = _team_name;
    }else {
        self.team_name = _group_name;
    }
    return _group_name;
}

- (NSString *)merge_last_msg_id{
    
    if ([NSString isEmpty:_merge_last_msg_id]) {
        _merge_last_msg_id = @"0";
    }
    
    return _merge_last_msg_id;
}

//2.2.0处理是否有项目信息
- (BOOL)isUnProInfo {

    _isUnProInfo = NO;
    
    if (!JLGisLoginBool || [NSString isEmpty:self.group_info.group_name]) {
        
        _isUnProInfo = YES;
    }
    
    return _isUnProInfo;
}

- (CGFloat)checkProCellHeight {
    
    if (_checkProCellHeight > 0) {
        
        return _checkProCellHeight;
    }
    
    BOOL isMySelfGroup = [self.myself_group isEqualToString:@"1"];
    
    NSString *myGroupFlagStr = isMySelfGroup ?@"(我创建的)" : @"";
    
    NSString *proName = [NSString stringWithFormat:@"%@ %@", self.group_name, myGroupFlagStr];
    
    if (!self.isCheckClosedPro) {
        
        _checkProCellHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 117.0 content:proName font:AppFont30Size lineSpace:1] + 31.5;
        
    }else {
        
        _checkProCellHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 80.0 content:proName font:AppFont30Size lineSpace:1] ;
        
        if (_checkProCellHeight > 20.0) {
            
            _checkProCellHeight = 85.0;
            
        }
    }
    
    return _checkProCellHeight;
}

- (BOOL)is_agency_group {

    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if ([NSString isEmpty:self.agency_group_user.uid]) {
        
        return NO;
        
    }else {
        
        return [self.class_type isEqualToString:@"group"] && ![myUid isEqualToString:self.agency_group_user.uid];
    }
    
}

- (BOOL)is_myAgency_group {

    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if ([NSString isEmpty:self.agency_group_user.uid]) {
        
        return NO;
        
    }else {
        
       return [self.class_type isEqualToString:@"group"] && [myUid isEqualToString:self.agency_group_user.uid];
    }
    
}

- (NSArray *)members_head_pic {
    
    if (![NSString isEmpty:_local_head_pic]) {
        
        _members_head_pic = [_local_head_pic mj_JSONObject];
    }
    
    return _members_head_pic;
}

//#pragma mark - 全局取消黄金服务版(4个位置修改了，搜索这句话)
//- (NSString *)is_senior {
//
//    return @"0";
//}

MJExtensionCodingImplementation

@end

@implementation JGJActiveGroupListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"JGJMyWorkCircleModel",
             @"chatList" : @"JGJMyWorkCircleProListModel"};
}

@end

@implementation JGJActiveGroupModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"unclose" : @"JGJMyWorkCircleProListModel",
             
             @"closed_list" : @"JGJMyWorkCircleProListModel"};
}

- (NSArray *)closed_list {

    for (JGJMyWorkCircleProListModel *proListModel in _closed_list) {
        
        proListModel.isClosedTeamVc = YES;
        
    }

    return _closed_list;
}

#pragma mark - 刷新底部项目组数据计算高度
- (CGFloat)workCircleHeight {
    _workCircleHeight = 0;
    NSUInteger closedCount = [self.closed.closed_group_count integerValue];
    NSUInteger unClosedCount = self.unclose.count;
    self.workCircleCount = self.unclose.count;
    BOOL isNoneExistPro = unClosedCount == 0 && closedCount == 0; //没有项目
    BOOL isExistPro = self.unclose.count > 0 && closedCount > 0; //存在未关闭的项目，和存在关闭的项目
    BOOL isOnlyExistClosedPro = unClosedCount == 0 && closedCount > 0; //仅存在关闭的项目
     BOOL isOnlyExistUnClosedPro = unClosedCount > 0 && closedCount == 0; //仅存在未关闭项目
    CGFloat height = 0.0;
    if (isNoneExistPro) { //不存在项目
        height = JGJWorkCircleDefaultHeight  + WorkCircleTableViewHeaderHegiht + WorkCircleTableViewFooterHegiht;
    } else if (isExistPro) {
        height = WorkCircleTableViewFooterHegiht + WorkCircleTableViewHeaderHegiht;
    }else if (isOnlyExistClosedPro) {
         height =  WorkCircleTableViewHeaderHegiht + JGJWorkCircleProGroupCellHeight + WorkCircleTableViewFooterHegiht;
    } else if (isOnlyExistUnClosedPro) {
        height = WorkCircleTableViewHeaderHegiht;
    }
    _workCircleHeight += self.unclose.count * JGJWorkCircleProGroupCellHeight;
    _workCircleHeight += height;
    return _workCircleHeight;
}

MJExtensionCodingImplementation
@end


#pragma mark - 创建班组
@implementation JGJCreatTeamModel

@end

@implementation JGJTeamMemberModel

@end

#pragma mark - 班组管理通用模型设置头部标题和人数
@implementation JGJTeamMemberCommonModel

@end

#pragma mark - 新通知模型
@implementation JGJNewNotifyModel

- (JGJNewNotifyType)notifyType {    
    _notifyType = [Class_types indexOfObject:self.class_type];
    return _notifyType;
}
//- (NSString *)user_name {
//    BOOL isEmpty = [NSString isEmpty:self.group_name];
//    if (isEmpty) {
//        self.group_name = @"";
//    }
//    return _user_name;
//}

- (NSString *)group_name {
    if ([NSString isEmpty:_group_name]) {
        _group_name = @"";
    }
    return _group_name;
}

- (NSString *)team_name {
    if ([NSString isEmpty:_team_name]) {
        _team_name = @"";
    }
    return _team_name;
}

- (CGFloat)cellHeight {
    
    CGFloat titleH = [NSString stringWithContentWidth:TYGetUIScreenWidth - 183 content:self.title font:AppFont30Size];
        
    _cellHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 123 content:self.info font:AppFont28Size] + 74 + titleH;
    
    //成功之后隐藏按钮,高度减去33
    if (self.isSuccessSyn || self.notifyType == superior_work_leader || self.isRefused) {
        
        _cellHeight -= 33;
    }
    
    return _cellHeight;
    
}

- (NSString *)info {
    
    //同步文字处理，其余参考列表高度
    
    switch (self.notifyType) {
            
        case SyncedSyncProjectType:{
            
            _info = [NSString stringWithFormat:@"%@%@", self.user_name,@"向你请求同步了记工数据"];
        }
            
            
            break;
            
        case syncGroupToGroup:{
            
            _info = [NSString stringWithFormat:@"%@%@", self.user_name,@"（班组长）向你请求同步记工记账数据"];
        }
            
            break;
            
        case syncedSyncGroupToGroup:{
            
            _info = [NSString stringWithFormat:@"%@%@", self.user_name,@"向你同步了记工记账数据"];
            
        }
            
            break;
            
        case SyncProjectType:{
            
            _info = [NSString stringWithFormat:@"%@%@", self.user_name,@"（项目部）向你请求同步记工数据"];
        }
            
            break;
            
        default:
            break;
    }
    
    return _info;
}

MJCodingImplementation
@end

@implementation JGJGroupInfoModel

@end

@implementation JGJMemberListModel

@end

@implementation JGJTeamInfoModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"report_user_list" : @"JGJSynBillingModel",
             @"member_list" : @"JGJSynBillingModel",
             @"source_members" : @"JGJSynBillingModel",
             @"team_members" :  @"JGJSynBillingModel",
             @"current_server" : @"JGJTeamServiceModel"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{@"class_Type" : @"class_type"};
}

- (NSMutableArray<JGJSynBillingModel *> *)team_group_members {
//    [self.class_Type isEqualToString:@"group"] ? _member_list : _team_members //之前做了区分
    return _member_list; //后改为一个;
}

- (NSMutableArray<JGJSynBillingModel *> *)source_report_members {
    return [self.group_info.class_type isEqualToString:@"group"] ? _report_user_list : _source_members;
}

- (JGJGroupInfoModel *)team_group_info {
//    _team_group_info = [self.group_info.class_type isEqualToString:@"group"] ? _group_info : _team_info;
    
    _team_group_info = _group_info;
    
    return _team_group_info;
}

- (NSString *)class_TypeId {
    return [self.group_info.class_type isEqualToString:@"group"] ? _group_id : _team_id;
}

- (NSString *)class_Type {
    
    return self.group_info.class_type ? : _class_type ? : _class_Type;
}

- (NSString *)group_id {
    
    return self.group_info.group_id ? : _group_id;
}
- (BOOL)isUpdatePer {
        
    if (self.team_info.is_senior) {
        
        _isUpdatePer = self.cur_member_num >= self.team_info.buyer_person;
        
    }else {
        
        _isUpdatePer = self.cur_member_num >= 5;
    }
    
    return _isUpdatePer;
}

//#pragma mark - #pragma mark - 全局取消黄金服务版(4个位置修改了，搜索这句话)
//- (BOOL)is_senior {
//    
//    return NO;
//}

@end

@implementation JGJProjectListModel

////新通知加入班组
//- (NSString *)group_id {
//    if (![NSString isEmpty:self.pro_id]) {
//        _group_id = self.pro_id;
//    }
//    if (![NSString isEmpty:self.pid]) {
//        _group_id = self.pid;
//    }
//    return _group_id;
//}

@end

@implementation JGJADModel

@end

@implementation JGJADCacheModel

MJExtensionCodingImplementation
@end

@implementation JGJSynMergecheckModel

@end


@implementation JGJShareProDesModel

@end

@implementation JGJTitleInfoModel

@end

@implementation JGJAddressBookSortContactsModel
MJCodingImplementation
@end

@implementation JGJMineInfoThirdModel

@end
@implementation JGJMineInfoSecModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"mineInfos" : @"JGJMineInfoThirdModel",
             };
}
@end
@implementation JGJMineInfoFirstModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"mineInfos" : @"JGJMineInfoSecModel",
             };
}
@end

@implementation JGJAdminListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"JGJSynBillingModel"};
}
@end

@implementation JGJChatInputViewInfoModel

@end

@implementation JGJUpdateVerInfoModel

@end

@implementation JGJChatDetailInfoCommonModel

@end

@implementation JGJChatPerInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"common_friends" : @"JGJSynBillingModel"};
}

//签名文字高度

- (CGFloat)headHeight {
    
    if (![NSString isFloatZero:_headHeight]) {
        
        return _headHeight;
    }
    
    CGFloat baseH = 65 + 20 * 2;
    
    UIFont *font = [UIFont systemFontOfSize:AppFont24Size];
        
    _headHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 99.0 content:self.signature font:AppFont24Size];
    
    _headHeight += baseH - font.lineHeight;
    
    if (_headHeight < baseH) {
        
        _headHeight = baseH;
    }
    
    return _headHeight;
}


- (void)setSignature:(NSString *)signature {

    _signature = signature;

    if ([NSString isEmpty:_signature]) {

        _signature = @"独一无二的个性介绍，会让你的朋友满天下！";
    }

}

@end

@implementation JGJSingleChatModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"member_list" : @"JGJSynBillingModel"};
}
@end

@implementation JGJAddFriendStyleModel

@end

@implementation JGJAddFriendSendMsgModel

- (CGFloat)height {
    
    _height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 87 content:self.msg_text font:AppFont24Size lineSpace:1];
    
    return _height;
}


@end

@implementation JGJFreshFriendListModel

@end

@implementation JGJChatFindHelperModel

MJCodingImplementation
@end

@implementation JGJChatFindJobModel
MJCodingImplementation

//- (NSString *)verified {
//    
//    return @"2";
//}

@end

@implementation jgjrecordMonthModel
//+ (NSDictionary *)mj_objectClassInArray {
//    return @{@"list" : @"JgjRecordMorePeoplelistModel"};
//}
@end

@implementation jgjrecordselectedModel

@end


@implementation JGJShowShareDynamic

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"dynamicId" : @"id"};
}

@end

@implementation JGJShowShareMenuModel


@end

@implementation JGJNotifyDetailMembersModel

+ (NSDictionary *)mj_objectClassInArray {
    
    
    return @{@"replyList" : @"JGJSynBillingModel",
             @"unrelay_members" : @"JGJSynBillingModel",
             @"members" : @"JGJSynBillingModel",@"pub_man":@"JGJTaskPubManModel"};
}

@end

@implementation JGJCheckUnCloseProModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"unclose" : @"JGJMyWorkCircleProListModel"
             };
}
MJExtensionCodingImplementation
@end
@implementation buttonDesType
- (id)mutableCopyWithZone:(NSZone *)zone {
    buttonDesType *mutableCopy = [[buttonDesType allocWithZone:zone] init];
    mutableCopy.accounts_type   = _accounts_type;
    mutableCopy.amount = _amount;
    mutableCopy.name = _name;
    mutableCopy.self_lable = _self_lable;

    return mutableCopy;
}


@end
@implementation recordList



@end
@implementation JGJRecordMonthBillModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list":@"jgjrecordMonthModel",@"y_total":@"JGJYearTotalModel",@"m_total":@"JGJMonthTotalModel",@"b_total":@"JGJBlanceTotalModel",
             };
}
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
@end

@implementation JGJTeamServiceModel


@end
@implementation JGJTaskPubManModel



@end
@implementation JGJMonthTotalModel
-(instancetype)init{
    if (self = [super init]) {
        self.total = @"0.00";
        self.unit = @"";
        self.pre_unit = @"";
    }
    return self;
}
@end
@implementation JGJYearTotalModel
-(instancetype)init{
    if (self = [super init]) {
        self.total = @"0.00";
        self.unit = @"";
        self.pre_unit = @"";
    }
    return self;
}
@end
@implementation JGJBlanceTotalModel
-(instancetype)init{
    if (self = [super init]) {
        self.total = @"0.00";
        self.unit = @"";
        self.pre_unit = @"";
    }
    return self;
}
@end


@implementation JGJLogoutItemDesModel


@end

@implementation JGJLoginUserInfoModel



@end




@implementation JGJWXMiniModel



@end

@implementation JGJLogoutReasonModel



@end

//3.3.0添加
@implementation JGJEmployTypeModel

- (CGFloat)type_nameW {
    
    //宽度自适应
    
    if ([NSString isFloatZero:_type_nameW]) {
        
        NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:AppFont22Size]};
        
        CGRect frame_W = [_type_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
        
        _type_nameW = frame_W.size.width + 10;
    }
    
    return _type_nameW;
}

MJExtensionCodingImplementation

@end

@implementation JGJEmployClassesModel


MJExtensionCodingImplementation
@end

@implementation JGJEmployListModel

+ (NSDictionary *)objectClassInArray{
    
    return @{
             @"classes" : [JGJEmployClassesModel class]
             
            };
}

- (JGJWelfareTagView *)tagView {
    
    if (!_tagView) {
        
        _tagView = [[JGJWelfareTagView alloc] init];
        
        _tagView.tags = self.welfare;
    }
    
    return _tagView;
}

//- (NSArray *)welfare {
//
//    return @[@"包吃包住", @"不包吃不包住",@"包吃包住", @"不包吃不包住",@"包为为为吃包住", @"不包问问我二位额吃不包住",@"包吃包住", @"不包吃不包住"];
//}
//
//- (NSString *)pro_description{
//
//    _pro_description = @"为我二位额为我二位二位额为我恶趣味额切请问额请问王企鹅请问恶趣味额请问我而且为为请问恶趣味额请问我二位额请问请问我二位二位额为我恶趣味额切请问额请问王企鹅请问恶趣味额请问我而且为为1111";
//
//    return _pro_description;
//}
//
//- (NSString *)pro_title {
//
//    _pro_title = @"我饿为为我二位二位额为我二位额为我二位额为我饿12314567890";
//
//    return _pro_title;
//}

- (CGFloat)cellHeight {
    
    CGFloat totalHeight = 190;
    
    _cellHeight = totalHeight;
    
    if (self.tagView.height > TagH) {
        
        _cellHeight = totalHeight - TagH + self.tagView.height;
    }
    
   CGFloat contentH = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 20 font:AppFont28Size lineSpace:1 content:self.pro_description];
    
    if (contentH > 10) {
        
        _cellHeight = _cellHeight + 10;
    }
    
    if (self.welfare.count == 0) {
        
        _cellHeight -= 42;
    }
    
    return _cellHeight;
}

- (NSString *)distance {
    
    CLLocationDegrees curlat = [[TYUserDefaults objectForKey:JLGLatitude] doubleValue];
    
    CLLocationDegrees curlng = [[TYUserDefaults objectForKey:JLGLongitude] doubleValue];
    
    if (self.pro_location.count > 0 && curlat > 0 && curlng > 0) {
        
        CLLocationDegrees lat = [self.pro_location.lastObject doubleValue];
        
        CLLocationDegrees lng = [self.pro_location.firstObject doubleValue];
        
        //第一个坐标
        CLLocation *curloc = [[CLLocation alloc] initWithLatitude:curlat longitude:curlng];
        
        //第二个坐标
        CLLocation *loca = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        
        // 计算距离
        CLLocationDistance meters = [curloc distanceFromLocation:loca];
        
        TYLog(@"------------------%.lf", meters);
        
        if (meters > 1000) {
            
            _distance = [NSString stringWithFormat:@"%.lf公里", meters/1000.0];
            
        }else {
            
            _distance = @"1公里";
        }
        
    }
    
//    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(lat,lng));
//
//    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(38.915,115.404));
//
//    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    
    return _distance;
}
MJExtensionCodingImplementation

@end

@implementation JGJExistTeamInfoModel

- (NSString *)mergeProName {
    
    _mergeProName = self.team_name;
    
    return _mergeProName;
}

@end


@implementation JGJSourceSyncThirdInfoModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"JGJSyncProlistModel"};
}
@end

@implementation JGJSourceSynProSeclistModel

- (BOOL)isSelectedSource {
    for (int idx = 0; idx < self.sync_unsource.list.count; idx ++) {
        JGJSyncProlistModel *prolistModel = self.sync_unsource.list[idx];
        if (prolistModel.isSelected) {
            self.isSelectedSource = YES;
            continue;
        }
    }
    return _isSelectedSource;
}

- (NSString *)source_pro_id {
    NSMutableString *mergeProInfoStr = [NSMutableString string];
    [self.sync_unsource.list enumerateObjectsUsingBlock:^(JGJSyncProlistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            [mergeProInfoStr appendFormat:@"%@,",obj.pid];
        }
    }];
    //    删除末尾的分号
    if (mergeProInfoStr.length > 0 && mergeProInfoStr != nil) {
        [mergeProInfoStr deleteCharactersInRange:NSMakeRange(mergeProInfoStr.length - 1, 1)];
    }
    _source_pro_id = mergeProInfoStr;
    return _source_pro_id;
}

@end

@implementation JGJSyncProCountModel

@end

@implementation JGJSourceSynProFirstModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"JGJSourceSynProSeclistModel"};
}

- (NSArray *)selectedSync_sources {
    NSMutableArray *selectedSynSourceMembers = [NSMutableArray array];
    for (int idx = 0; idx < self.list.count; idx ++) {
        JGJSourceSynProSeclistModel *synProSeclistModel = self.list[idx];
        JGJSynBillingModel *teamMemberModel = [[JGJSynBillingModel alloc] init];
        if (synProSeclistModel.isSelectedSource) {
            teamMemberModel.telephone = synProSeclistModel.telephone;
            teamMemberModel.real_name = synProSeclistModel.real_name;
            teamMemberModel.uid = synProSeclistModel.uid;
            teamMemberModel.head_pic = synProSeclistModel.head_pic;
            teamMemberModel.is_demand = synProSeclistModel.is_demand;
            teamMemberModel.source_pro_id = synProSeclistModel.source_pro_id;
            [selectedSynSourceMembers addObject:teamMemberModel];
        }
    }
    _selectedSync_sources = selectedSynSourceMembers;
    return _selectedSync_sources;
}

@end

@implementation jgjrecordMonthMsgModel

@end

@implementation JGJGetWorkTplByUidModel

@end

@implementation JGJGetWorkAllTplByUidModel

@end

@implementation JGJComTitleDesInfoModel

- (id)copyWithZone:(nullable NSZone *)zone{
    
    JGJComTitleDesInfoModel *desInfo = [[self class] allocWithZone:zone];
    
    desInfo.title = [_title copy];
    
    desInfo.des = [_des copy];
    
    desInfo.typeId = [_typeId copy];
    
    desInfo.font = [_font copy];
    
    desInfo.desColor = [_desColor copy];
    
    return desInfo;
}
- (id)mutableCopyWithZone:(nullable NSZone *)zone{
    
    JGJComTitleDesInfoModel *desInfo = [[self class] allocWithZone:zone];
    
    desInfo.title = [_title copy];
    
    desInfo.des = [_des copy];
    
    desInfo.typeId = [_typeId copy];
    
    desInfo.font = [_font copy];
    
    desInfo.desColor = [_desColor copy];
    
    return desInfo;
}

@end

@implementation JGJDynamicMsgNumModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"comment_num" : @"new_comment_num",
             @"liked_num" : @"new_liked_num",
             @"fans_num" : @"new_fans_num"
             };
    
}
@end

