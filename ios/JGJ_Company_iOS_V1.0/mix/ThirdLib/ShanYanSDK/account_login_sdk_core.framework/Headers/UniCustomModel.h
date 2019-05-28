//
//  UniCustomModel.h
//  account_login_sdk_core
//
//  Created by zhuof on 2019/1/18.
//  Copyright © 2019年 xiaowo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UniCustomModel : NSObject
/*----------------------------------------授权页面-----------------------------------*/

//MARK:Background*************

/**导航栏颜色*/
@property (nonatomic,strong) UIColor *backgroundColor;

//MARK:导航栏*************

/**导航栏颜色*/
@property (nonatomic,strong) UIColor *navColor;
/**导航栏标题*/
@property (nonatomic,strong) NSAttributedString *navText;
/**导航返回图标*/
@property (nonatomic,strong) UIImage *navReturnImg;
/**导航栏右侧自定义控件*/
@property (nonatomic,strong) UIBarButtonItem *navControl;
/**状态栏着色样式*/
@property (nonatomic,assign) UIStatusBarStyle barStyle;
/**隐藏导航栏线条*/
@property (nonatomic,assign) BOOL navLineHidden;

//MARK:图片设置************

/**LOGO图片*/
@property (nonatomic,strong) UIImage *logoImg;
/**LOGO图片宽度*/
@property (nonatomic,assign) CGFloat logoWidth;
/**LOGO图片高度*/
@property (nonatomic,assign) CGFloat logoHeight;
/**LOGO图片偏移量*/
@property (nonatomic,assign) CGFloat logoOffsetY;

//MARK:登录按钮设置************

/**登录按钮文本*/
@property (nonatomic,strong) NSString *logBtnText;
/**登录按钮Y偏移量*/
@property (nonatomic,assign) CGFloat logBtnOffsetY;
/**登录按钮文本颜色*/
@property (nonatomic,strong) UIColor *logBtnTextColor;
/**登录按钮背景颜色*/
@property (nonatomic,strong) UIColor *logBtnColor;
/**登录按钮背景图片*/
@property (nonatomic,strong) UIImage *logBtnImg;
/**登录按钮圆角*/
@property (nonatomic,assign) CGFloat logBtnRadius;
/**登录按钮字体*/
@property (nonatomic,strong) UIFont *logBtnTextFont;

//MARK:号码框设置************

/**手机号码字体颜色*/
@property (nonatomic,strong) UIColor *numberColor;
/**手机号码Y偏移量*/
@property (nonatomic,assign) CGFloat numberOffsetY;
/**手机号码字体*/
@property (nonatomic,strong) UIFont *numberFont;

//MARK:appName设置************

/**隐藏应用名*/
@property (nonatomic,assign) BOOL appNameHidden;
/**应用名字体颜色*/
@property (nonatomic,strong) UIColor *appNameTextColor;
/**应用名字体*/
@property (nonatomic,strong) UIFont *appNameFont;
/**应用名Y偏移量*/
@property (nonatomic,assign) CGFloat appNameOffsetY;

//MARK:其他登录方式设置************

/**隐藏其他登录方式按钮*/
@property (nonatomic,assign) BOOL swithAccHidden;
/**其他登录方式字体颜色*/
@property (nonatomic,strong) UIColor *swithAccTextColor;
/**其他登录方式Y偏移量*/
@property (nonatomic,assign) CGFloat swithAccOffsetY;
/**其他登录方式X偏移量*/
@property (nonatomic,assign) CGFloat swithAccOffsetX;
/**其他登录方式字体*/
@property (nonatomic,strong) UIFont *swithAccFont;

//MARK:隐私条款设置************

///**复选框选中时图片*/
//@property (nonatomic,strong) UIImage *checkedImg;
/**隐私条款名称颜色（含书名号）*/
@property (nonatomic,strong) UIColor *privacyTextColor;
/**隐私条款Y偏移量*/
@property (nonatomic,assign) CGFloat privacyOffsetY;
/**开发者隐私条款名称颜色（含书名号）*/
@property (nonatomic,strong) UIColor *appPrivacyColor;
/**开发者隐私条款名称（含书名号）*/
@property (nonatomic,strong) NSString *appPrivacyText;
/**开发者隐私条款url*/
@property (nonatomic,strong) NSString *appPrivacyUrl;
/**隐私条款底部文本*/
@property (nonatomic,strong) NSString *privacyButtomText;

//MARK:slogan设置************

/**认证服务品牌文字颜色*/
@property (nonatomic,strong) UIColor *sloganTextColor;
/**认证服务品牌Y偏移量*/
@property (nonatomic,assign) CGFloat sloganOffsetY;


//MARK:loading设置************

/**loading背景色*/
@property (nonatomic,strong) UIColor *loadingBgColor;
/**loading背景圆角*/
@property (nonatomic,assign) CGFloat loadingBgRadius;
/**loading背景宽度*/
@property (nonatomic,assign) CGFloat loadingBgWidth;
/**loading背景高度*/
@property (nonatomic,assign) CGFloat loadingBgHeight;
/**loading提示文字*/
@property (nonatomic,strong) NSString *loadingText;
/**loading提示文字颜色*/
@property (nonatomic,strong) UIColor *loadingTextColor;
/**loading提示文字字体*/
@property (nonatomic,strong) UIFont *loadingTextFont;
/**loading提示文字高度*/
@property (nonatomic,assign) CGFloat loadingTextHeight;
/**loading动画帧*/
@property (nonatomic,strong) NSArray *loadingRes;
/**loading动画耗时*/
@property (nonatomic,assign) CGFloat loadingResDuration;
/**loading动画帧宽度*/
@property (nonatomic,assign) CGFloat loadingResWidth;
/**loading动画帧高度*/
@property (nonatomic,assign) CGFloat loadingResHeight;

@end
