//
//  JGJCustomShareMenuView.h
//  mix
//
//  Created by yj on 17/2/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

//分享代码注释
//#import "UMSocial.h"

#import <UMShare/UMShare.h>

typedef enum : NSUInteger {
    //    JGJShareMenuViewDefaultType = 0,
    JGJShareMenuViewJGJFriendlyType, //吉工家好友
    JGJShareMenuViewWorkCircleType, //吉工家工友圈
    JGJShareMenuViewWXType,//朋友圈
    JGJShareMenuViewWXChatType,//微信好友
    JGJShareMenuViewQQType,//QQ好友
    JGJShareMenuViewQQZoneType,//QQ空间
    JGJShareMenuViewFaceToFaceType 
} JGJShareMenuViewType;

//typedef void(^ShareButtonPressedBlock)(JGJShareMenuViewType);

@class JGJCustomShareMenuView;

@protocol JGJCustomShareMenuViewDelegate <NSObject>

@optional

- (void)customShareMenuViewWithMenuView:(JGJCustomShareMenuView *)memuView shareMenuModel:(JGJShowShareMenuModel *)shareMenuModel;

@end

@interface JGJCustomShareMenuView : UIView

- (void)showCustomShareMenuViewWithShareMenuModel:(JGJShowShareMenuModel *)ShareMenuModel;

- (void)hiddenCustomShareMenuView;

//分享微信小程序

- (BOOL)sendMiniProgramWithShareMenuModel:(JGJShowShareMenuModel *)shareModel;

@property (nonatomic, strong) JGJShowShareMenuModel *shareMenuModel;

@property (nonatomic , weak)    id <JGJCustomShareMenuViewDelegate> delegate;

@property (nonatomic , weak)    UIViewController *Vc;

@property (nonatomic, assign)  JGJShareMenuViewType shareMenuViewType;

@property (nonatomic, copy)   void(^shareButtonPressedBlock)(JGJShareMenuViewType);

@property (weak, nonatomic, readonly) IBOutlet UIButton *savePhotoBtn;

@property (weak, nonatomic, readonly) IBOutlet NSLayoutConstraint *savePhotoBtnH;

/**
 *  调用分享接口
 *
 *  @param Vc         需要在哪个Vc里面分享
 *  @param linkUrl    连接的url
 *  @param snsName    分享的平台名
 *  @param text  分享的文子
 *  @param imageUrl 分享的图片
 */
- (void)shareInVc:(UIViewController *)Vc linkUrl:(NSString *)linkUrl platformType:(UMSocialPlatformType)platformType  text:(NSString *)text imageUrl:(NSString *)imageUrl;
@end
