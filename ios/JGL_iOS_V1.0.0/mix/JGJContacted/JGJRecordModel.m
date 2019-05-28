//
//  JGJRecordModel.m
//  mix
//
//  Created by Tony on 2017/2/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecordModel.h"

@implementation JGJRecordModel

@end
@implementation JgjRecordlistModel

@end
@implementation JgjRecordMorePeoplelistModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.record_id forKey:@"record_id"];
    [aCoder encodeObject:self.salary forKey:@"salary"];
    [aCoder encodeObject:self.is_salary forKey:@"is_salary"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.work_time forKey:@"work_time"];
    [aCoder encodeObject:self.over_time forKey:@"over_time"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.tpl forKey:@"tpl"];
    [aCoder encodeObject:self.choose_tpl forKey:@"choose_tpl"];
    [aCoder encodeObject:self.msg forKey:@"msg"];

}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.record_id = [aDecoder decodeObjectForKey:@"record_id"];
        self.salary = [aDecoder decodeObjectForKey:@"salary"];
        self.is_salary = [aDecoder decodeObjectForKey:@"is_salary"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.work_time = [aDecoder decodeObjectForKey:@"work_time"];
        self.over_time = [aDecoder decodeObjectForKey:@"over_time"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.tpl = [aDecoder decodeObjectForKey:@"tpl"];
        self.choose_tpl = [aDecoder decodeObjectForKey:@"choose_tpl"];
        self.msg = [aDecoder decodeObjectForKey:@"msg"];
    }
    return self;
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{@"record_id" : @"id"};
}

@end

@implementation JGJMoneyListModel

@end
@implementation JGJTplModel
- (id)mutableCopyWithZone:(NSZone *)zone {
    JGJTplModel *mutableCopy = [[JGJTplModel allocWithZone:zone] init];
    mutableCopy.s_tpl   = _s_tpl;
    mutableCopy.w_h_tpl = _w_h_tpl;
    mutableCopy.o_h_tpl = _o_h_tpl;
    return mutableCopy;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.s_tpl forKey:@"s_tpl"];
    [aCoder encodeObject:self.w_h_tpl forKey:@"w_h_tpl"];
    [aCoder encodeObject:self.o_h_tpl forKey:@"o_h_tpl"];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.s_tpl = [aDecoder decodeObjectForKey:@"s_tpl"];
        self.w_h_tpl = [aDecoder decodeObjectForKey:@"w_h_tpl"];
        self.o_h_tpl = [aDecoder decodeObjectForKey:@"o_h_tpl"];

    }
    return self;
}

@end

@implementation JGJChooseTplModel
- (id)mutableCopyWithZone:(NSZone *)zone {
    JGJChooseTplModel *mutableCopy = [[JGJChooseTplModel allocWithZone:zone] init];
    mutableCopy.choose_o_h_tpl = _choose_o_h_tpl;
    mutableCopy.choose_w_h_tpl = _choose_w_h_tpl;
    return mutableCopy;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.choose_w_h_tpl forKey:@"choose_w_h_tpl"];
    [aCoder encodeObject:self.choose_o_h_tpl forKey:@"choose_o_h_tpl"];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.choose_w_h_tpl = [aDecoder decodeObjectForKey:@"choose_w_h_tpl"];
        self.choose_o_h_tpl = [aDecoder decodeObjectForKey:@"choose_o_h_tpl"];
        
    }
    return self;
}
@end
@implementation JGJMsgModel
- (id)mutableCopyWithZone:(NSZone *)zone {
    JGJMsgModel *mutableCopy = [[JGJMsgModel allocWithZone:zone] init];
    mutableCopy.msg_text   = _msg_text;
    mutableCopy.msg_type = _msg_type;
    return mutableCopy;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.msg_text forKey:@"msg_text"];
    [aCoder encodeObject:self.msg_type forKey:@"msg_type"];
    
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.msg_text = [aDecoder decodeObjectForKey:@"msg_text"];
        self.msg_type = [aDecoder decodeObjectForKey:@"msg_type"];        
    }
    return self;
}


@end
@implementation JGJFirstMorePeoplelistModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"JgjRecordMorePeoplelistModel"};
}

@end

@implementation JGJAddProModel

@end
@implementation JGJeRecordBillDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": @"JGJeRecordBillDetailArrModel"};
}

@end
@implementation JGJeRecordBillDetailArrModel



@end

@implementation accountsModel

- (id)mutableCopyWithZone:(NSZone *)zone {
    accountsModel *mutableCopy = [[accountsModel allocWithZone:zone] init];
    mutableCopy.code   = _code;
    mutableCopy.txt = _txt;
    return mutableCopy;
}


@end
@implementation JGJeRecordFourBillDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"workday": @"JGJeRecordFourBillDetailArrModel"};
}


@end
@implementation JGJeRecordFourBillDetailArrModel



@end
@implementation JGGtypeModel

- (id)mutableCopyWithZone:(NSZone *)zone {
    JGGtypeModel *mutableCopy = [[JGGtypeModel allocWithZone:zone] init];
    mutableCopy.code   = _code;
    mutableCopy.txt = _txt;
    return mutableCopy;
}



@end
@implementation JGJFilloutNumModel

@end

@implementation JGJAccountedMsgModel

@end

@implementation JGJAttendanceUnitQuanTplModel

@end

