//
//  JGJCreatProCompanyVC.h
//  JGJCompany
//
//  Created by yj on 16/9/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJWorkingChatMsgViewController.h"
//创建成功回调
typedef void(^CreatProSuccessBlock)(id);
@interface JGJCreatProCompanyVC : UIViewController
@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;
@property (nonatomic, copy) CreatProSuccessBlock creatProSuccess;
@end
