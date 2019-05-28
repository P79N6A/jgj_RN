//
//  JGJShareInstance.m
//  mix
//
//  Created by Tony on 2017/1/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJShareInstance.h"

@implementation JGJShareInstance
+(JGJShareInstance *)shareInstance
{
    
   static JGJShareInstance *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[JGJShareInstance alloc]init];
       
    });
    
    return share;
}
-(instancetype)init
{
    if (self =[super init]) {
        
        _isFirst = YES;
        
    }

    return self;
}
@end
