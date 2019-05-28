//
//  HomeVC+ServiceApiRequest.h
//  mix
//
//  Created by yj on 2018/8/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC (ServiceApiRequest)

/*
 *
 *获取发现消息数量,isFindred YES有红点,NO不确定红点调用接口
 */
- (void)getDynamicMsgNum:(BOOL)isFindred;

/*
 *
 *注册通信
 */

- (void)registerNotifyCenter;

/*
*获取服务器时间戳校正
*
*/

- (void)serviceTimestampSuccessBlock:(void (^)(id responseObject))success;
@end
