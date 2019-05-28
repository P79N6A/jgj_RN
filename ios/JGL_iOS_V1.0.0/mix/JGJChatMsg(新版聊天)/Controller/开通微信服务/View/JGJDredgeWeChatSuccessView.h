//
//  JGJDredgeWeChatSuccessView.h
//  mix
//
//  Created by Tony on 2018/12/18.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GotoGetRedPacket)(void);
@interface JGJDredgeWeChatSuccessView : UIView

@property (nonatomic, copy) GotoGetRedPacket getRedPacket;
@property (nonatomic, assign) BOOL isWebViewComeIn;// 是否是H5 页面跳转过来
@end
