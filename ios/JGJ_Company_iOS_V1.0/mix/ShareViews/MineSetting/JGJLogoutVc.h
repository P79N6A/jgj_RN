//
//  JGJLogoutVc.h
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJLogoutStatusModel : NSObject

@property (nonatomic, copy) NSString *status; //"status": "1", //0没有任何住下操作，1，注销提交，2，注销成功，3住下被拒

@property (nonatomic, copy) NSString *comment;

@end

@interface JGJLogoutVc : UIViewController

@end
