//
//  JGJChatListRecordVc.h
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatListType.h"

typedef void(^skipToNextVc)(UIViewController *nextVc);

@interface JGJChatListRecordVc : UIViewController
/**
 *  需要请求服务器的model
 */
@property (nonatomic,strong) JGJChatRootRequestModel *chatListRequestModel;

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (nonatomic,copy) skipToNextVc skipToNextVc;

@end
