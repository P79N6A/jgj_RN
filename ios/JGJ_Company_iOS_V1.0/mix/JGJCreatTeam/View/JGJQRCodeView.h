//
//  JGJQRCodeView.h
//  mix
//
//  Created by Tony on 2016/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JGJQRCodeViewDefualt = 0,
    JGJQRCodeViewCreate,
    JGJQRCodeViewJoin
} JGJQRCodeViewType;

@interface JGJQRCodeView : UIView

@property (nonatomic,assign) JGJQRCodeViewType codeViewType;
/**
 *  显示的数据模型
 */
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

//获取url
- (void)createQRCodeImageWithUrl:(NSString *)codeUrl;

//设置父vc
- (void)superVc:(UIViewController <UIActionSheetDelegate >*)superVc;

//保存到相册
- (void)saveToAlbum;
@end
