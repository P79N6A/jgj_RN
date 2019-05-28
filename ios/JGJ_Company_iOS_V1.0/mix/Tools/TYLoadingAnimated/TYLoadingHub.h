//
//  TYLoadingHub.h
//  mix
//
//  Created by Tony on 16/1/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLoadingHub : UIView
+ (id)showLoadingWithMessage:(id )message;

+ (id)showLoadingNoDataDefultWithMessage:(id )message;

+ (id)showLoadingWithMessage:(id )message lineNum:(NSInteger )lineNum;

+ (id)showLoadingViewTo:(UIView *)view message:(id )message;

+ (id)showLoadingViewTo:(UIView *)view message:(id )message frame:(CGRect )frame;

+ (void)hideLoadingView;

+ (void)hideLoadingView:(UIView *)view;

@property (nonatomic,assign) BOOL defultAnimation;

@end
