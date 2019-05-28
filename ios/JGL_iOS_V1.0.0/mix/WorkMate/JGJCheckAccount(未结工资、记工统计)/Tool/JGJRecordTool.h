//
//  JGJRecordTool.h
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJRecordToolModel : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *name;

//本地文件路径用于打开用

@property (nonatomic, copy) NSString *localfilePath;

//查看文档类型
@property (nonatomic, assign) BOOL isOpenDocument;

@property (nonatomic, strong) UIViewController *curVc;

@end

typedef void(^JGJRecordToolBlock)(BOOL isSucess, NSURL *localFilePath);

typedef void(^JGJRecordToolCheckDocumentBlock)(BOOL isSucess, NSString *localFilePath);

@interface JGJRecordTool : UIViewController

@property (nonatomic, strong) JGJRecordToolModel *toolModel;

@property (nonatomic, copy) JGJRecordToolBlock recordToolBlock;

//查看文档标记

@property (nonatomic, copy) JGJRecordToolCheckDocumentBlock recordToolCheckDocumentBlock;

//判断记工统计是否需要再次下载

+ (JGJRecordWorkDownLoadModel *)downFileExistWithDownLoadModel:(JGJRecordWorkDownLoadModel *)downLoadModel request:(JGJRecordWorkStaRequestModel *)request;

//判断记工流水是否需要再次下载

+ (JGJRecordWorkDownLoadModel *)downFileExistWithRecordDownLoadModel:(JGJRecordWorkDownLoadModel *)downLoadModel request:(JGJRecordWorkPointRequestModel *)request;

@end
