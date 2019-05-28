//
//  JGJKnowBaseRequestModel.h
//  mix
//
//  Created by yj on 17/4/12.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJKnowBaseRequestCommonModel : NSObject

@property (nonatomic, assign) NSInteger pg; //页，默认为1

@property (nonatomic, assign) NSInteger pagesize; //页面条数 ，默认为10

@property (nonatomic, copy) NSString *sign; //签名

@property (nonatomic, copy) NSString *timestamp; //签名使用的	时间戳

@end

@interface JGJKnowBaseRequestModel : JGJKnowBaseRequestCommonModel

@property (nonatomic, copy) NSString *id;   //目录 id

@property (nonatomic, copy) NSString *class_type; //目录dir

@property (nonatomic, copy) NSString *last_file_id; //目录中最后的文件id

@property (nonatomic, copy) NSString *file_name; //搜索是用的文件名字
@end

@interface JGJKnowBaseCollecRequestModel : JGJKnowBaseRequestCommonModel

//@property (nonatomic, copy) NSString *timestamp; //时间戳

@end

@interface JGJKnowBaseGetFileRequestModel : JGJKnowBaseRequestCommonModel

@property (nonatomic, copy) NSString *file_id; //时间戳

@end

@interface JGJKnowBaseChildVcRequestModel : JGJKnowBaseRequestCommonModel

@property (nonatomic, strong) JGJKnowBaseRequestModel *knowBaseRequestModel; //存储请求模型数据

@property (nonatomic, strong) JGJKnowBaseModel *topKnowBaseModel; //知识库顶层模型

@property (nonatomic, strong) NSMutableArray *knowBases; //存储数据

@property (nonatomic, strong) UIViewController *childVc;//存储当前子控制器

@end
