//
//  JGJPayModel.h
//  mix
//
//  Created by yj on 2018/5/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJPayModel : NSObject

@end


///*! @brief 第三方向微信终端发起支付的消息结构体
// *
// *  第三方向微信终端发起支付的消息结构体，微信终端处理后会向第三方返回处理结果
// * @see PayResp
// */
//@interface JGJPayReq : BaseReq
//
///** 商家向财付通申请的商家id */
//@property (nonatomic, retain) NSString *partnerId;
///** 预支付订单 */
//@property (nonatomic, retain) NSString *prepayId;
///** 随机串，防重发 */
//@property (nonatomic, retain) NSString *nonceStr;
///** 时间戳，防重发 */
//@property (nonatomic, assign) UInt32 timeStamp;
///** 商家根据财付通文档填写的数据和签名 */
//@property (nonatomic, retain) NSString *package;
///** 商家根据微信开放平台文档对数据做的签名 */
//@property (nonatomic, retain) NSString *sign;
//
//
//@end
//
//#pragma mark - PayResp
///*! @brief 微信终端返回给第三方的关于支付结果的结构体
// *
// *  微信终端返回给第三方的关于支付结果的结构体
// */
//@interface JGJPayResp : BaseResp
//
///** 财付通返回给商家的信息 */
//@property (nonatomic, retain) NSString *returnKey;
//
//@end


