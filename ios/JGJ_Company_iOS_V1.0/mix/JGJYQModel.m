//
//  JGJYQModel.m
//  JGJCompany
//
//  Created by Tony on 2017/5/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJYQModel.h"

@implementation JGJYQModel

@end
@implementation JGJSetRainWorkerModel

@end
@implementation JGJSendDailyModel



@end
@implementation JGJWorkReportSendModel



@end
@implementation JGJNodataDefultModel



@end
@implementation JGJRecordWeatherModel



@end

@implementation JGJRainCalenderDetailModel



@end
@implementation UserInfo


@end
@implementation JGJHadRecordWeatherModel



@end
@implementation JGJFilterLogModel



@end

@implementation JGJSelfLogTempRatrueModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"select_value_list": @"selectvaluelistModel",@"list":@"listLogmodel"};
}

@end

@implementation JGJGetLogTemplateModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cat_name forKey:@"cat_name"];
    [aCoder encodeObject:self.cat_id forKey:@"cat_id"];
    [aCoder encodeObject:self.log_type forKey:@"log_type"];

}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.cat_name = [aDecoder decodeObjectForKey:@"cat_name"];
        self.cat_id = [aDecoder decodeObjectForKey:@"cat_id"];
        self.log_type = [aDecoder decodeObjectForKey:@"log_type"];

    }
    return self;
}
@end
@implementation selectvaluelistModel



@end
@implementation listLogmodel



@end
@implementation JGJLogListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":@"JGJLogSectionListModel",@"user_info":@"JGJUserInfoModel"};
}
@end
@implementation JGJLogSectionListModel



@end
@implementation JGJUserInfoModel



@end

@implementation JGJLogReceiverListModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list":@"JGJSynBillingModel"};
}


@end

@implementation JGJLogDetailModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"element_list":@"JGJElementDetailModel"};
}


@end
@implementation JGJElementDetailModel
//+ (NSDictionary *)mj_objectClassInArray {
//
//    return @{@"Weather_value":@"JGJLogWeatherDeailModel"};
//}

@end
@implementation JGJLogWeatherDeailModel



@end
@implementation JGJLogTotalListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":@"JGJLogListModel"};
}


@end
@implementation JGJMyRelationshipProModel



@end
@implementation JGJSureOrderListModel



@end
@implementation JGJMyorderListmodel

+(NSDictionary *)mj_objectClassInArray
{
return @{@"list":@"JGJOrderListModel"};
}

@end
@implementation JGJOrderListModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"produce_info":@"JGJProductinfoModel"};
}

@end
@implementation JGJOverTimeModel

@end
@implementation JGJAccountListModel



@end
@implementation JGJCloudPriceModel



@end
@implementation JGJWeiXinuserInfo



@end
@implementation JGJweiXinPaymodel 



@end
@implementation JGJLogUserInfoModel



@end
@implementation JGJProductinfoModel



@end
@implementation JGJCreateCheckModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"dot_list":@"JGJCreateCheckDetailModel"};
}

-(NSMutableArray<JGJCreateCheckDetailModel *> *)dot_list
{
    if (!_dot_list) {
        
        _dot_list = [[NSMutableArray alloc]init];
        
    }
    return _dot_list;
}


@end
@implementation JGJCreateCheckDetailModel



@end
@implementation JGJCheckItemMainListModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"JGJCheckItemListDetailModel"};
}


@end
@implementation JGJCheckItemListDetailModel



@end

@implementation JGJCheckContentDetailModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"dot_list":@"JGJCheckItemListDetailListModel"};
}


@end

@implementation JGJCheckItemListDetailListModel



@end
@implementation JGJCheckItemPubDetailModel
-(NSMutableArray<JGJCheckItemPubDetailListModel *> *)content_list
{
    if (!_content_list) {
        _content_list = [[NSMutableArray alloc]init];
    }
    return _content_list;
}
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"content_list":@"JGJCheckItemPubDetailListModel"};
}

@end
@implementation JGJCheckItemPubDetailListModel
-(NSMutableArray<JGJCheckItemListDetailListModel *> *)dot_list
{
    if (!_dot_list) {
        
        _dot_list = [[NSMutableArray alloc]init];
        
    }
    return _dot_list;
}
-(void)setOpenO:(BOOL)openO
{
    _openO = openO;

}
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"dot_list":@"JGJCheckItemListDetailListModel"};
}


@end

@implementation JGJAddCheckItemModel
-(NSMutableArray<JGJCheckContentListModel *> *)pro_list
{
    if (!_pro_list) {
        _pro_list = [[NSMutableArray alloc]init];
    }
    
    return _pro_list;
}
-(NSMutableArray<JGJSynBillingModel *> *)member_list
{
    if (!_member_list) {
        _member_list = [[NSMutableArray alloc]init];
    }
    return _member_list;
}
+(NSDictionary *)mj_objectClassInArray
{
    
    return @{@"content_list":@"JGJCheckContentListModel",@"member_list":@"JGJSynBillingModel",@"pro_list":@"JGJCheckContentListModel"};
}


@end

@implementation JGJCheckContentListModel



@end
@implementation JGJAllNoticeModel
+(NSDictionary *)mj_objectClassInArray
{
    
    return @{@"user_info":@"UserInfo"};
}
-(NSArray *)reply_msg
{
    if (!_reply_msg) {
        _reply_msg = [NSArray array];
    }
    return _reply_msg;
}
-(NSArray *)msg_src
{
    if (!_msg_src) {
        _msg_src = [NSArray array];
    }
    return _msg_src;
    
}
@end
@implementation JGJAppBuyCombo

@end
