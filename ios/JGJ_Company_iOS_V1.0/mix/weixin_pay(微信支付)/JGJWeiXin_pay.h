//
//  JGJWeiXin_pay.h
//  JGJCompany
//
//  Created by Tony on 2017/7/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"

typedef void(^WXAuthorSuccessBlock)(JGJWeiXinuserInfo *wxUserInfo);

typedef void(^paySuccess)(JGJOrderListModel *orderListModel);
@protocol WXApiManagerDelegate <NSObject>

@optional
- (void)weiXinpaySuccesAndpresent;

- (void)weiXinAddAcountSuccessAndpopVCAndModel:(JGJAccountListModel *)accountModel;

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

//- (void)managerDidRecvShowMessageReq:(TYShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

@end
@interface JGJWeiXin_pay : NSObject<WXApiDelegate>
@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;
@property (nonatomic, copy) paySuccess paysuccess;
@property (nonatomic, strong) JGJWeiXinuserInfo *WeixinUserInfo;
@property (nonatomic, strong) JGJweiXinPaymodel *weixinpayModels;
@property (nonatomic, strong) JGJOrderListModel *orderListmodel;

@property (nonatomic, strong) NSString *payId;

//微信授权成功返回
@property (nonatomic, copy)   WXAuthorSuccessBlock wxAuthorSuccessBlock;

+ (instancetype)sharedManager;

+ (void)startWeixinPay;
/*
*生成预付订单
*/
+ (void)creatWeiXinPayOrderForGoods;
/*
*随机数生成
*/
+(NSString *)creatMD5WithParmDic:(NSMutableDictionary *)paramDic andkey:(NSString *)keyStr;

//发起支付
+ (void)sendPayRepWitParamDic:(NSMutableDictionary *)paramDic;
/*
 *生成订单号
 */
+(NSString *)creatOrderNum;
/*
 *生成签名
 */
+(NSString *)creatOrderSign;
/*
 *绑定微信 获取openid
 */
+(void)sendWxinPay;
/*
 *微信支付和阿里云支付
 */
+(void)GETNetPayidforAliPayorWeixinPay:(JGJOrderListModel *)model andpayBlock:(paySuccess)payState;

/*
 *支付宝支付
 */
+(void)GETNetPayidforAliPay:(JGJOrderListModel *)model;
/*
 * 掉期支付接口
 */
- (void)doAlipayPaypayCode:(NSString *)paycode andmodel:(JGJOrderListModel *)model ;
/*
 * 支付保证金
 */
+ (void)doPayDesCashAndModel:(JGJOrderListModel *)model andpayBlock:(paySuccess)payState;
/*
 * 支付保证金
 */
+(void)getCash:(JGJOrderListModel *)model;

@end
