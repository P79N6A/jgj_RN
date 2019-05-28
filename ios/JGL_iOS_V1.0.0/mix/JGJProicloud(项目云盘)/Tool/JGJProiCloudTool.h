//
//  JGJProiCloudTool.h
//  JGJCompany
//
//  Created by yj on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JGJProiCloud.h"

#import <Photos/PHAssetResource.h>

#import <Photos/Photos.h>

// 下载文件的总文件夹
#define BASE       @"JGJOSSDownLoad"
// 完整文件路径
#define TARGET     @"CacheList"
// 临时文件夹名称
#define TEMP       @"Temp"

#define UPLoadBASE       @"JGJOSSUpLoad"

// 缓存主目录
#define CACHES_DIRECTORY     [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

// 临时文件夹的路径
#define TEMP_FOLDER          [NSString stringWithFormat:@"%@/%@/%@",CACHES_DIRECTORY,BASE,TEMP]

// 临时文件的路径
#define TEMP_PATH(name)      [NSString stringWithFormat:@"%@/%@",[JGJOSSCommonHelper createFolder:TEMP_FOLDER],name]

// 下载文件夹路径
#define FILE_FOLDER          [NSString stringWithFormat:@"%@/%@/%@",CACHES_DIRECTORY,BASE,TARGET]

// 下载文件的路径
#define FILE_PATH(name)      [NSString stringWithFormat:@"%@/%@",[JGJOSSCommonHelper createFolder:FILE_FOLDER],name]

//上传的文件夹

// 上传临时文件夹的路径
#define UPLoad_TEMP_FOLDER          [NSString stringWithFormat:@"%@/%@/%@",CACHES_DIRECTORY,UPLoadBASE,TEMP]

// 上传临时文件的路径
#define UPLoad_TEMP_PATH(name)      [NSString stringWithFormat:@"%@/%@",[JGJOSSCommonHelper createFolder:UPLoad_TEMP_FOLDER],name]

// 上传下载文件夹路径
#define UPLoad_FILE_FOLDER          [NSString stringWithFormat:@"%@/%@/%@",CACHES_DIRECTORY,UPLoadBASE,TARGET]

// 上传下载文件的路径
#define UPLoad_FILE_PATH(name)      [NSString stringWithFormat:@"%@/%@",[JGJOSSCommonHelper createFolder:UPLoad_FILE_FOLDER],name]



@interface JGJOSSCommonHelper : NSObject

/** 将文件大小转化成M单位或者B单位 */
+ (NSString *)getFileSizeString:(NSString *)size;
/** 经文件大小转化成不带单位的数字 */
+ (float)getFileSizeNumber:(NSString *)size;
/** 字符串格式化成日期 */
+ (NSDate *)makeDate:(NSString *)birthday;
/** 日期格式化成字符串 */
+ (NSString *)dateToString:(NSDate*)date;
/** 检查文件名是否存在 */
+ (BOOL)isExistFile:(NSString *)fileName;
+ (NSString *)createFolder:(NSString *)path;

+ (CGFloat)calculateFileSizeInUnit:(unsigned long long)contentLength;

+ (NSString *)calculateUnit:(unsigned long long)contentLength;

//删除文件
+ (BOOL)removeFileWithFilepath:(NSString *)filepath;

@end


typedef void (^ProiCloudToolNetworkingUploadProgressBlock) (int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend, BOOL isSuccess);

typedef void (^ProiCloudToolDownloadProgressBlock) (int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite, BOOL isSuccess);

typedef void(^ResultPath)(NSString *filePath, NSString *fileName);

typedef void(^PhotoAlbumResult)(NSString *fileType, NSString *fileName, int64_t size);

typedef void(^ProiCloudToolBlock)(id);

@interface JGJProiCloudTool : NSObject

+ (instancetype)shareProiCloudTool;

//取消下载请求
@property (nonatomic, strong) JGJProiCloudUploadFilesModel * transRequest;

//当前控制器
@property (nonatomic, strong) UIViewController *targetVc;

//上传
@property (nonatomic, copy) ProiCloudToolNetworkingUploadProgressBlock proiCloudToolNetworkingUploadProgressBlock;

//下载
@property (nonatomic, copy) ProiCloudToolDownloadProgressBlock proiCloudToolDownloadProgressBlock;

// 异步上传
+ (void)proiCloudToolUploadObjectAsync:(UIImage *)image uploadObjectModel:(JGJProiCloudUploadFilesModel *)uploadObjectModel proiCloudToolNetworkingUploadProgressBlock:(ProiCloudToolNetworkingUploadProgressBlock) proiCloudToolNetworkingUploadProgressBlock;

//异步下载
+ (void)proiCloudToolDownObjectAsync:(UIImage *)image downObjectModel:(JGJProiCloudUploadFilesModel *)downObjectModel proiCloudToolDownloadProgressBlock:(ProiCloudToolDownloadProgressBlock) ProiCloudToolDownloadProgressBlock;

//选取上传材料
+ (void)getImageAsset:(PHAsset *)asset assets:(NSArray *)assets image:(UIImage *)image fileUrl:(NSString *)fileUrl cloudListModel:(JGJProicloudListModel *)cloudListModel;

//传输列表点击开始或者暂停上传
+ (void)requestUpLoadWithUpLoadCloudListModel:(JGJProicloudListModel *)cloudListModel image:(UIImage *)image;

//获取相册后得到名字和地址
+ (void)getPhotoAlbumPathFromPHAsset:(PHAsset *)asset Complete:(ResultPath)result;

//获取相册名字和类型
+ (void)getPhotoAlbumPathFromPHAsset:(PHAsset *)asset photoAlbumResult:(PhotoAlbumResult)photoAlbumResult;

//打开图片视频等
+ (void)proiCloudToolOpenFileWithCloudListModel:(JGJProicloudListModel *)cloudListModel;

//回调
@property (nonatomic, copy) ProiCloudToolBlock proiCloudToolBlock;
@end
