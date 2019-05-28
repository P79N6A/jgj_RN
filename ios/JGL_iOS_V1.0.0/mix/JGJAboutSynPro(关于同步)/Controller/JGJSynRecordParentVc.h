//
//  JGJSynRecordParentVc.h
//  mix
//
//  Created by yj on 2018/12/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "YZDisplayViewController.h"

typedef enum : NSUInteger {
    
    JGJSynToMeRecordType,//同步给我的记工
    
    JGJSynRecordType //同步记工
    
} JGJSynType;

@interface JGJSynRecordParentVc : YZDisplayViewController

//同步类型

@property (nonatomic, assign) JGJSynType synType;

@end
