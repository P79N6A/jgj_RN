//
//  JGJDredgeWeChatServiceViewController.h
//  mix
//
//  Created by Tony on 2018/9/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJDredgeWeChatSuccessView.h"
@interface JGJDredgeWeChatServiceViewController : UIViewController
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong,readonly) JGJDredgeWeChatSuccessView *dredgeWeChatSuccess;
@property (nonatomic, assign) BOOL isWebViewComeIn;// 是否是H5 页面跳转过来
@end
