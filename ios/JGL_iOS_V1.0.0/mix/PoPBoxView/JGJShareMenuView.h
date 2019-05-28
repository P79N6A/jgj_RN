//
//  JGJShareMenuView.h
//  mix
//
//  Created by Json on 2019/4/8.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMShare/UMShare.h>

typedef NS_ENUM(NSUInteger, JGJShareType) {
    JGJShareTypeWXType,//微信好友
    JGJShareTypeWXChatType,//朋友圈
    JGJShareTypeQQType,//QQ好友
    JGJShareTypeQQZoneType,//QQ空间
};

@class JGJShareMenuView;


@protocol JGJShareMenuViewDelegate <NSObject>

@optional

- (void)shareMenuViewWithMenuView:(JGJShareMenuView *)menuView shareMenuModel:(JGJShowShareMenuModel *)shareMenuModel;

@end

@interface JGJShareMenuView : UIView

- (void)showCustomShareMenuViewWithShareMenuModel:(JGJShowShareMenuModel *)ShareMenuModel;

- (void)hiddenCustomShareMenuView;

//分享微信小程序

- (BOOL)sendMiniProgramWithShareMenuModel:(JGJShowShareMenuModel *)shareModel;

@property (nonatomic, strong) JGJShowShareMenuModel *shareMenuModel;

@property (nonatomic , weak)    id <JGJShareMenuViewDelegate> delegate;

@property (nonatomic , weak)    UIViewController *Vc;

@property (nonatomic, assign)  JGJShareType shareMenuViewType;

@property (nonatomic, copy)   void(^shareButtonPressedBlock)(JGJShareType);

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
- (void)shareInVc:(UIViewController *)Vc linkUrl:(NSString *)linkUrl platformType:(UMSocialPlatformType*)platformType  text:(NSString *)text imageUrl:(NSString *)imageUrl;
@end

