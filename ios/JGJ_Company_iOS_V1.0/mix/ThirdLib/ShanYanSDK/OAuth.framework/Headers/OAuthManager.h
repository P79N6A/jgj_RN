
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ResultListener.h"
#import <account_login_sdk_core/UniCustomModel.h>


@interface OAuthManager : NSObject


+ (instancetype)getInstance:(NSString*) apiKey pubKey:(NSString*)pubKey;

//免密登录初始化
-(void) registerApp;

//预取号
-(void) getAccessToken:(double) timeout listener:(resultListener)listener;

//免密登录
-(void) login :(UIViewController*)uiController listener:(resultListener) listener timeout:(double)timeout;

//获取用户信息
-(void) user:(NSString *) accessToken listener:(resultListener) listener;

//修改UI
-(void)customUIWithParams:(UniCustomModel *)uniCustomModel customViews:(void(^)(NSDictionary *customAreaDict))customViews;
//自定义跳转
-(void)setLoginSuccessPage:(UIViewController *)uiController;

//获取AccessCode
-(void) getAccessCode :(resultListener) listener timeout:(double)timeout;

//认证手机号
-(void) oauth:(NSString*)mobile accessCode:(NSString*)accessCode listener:(resultListener) listener;


/**
 *  是否使用测试环境
 *
 *  @param isDebug true／false
 */
- (void) setDebug:(Boolean) isDebug ;

- (void) isLog:(Boolean) isLog;
@end
