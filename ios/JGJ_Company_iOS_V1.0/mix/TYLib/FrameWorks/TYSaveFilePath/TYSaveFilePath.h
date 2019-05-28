//
//  TYSaveFilePath.h
//  HuDuoDuoLogistics
//
//  Created by jizhi on 15/8/6.
//  Copyright (c) 2015年 JiZhiShengHuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TYSaveSrcFileNamePath [[NSBundle mainBundle] pathForResource:dataBaseName ofType:nil]//原始目录


#define TYDesFileNamePath [UserDocumentPaths stringByAppendingPathComponent:dataBaseName]//目标目录

@interface TYSaveFilePath : NSObject
/**
 *  移动文件
 *
 *  @param desFileNamePath 目标的文件路径
 *  @param srcFileNamePath 原始的文件路径
 */
+ (void)copyFileAtPath:(NSString *)desFileNamePath SrcFileName:(NSString *)srcFileNamePath;
@end
