//
//  JGJClearCache.h
//  mix
//
//  Created by Tony on 2016/12/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJClearCache : NSObject
- (float)checkTmpSize;
+ (void)clearTmpPicsData;
-(float)datalenthFromPath:(NSString *)path;
@end
