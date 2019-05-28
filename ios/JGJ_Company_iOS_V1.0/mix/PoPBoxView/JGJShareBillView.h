//
//  JGJShareBillView.h
//  mix
//
//  Created by Tony on 16/6/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJShareBillView;
@protocol JGJShareBillViewDelegate <NSObject>

- (void )ShareBillDownLoadBtnClick:(JGJShareBillView *)jgjShareBillView;

@optional
- (void )ShareBillQQBtnClick:(JGJShareBillView *)jgjShareBillView snsName:(NSString *)snsName;

- (void )ShareBillWxBtnClick:(JGJShareBillView *)jgjShareBillView snsName:(NSString *)snsName;

@end

@interface JGJShareBillView : UIView
@property (nonatomic , weak)    id<JGJShareBillViewDelegate> delegate;
@property (nonatomic , weak)    UIViewController *Vc;
@property (nonatomic , copy)    NSString *shareText;
@property (nonatomic , copy)    NSString *shareImageUrl;
@property (nonatomic , copy)    NSString *sharelinkUrl;

- (void)showShareBillView;

- (void)hiddenShareBillView;


/**
 *  调用分享接口
 *
 *  @param Vc         需要在哪个Vc里面分享
 *  @param linkUrl    连接的url
 *  @param snsName    分享的平台名
 *  @param text  分享的文子
 *  @param imageUrl 分享的图片
 */
- (void)shareInVc:(UIViewController *)Vc linkUrl:(NSString *)linkUrl snsName:(NSString *)snsName text:(NSString *)text imageUrl:(NSString *)imageUrl ;

@end
