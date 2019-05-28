//
//  NSString+localID.m
//  mix
//
//  Created by Tony on 2016/9/6.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "NSString+localID.h"

@implementation NSString (localID)
- (NSString *)localID{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeID = [NSString stringWithFormat:@"%.lf", time];
    
    return timeID;
}
@end
