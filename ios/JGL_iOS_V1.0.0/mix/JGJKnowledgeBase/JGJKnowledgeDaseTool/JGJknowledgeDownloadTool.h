//
//  JGJknowledgeDownloadTool.h
//  mix
//
//  Created by yj on 2018/7/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSDate+Extend.h"

@interface JGJknowledgeDownloadTool : NSObject

//所有的下载资料
+ (NSArray *)allknowBaseModels;

//添加下载资料
+ (BOOL)addCollectKnowBaseModel:(JGJKnowBaseModel *)model;

//删除下载资料
+ (BOOL)removeCollectKnowBaseModel:(JGJKnowBaseModel *)model;

@end
