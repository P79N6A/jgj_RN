//
//  JGJNotifyJoinExistProVC.h
//  JGJCompany
//
//  Created by YJ on 16/11/9.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJNotifyJoinExistProVCBlock)(id);

@interface JGJNotifyJoinExistProVC : UIViewController

@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;

@property (nonatomic, copy) JGJNotifyJoinExistProVCBlock notifyJoinExistProSuccessBlock;

@end
