//
//  JGJWeiXin_pay.m
//  JGJCompany
//
//  Created by Tony on 2017/7/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWeiXin_pay.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <CommonCrypto/CommonDigest.h>
#import "JGJTime.h"
#import "NSString+Extend.h"
#define WeixinApi @"https://api.mch.weixin.qq.com/pay/unifiedorder"

@implementation JGJWeiXin_pay

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static JGJWeiXin_pay *instance;
    dispatch_once(&onceToken, ^{
        instance = [[JGJWeiXin_pay alloc] init];
    });
    return instance;
}
-(instancetype)init
{
    if (self = [super init]) {
    
    }
    return self;
}
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        //登录
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if ( [NSString isEmpty:authResp.code ]) {
            [TYShowMessage showError:@"获取用户权限出错"];
            return;
        }
        [self getWeiXinOpenIdWithAuthResp:authResp];
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
//            SendAuthResp *authResp = (SendAuthResp *)resp;
//            [_delegate managerDidRecvAuthResponse:authResp];
//        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
                _orderListmodel.paySucees = YES;
               self.paysuccess(_orderListmodel);

//                [TYShowMessage showSuccess:@"支付成功"];
//                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                [dic setObject:_payId?:@"" forKey:@"payId"];
//                [TYNotificationCenter postNotificationName:JGJWeixinPayNitification object:_payId];
                
                break;
                
            default:
                _orderListmodel.paySucees = NO;
                self.paysuccess(_orderListmodel);
//                [TYShowMessage showError:@"支付失败"];
                               break;
        }

    }
    
}


- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } /*else if ([req isKindOfClass:[TYShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            TYShowMessageFromWXReq *showMessageReq = (TYShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    }*/else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}



+ (void)startWeixinPay
{
    [JGJWeiXin_pay creatWeiXinPayOrderForGoods];
}
//发起支付请求
+ (void)sendPayRepWitParamDic:(NSMutableDictionary *)paramDic
{
    if(paramDic != nil){
        NSMutableString *retcode = [paramDic objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [paramDic objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [paramDic objectForKey:@"partnerid"];
            req.prepayId            = [paramDic objectForKey:@"prepayid"];
            req.nonceStr            = [paramDic objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [paramDic objectForKey:@"package"];
            req.sign                = [paramDic objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[paramDic objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
            [TYShowMessage showError:@"生成订单失败"];
        }
    }
}
+ (void)creatWeiXinPayOrderForGoods
{
    
    NSDictionary *paramDic = @{@"appid":@"wx4aef8d4d0753d388",//应用id 是
                               @"mch_id":@"1230000109",//商户号是
                               @"device_info":@"WEB",//设备号 否
                               @"nonce_str":[JGJWeiXin_pay creatMD5WithParmDic:nil andkey:@""],//随机字符串 是
                               @"sign":[JGJWeiXin_pay creatMD5WithParmDic:nil andkey:@""],//签名 是
                               @"sign_type":@"MD5",//签名类型 否
                               @"body":@"吉工宝-产品购买",//商品描述商品描述交易字段格式根据不同的应用场景按照以下格式：
                               //APP——需传入应用市场上的APP名字-实际商品名称，天天爱消除-游戏充值。 是
                               @"detail":@"吉工宝高级版项目",//商品详情 否
                               @"attach":@"吉工宝产品购买",//附加数据 否 附加数据，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
                               @"out_trade_no":[JGJWeiXin_pay creatOrderNum],//用户订单号 是
                               @"fee_type":@"CNY",//货币类型 否
                               @"total_fee":@"1",//总金额 是
                               @"spbill_create_ip":@"",//终端ip 是
                               @"time_start":@"",//交易起始时间 否
                               @"time_expire":@"",//交易结束时间 否
                               @"goods_tag":@"",//订单优惠标记 否
                               @"notify_url":@"http://www.weixin.qq.com/wxpay/pay.php",//通知地址 是
                               @"trade_type":@"APP",//交易类型 是
                               @"limit_pay":@"",//指定支付方式 否
                               @"scene_info":@"",//场景信息 否

                               };
    [JLGHttpRequest_AFN PostWithOtherApi:WeixinApi parameters:paramDic success:^(id responseObject) {
    [JGJWeiXin_pay sendPayRepWitParamDic:responseObject];
 
    } failure:^(NSError *error) {
    [TYShowMessage showError:@"发起支付失败"];
 
    }];
//[JLGHttpRequest_AFN PostWithApi:WeixinApi parameters:paramDic success:^(id responseObject) {
//    
//    [JGJWeiXin_pay sendPayRepWitParamDic:responseObject];
//} failure:^(NSError *error) {
//    
//    [TYShowMessage showError:@"发起支付失败"];
//}];

}
//随机字符串
+(NSString *)creatMD5WithParmDic:(NSMutableDictionary *)paramDic andkey:(NSString *)keyStr
{
//    key为商户平台设置的密钥key
    NSString *appidStr = [[@"appid=" stringByAppendingString:@"wx4aef8d4d0753d388"] stringByAppendingString:@"&"];
    NSString *mch_idStr = [[@"mch_id=" stringByAppendingString:@"d"] stringByAppendingString:@"&"];
    NSString *device_infoStr = [[@"device_info=" stringByAppendingString:@"WEB"] stringByAppendingString:@"&"];
    NSString *bodyStr = [[@"body=" stringByAppendingString:@"test"] stringByAppendingString:@"&"];
    NSString *nonce_strStr = [[@"nonce_str=" stringByAppendingString:@"ibuaiVcKdpRxkhJA"] stringByAppendingString:@"&"];
    NSString *NkeyStr =  [@"key=" stringByAppendingString:keyStr];

    NSString *Md5String = [[[[appidStr stringByAppendingString:mch_idStr] stringByAppendingString:device_infoStr] stringByAppendingString:bodyStr] stringByAppendingString:nonce_strStr];
    //拼接密钥
    NSString *stringSignTemp = [Md5String stringByAppendingString:NkeyStr];
    const char *cStr = [stringSignTemp UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    NSString *upStr = [output uppercaseString];

return upStr;
}
//生成订单号
+(NSString *)creatOrderNum
{
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    
    
return [[JGJTime yearAppendMonthanddayfromstamp:[NSDate date]] stringByAppendingString:timeStamp];
}
//生成签名
+(NSString *)creatOrderSign
{
    
    return @"";
}
+(void)sendWxinPay
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init  ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];

}


- (NSString *)bundleSeedID{
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:                                kSecClassGenericPassword,
                           kSecClass,
                           @"bundleSeedID",
                           kSecAttrAccount,
                           @"",
                           kSecAttrService,
                           (id)kCFBooleanTrue,
                           kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query,
                                          (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((CFDictionaryRef)query,
                            (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:kSecAttrAccessGroup];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}
+(void)GETNetPayidforAliPayorWeixinPay:(JGJOrderListModel *)model andpayBlock:(paySuccess)payState
{
//    JGJWeiXin_pay * weiXin_pay = [[JGJWeiXin_pay alloc]init];
    JGJWeiXin_pay * weiXin_pay = [JGJWeiXin_pay sharedManager];

    weiXin_pay.paysuccess = payState;
    if ([NSString isEmpty:model.group_id]) {
        [TYShowMessage showError:@"请选择服务项目"];
        return;
    }
    
    if ([NSString isEmpty:model.pay_type]) {
        if (![WXApi isWXAppInstalled]) {
            model.pay_type = @"2";
        }else{
            model.pay_type = @"1";
        }
    }
    [TYLoadingHub showLoadingWithMessage:nil];
    NSDictionary *paramDic = @{
                               @"group_id":model.group_id,
                               @"class_type":model.class_type,
                               @"server_id":model.server_id?:@"",
                               @"time":model.isPayDay?[NSString stringWithFormat:@"%@",model.add_serverTime]:[NSString stringWithFormat:@"%.0f",[model.add_serverTime floatValue]/0.5*180],
                               @"pay_type":model.pay_type?:@"1",
                               @"server_person":model.add_people?:@"",
                               @"person":model.buyer_person?:@"0",
                               @"server_cloud":model.add_cloudplace?:@"0",
                               @"second_server_id":model.add_cloudplace?model.second_server_id?:@"":@"",//高级版购买云盘时才传
                               @"order_id":model.order_id?:@"0",

                               };
    [JLGHttpRequest_AFN PostWithApi:@"v2/order/payOrder" parameters:paramDic success:^(id responseObject) {
        NSString * string = [NSString stringWithFormat:@"%@", responseObject[@"record_id"]];
        string=[string stringByReplacingOccurrencesOfString:@";"withString:@"&"];
        
        if (string) {
            if ([string isEqualToString:@"1"]) {
                model.DontPay = YES;
                model.paySucees = YES;
                model.trade_no = responseObject[@"order_sn"];
                weiXin_pay.paysuccess(model);
            }else{
            if ([model.pay_type isEqualToString:@"2"]) {
                //支付宝支付
            [weiXin_pay doAlipayPaypayCode:string andmodel:model];
            }else{
                NSError *error;
                NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];

                NSDictionary *weixinParam = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:&error];
                JGJweiXinPaymodel *payModel;
               payModel = [JGJweiXinPaymodel mj_objectWithKeyValues:weixinParam];
                //微信支付
             
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = payModel.partnerid;//商户id
                req.prepayId            = payModel.prepayid;//订单号
                req.nonceStr            = payModel.noncestr;//随机字符串
                req.timeStamp           = payModel.timestamp;//时间戳
                req.package             = payModel.package;
                req.sign                = payModel.sign;
                weiXin_pay.payId        = payModel.prepayid;
                
                //保存订单号
                model.trade_no          = payModel.order_sn;
                if (!weiXin_pay.orderListmodel) {
                    weiXin_pay.orderListmodel = [[JGJOrderListModel alloc]init];
                }
                weiXin_pay.orderListmodel = model;
                [WXApi sendReq:req];
            }
            }
        }else{
        [TYShowMessage showError:@"生成商品订单失败"];
        }
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYShowMessage showError:@"订单信息错误"];
        [TYLoadingHub hideLoadingView];

    }];

}

- (void)doAlipayPaypayCode:(NSString *)paycode andmodel:(JGJOrderListModel *)model
{
    NSString *appScheme = @"Alipaycom";
    [[AlipaySDK defaultService] payOrder:paycode fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            model.paySucees = YES;
//            [TYShowMessage showSuccess:@"支付成功"];
            NSData *JSONData = [resultDic[@"result"]  dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            model.trade_no = responseJSON[@"alipay_trade_app_pay_response"][@"out_trade_no"];
            self.paysuccess(model);

        }else{
            model.paySucees = NO;
            self.paysuccess(model);
//            [TYShowMessage showSuccess:[@"错误码 " stringByAppendingString: resultDic[@"resultStatus"] ]];
        }
        NSLog(@"reslut = %@",resultDic);
        
    }];
}
+(void)GETNetPayidforweixinPay:(JGJOrderListModel *)model
{


}
#pragma mark - 获取opendid
- (void)getWeiXinOpenIdWithAuthResp:(SendAuthResp *)authResp{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx4aef8d4d0753d388",@"3e95a59794617e76242a2bbc57cff1e9",authResp.code];
//    9838e530da645c7fd4c435778160d32f
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *openID = dic[@"openid"];
                NSString *unionid = dic[@"unionid"];
                NSString *accesToken = dic[@"access_token"];
                
                //第三方授权登录
                if ([authResp.state isEqualToString:AuthorLogin]) {
                    
                    JGJWeiXinuserInfo *wxUserInfo = [JGJWeiXinuserInfo mj_objectWithKeyValues:dic];
                    
                    if (self.wxAuthorSuccessBlock) {
                        
                        self.wxAuthorSuccessBlock(wxUserInfo);
                    }
                    
                }else {
                    
                    
                    [self getUserInfoWithOpenid:openID andAccess_token:accesToken];
                }
                
            }
        });
    });
}

-(void)getUserInfoWithOpenid:(NSString *)pendID andAccess_token:(NSString *)accesToken
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accesToken,pendID];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if (dic) {
                    
                    _WeixinUserInfo = [JGJWeiXinuserInfo mj_objectWithKeyValues:dic];
                    
                    [self addWeixinAccountand:_WeixinUserInfo];
                    
                }
            }
        });
    });
}

-(void)addWeixinAccountand:(JGJWeiXinuserInfo *)userInfo
{
    __weak typeof(self) weakself = self;
    NSDictionary *paramDic = @{
                               @"pay_type":@"1",
                               @"account_name": userInfo.nickname?:@"",
                               @"open_id":userInfo.openid?:@""
                               };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/partner/addPartnerWithdrawTele" parameters:paramDic success:^(id responseObject) {
      JGJAccountListModel *AccountListModel = [JGJAccountListModel mj_objectWithKeyValues:responseObject];

        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(weiXinAddAcountSuccessAndpopVCAndModel:)]) {
            [weakself.delegate weiXinAddAcountSuccessAndpopVCAndModel:AccountListModel];
        }
        
        [TYShowMessage showSuccess:@"绑定成功"];
        
        
    }failure:^(NSError *error) {
        
    }];

}
+ (void)doPayDesCashAndModel:(JGJOrderListModel *)model andpayBlock:(paySuccess)payState
{
    JGJWeiXin_pay * weiXin_pay = [JGJWeiXin_pay sharedManager];
    
    weiXin_pay.paysuccess = payState;

    
    if ([NSString isEmpty:model.pay_type]) {
        if (![WXApi isWXAppInstalled]) {
            model.pay_type = @"2";
        }else{
            model.pay_type = @"1";
        }
    }
    [TYLoadingHub showLoadingWithMessage:nil];
    NSDictionary *paramDic = @{

                               @"pay_type":model.pay_type?:@"1",

                               };
    [JLGHttpRequest_AFN PostWithApi:@"v2/pay/payDeposit" parameters:paramDic success:^(id responseObject) {
        NSString * string = [NSString stringWithFormat:@"%@", responseObject[@"record_id"]];
        string=[string stringByReplacingOccurrencesOfString:@";"withString:@"&"];
        
        if (string) {
            if ([model.pay_type isEqualToString:@"2"]) {
                //支付宝支付
                [weiXin_pay doAlipayPaypayCode:string andmodel:model];
                
            }else{
                NSError *error;
                NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *weixinParam = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:&error];
                JGJweiXinPaymodel *payModel;
                payModel = [JGJweiXinPaymodel mj_objectWithKeyValues:weixinParam];
                //微信支付
                
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = payModel.partnerid;//商户id
                req.prepayId            = payModel.prepayid;//订单号
                req.nonceStr            = payModel.noncestr;//随机字符串
                req.timeStamp           = payModel.timestamp;//时间戳
                req.package             = payModel.package;
                req.sign                = payModel.sign;
                weiXin_pay.payId        = payModel.prepayid;
                
                //保存订单号
                model.order_sn          = payModel.order_sn;
                if (!weiXin_pay.orderListmodel) {
                    weiXin_pay.orderListmodel = [[JGJOrderListModel alloc]init];
                }
                weiXin_pay.orderListmodel = model;
                [WXApi sendReq:req];
            }
        }else{
            [TYShowMessage showError:@"生成商品订单失败"];
        }
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYShowMessage showError:@"服务器错误"];
        [TYLoadingHub hideLoadingView];
        
    }];



}
+(void)getCash:(JGJOrderListModel *)model
{
    if ([NSString isEmpty:model.pay_type]) {
        if (![WXApi isWXAppInstalled]) {
            model.pay_type = @"2";
        }else{
            model.pay_type = @"1";
        }
    }
    NSDictionary *paramDic = @{
                               @"id":model.id?:@"",//退保证金订单id
                               @"telephone":model.telephone,
                               @"total_amount":model.total_amount,
                               @"vcode":model.vcode,
                               @"pay_type":model.pay_type?:@"1",

                               };
    [JLGHttpRequest_AFN PostWithApi:@"v2/pay/getMoneyFromBalance" parameters:paramDic success:^(id responseObject) {
        [TYShowMessage showSuccess:@"提现成功!"];
    }failure:^(NSError *error) {
        [TYShowMessage showError:@"服务器错误"];
    }];


}
@end
