//
//  JGLAppDelegate.h
//  mix
//
//  Created by jizhi on 15/11/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CECardsAnimationController.h"
#import "CEVerticalSwipeInteractionController.h"


#define JLGAppDelegateAccessor ((JLGAppDelegate *)[[UIApplication sharedApplication] delegate])

typedef void(^ThirdAuthorLoginSuccessBlock)(id);

@class CEReversibleAnimationController, CEBaseInteractionController;
@interface JLGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CEReversibleAnimationController *settingsAnimationController;
@property (strong, nonatomic) CEReversibleAnimationController *navigationControllerAnimationController;
@property (strong, nonatomic) CEBaseInteractionController *navigationControllerInteractionController;
@property (strong, nonatomic) CEBaseInteractionController *settingsInteractionController;

//第三方授权登录成功
@property (copy, nonatomic) ThirdAuthorLoginSuccessBlock thirdAuthorLoginSuccessBlock;

//招劳务 是否已经获取了定位权限。只弹一次框。
@property (assign, nonatomic) BOOL isAuthedLocal;

- (void)setRootViewController;

//App进入前后台告诉服务器 0前台，1后台
- (void)appDidisEnterBackground:(NSString *)isEnterBackground responseBlock:(void(^)(id response))responseBlock;

//没打开定位描述
- (void)unOpenLocalTilte:(NSString *)title message:(NSString *)message;

//当前进入后台不请求发送聊天推送
@property (assign, nonatomic) BOOL isUnCanReceiveChatMsg;

@end

