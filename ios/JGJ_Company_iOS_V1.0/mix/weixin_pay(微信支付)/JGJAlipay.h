//
//  JGJAlipay.h
//  JGJCompany
//
//  Created by Tony on 2017/7/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^alipayPayCode)(NSString *paramDic);

typedef NS_ENUM(NSInteger ,aliInstallPayType) {
  unInstallAppForUrlPay,
  InstallAppForAppPay
};
@interface JGJAlipay : NSObject
@property (copy, nonatomic) alipayPayCode alipayPayCode;

//支付宝支付
-(id)initAlipayCodePayCode:(alipayPayCode)payCode;

- (void)doAlipayPaypayCode:(NSString *)paycode;

@end
