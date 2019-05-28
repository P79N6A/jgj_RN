//
//  JGJAlipay.m
//  JGJCompany
//
//  Created by Tony on 2017/7/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAlipay.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation JGJAlipay
//#pragma mark - 支付宝支付
-(id)initAlipayCodePayCode:(alipayPayCode)payCode
{
    if (self = [super init]) {
        self.alipayPayCode = payCode;
        [self getAlipayCode];
    }
    return self;
}
-(void)getAlipayCode
{
    NSDictionary *paramDic = @{
                               @"group_id":@"60",
                               @"class_type":@"team",
                               @"server_id":@"1",
                               @"token":@"81fe151bf02febddb61d9ee1f254e495",
                               @"server_id":@"1",
                               @"pro_id":@"147",
                               @"time":@"1",
                               @"cloud_space":@"20",
                               @"total_amount":@"0.01",
                               @"pay_type":@"2",
                               };
    
[JLGHttpRequest_AFN PostWithApi:@"v2/order/payOrder" parameters:paramDic success:^(id responseObject) {
//  [self doAlipayPaypayCode:responseObject[@"record_id"]];
    NSString * string = responseObject[@"record_id"];
    string=[string stringByReplacingOccurrencesOfString:@";"withString:@"&"];
//    [self doAlipayPaypayCode:string];

    self.alipayPayCode(string);
    
}failure:^(NSError *error) {
    self.alipayPayCode(@"alipay_sdk=alipay-sdk-php-20161101&app_id=2016082000291890&biz_content=%7B%22out_trade_no%22%3A%22201708221892000%22%2C%22total_amount%22%3A0.01%2C%22subject%22%3A%22%5Cu9ec4%5Cu91d1%5Cu670d%5Cu52a1%5Cu7248%22%2C%22product_code%22%3A%22FAST_INSTANT_TRADE_PAY%22%2C%22body%22%3A%22%5Cu54c8%5Cu54c8%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fapi.ex.yzgong.com%2Fv2%2Forder%2FcallbackPay&sign_type=RSA2&timestamp=2017-08-02+15%3A07%3A38&version=1.0&sign=EQUP%2BRhhz0MRYUB0nJiP2pX7L%2F2d%2BY0dViwMnLGuIkLnUPf7x3BFIx8ccH53Amh09nOIppp8XhNIHxAEf4Bcyd2FdctloFSkUsRGxhN43ZiR07224Zu6qt0xEuXl1%2F73BC86w4j6vm7CeQpmomecPbA1XMfwk0ahAbBNn5XhpNcyj%2Bwlvv7EW9hYiBSJ03ReElbTdb6AdH0IKTo%2BiS3iuxBmFJr1jayDWT%2FdJAetto%2Fz6FL2fbDd9FAtNZl9mi46aPvMc376zyW1zknpSPBjElL3y7DvvdYco26zf%2BAD8CPxLuJneMe%2B%2BQ3gueEuqY9GclS34R8ljG4C2hLCXsRjOA%3D%3D");

}];

}

- (void)doAlipayPaypayCode:(NSString *)paycode
{
    NSString *appScheme = @"Alipay";
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:paycode fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        
    }];
}
@end
