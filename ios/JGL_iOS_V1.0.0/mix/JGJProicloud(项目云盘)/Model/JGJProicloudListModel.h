//
//  JGJProicloudListModel.h
//  JGJCompany
//
//  Created by yj on 2017/7/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AliyunOSSiOS/AliyunOSSiOS.h>

typedef enum : NSUInteger {
    
    ProicloudVcTransButtonType = 0, //传输
    
    ProicloudVcCreatButtonType = 1, //新建
    
    ProicloudVcUploadButtonType = 2, //上传
    
    ProicloudVcMoveButtonType = 0, //移动文件
    
    ProicloudVcDelButtonType = 2 //删除文件
    
} ProicloudVcButtonType;

typedef enum : NSUInteger {
    
    ProicloudRootDefaultVcType,
    
    ProicloudRootSearchVcType,
    
} ProicloudRootVcType;

typedef enum : NSUInteger {
    
    ProicloudListDefaultCellType, //默认类型查看，没有选择按钮
    
    ProicloudListMoreOperaCellType, //更多操作有选择按钮
    
} ProicloudListCellType;

typedef enum : NSUInteger {
    
    JGJProicloudListCellDownloadButtonType,
    
    JGJProicloudListCellShareButtonType, //是否分享
    
    JGJProicloudListCellRenameButtonType,
    
    JGJProicloudListCellStartButtonType, //是否下载
    
    JGJProicloudListCellStartUpLoadButtonType //是否开始上传
    
} JGJProicloudListCellButtonType;


typedef enum : NSUInteger {
    
    ProiCloudDataBaseDownLoadType = 0, //下载类型
    
    ProiCloudDataBaseUpLoadType = 1 //上传类型
    
} ProiCloudDataBaseType;

typedef enum : NSUInteger {
    
    JGJProicloudLoadingStatusType, //正在加载
    
    JGJProicloudSuccessStatusType,//完成
    
    JGJProicloudFailureStatusType, //下载失败
    
    JGJProicloudStartStatusType, //开始加载
    
    JGJProicloudPauseStatusType //暂停加载
    
} JGJProicloudFinishStatusType;

@interface JGJProicloudListModel : NSObject

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, assign) BOOL isHiddenLineView;

@property (nonatomic, assign) ProicloudListCellType cloudListCellType;

@property (nonatomic, copy) NSString *fileId; //文件id

@property (nonatomic, copy) NSString *file_name;

@property (nonatomic, copy) NSString *parent_id;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *bucket_name;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *file_type;

//文件icon用归类显示png ,jpeg属于pic等
@property (nonatomic, copy) NSString *file_broad_type;

@property (nonatomic, copy) NSString *file_path;

//缩略图地址
@property (nonatomic, copy) NSString *thumbnail_file_path;

@property (nonatomic, copy) NSString *file_size;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, assign) JGJProicloudListCellButtonType buttonType;

@property (nonatomic, assign) BOOL isImage;

//合并路径
@property (nonatomic, copy) NSString *file_merge_path;

//oss_file_name下载路径名字
@property (nonatomic, copy) NSString *oss_file_name;

@property (nonatomic, strong) UIImageView *imageView;

// 文档 document 图片 picture  视频video 工程文档 project_document
@property (nonatomic, copy) NSString *belong_file;

//文件下载上传进度
@property (nonatomic, assign) CGFloat progress;

//完成状态
@property (nonatomic, assign) JGJProicloudFinishStatusType finish_status;

//位置
@property (nonatomic, strong) NSIndexPath *indexPath;

//是不是上传1 上传，0下载
@property (nonatomic, assign) ProiCloudDataBaseType is_upload;

//已下载大小
@property (nonatomic, assign) int64_t totalBytes;

//总大小
@property (nonatomic, assign) int64_t totalBytesExpected;

//是否开始下载或者上传完成
@property (nonatomic, assign) BOOL is_start;

@property (nonatomic, copy) NSString *iCloudUniqueId; //上传文件唯一标示

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) NSString *object_name;//项目组空间

//3.0.0

@property (nonatomic, copy) NSString *update_time;//更新时间

@property (nonatomic, copy) NSString *opeator_name;//操作人

@end

@interface JGJProicloudModel : NSObject

@property (nonatomic, copy) NSString *allnum;

@property (nonatomic, strong) NSArray <JGJProicloudListModel *> *list;

@end

@interface JGJProiCloudUploadFilesModel : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *AccessKeyId;

@property (nonatomic, copy) NSString *AccessKeySecret;

@property (nonatomic, copy) NSString *Expiration;

@property (nonatomic, copy) NSString *SecurityToken;

@property (nonatomic, copy) NSString *EndPoint;

@property (nonatomic, copy) NSString *Bucketname;

@property (nonatomic, copy) NSString *callbackUrl;

@property (nonatomic, copy) NSString *callbackBody;

@property (nonatomic, copy) NSString *callbackBodyType;

@property (nonatomic, copy) NSString *objectKey;

@property (nonatomic, copy) NSString *xId;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *fileId;

@property (nonatomic, copy) NSString *group_id;//班组ID

@property (nonatomic, copy) NSString *class_type;//班组类型

@property (nonatomic, copy) NSString *object_name;//项目组空间

//下载上传的当前的模型数据
@property (nonatomic, strong) JGJProicloudListModel *cloudListModel;

//下载任务
@property (nonatomic, strong) OSSTask * getTask;

//取消下载请求
@property (nonatomic, strong) OSSGetObjectRequest * request;

//取消上传请求
@property (nonatomic, strong) OSSResumableUploadRequest * resumableUpload;

//文件icon用归类显示png ,jpeg属于pic等
@property (nonatomic, copy) NSString *file_broad_type;

@property (nonatomic, assign) NSInteger reduce_space;
@end

