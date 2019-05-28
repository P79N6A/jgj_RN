//
//  TYSaveFilePath.m
//  HuDuoDuoLogistics
//
//  Created by jizhi on 15/8/6.
//  Copyright (c) 2015年 JiZhiShengHuo. All rights reserved.
//

#import "TYSaveFilePath.h"

@implementation TYSaveFilePath

/* 移动文件，从NSCachesDirectory 移动到 NSCachesDirectory//tempFolder目录 */

+ (void)copyFileAtPath:(NSString *)desFileNamePath SrcFileName:(NSString *)srcFileNamePath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;

    
    if ([fileManager fileExistsAtPath:desFileNamePath])
    {
        if ([fileManager removeItemAtPath:desFileNamePath error:&error] != YES)
            TYLog(@"Unable to remove file: %@", [error localizedDescription]);
    }
    
    //判断是否移动
    if ([fileManager copyItemAtPath:srcFileNamePath toPath:desFileNamePath error:&error] != YES)
        TYLog(@"Unable to move file: %@", [error localizedDescription]);
}

@end