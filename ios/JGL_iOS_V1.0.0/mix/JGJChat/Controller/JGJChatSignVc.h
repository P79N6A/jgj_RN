//
//  JGJChatSignVc.h
//  JGJCompany
//
//  Created by Tony on 16/9/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatNoticeVc.h"
#import "JGJAddSignModel.h"
#import "JGJChatSignModel.h"

typedef void(^skipToNextVc)(UIViewController *nextVc);

@interface JGJChatSignVc : JGJChatNoticeVc

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (nonatomic,strong) JGJAddSignModel *addSignModel;

@property (nonatomic,copy) skipToNextVc skipToNextVc;

//如果存在sign_id说明只需要查看
@property (nonatomic,copy) NSString *sign_id;

@property (nonatomic,strong) JGJChatSignModel *chatSignModel;

@end
