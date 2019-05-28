//
//  UniAuthHelper.h
//  account_verify_sdk_core
//
//  Created by zhuof on 2018/3/8.
//  Copyright © 2018年 xiaowo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniResultListener.h"
#import <UIKit/UIKit.h>
#import "UniCustomModel.h"

@interface UniAuthHelper : NSObject

+(UniAuthHelper *) getInstance;

-(void) registerAppId:(NSString *)appId appSecret:(NSString *)AppSecret;

-(void) getAccessCode:(double)timeout listener:(UniResultListener) listener;

-(void) login : (UIViewController*)uiController timeout:(double)timeout listener:(UniResultListener) listener;

-(void)customUIWithParams:(UniCustomModel *)uniCustomModel customViews:(void(^)(NSDictionary *customAreaDict))customViews;


-(void)setLoginSuccessPage:(UIViewController *)uiController;

@end
