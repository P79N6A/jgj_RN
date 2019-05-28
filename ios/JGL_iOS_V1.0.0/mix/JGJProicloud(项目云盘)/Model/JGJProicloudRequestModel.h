//
//  JGJProicloudRequestModel.h
//  JGJCompany
//
//  Created by yj on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJProicloudCommonModel : NSObject

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@end

@interface JGJProicloudRequestModel : JGJProicloudCommonModel

@property (nonatomic, copy) NSString *parent_id;  //父目录id

@property (nonatomic, copy) NSString *last_file_id;  //父目录id

//1：表示回收站
@property (nonatomic, copy) NSString *is_bin;  

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *move_id;
@end


@interface JGJProiCloudUploadFilesRequestModel : JGJProicloudCommonModel

@property (nonatomic, copy) NSString *cat_id; //上传父文件id

@property (nonatomic, copy) NSString *file_name;

@property (nonatomic, copy) NSString *file_type;

@property (nonatomic, copy) NSString *file_size;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *file_id;//断点续传文件id

@end

//创建目录
@interface JGJProiColoudCreateCloudDirRequestModel : JGJProicloudCommonModel

@property (nonatomic, copy) NSString *parent_id;

@property (nonatomic, copy) NSString *cat_name;

@end

//删除文件
@interface JGJProiColoudDelFilesRequestModel : JGJProicloudCommonModel

@property (nonatomic, copy) NSString *parent_id;

@property (nonatomic, strong) NSArray *source_ids;

@property (nonatomic, copy) NSString *del_type;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray *delFile_ids;

@end

@interface JGJProiColoudSearchFileRequestModel : JGJProicloudCommonModel

@property (nonatomic, copy) NSString *cat_id; //默认是顶级目录

@property (nonatomic, copy) NSString *file_name; //文件名

@property (nonatomic, copy) NSString *is_bin; //回收站搜索为1

@end

@interface JGJProiColoudRenameFileRequestModel : JGJProicloudCommonModel

@property (nonatomic, copy) NSString *file_name; //重命名

@property (nonatomic, copy) NSString *type; //文件名

@property (nonatomic, copy) NSString *file_id; //文件id

@end

//移动文件
@interface JGJProiColoudMoveFilesRequestModel : JGJProicloudCommonModel

@property (nonatomic, copy) NSString *dir_id; //移动的目录id，不传，默认是根目录

@property (nonatomic, copy) NSString *source_ids; //文件名

@property (nonatomic, copy) NSString *file_id; //文件id

@property (nonatomic, copy) NSString *id; //文件id

@property (nonatomic, copy) NSString *type; //文件id

@property (nonatomic, strong) NSArray *moveFile_ids;

@end

//传输列表
@interface JGJProiColoudGetTransFileListRequestModel : JGJProicloudCommonModel

@property (nonatomic, copy) NSString *status; //默认为0，1：表示已完成下载，2：未完成下载

@end
