//
//  JGJHashModel.m
//  mix
//
//  Created by Tony on 2016/12/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJHashModel.h"

@implementation JGJHashModel
+(id)hashStr:(NSString *)hashStr
{
    long hash = 1315423911;
    NSString *lastStr = [hashStr substringWithRange:NSMakeRange(hashStr.length-1, 1)];
    return 0;
}
@end
