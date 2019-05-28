//
//  JGJKnowBaseModel.h
//  mix
//
//  Created by yj on 17/4/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJKnowBaseCommonModel : NSObject


@end

typedef enum : NSUInteger {
    
    KnowBaseDefaultCellType, //默认
    
    KnowBaseCollecCellType //收藏类型，主要标记右边显示情况

} KnowBaseCellType;

@interface JGJKnowBaseModel : NSObject

@property (nonatomic, copy) NSString *file_type;

@property (nonatomic, copy) NSString *knowBaseId;

@property (nonatomic, copy) NSString *file_name;

//@property (nonatomic, copy) NSString *id;
//@property (nonatomic, copy) NSString *is_active;
@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *file_path;

@property (nonatomic, assign) BOOL is_collection;

@property (nonatomic, copy) NSString *file_size;

@property (nonatomic, assign) CGFloat progress; //文件下载进度

@property (nonatomic, assign) CGFloat totalBytesRead; //文件总大小

@property (nonatomic, assign) BOOL isDownLoadSuccess; //是否下载成功

@property (nonatomic, strong) NSArray <JGJKnowBaseModel *> *child; //子文件

@property (nonatomic, copy) NSString *localFilePath;//下载完保存在本地得地址

@property (nonatomic, assign) KnowBaseCellType knowBaseCellType; //当前cell类型

@property (nonatomic, strong) NSIndexPath *knowBaseIndexPath;//知识库的位置

@property (nonatomic, assign) NSInteger childVcIndex; //子控制器索引
@end

@interface JGJWorkCircleMiddleInfoModel : JGJKnowBaseCommonModel
@property (nonatomic, copy) NSString *InfoImageIcon;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *unread_msg_count; //工作消息未读数
@property (nonatomic, assign) WorkCircleCollectionViewCellType cellType;
@property (nonatomic, strong) JGJKnowBaseModel *knowBaseModel; //知识库模型
@property (nonatomic, assign) BOOL isHiddenUnReadMsgFlag; //是否显示未读数标记
@end
