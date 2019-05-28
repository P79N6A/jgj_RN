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
#import "JGJNewNotifyTool.h"
#import "NSString+Extend.h"
@implementation CommonModel

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
    NSString *verifiedStr = @"当前身份:班组长";
    return verifiedStr;
}

@end

@implementation MyWorkZone

- (NSString *)statusString {
    NSString *status = nil;
    switch (self.work_staus) {
        case NoWorkType:
            status = @"还没有工作";
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

- (void)setReal_name:(NSString *)real_name {
    _real_name = real_name;
    //    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+@? "];
    //    _real_name = [[_real_name componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    //    if ([NSString isEmpty:_real_name]) {
    //        _real_name = @"其他";
    //    }
    _name  = _real_name;
}

- (void)setName:(NSString *)name {
    _name = name;
    //    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+@? "];
    //    _name = [[_name componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    //    if ([NSString isEmpty:_name]) {
    //        _name = @"其他";
    //    }
    _real_name = _name;
}

- (void)setTelephone:(NSString *)telephone {
    _telephone = telephone;
    if (_telephone.length > 0) {
        _telephone = [_telephone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        _telephone = [_telephone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        _telph = _telephone;
        _telphone = _telephone;
    }
}

- (void)setTelph:(NSString *)telph {
    _telph = telph;
    if (_telph.length > 0) {
        _telph = [_telph stringByReplacingOccurrencesOfString:@"-" withString:@""];
        _telph = [_telph stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        _telephone = _telph;
        _telphone = _telephone;
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
        NSArray *hashColors = @[TYColorHex(0xe6884f),TYColorHex(0xffae2f),TYColorHex(0x99bb4f),TYColorHex(0x56c2c5),TYColorHex(0x62b1da),TYColorHex(0x5990d4),TYColorHex(0x7266ca),TYColorHex(0xbf67cf),TYColorHex(0xda63af),TYColorHex(0xdf5e5e)];
        NSInteger hashCode = [self getHashCode:self.name];
        NSString *lastHashCodeStr = [NSString stringWithFormat:@"%@", @(hashCode)];
        NSInteger colorIndx = [lastHashCodeStr characterAtIndex:lastHashCodeStr.length - 1];
        colorIndx -= 48;
        if ([hashColors indexOfObject:hashColors[colorIndx]] == NSNotFound) {
            NSInteger index = arc4random() % 9;
            _modelBackGroundColor = hashColors[index];
        }else {
            _modelBackGroundColor = hashColors[colorIndx];
        }
    }
    return _modelBackGroundColor;
}

- (NSInteger)getHashCode:(NSString *)real_name {
    NSString *lastName = [real_name substringWithRange:NSMakeRange(real_name.length - 1, 1)];
//    NSInteger hash = 1315423911;
    NSInteger temp = (NSInteger)[lastName characterAtIndex:0];
//    hash ^= ((hash << 5) + temp + (hash >> 2));
    return temp;
}

- (BOOL)isEqual:(JGJSynBillingModel *)object {
    if ([self.telephone isEqualToString:object.telephone]) {
        
        return YES;
    } else {
        
        return NO;
    }
    //    return [self.telephone isEqualToString:object.telephone];
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
    }
}

@end

@implementation JGJClosedGroupModel

- (BOOL)canOpen {
    return [self.myself_group isEqualToString:@"1"];
}

@end

@implementation JGJMyWorkCircleProListModel

- (instancetype)init{
    self = [super init];
    if (self) {
        _token = [NSString isEmpty:[TYUserDefaults objectForKey:JLGPhone]]?@"":[TYUserDefaults objectForKey:JLGPhone];
    }
    
    return self;
}

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
//    _classTypeDesc = [self.myself_group isEqualToString:@"1"] ? @"项目组管理" : @"项目组信息";
    _classTypeDesc = @"设置";
    return _classTypeDesc;
}

- (NSString *)class_typeIdKey {
    return [self.class_type isEqualToString:@"team"] ? @"team_id" : @"group_id";
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"class_typeIdValue" : @"team_id",
             @"class_typeIdValue" : @"group_id",
             @"isClosedTeamVc" : @"is_closed"
             };
}

- (JGJTeamMangerVcType)teamMangerVcType {
    if (self.is_source_member && !self.is_admin) {
        _teamMangerVcType = JGJSourceMemberType; //来源人
    } else if([self.myself_group isEqualToString:@"1"]) { //普通成员或者管理者
        _teamMangerVcType = JGJProMangerType;
    } else if (self.is_admin && !self.is_source_member) { //只要是管理员就可以添加删除成员
        _teamMangerVcType = JGJNormalProMangerType;
    }else if (self.is_admin && self.is_source_member){
        _teamMangerVcType = JGJNormalProMangerAndSourceMemberType; //两种成员身份普通管理员和数据来源人点击
    }else {
        _teamMangerVcType = JGJProInfoType; //普通成员
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
    if (self.is_source_member) {
        _proDetailButtontitle = @"关闭同步"; //来源人
    } else { //普通成员或者管理者
        _proDetailButtontitle = [self.myself_group isEqualToString:@"1"] ? @"关闭项目" :  @"退出项目组";
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
    
    BOOL isMySelfGroup = [self.myself_group isEqualToString:@"1"];
    
    NSString *myGroupFlagStr = isMySelfGroup ?@"(我创建的)" : @"";
    
    NSString *proName = [NSString stringWithFormat:@"%@ %@", self.group_name, myGroupFlagStr];
    
    if (!self.isCheckClosedPro) {
        
        _checkProCellHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 97.0 content:proName font:AppFont30Size lineSpace:1] + 31.5;
        
    }else {
        
        _checkProCellHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 80.0 content:proName font:AppFont30Size lineSpace:1] ;
        
        if (_checkProCellHeight > 20.0) {
            
            _checkProCellHeight = 85.0;
            
        }
    }
    
    return _checkProCellHeight;
}

//#pragma mark - #pragma mark - 全局取消黄金服务版(4个位置修改了，搜索这句话)
//- (NSString *)is_senior {
//
//    return @"0";
//}

- (NSArray *)members_head_pic {
    
    if (![NSString isEmpty:_local_head_pic]) {
        
        _members_head_pic = [_local_head_pic mj_JSONObject];
    }
    
    return _members_head_pic;
}

MJExtensionCodingImplementation

@end

@implementation JGJActiveGroupListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"JGJMyWorkCircleModel"};
}
@end

@implementation JGJActiveGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"unclose" : @"JGJMyWorkCircleProListModel",
             
             @"closed_list" : @"JGJMyWorkCircleProListModel"
             
             };

}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"fresh_friend_num" : @"new_friend_num"};
}

- (NSArray *)closed_list {
    
    for (JGJMyWorkCircleProListModel *proListModel in _closed_list) {
        
        proListModel.isClosedTeamVc = YES;
        
    }
    
    return _closed_list;
}

-(void)setUnclose:(NSArray<JGJMyWorkCircleProListModel *> *)unclose {
    _unclose = unclose;
//    _unclose = [JGJMyWorkCircleProListModel mj_objectArrayWithKeyValuesArray:unclose];
}

//#pragma mark - 刷新底部项目组数据计算高度
//- (CGFloat)workCircleHeight {
//    __block BOOL isExistMySelfTeam = NO;
//    _workCircleHeight = 0;
//    NSUInteger closedCount = [self.closed.closed_group_count integerValue];
//    NSUInteger unClosedCount = self.unclose.count;
//    BOOL isNoneExistPro = unClosedCount == 0 && closedCount == 0; //没有项目
//    BOOL isExistPro = self.unclose.count > 0 && closedCount > 0; //存在未关闭的项目，和存在关闭的项目
//    BOOL isOnlyExistClosedPro = unClosedCount == 0 && closedCount > 0; //仅存在关闭的项目
//    BOOL isOnlyExistUnClosedPro = unClosedCount > 0 && closedCount == 0; //仅存在未关闭项目
//    CGFloat height = 0.0;
//    if (isNoneExistPro) { //不存在项目
//        height = WorkCircleHeaderHegiht + JGJWorkCircleDefaultHeight  + WorkCircleTableViewHeaderHegiht + WorkCircleTableViewFooterHegiht;
//    } else if (isExistPro) {
//        height =  WorkCircleTableViewFooterHegiht + WorkCircleTableViewHeaderHegiht;
//    }else if (isOnlyExistClosedPro) {
//        height = WorkCircleHeaderHegiht + WorkCircleTableViewHeaderHegiht + JGJWorkCircleProGroupCellHeight + WorkCircleTableViewFooterHegiht;
//    } else if (isOnlyExistUnClosedPro) {
//        height = WorkCircleTableViewHeaderHegiht;
//    }
//    NSInteger section = 0;
//    self.workCircleCount = self.unclose.count;
//    _workCircleHeight = self.unclose.count * JGJWorkCircleProGroupCellHeight; //这里要加判断根据项目组改变高度 75为项目高度
//    [self.unclose enumerateObjectsUsingBlock:^(JGJMyWorkCircleProListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:section];
//        obj.indexPath = indexPath;
//        if (!isExistMySelfTeam && [obj.myself_group isEqualToString:@"1"]) { //判断是否存在我自己创建的项目
//            isExistMySelfTeam = YES;
//            self.isExistMyCreatTeam = YES;
//        }
//    }];
//    self.isExistMyCreatTeam = isExistMySelfTeam;
//    _workCircleHeight += height;
//    return _workCircleHeight;
//}

MJCodingImplementation
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

- (NSString *)group_name {
    return _group_name ?:@"";
}

- (NSString *)team_name {
    return _team_name ?:@"";
}

- (CGFloat)cellHeight {

    CGFloat titleH = [NSString stringWithContentWidth:TYGetUIScreenWidth - 183 content:self.title font:AppFont30Size];
    
    _cellHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 123 content:self.info font:AppFont28Size] + 74 + titleH;
    
    //成功之后隐藏按钮,高度减去33
    if (self.isSuccessSyn || self.isRefused) {
        
        _cellHeight -= 33;
    }
    
    return _cellHeight;
}

- (NSString *)info {
    
    //同步文字处理，其余参考列表高度
    
    switch (self.notifyType) {
            
        case SyncNoticeTargetType:{
            
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

- (NSMutableArray<JGJSynBillingModel *> *)team_group_members {
    //    [self.class_Type isEqualToString:@"group"] ? _member_list : _team_members //之前做了区分
    return _member_list; //后改为一个
}

- (NSMutableArray<JGJSynBillingModel *> *)source_report_members {
    return [self.class_type isEqualToString:@"group"] ? _report_user_list : _source_members;
}

- (JGJGroupInfoModel *)team_group_info {
    
    //    _team_group_info = [self.group_info.class_type isEqualToString:@"group"] ? _group_info : _team_info;
    
    _team_group_info = _group_info;
    
    return _team_group_info;
}

- (NSString *)class_TypeId {
    return [self.class_type isEqualToString:@"group"] ? _group_id : _team_id;
}

- (BOOL)isUpdatePer {

    if (self.team_info.is_senior) {
        
        _isUpdatePer = self.cur_member_num >= self.team_info.buyer_person;
        
    }else {
    
        _isUpdatePer = self.cur_member_num >= 5;
    }
    
    return _isUpdatePer;
}

//#pragma mark - 全局取消黄金服务版(4个位置修改了，搜索这句话)
//- (BOOL)is_senior {
//    
//    return NO;
//}

@end

@implementation JGJProjectListModel

@end

@implementation JGJADModel

@end

//#pragma mark - 企业版1.0添加
//@implementation JGJWorkCircleMiddleInfoModel
//
//@end

@implementation JGJCreatProDecModel

@end

@implementation JGJMergeSplitProModel

@end

@implementation JGJShareProDesModel

@end

@implementation JGJSplitProModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"JGJMergeSplitProModel"};
}
@end

@implementation JGJSynMergecheckModel

@end

@implementation JGJTitleInfoModel

@end

@implementation JGJExistTeamInfoModel

- (NSString *)mergeProName {
    
    _mergeProName = self.team_name;
    
//    NSUInteger proNameLength = 16.0;
//    _mergeProName = [NSString stringWithFormat:@"%@ (%@)", self.team_name, self.pro_name];
//    if (![NSString isEmpty:_mergeProName] && _mergeProName.length > proNameLength) {
//        _mergeProName = [NSString stringWithFormat:@"%@%@", [_mergeProName substringToIndex:proNameLength],@"..."];
//    }
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
            teamMemberModel.telphone = synProSeclistModel.telephone;
            teamMemberModel.real_name = synProSeclistModel.user_name;
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
    
    CGFloat baseH = 110;
    
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

@end

@implementation JGJTeamServiceModel


@end
@implementation JGJTaskPubManModel



@end

@implementation JGJLogoutItemDesModel


@end

@implementation JGJLoginUserInfoModel



@end

@implementation JGJWXMiniModel



@end

@implementation JGJLogoutReasonModel



@end


@implementation JGJDynamicMsgNumModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"comment_num" : @"new_comment_num",
             @"liked_num" : @"new_liked_num",
             @"fans_num" : @"new_fans_num"
             };
    
}

@end
