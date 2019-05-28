//
//  JGJProiCloudTool.m
//  JGJCompany
//
//  Created by yj on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiCloudTool.h"

#import "TYUIImage.h"

#import <AliyunOSSiOS/AliyunOSSiOS.h>

#import "NSString+Extend.h"

//打开视频图片
#import "MJPhotoBrowser.h"

#import "MJPhoto.h"

#import "JGJProiCloudShareVc.h"

#import "JGJProiCloudMediaVc.h"

#import "JGJKnowBaseDownLoadPopView.h"

#import "JGJCustomPopView.h"

#define MaxFileSize 300

@implementation JGJOSSCommonHelper

+ (NSString *)getFileSizeString:(NSString *)size {
    if([size floatValue]>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%1.2fM",[size floatValue]/1024/1024];
    }
    else if([size floatValue]>=1024&&[size floatValue]<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%1.2fK",[size floatValue]/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%1.2fB",[size floatValue]];
    }
}

+ (float)getFileSizeNumber:(NSString *)size {
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)//是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)//是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)//是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else//没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}

+ (BOOL)isExistFile:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+ (NSDate *)makeDate:(NSString *)birthday {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:birthday];
    return date;
}

+ (NSString *)dateToString:(NSDate*)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [df stringFromDate:date];
    return datestr;
}

+ (NSString *)createFolder:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if(!error) {
            NSLog(@"%@",[error description]);
        }
    }
    return path;
}


+ (CGFloat)calculateFileSizeInUnit:(unsigned long long)contentLength {
    if (contentLength >= pow(1024, 3)) { return (CGFloat) (contentLength / (CGFloat)pow(1024, 3)); }
    else if (contentLength >= pow(1024, 2)) { return (CGFloat) (contentLength / (CGFloat)pow(1024, 2)); }
    else if (contentLength >= 1024) { return (CGFloat) (contentLength / (CGFloat)1024); }
    else { return (CGFloat) (contentLength); }
}

+ (NSString *)calculateUnit:(unsigned long long)contentLength {
    if(contentLength >= pow(1024, 3)) { return @"GB";}
    else if(contentLength >= pow(1024, 2)) { return @"MB"; }
    else if(contentLength >= 1024) { return @"KB"; }
    else { return @"B"; }
}

+ (BOOL)removeFileWithFilepath:(NSString *)filepath {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
   BOOL isRemove = [fileManager removeItemAtPath:filepath error:nil];
    
    return isRemove;
}

@end

static JGJProiCloudTool *_proiCloudTool;

@interface JGJProiCloudTool ()

@property (strong, nonatomic) OSSClient * client;

/**
 *  用来写数据的文件句柄对象
 */
@property (nonatomic, strong) NSFileHandle *writeHandle;

/**
 *  当前已经写入的总大小
 */
@property (nonatomic, assign) long long  currentLength;

/**
 *  上传请求参数
 */
@property (strong, nonatomic) JGJProiCloudUploadFilesRequestModel *uploadFilesRequestModel;
@end

@implementation JGJProiCloudTool

+ (void)initialize {

    [self shareProiCloudTool];

}

+ (instancetype)shareProiCloudTool
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        _proiCloudTool = [[self alloc] init];

    });
    return _proiCloudTool;
}

- (instancetype)init {

    self = [super init];
    
    if (self) {
        
    }
    
    return self;

}

- (void)initialOSSClientWithUploadObjectModel:(JGJProiCloudUploadFilesModel *)uploadObjectModel {

    NSString *endPoint = [NSString stringWithFormat:@"https://%@", uploadObjectModel.EndPoint];
    
//    endPoint = @"oss-cn-beijing.aliyuncs.com";
//
//    OSSPlainTextAKSKPairCredentialProvider *credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"LTAIvZzqmMViYaBb" secretKey:@"F2L3vW8zVaeSsXXXaQJ9XeHOXW1TKz"];
    

    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    
    conf.maxRetryCount = 2;
    
    conf.timeoutIntervalForRequest = 30;
    
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:uploadObjectModel.AccessKeyId secretKeyId:uploadObjectModel.AccessKeySecret securityToken:uploadObjectModel.SecurityToken];
    
    _client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
    
    
}

// 异步上传
+ (void)proiCloudToolUploadObjectAsync:(UIImage *)image uploadObjectModel:(JGJProiCloudUploadFilesModel *)uploadObjectModel proiCloudToolNetworkingUploadProgressBlock:(ProiCloudToolNetworkingUploadProgressBlock) proiCloudToolNetworkingUploadProgressBlock {
    
    //视频断点上传、图片直接上传
    if (![NSString isEmpty:uploadObjectModel.filePath]) {
        
        NSString *checkStr = @"CacheList/";
        NSRange videonameRange = [uploadObjectModel.filePath rangeOfString:checkStr];
        
        if (videonameRange.location != NSNotFound) {
            
            NSString *videofileName = [uploadObjectModel.filePath substringFromIndex:videonameRange.location + videonameRange.length];
           
            uploadObjectModel.filePath  = UPLoad_FILE_PATH(videofileName);
            
        }
        
        [JGJProiCloudTool appendObjectWithUploadObjectAsync:image uploadObjectModel:uploadObjectModel proiCloudToolNetworkingUploadProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend, BOOL isSuccess) {
            
            TYLog(@"fileName =======%@,  %lld, %lld, %lld", uploadObjectModel.fileName, bytesSent, totalBytesSent, totalBytesExpectedToSend, isSuccess);
            
            CGFloat progress = 1.0 * totalBytesSent / totalBytesExpectedToSend;
            
            uploadObjectModel.cloudListModel.progress = progress;
            
            uploadObjectModel.cloudListModel.totalBytes = totalBytesSent;
            
            uploadObjectModel.cloudListModel.totalBytesExpected = totalBytesExpectedToSend;
            
            uploadObjectModel.cloudListModel.finish_status = JGJProicloudLoadingStatusType;
            
            if (isSuccess || progress == 1.0) {
                
                //添加数据库上传完成
                uploadObjectModel.cloudListModel.finish_status = JGJProicloudSuccessStatusType;
                
                uploadObjectModel.cloudListModel.is_upload = ProiCloudDataBaseUpLoadType;
                
                [JGJProiCloudDataBaseTool updateicloudListModel:uploadObjectModel.cloudListModel];
 
            }
                        
            [TYNotificationCenter postNotificationName:JGJProiCloudUpLoadFilesNotification object:uploadObjectModel];

        }];
        
        return;
    }
    
}


// 断点续传

+ (void)appendObjectWithUploadObjectAsync:(UIImage *)image uploadObjectModel:(JGJProiCloudUploadFilesModel *)uploadObjectModel proiCloudToolNetworkingUploadProgressBlock:(ProiCloudToolNetworkingUploadProgressBlock) proiCloudToolNetworkingUploadProgressBlock {
    
    JGJProiCloudTool *proiCloudTool = [JGJProiCloudTool shareProiCloudTool];
    
    [proiCloudTool initialOSSClientWithUploadObjectModel:uploadObjectModel];
    
    __block NSString * recordKey;
    
    NSString * filePath = uploadObjectModel.filePath;
    
    NSString * bucketName = uploadObjectModel.Bucketname;
    
    NSString * objectKey = [NSString stringWithFormat:@"%@/%@", uploadObjectModel.object_name,uploadObjectModel.objectKey];
    
    [[[[[[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
        // 为该文件构造一个唯一的记录键
        NSURL * fileURL = [NSURL fileURLWithPath:filePath];
        NSDate * lastModified;
        NSError * error;
        [fileURL getResourceValue:&lastModified forKey:NSURLContentModificationDateKey error:&error];
        if (error) {
            return [OSSTask taskWithError:error];
        }
        
        //唯一标识
        recordKey = [NSString stringWithFormat:@"%@-%@-%@", bucketName, objectKey, uploadObjectModel.cloudListModel.file_name];
        // 通过记录键查看本地是否保存有未完成的UploadId
        
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        return [OSSTask taskWithResult:[userDefault objectForKey:recordKey]];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        if (!task.result) {
            // 如果本地尚无记录，调用初始化UploadId接口获取
            OSSInitMultipartUploadRequest * initMultipart = [OSSInitMultipartUploadRequest new];
            
            initMultipart.bucketName = bucketName;
            
            initMultipart.objectKey = objectKey;
            
            
//            initMultipart.contentType = @"application/octet-stream";
            return [proiCloudTool.client multipartUploadInit:initMultipart];
        }
        OSSLogVerbose(@"An resumable task for uploadid: %@", task.result);
        return task;
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        NSString * uploadId = nil;
        
        if (task.error) {
            return task;
        }
        
        if ([task.result isKindOfClass:[OSSInitMultipartUploadResult class]]) {
            
            uploadId = ((OSSInitMultipartUploadResult *)task.result).uploadId;
            
        } else {
            
            uploadId = task.result;
            
        }
        
        if (!uploadId) {
            return [OSSTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
                                                              code:OSSClientErrorCodeNilUploadid
                                                          userInfo:@{OSSErrorMessageTOKEN: @"Can't get an upload id"}]];
        }
        // 将“记录键：UploadId”持久化到本地存储
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:uploadId forKey:recordKey];
        [userDefault synchronize];
        return [OSSTask taskWithResult:uploadId];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        // 持有UploadId上传文件
        OSSResumableUploadRequest * resumableUpload = [OSSResumableUploadRequest new];
        
        //保存用于暂停和开始
        uploadObjectModel.resumableUpload = resumableUpload;
        
        resumableUpload.bucketName = bucketName;
        
        resumableUpload.objectKey = objectKey;
        
        resumableUpload.partSize = 1024 * 1024;
        
        resumableUpload.callbackParam = @{
                              
                              @"callbackUrl" : uploadObjectModel.callbackUrl?:@"",
                              
                              @"callbackBody": uploadObjectModel.callbackBody?:@""
                              
                              };
        
        resumableUpload.callbackVar = @{@"x:id" : uploadObjectModel.xId?:@""};
        
        resumableUpload.uploadId = task.result;
        resumableUpload.uploadingFileURL = [NSURL fileURLWithPath:filePath];
        resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
            if (proiCloudToolNetworkingUploadProgressBlock) {
                
                proiCloudToolNetworkingUploadProgressBlock(bytesSent, totalBytesSent, totalBytesExpectedToSend, NO);
            }
            
//            [TYNotificationCenter postNotificationName:JGJProiCloudUpLoadFilesNotification object:uploadObjectModel];

        };
        
        
        return [proiCloudTool.client resumableUpload:resumableUpload];
    }] continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
                // 如果续传失败且无法恢复，需要删除本地记录的UploadId，然后重启任务
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
                
                TYLog(@"task.error ==== %@", task.error);
            }
        } else {
            TYLog(@"upload completed!");
            
            TYLog(@"Succcess==fileName =======%@,  %d, %d, %d", uploadObjectModel.fileName, 1, 1, 1, NO);
            
            OSSPutObjectResult * result = task.result;
            //
            NSDictionary *resultDic = [result.serverReturnJsonString mj_JSONObject];
            
            JGJProicloudListModel *icloudListModel = [JGJProicloudListModel mj_objectWithKeyValues:resultDic];
            
            uploadObjectModel.cloudListModel.fileId = icloudListModel.fileId;
            
            uploadObjectModel.cloudListModel.thumbnail_file_path = icloudListModel.thumbnail_file_path;
            
            [JGJProiCloudDataBaseTool updateicloudListModel:uploadObjectModel.cloudListModel];
            
            if (proiCloudToolNetworkingUploadProgressBlock) {
                
                proiCloudToolNetworkingUploadProgressBlock(1, 1, 1, YES);
            }
            
            // 上传成功，删除本地保存的UploadId
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
            

            TYLog(@"Result - requestId: %@, headerFields: %@, servercallback: %@",
                  result.requestId,
                  result.httpResponseHeaderFields,
                  result.serverReturnJsonString);
            
        }
        return nil;
    }];

}

#pragma mark - 异步下载
+ (void)proiCloudToolDownObjectAsync:(UIImage *)image downObjectModel:(JGJProiCloudUploadFilesModel *)downObjectModel proiCloudToolDownloadProgressBlock:(ProiCloudToolDownloadProgressBlock) proiCloudToolDownloadProgressBlock {

    JGJProiCloudTool *proiCloudTool = [JGJProiCloudTool shareProiCloudTool];
    
    [proiCloudTool initialOSSClientWithUploadObjectModel:downObjectModel];
    
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = downObjectModel.Bucketname;
    
    request.objectKey = downObjectModel.objectKey;
    
    NSString * downFileUrl = FILE_PATH(downObjectModel.fileName);
    
    TYLog(@"downFileUrl === %@", downFileUrl);
    
    //这里分有文件和没有文件两种方式，文件存在用范围，首次就地址。范围加地址会出问题。每次都会重新下载。
    if ([JGJOSSCommonHelper isExistFile:downFileUrl]) {
        
        NSData *downLoadedData = [NSData dataWithContentsOfFile:downFileUrl];
        
        downObjectModel.cloudListModel.totalBytes = downLoadedData.length;
        
        request.range = [[OSSRange alloc] initWithStart:downObjectModel.cloudListModel.totalBytes withEnd: - 1]; // bytes=0-99，指定范围下载

        request.onRecieveData = ^(NSData *data){
            
            NSString * fileUrl = FILE_PATH(downObjectModel.fileName);
            
            // 打开缓存文件
            NSFileHandle *fp = [NSFileHandle fileHandleForWritingAtPath:fileUrl];
            
            // 如果文件不存在，直接写入数据
            if (!fp) {
                
                NSMutableData *receAllLoadedData = [NSData dataWithContentsOfFile:fileUrl].mutableCopy;
                
                proiCloudTool.currentLength += data.length;
                
                [receAllLoadedData appendData:data];
                
                [receAllLoadedData writeToFile:downFileUrl atomically:YES];
                
            } else {
                
                // 移动到文件末尾
                [fp seekToEndOfFile];
                
                // 将数据文件追加到文件末尾
                [fp writeData:data];
                
                // 关闭文件句柄
                [fp closeFile];
                
            }
            
        };

    }else {
        
        request.downloadToFileURL = [NSURL fileURLWithPath:downFileUrl];
        
    }
    
    //  获得下载进度 ,使用范围的情况用它的获取进度，会从偶开始获得值。其实文件夹已经有值了
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        NSString * fileUrl = FILE_PATH(downObjectModel.fileName);
        
        //当前文件已下载总大小
        int64_t totalBytes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileUrl error:nil].fileSize;
        
        int64_t totalBytesExpected = 0;
        
        if (downObjectModel.cloudListModel.totalBytesExpected <= 0 && totalBytesExpectedToWrite > 0) {
            
            downObjectModel.cloudListModel.totalBytesExpected = totalBytesExpectedToWrite;
            
            downObjectModel.cloudListModel.finish_status = JGJProicloudLoadingStatusType;
            //首次写入数据库存总大小
            [JGJProiCloudDataBaseTool updateicloudListModel:downObjectModel.cloudListModel];
            
            
        }else {
        
            totalBytesExpected = downObjectModel.cloudListModel.totalBytesExpected;
            
        }
        
        downObjectModel.cloudListModel.progress = 1.0 * totalBytes / totalBytesExpected;
        
        downObjectModel.cloudListModel.totalBytes = totalBytes;
        
         TYLog(@"fileName =======%@, totalBytesWritten = %lld,totalBytes = %lld, totalBytesExpectedToWrite = %lld, %@", downObjectModel.fileName, totalBytesWritten, totalBytes, totalBytesExpectedToWrite, [NSThread currentThread]);
        
        downObjectModel.cloudListModel.finish_status = JGJProicloudLoadingStatusType;
        
        downObjectModel.cloudListModel.is_upload = ProiCloudDataBaseDownLoadType;
        
//        JGJProicloudListModel *cloudListModel = [JGJProiCloudDataBaseTool inquireicloudListModell:downObjectModel.cloudListModel];
//
//        if (cloudListModel.finish_status != JGJProicloudSuccessStatusType) {
//
//
//        }

         [TYNotificationCenter postNotificationName:JGJProiCloudDownFilesNotification object:downObjectModel];
        
    };
    
    OSSTask * getTask = [proiCloudTool.client getObject:request];

    //获取当前下载请求
    downObjectModel.request = request;
    
    //点击分享的时候保存下载好取消
    JGJProiCloudTool *iCloudTool = [JGJProiCloudTool shareProiCloudTool];
    
    JGJProiCloudUploadFilesModel *transRequest = [JGJProiCloudUploadFilesModel new];
    
    transRequest.cloudListModel = downObjectModel.cloudListModel;
    
    transRequest.request = request;
    
    iCloudTool.transRequest = transRequest;
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            
            TYLog(@"download object success!");
            
            OSSGetObjectResult * getResult = task.result;
            
            TYLog(@"download dota length: %lu", [getResult.downloadedData length]);
            
            
            downObjectModel.cloudListModel.progress = 1.0;
            
            downObjectModel.cloudListModel.totalBytes = downObjectModel.cloudListModel.totalBytesExpected;
            
            downObjectModel.cloudListModel.totalBytesExpected = downObjectModel.cloudListModel.totalBytesExpected;
            
            //添加数据库上传完成
            downObjectModel.cloudListModel.finish_status = JGJProicloudSuccessStatusType;
            
            downObjectModel.cloudListModel.is_upload = ProiCloudDataBaseDownLoadType;
            
            [TYNotificationCenter postNotificationName:JGJProiCloudDownFilesNotification object:downObjectModel];
            
            //下载成功写入数据库存
            [JGJProiCloudDataBaseTool updateicloudListModel:downObjectModel.cloudListModel];
            
            
        } else {
            
//            downObjectModel.cloudListModel.finish_status = JGJProicloudFailureStatusType;
            
            downObjectModel.cloudListModel.finish_status = JGJProicloudPauseStatusType;
            //首次写入数据库存总大小
            [JGJProiCloudDataBaseTool updateicloudListModel:downObjectModel.cloudListModel];

            TYLog(@"JGJProicloudFailureStatusType == download object failed, error: %@" ,task.error);
        }
        return nil;
    }];
    
}

#pragma mark - 得到请求参数
+ (void)getImageAsset:(PHAsset *)asset assets:(NSArray *)assets image:(UIImage *)image fileUrl:(NSString *)fileUrl cloudListModel:(JGJProicloudListModel *)cloudListModel {
    
    //然后请求获取key
    [JGJProiCloudTool requestUpLoadWithUpLoadCloudListModel:cloudListModel image:image];
}


#pragma mark - 上传请求。这里传输列表直接传当前列表就可以了
+ (void)requestUpLoadWithUpLoadCloudListModel:(JGJProicloudListModel *)cloudListModel image:(UIImage *)image {

    //取得上传参数
    JGJProiCloudUploadFilesRequestModel *uploadFilesRequestModel = [JGJProiCloudUploadFilesRequestModel new];
    
    uploadFilesRequestModel.class_type = cloudListModel.class_type;
    
    uploadFilesRequestModel.group_id = cloudListModel.group_id;
    
    //上传的父文件id
    uploadFilesRequestModel.cat_id = cloudListModel.parent_id;
    
    //断点续传的文件id
    uploadFilesRequestModel.file_id = cloudListModel.fileId;
    
    NSString *file_name = cloudListModel.file_name;
    
    uploadFilesRequestModel.file_name = file_name;
    
    uploadFilesRequestModel.file_type = cloudListModel.file_type;
    
    
    NSString *file_size = cloudListModel.file_size;
    
    uploadFilesRequestModel.file_size = file_size;
    
    //添加到上传列表结束

    NSDictionary *parameters = [uploadFilesRequestModel mj_keyValues];
    
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/uploadFiles" parameters:parameters success:^(id responseObject) {
        

        JGJProiCloudUploadFilesModel *uploadFilesModel = [JGJProiCloudUploadFilesModel mj_objectWithKeyValues:responseObject];
        
//如果是从项目云盘列表上传弹框，续传不需要传
        
        if ([NSString isEmpty:cloudListModel.fileId]) {
            
            [TYShowMessage showPlaint:@"该文件已在上传,可在传输列表 中找到此文件"];
        }
        
        //视频资源上传地址
        uploadFilesModel.filePath = cloudListModel.file_path;
        
        //上传的objectKey注意
        uploadFilesModel.objectKey = [NSString stringWithFormat:@"%@%@",cloudListModel.file_merge_path?:@"",cloudListModel.file_name];
        
        uploadFilesModel.fileName = uploadFilesRequestModel.file_name;
        
        uploadFilesModel.fileId = cloudListModel.fileId;
        
        uploadFilesModel.cloudListModel = cloudListModel;
        
        //存入id，文件名字，地址
        cloudListModel.fileId = uploadFilesModel.xId;
        
        cloudListModel.file_name = uploadFilesModel.fileName;
        
        cloudListModel.file_path = uploadFilesModel.filePath;
        
        cloudListModel.file_broad_type = uploadFilesModel.file_broad_type;
        //点击之后就添加
        [JGJProiCloudDataBaseTool addCollecticloudListModel:cloudListModel];
        
        [JGJProiCloudTool proiCloudToolUploadObjectAsync:image uploadObjectModel:uploadFilesModel proiCloudToolNetworkingUploadProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend, BOOL isSuccess) {
            
            TYLog(@"fileName =======%@,  %lld, %lld, %lld, %@ , %@", uploadFilesModel.fileName, bytesSent, totalBytesSent, totalBytesExpectedToSend, @(isSuccess), [NSThread currentThread]);
            
            uploadFilesModel.cloudListModel.progress = 1.0 * totalBytesSent / totalBytesExpectedToSend;
            
            //成功的时候更新数据库
            if (isSuccess) {
                
                //添加数据库上传完成
                uploadFilesModel.cloudListModel.finish_status = JGJProicloudSuccessStatusType;
                
                uploadFilesModel.cloudListModel.is_upload = ProiCloudDataBaseUpLoadType;
                
                [JGJProiCloudDataBaseTool updateicloudListModel:uploadFilesModel.cloudListModel];
                
            }
            
            [TYNotificationCenter postNotificationName:JGJProiCloudUpLoadFilesNotification object:uploadFilesModel];
            
        }];
        
    } failure:^(NSError *error) {
        
        NSDictionary *errorDic = (NSDictionary *)error;
        
        NSString *errnostr = [NSString stringWithFormat:@"%@", errorDic[@"errno"]];
        
        //云盘空间不足提示
        if ([errnostr isEqualToString:@"810507"]) {
            
            TYLog(@"error ===== %@", error);
            
            [_proiCloudTool cloudServiceTip];
        }
        
        
    }];

}

#pragma mark -云盘购买提示
- (void)cloudServiceTip {

    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    desModel.popDetail = @"待上传文件大小已超过云盘剩余空间，如需继续上传，请扩容。";
    desModel.leftTilte = @"我再想想";
    desModel.rightTilte = @"立即扩容";
    desModel.lineSapcing = 5.0;
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    alertView.messageLable.textAlignment = NSTextAlignmentLeft;
    alertView.onOkBlock = ^{
        
        if (_proiCloudTool.proiCloudToolBlock) {
            
            _proiCloudTool.proiCloudToolBlock(@"");
        }
        
    };

}

+ (void)getPhotoAlbumPathFromPHAsset:(PHAsset *)asset Complete:(ResultPath)result {
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo || assetRes.type == PHAssetResourceTypePhoto) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive || asset.mediaType == PHAssetMediaTypeImage) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
//        NSString *filePath = [NSString stringWithFormat:@"JGJProUpLoad/%@", fileName];
//        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:filePath];
        
        NSString *creatDate = [NSString stringFromDate:asset.creationDate withDateFormat:@"yyyy-MM-dd"];
        
        fileName = [NSString stringWithFormat:@"%@-%@", creatDate, fileName];
        
        NSString *PATH_MOVIE_FILE = UPLoad_FILE_PATH(fileName);
        
        PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
        
        NSInteger verValue = [[[UIDevice currentDevice] systemVersion] integerValue];
        
        if (verValue >= 10) {
            
            long long size = [[resource valueForKey:@"fileSize"] longLongValue];
            
            if (MaxFileSize < size /1024/1024) {
                
                [TYShowMessage showPlaint:@"当前选择文件过大"];
                
                return;
            }
        }
        
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
    
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        // 2.添加 任务 到主队列中 异步 执行
        dispatch_async(queue, ^{
            
            TYLog(@"-----下载图片1---%@", [NSThread currentThread]);
            
            [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                        toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                       options:nil
                                                             completionHandler:^(NSError * _Nullable error) {
                                                                 if (error) {
                                                                     result(nil, fileName);
                                                                 } else {
                                                                     result(PATH_MOVIE_FILE, fileName);
                                                                 }
                                                             }];
            
        });

    } else {
        result(nil, nil);
    }
}

+ (void)getPhotoAlbumPathFromPHAsset:(PHAsset *)asset photoAlbumResult:(PhotoAlbumResult)photoAlbumResult {
    
    NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
    
    NSString *orgFilename = ((PHAssetResource*)resources[0]).originalFilename;
    
    NSRange range = [orgFilename rangeOfString:@"." options:NSBackwardsSearch];
    
    NSString *fileType = @"";
    
    NSInteger verValue = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    
    long long size = 1 * 1024 * 1024;
    
    if (verValue >= 10) {
        
        size = [[resource valueForKey:@"fileSize"] longLongValue];
        
        if (MaxFileSize < size /1024/1024) {
            
            [TYShowMessage showPlaint:@"当前选择文件过大"];
            
            return;
        }
    }
    
    if (range.location != NSNotFound) {
        
        fileType = [orgFilename substringFromIndex:range.location + 1];
        
    }
    
    if (photoAlbumResult) {
        
        photoAlbumResult(fileType, orgFilename, size);
    }
    
}


#pragma mark - 打开图片，视频等

+ (void)proiCloudToolOpenFileWithCloudListModel:(JGJProicloudListModel *)cloudListModel {



}

#pragma mark - 打开图片
- (void)browsePhotoImageViewWithCloudListModel:(JGJProicloudListModel *)cloudListModel{
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    
    NSURL *filePathUrl = [NSURL URLWithString:cloudListModel.file_path]; // 图片路径
    photo.url = filePathUrl; // 图片路径
    
    photo.srcImageView = cloudListModel.imageView; // 来源于哪个UIImageView
    
    NSMutableArray *photos = [NSMutableArray new];
    
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    
    browser.photos = photos; // 设置所有的图片
    
    [browser show];
    
}

- (void)openVideoWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    JGJProiCloudMediaVc *videoVc = [[JGJProiCloudMediaVc alloc] init];
    
    videoVc.cloudListModel = cloudListModel;
    
    [self.targetVc presentViewController:videoVc animated:YES completion:nil];

}

- (void)openDocumentWithCloudListModel:(JGJProicloudListModel *)cloudListModel {
    
    JGJProiCloudShareVc *shareVc = [JGJProiCloudShareVc new];
    
    shareVc.title = cloudListModel.file_name;
    
    NSString * downFileUrl = FILE_PATH(cloudListModel.file_name);
    
    //存在就打开
    if ([JGJOSSCommonHelper isExistFile:downFileUrl]) {
        
        shareVc = [JGJProiCloudShareVc new];
        
        shareVc.cloudListModel = cloudListModel;
        
        [self.targetVc.navigationController pushViewController:shareVc animated:YES];

    }
    
}


@end
