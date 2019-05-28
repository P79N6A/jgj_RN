//
//  JGJRecordStaListMidVc.h
//  mix
//
//  Created by yj on 2018/9/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordStaListVc.h"

@interface JGJRecordStaListMidVc : JGJRecordStaListVc

@property (nonatomic, strong) JGJRecordWorkStaListModel *staListModel;

//是否禁止跳转到记工流水页面(同步给我的记工查看的时候)
@property (assign, nonatomic) BOOL isForbidSkipWorkpoints;

//是否是同步带过来的数据
@property (nonatomic, copy) NSString *is_sync;

@end
