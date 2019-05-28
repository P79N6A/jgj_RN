//
//  JGJRecordStaListDetailVc.h
//  mix
//
//  Created by yj on 2018/1/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJRecordStaListVc.h"

@interface JGJRecordStaListDetailVc : JGJRecordStaListVc

@property (nonatomic, strong) JGJRecordWorkStaListModel *staListModel;

@property (strong, nonatomic) JGJRecordWorkStaRequestModel *request;

//代理班组长
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@end
