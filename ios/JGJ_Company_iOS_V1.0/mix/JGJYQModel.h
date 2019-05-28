//
//  JGJYQModel.h
//  JGJCompany
//
//  Created by Tony on 2017/5/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonModel.h"
typedef NS_ENUM(NSInteger ,logElementType){
 JGJLogSelectType,//多选
 JGJLogDateframeType,//截止时间
 JGJLogNumberType,//数字输入
 JGJLogTextareaType,//文字输入
 JGJLogUpimgType,//文字输入
 JGJLogGroupType,//文字输入

};
typedef enum :NSUInteger{
    rainCalenderNormal,//正常的设置天气
    rainCalenderEdite //重新编辑天气
    
}rainWeatherType;

typedef enum :NSUInteger{
    WXpayType,
    AlipayType,
    
}payType;//支付类型

typedef enum :NSUInteger{
    VipListType,
    CloudListType,
    
}GoodsType;//支付类型
@class UserInfo;
@class selectvaluelistModel;
@class listLogmodel;
@class JGJLogSectionListModel;
@class JGJUserInfoModel;
@class JGJElementDetailModel;
@class JGJLogWeatherDeailModel;
@class JGJLogListModel;
@class JGJOrderListModel;
@class JGJCloudPriceModel;
@interface JGJYQModel : NSObject

@end
//设置天气记录员的模型
@interface JGJSetRainWorkerModel : CommonModel
@property (nonatomic ,copy)NSString *gender;
@property (nonatomic ,copy)NSString *head_pic;
@property (nonatomic ,copy)NSString *head_pic_time;
@property (nonatomic ,copy)NSString *is_active;
@property (nonatomic ,copy)NSString *is_admin;
@property (nonatomic ,copy)NSString *is_creater;
@property (nonatomic ,copy)NSString *is_report;
@property (nonatomic ,copy)NSString *nickname;
@property (nonatomic ,copy)NSString *real_name;
@property (nonatomic ,copy)NSString *telphone;
@property (nonatomic ,copy)NSString *uid;

@end
@interface JGJRainCalenderDetailModel : CommonModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *class_type;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *weat_one;
@property (nonatomic, copy) NSString *weat_two;
@property (nonatomic, copy) NSString *weat_three;
@property (nonatomic, copy) NSString *weat_four;
@property (nonatomic, copy) NSString *temp_am;
@property (nonatomic, copy) NSString *temp_pm;
@property (nonatomic, copy) NSString *wind_am;
@property (nonatomic, copy) NSString *wind_pm;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *is_active;
@property (nonatomic, copy) NSString *lunar_date;
@property (nonatomic, copy) NSArray *head_pic;
@property (nonatomic, copy) NSString *all_date;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *weekday;
@property (nonatomic, copy) NSString *weat_temp_wind;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *is_close;
@property (nonatomic, copy) NSString *temp;
@property (nonatomic, copy) NSString *wind;
@property (nonatomic, copy) NSString *weat;
@property (nonatomic, copy) NSString *is_admin;
@property (nonatomic, copy) NSString *is_report;
@property (nonatomic, copy) NSString *is_creater;

@property (nonatomic, strong)UserInfo *record_info;


@end
@interface UserInfo : CommonModel
@property (nonatomic, copy) NSString *head_pic;//	组id
@property (nonatomic, copy) NSString *real_name;//	组id
@property (nonatomic, copy) NSString *is_report;//	组id
@property (nonatomic, copy) NSString *uid;//	组id
@property (nonatomic, copy) NSString *is_creater;//	组id
@property (nonatomic, copy) NSString *is_admin;//	组id
@property (nonatomic, copy) NSString *telephone;//	组id
@property (nonatomic, copy) NSString *user_name;//	组id


@end
@interface JGJWorkReportSendModel : CommonModel
@property (nonatomic, copy) NSString *group_id;//	组id
@property (nonatomic, copy) NSString *class_type;//	班组：group；项目组：team
@property (nonatomic, copy) NSString *report_uid;//	发布的用户uid，不传默认当前用户
@property (nonatomic, copy) NSString *report_type;//发布汇报类型：today：今天；week：周；month：月
@property (nonatomic, copy) NSString *finish_plant;//今天/今周/今月的完成内容
@property (nonatomic, copy) NSString *next_plant;//明天/下周/下月的工作计划
@property (nonatomic, copy) NSString *coordinate_work;//汇报协调工作
@property (nonatomic, copy) NSString *summarize;//	周/月总结
@property (nonatomic, copy) NSString *receive_uids;//接受者的uid，以逗号隔开
@property (nonatomic, copy) NSString *report_imgs;//	图片
@property (nonatomic, copy) NSString *sign;//	签名字符串
@property (nonatomic, copy) NSString *client_type;//平台类型 person 个人端 manage 管理端


@end
@interface JGJSendDailyModel : CommonModel//发施工日志
//@property (nonatomic, copy) NSArray *days;
//@property (nonatomic, copy) NSString *normal_work;
@property (nonatomic, copy) NSString *weat_am;//上午的天气
@property (nonatomic, copy) NSString *weat_pm;//下午的天气
@property (nonatomic, copy) NSString *temp_am;//上午的温度
@property (nonatomic, copy) NSString *temp_pm;//下午的温度
@property (nonatomic, copy) NSString *wind_am;//上午的风力
@property (nonatomic, copy) NSString *wind_pm;//下午的风力
@property (nonatomic, copy) NSString *text_msg;//文本输入
@property (nonatomic, copy) NSString *numtext;//数字输入
@property (nonatomic, copy) NSString *startTime;//开始时间
@property (nonatomic, copy) NSString *endTime;//结束时间
@property (nonatomic, copy) NSString *selectValue;//结束时间
@property (nonatomic, copy) NSString *selectID;//结束时间
@property (nonatomic, copy) NSString *text;//单行文本
@property (nonatomic, copy) NSString *pushtime;//发布时间
@property (nonatomic, copy) NSString *car_id;//模板id  用于编辑日志时获取模板
@property (nonatomic, copy) NSString *time;//单选时间

@property (nonatomic, copy) NSString *product_text;//生产情况记录
@property (nonatomic, copy) NSString *technique_text;//技术质量工作记录
@property (nonatomic, copy) NSMutableArray *image_Arr;//选择的图片
@property (nonatomic, copy) NSString *pro_name;//项目名
@property (nonatomic, copy) NSString *msg_prodetail;//招聘聊天传，其他不必传
@property (nonatomic, copy) NSString *is_find_job;//0:非招聘聊天;1：如果是招聘聊天，必传
@property (nonatomic, copy) NSString *at_uid;//at成员uid，如有多个成员时,uid用’,’号隔开，例：20,21；如果是全部，则参数为：all（只有管理员才能操作）
@property (nonatomic, copy) NSString *pic_w_h;//图片的宽高pic_w_h”:[“200”,”45”]，发送图片时必传
@property (nonatomic, copy) NSString *voice_long;//语音消息时长，如果msg_type为voice时必传
@property (nonatomic, copy) NSString *local_id;//本地消息id
@property (nonatomic, copy) NSString *send_time;//消息发送时间,如果不传则取服务器接收数据时间
//@property (nonatomic, copy) NSString *msg_src;//语音或者图片地址 "msg_src":['notice1.png','notice2.png',] 或 "msg_src":['notice1.mp3']
@property (nonatomic, copy) NSString *msg_text;//语音消息可不传，其他必传
@property (nonatomic, copy) NSString *group_id;//发送到的班组或项目组，如果class_type为group,则为group_id,为team则传team_id的值
@property (nonatomic, copy) NSString *class_type;//类别，group为班组，team为讨论组 ,groupChat群聊，singleChat单聊（为单聊时，group_id为用户的uid）
@property (nonatomic, copy) NSString *msg_type;//text文本消息,voice语音消息，notice通知,log 日志,signIn 签到,safe 安全,quality 质量,billRecord 记工记账，signIn签到消息,pic图片消息,proDetail招聘信息
@property (nonatomic, copy) NSString *techno_quali_log;//text文本消息,voice语音消息，notice通知,log 日志,signIn 签到,safe 安全,quality 质量,billRecord 记工记账，signIn签到消息,pic图片消息,proDetail招聘信息
@property (nonatomic, copy) NSArray *msg_srcs;//日志图片

@end
@interface JGJRecordWeatherModel : CommonModel
@property (nonatomic ,assign)rainWeatherType rainCalenderType;
@property (nonatomic, copy) NSString *token;//TOKEN
@property (nonatomic, copy) NSString *os;//平台
@property (nonatomic, copy) NSString *ctrl;//message 控制器名
@property (nonatomic, copy) NSString *action;//	handleWorkReports
@property (nonatomic, copy) NSString *class_type;//班组：group；项目组：team
@property (nonatomic, copy) NSString *group_id;//	组id
@property (nonatomic, copy) NSString *uid;//发布的用户uid，不传默认当前用户
@property (nonatomic, copy) NSString *weat_one;//天气1
@property (nonatomic, copy) NSString *weat_two;//天气2
@property (nonatomic, copy) NSString *weat_three;//天气3
@property (nonatomic, copy) NSString *weat_four;//天气4
@property (nonatomic, copy) NSString *temp_am;//下午温度
@property (nonatomic, copy) NSString *temp_pm;//下午温度
@property (nonatomic, copy) NSString *wind_am;//上午温度
@property (nonatomic, copy) NSString *wind_pm;//	下午温度
@property (nonatomic, copy) NSString *detail;//	描述
@property (nonatomic, copy) NSString *sign;//签名字符串
@property (nonatomic, copy) NSString *client_type;//平台类型 person 个人端 manage 管理端
@property (nonatomic, copy) NSString *id;//签名字符串

@end
@interface JGJHadRecordWeatherModel : CommonModel
@property (nonatomic, copy) NSString *temp_am;//温度
@property (nonatomic, copy) NSString *temp_pm;///温度
@property (nonatomic, copy) NSString *wind_am;//风力
@property (nonatomic, copy) NSString *wind_pm;//风力
@property (nonatomic, copy) NSString *weat_am;//天气
@property (nonatomic, copy) NSString *weat_pm;//天气
@property (nonatomic, copy) NSString *weat_one;//天气
@property (nonatomic, copy) NSString *weat_two;//天气
@property (nonatomic, copy) NSString *weat_three;//天气
@property (nonatomic, copy) NSString *weat_four;//天气
//筛选日志

@end
@interface JGJFilterLogModel : CommonModel
@property (nonatomic, copy) NSString *cat_id;//模板id
@property (nonatomic, copy) NSString *cat_name;//模板名称
@property (nonatomic, copy) NSString *logType;//筛选日志类型
@property (nonatomic, copy) NSString *startTime;///开始时间
@property (nonatomic, copy) NSString *netstartTime;///开始时间

@property (nonatomic, copy) NSString *endTime;//结束时间
@property (nonatomic, copy) NSString *netendTime;//结束时间

@property (nonatomic, copy) NSString *name;//提交人
@property (nonatomic, copy) NSString *uid;//提交人


@end

@interface JGJSelfLogTempRatrueModel : CommonModel
@property (nonatomic, copy) NSString *element_name;//筛选日志类型
@property (nonatomic, copy) NSString *element_type;///开始时间
@property (nonatomic, copy) NSString *is_require;//结束时间
@property (nonatomic, copy) NSString *element_key;//提交人
@property (nonatomic, copy) NSString *cat_id;//提交人
@property (nonatomic, copy) NSString *date_type;//提交人
@property (nonatomic, copy) NSString *element_unit;//提交人
@property (nonatomic, strong) NSArray <listLogmodel *>*list;//提交人
@property (nonatomic, strong) NSArray <selectvaluelistModel *>*select_value_list;//多选选项

@property (nonatomic, copy) NSString *create_time;//创建时间

@property (nonatomic, copy) NSString *length_range;//创建时间

@property (nonatomic, assign) logElementType elementtype;//结束时间
@property (nonatomic, copy) NSString *decimal_place;//小数点后面位数


@end

@interface JGJGetLogTemplateModel : CommonModel<NSCoding>
@property (nonatomic, copy) NSString *cat_id;//模板id
@property (nonatomic, copy) NSString *cat_name;//模板名称
@property (nonatomic, copy) NSString *log_type;//日志类型
@end


@interface selectvaluelistModel : CommonModel
@property (nonatomic, copy) NSString *id;//模板id
@property (nonatomic, copy) NSString *name;//模板名称
@end
@interface listLogmodel : CommonModel
@property (nonatomic, copy) NSString *element_name;//模板名称
@property (nonatomic, copy) NSString *position;//模板名称

@end

@interface JGJLogTotalListModel : CommonModel
@property (nonatomic, copy) NSString *s_date;
@property (nonatomic, copy) NSString *allnum;
@property (nonatomic, strong) NSArray <JGJLogListModel *>*list;


@end
//每个时间段的  数组 每个section的
@interface JGJLogListModel : CommonModel
@property (nonatomic, copy) NSString *day_num;
@property (nonatomic, strong) NSArray <JGJLogSectionListModel *>*list;
@property (nonatomic, copy) NSString *log_date;

@property (nonatomic, copy) NSString *msg_sender;

@end


//每个row的信息
@interface JGJLogSectionListModel : CommonModel
@property (nonatomic, copy) NSString *cat_name;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSArray *imgs;
@property (nonatomic, copy) NSString *show_list_content;
@property (nonatomic, strong) JGJUserInfoModel *user_info;
@property (nonatomic, copy) NSString *cat_id;
@property (nonatomic, copy) NSString *week_day;

@end
@interface JGJUserInfoModel : CommonModel
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *uid;

@end

@interface JGJLogReceiverListModel : CommonModel

@property (nonatomic, copy) NSString *allnum;

@property (nonatomic, copy) NSString *receiver_uid;

@property (nonatomic, strong) NSArray <JGJSynBillingModel *>*list;

@end

@interface JGJLogDetailModel : CommonModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) JGJUserInfoModel *user_info;
@property (nonatomic, copy) NSArray <JGJElementDetailModel *>*element_list;
@property (nonatomic, copy) NSArray <NSString *> *msg_src;

@property (nonatomic, strong) JGJLogReceiverListModel *receiver_list;

@end

@interface JGJElementDetailModel : CommonModel
@property (nonatomic, copy) NSString *element_name;
@property (nonatomic, copy) NSString *element_value;
@property (nonatomic, copy) NSString *select_id;
//@property (nonatomic, strong) JGJLogWeatherDeailModel *Weather_value;
@property (nonatomic, copy) NSString *Weather_value;

@property (nonatomic, copy) NSString *element_unit;
@property (nonatomic, copy) NSString *element_type;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *element_key;
@property (nonatomic, copy) NSString *id;

@end

@interface JGJLogWeatherDeailModel : CommonModel
@property (nonatomic, copy) NSString *weat_am;
@property (nonatomic, copy) NSString *weat_pm;
@property (nonatomic, copy) NSString *wind_am;
@property (nonatomic, copy) NSString *wind_pm;
@property (nonatomic, copy) NSString *temp_am;
@property (nonatomic, copy) NSString *temp_pm;

@end

@interface JGJMyRelationshipProModel : CommonModel
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *class_type;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *is_closed;
@property (nonatomic, copy) NSString *is_default;
@property (nonatomic, copy) NSString *members_num;
@property (nonatomic, copy) NSString *cloud_space;//剩余云盘空间
@property (nonatomic, copy) NSString *buyer_person;//一定服务人数
@property (nonatomic, copy) NSString *lave_days;//剩余服务时长
@property (nonatomic, copy) NSString *used_space;//一用云盘空间
@property (nonatomic, copy) NSString *cloud_lave_days;//云盘剩余服务天数
@property (nonatomic, copy) NSString *service_lave_days;//黄金版剩余服务天数
@property (nonatomic, copy) NSString *donate_space;//黄金版剩余服务天数
@end

@interface JGJSureOrderListModel : CommonModel//确认订单
@property (nonatomic, strong) JGJMyRelationshipProModel *MyRelationShipProModel;//项目信息
@property (nonatomic, copy) NSString *serviceTime;//服务时长
@property (nonatomic, assign) GoodsType goodsType;//上平类型
@property (nonatomic, assign) payType payType;//支付类型
@property (nonatomic, copy) NSString *peopleNum;//服务人数
@property (nonatomic, copy) NSString *cloudNum;//云盘空间
@property (nonatomic, copy) NSString *salary;//支付金额

@end
@interface JGJMyorderListmodel : CommonModel
@property (nonatomic, copy) NSString *all_amount;
@property (nonatomic, copy) NSArray <JGJOrderListModel *>*list;

@end
@class JGJProductinfoModel;
@interface JGJOrderListModel : CommonModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *class_type;
@property (nonatomic, copy) NSString *server_id;//1是黄金服务班 2是云盘
@property (nonatomic, copy) NSString *server_name;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, copy) NSString *pro_name;
@property (nonatomic, copy) NSString *expire_time;
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, copy) NSString *pay_name;
@property (nonatomic, copy) NSString *server_counts;
@property (nonatomic, copy) NSString *donate_space;
@property (nonatomic, copy) NSString *cloud_space;
@property (nonatomic, copy) NSString *discount_amout;
@property (nonatomic, copy) NSString *total_amount;//原价
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *is_active;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *msg_src;
@property (nonatomic, copy) NSString *price3;
@property (nonatomic, copy) NSString *price_detail;
@property (nonatomic, copy) NSString *service_time;//服务时长
@property (nonatomic, assign) GoodsType goodsType;//服务时长
@property (nonatomic, copy) NSString *is_sale;//是否在销售
@property (nonatomic, copy) NSString *units;//单位"人*半年",
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *person;
@property (nonatomic, copy) NSString *percents;
@property (nonatomic, copy) NSString *buyer_person;//已购服务人数
@property (nonatomic, copy) NSString *add_people;//后期添加的人数
@property (nonatomic, copy) NSString *add_cloudplace;//后期添加的云盘空间
@property (nonatomic, copy) NSString *add_serverTime;
@property (nonatomic, copy) NSString *members_num;//项目成员人数
@property (nonatomic, copy) NSString *used_space;//一用云盘空间
@property (nonatomic, copy) NSString *service_lave_days;//剩余高级版服务天数
@property (nonatomic, copy) NSString *cloud_lave_days;//剩余云盘服务天数
@property (nonatomic, assign) BOOL isPayDay;//直接按天书计算 此处返回的是天数 否则返回的是年
@property (nonatomic, copy) NSString *order_type;//商品类型
@property (nonatomic, assign) BOOL paySucees;//支付是否成功
@property (nonatomic, copy) NSString *price;//服务商品实际价 现价
@property (nonatomic, assign) BOOL clickPay;//点击按钮支付
@property (nonatomic, assign) BOOL upgrade;//是否升级
@property (nonatomic, copy) NSString *group_name;//项目名称
@property (nonatomic, strong) JGJCloudPriceModel *cloud_info;//项目名称
@property (nonatomic, copy) NSString *trade_no;//支付成功后的订单号
@property (nonatomic, copy) NSString *cloud_total_amount;//云盘原价
@property (nonatomic, copy) NSString *cloud_price;//云盘现价
@property (nonatomic, copy) NSString *second_server_id;//高买高级服务时也选择了云盘接口续传这个
@property (nonatomic, copy) NSString *timestamp;//服务器返回的时间戳
@property (nonatomic, copy) NSString *vcode;//手机验证码用于提现手机验证
@property (nonatomic, strong) JGJProductinfoModel *produce_info;//订单列表的商品详情
@property (nonatomic, assign) BOOL DontPay;//用于区别金额为0时 不跳转支付界面
@property (nonatomic, copy) NSString *order_id;//订单详情
@property (nonatomic, copy) NSString *totalMoney;//总价


@end

//过期提示模型
@interface JGJOverTimeModel : CommonModel
@property (nonatomic, copy) NSString *tipStr;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *contentSubStr;
@property (nonatomic, assign) BOOL showView;//是否强制弹框显示
@property (nonatomic, strong) NSArray *buttonArr;
@property (nonatomic, copy) NSString *proNameStr;
@property (nonatomic, assign) BOOL cloudType;//云盘过期
@end
@interface JGJNodataDefultModel : CommonModel
@property (nonatomic, copy) NSString *contentStr;//内容提示
@property (nonatomic, copy) NSString *helpTitle;//左边按钮的title
@property (nonatomic, copy) NSString *pubTitle;//右边按钮的title

@end
@interface JGJAccountListModel : CommonModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *account_name;//账户名
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, copy) NSString *is_active;
@property (nonatomic, copy) NSString *amount;//可提现金额
@property (nonatomic, copy) NSString *telephone;//绑定电话号码
@end
@interface JGJCloudPriceModel : CommonModel
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *is_active;
@property (nonatomic, copy) NSString *is_sale;
@property (nonatomic, copy) NSString *msg_src;
@property (nonatomic, copy) NSString *percents;
@property (nonatomic, copy) NSString *person;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *server_id;
@property (nonatomic, copy) NSString *server_name;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *total_amount;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *units;
@property (nonatomic, copy) NSString *year;
@end

@interface JGJWeiXinuserInfo : CommonModel
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *unionid;

@end
@interface JGJweiXinPaymodel : CommonModel
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *appid;

@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, assign) UInt32 timestamp;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *order_sn;//订单号


@end
@interface JGJLogUserInfoModel : CommonModel
@property (nonatomic, copy) NSString *head_pic;//订单号
@property (nonatomic, copy) NSString *real_name;//订单号
@property (nonatomic, copy) NSString *telephone;//订单号
@property (nonatomic, copy) NSString *uid;//订单号

@end
@interface JGJProductinfoModel : CommonModel
@property (nonatomic, copy) NSString *discount_amount;//订单号
@property (nonatomic, copy) NSString *msg_src;//订单号
@property (nonatomic, copy) NSString *price;//订单号
@property (nonatomic, copy) NSString *server_id;//订单号
@property (nonatomic, copy) NSString *server_name;//订单号
@property (nonatomic, copy) NSString *total_amount;//订单号
@property (nonatomic, copy) NSString *units;//订单号

@end
@class JGJCreateCheckDetailModel;
@interface JGJCreateCheckModel : CommonModel
@property (nonatomic, copy) NSString *content_name;//检查内容的标题
@property (nonatomic, copy) NSString *class_type;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *is_operate;
@property (nonatomic, copy) NSString *oper_uid;

@property (nonatomic, strong) NSMutableArray <JGJCreateCheckDetailModel *>*dot_list;//黄见得检查点的数组

@end

@interface JGJCreateCheckDetailModel : CommonModel
@property (nonatomic, copy) NSString *dot_name;//检查内容
@property (nonatomic, copy) NSString *dot_id;//检查id

@end
@class JGJCheckItemListDetailModel;
@interface JGJCheckItemMainListModel : CommonModel

@property (nonatomic, copy) NSString *type;//检查类型 ocntent为检查内容

@property (nonatomic, strong) NSMutableArray <JGJCheckItemListDetailModel *>*list;//检查id


@end

@interface JGJCheckItemListDetailModel : CommonModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *content_id;

@property (nonatomic, copy) NSString *is_operate;



@end

//检查内容详情 也用于获取添加检查点检查内容列表
@class JGJCheckItemListDetailListModel;

@interface JGJCheckContentDetailModel : CommonModel

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *content_name;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *content_id;


@property (nonatomic, copy) NSString *is_operate;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *is_selected;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *is_sort;

@property (nonatomic, copy) NSString *oper_type;

@property (nonatomic, copy) NSString *oper_uid;

@property (nonatomic, strong) NSMutableArray <JGJCheckItemListDetailListModel *>*dot_list;
@end
@interface JGJCheckItemListDetailListModel : CommonModel

@property (nonatomic, copy) NSString *dot_id;

@property (nonatomic, copy) NSString *dot_name;

@property (nonatomic, copy) NSString *is_sort;

@property (nonatomic, copy) NSString *content_id;

@end
//检查项详情和修改和发布模型
@class JGJCheckItemPubDetailListModel;
@interface JGJCheckItemPubDetailModel : CommonModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *content_id;

@property (nonatomic, copy) NSString *pro_name;//检查项名称

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *oper_uid;

@property (nonatomic, copy) NSString *pro_id;

@property (nonatomic, copy) NSString *oper_type;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *location_text;

@property (nonatomic, copy) NSString *is_operate;//是否可以操作


@property (nonatomic, strong) NSMutableArray <JGJCheckItemPubDetailListModel *>*content_list;

@end

@interface JGJCheckItemPubDetailListModel : CommonModel

@property (nonatomic, copy) NSString *content_id;

@property (nonatomic, copy) NSString *content_name;

@property (nonatomic, assign) BOOL openO;

@property (nonatomic, strong) NSMutableArray <JGJCheckItemListDetailListModel *>*dot_list;

@end

//添加检查项
@class JGJCheckContentListModel;
@class JGJSynBillingModel;
@interface JGJAddCheckItemModel : CommonModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, strong) NSMutableArray <JGJCheckContentListModel *>*pro_list;

@property (nonatomic, strong) NSMutableArray <JGJSynBillingModel *>*member_list;

@property (nonatomic, copy) NSString *plan_name;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSString *execute_time;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *oper_type;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *pass_percent;

@property (nonatomic, copy) NSString *execute_percent;

@property (nonatomic, copy) NSString *is_operate;

@end

@interface JGJCheckContentListModel : CommonModel

@property (nonatomic, copy) NSString *pro_id;

@property (nonatomic, copy) NSString *pro_name;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, copy) NSString *update_time;

@property (nonatomic, copy) NSString *telephone;

@property (nonatomic, assign) NSInteger is_active;

@end

@interface JGJAllNoticeModel : CommonModel

@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, copy) NSString *reply_text;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSString *msg_text;

@property (nonatomic, copy) NSString *is_at;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, strong) UserInfo *user_info;

@property (nonatomic, strong) NSArray *reply_msg;

@property (nonatomic, strong) NSArray *msg_src;

@property (nonatomic, copy) NSString *reply_type;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *pub_name;

@property (nonatomic, assign) BOOL is_readed; //是否已读

@property (nonatomic, assign) BOOL is_checked; //已查看标识

@property (nonatomic, assign) BOOL is_delete; //消息已删除标识
@end


@interface JGJAppBuyCombo : CommonModel
@property (nonatomic, copy) NSString *pay_type;//支付类型
@property (nonatomic, copy) NSString *record_id;//支付id

@end
