//
//  TYQRCodeVc.h
//  Test
//
//  Created by Tony on 2016/8/23.
//  Copyright © 2016年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBXScanViewController.h"

@class TYQRCodeVc;
@protocol TYQRCodeVcDelegate <NSObject>

- (void)QRCodeVc: (TYQRCodeVc *)scanView scanResult:(LBXScanResult*)strResult;

@end

@interface TYQRCodeVc : LBXScanViewController

@property (nonatomic , weak) id<TYQRCodeVcDelegate> delegate;

/**
 *  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;

/**
 *  提示错误
 */
//- (void)showError:(NSString*)str;


//进入下一个界面
//- (void)showNextVCWithScanResult:(LBXScanResult*)strResult;
@end
