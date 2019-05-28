//
//  JGJRecordTool.m
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordTool.h"

@implementation JGJRecordToolModel


@end

@interface JGJRecordTool () <UIDocumentInteractionControllerDelegate>{
    
    UIDocumentInteractionController *_documentInteraction;
}

@end

@implementation JGJRecordTool

- (void)setToolModel:(JGJRecordToolModel *)toolModel {
    
    _toolModel = toolModel;
    
    //名字包含类型
    
    NSString *saveFileName = [NSString stringWithFormat:@"Documents/%@",toolModel.name];
    
//    BOOL isOpenDocument = toolModel.isOpenDocument;
//
//    if (isOpenDocument) {
//
//        saveFileName = [NSString stringWithFormat:@"Documents/%@.%@",toolModel.name, toolModel.type];
//    }
    
    NSString *localfilePath = [NSHomeDirectory() stringByAppendingPathComponent:saveFileName];
    
    NSString *enCodefilePath = [localfilePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *allFilePath = [[NSURL alloc] initFileURLWithPath:enCodefilePath isDirectory:NO];
    
    [JLGHttpRequest_AFN downloadWithUrl:toolModel.url?:@"" saveToPath:localfilePath success:^(NSString *fileURL, NSString *fileName) {
        
        if (self.recordToolBlock) {
            
            self.recordToolBlock(YES, allFilePath);
            
        }
        
    } fail:^{
       
        
    }];
    
}

+ (JGJRecordWorkDownLoadModel *)downFileExistWithDownLoadModel:(JGJRecordWorkDownLoadModel *)downLoadModel request:(JGJRecordWorkStaRequestModel *)request {
    
    NSString *saveFileName = [NSString stringWithFormat:@"Documents/%@",downLoadModel.file_name];
    
    NSString *localfilePath = [NSHomeDirectory() stringByAppendingPathComponent:saveFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isExist = [fileManager fileExistsAtPath:localfilePath];
    
    NSString *enCodefilePath = [localfilePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *allFilePath = [[NSURL alloc] initFileURLWithPath:enCodefilePath isDirectory:NO];
    
    downLoadModel.uid = request.uid;
    
    downLoadModel.class_type = request.class_type;
    
    downLoadModel.class_type_id = request.class_type_id;
    
    downLoadModel.start_time = request.start_time;
    
    downLoadModel.end_time = request.end_time;
    
    BOOL isExistDifFile = YES;
    
    if (![NSString isEmpty:downLoadModel.uid] && ![NSString isEmpty:request.uid]) {
        
        if (![downLoadModel.uid isEqualToString:request.uid]) {
            
            isExistDifFile = NO;
        }
    }
    
    if (![NSString isEmpty:downLoadModel.class_type] && ![NSString isEmpty:request.class_type]) {
        
        if (![downLoadModel.class_type isEqualToString:request.class_type]) {
            
            isExistDifFile = NO;
        }
    }
    
    
    if (![NSString isEmpty:downLoadModel.class_type_id] && ![NSString isEmpty:request.class_type_id]) {
        
        if (![downLoadModel.class_type_id isEqualToString:request.class_type_id]) {
            
            isExistDifFile = NO;
        }
    }
    
    if (![NSString isEmpty:downLoadModel.start_time] && ![NSString isEmpty:request.start_time]) {
        
        if (![downLoadModel.start_time isEqualToString:request.start_time]) {
            
            isExistDifFile = NO;
        }
    }
    
    if (![NSString isEmpty:downLoadModel.end_time] && ![NSString isEmpty:request.end_time]) {
        
        if (![downLoadModel.end_time isEqualToString:request.end_time]) {
            
            isExistDifFile = NO;
        }
    }
    
//    downLoadModel.isExistDifFile = isExistDifFile && isExist;
    
    downLoadModel.isExistDifFile = NO;
    
    downLoadModel.allFilePath = allFilePath;
    
    return downLoadModel;
}

+ (JGJRecordWorkDownLoadModel *)downFileExistWithRecordDownLoadModel:(JGJRecordWorkDownLoadModel *)downLoadModel request:(JGJRecordWorkPointRequestModel *)request {
    
    
    NSString *saveFileName = [NSString stringWithFormat:@"Documents/%@",downLoadModel.file_name];
    
    NSString *localfilePath = [NSHomeDirectory() stringByAppendingPathComponent:saveFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isExist = [fileManager fileExistsAtPath:localfilePath];
    
    NSString *enCodefilePath = [localfilePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *allFilePath = [[NSURL alloc] initFileURLWithPath:enCodefilePath isDirectory:NO];
    
    downLoadModel.uid = request.uid;
    
    downLoadModel.pid = request.pid;
    
    downLoadModel.date = request.date;
    
    BOOL isExistDifFile = YES;
    
    if (![NSString isEmpty:downLoadModel.uid] && ![NSString isEmpty:request.uid]) {
        
        if (![downLoadModel.uid isEqualToString:request.uid]) {
            
            isExistDifFile = NO;
        }
    }
    
    if (![NSString isEmpty:downLoadModel.pid] && ![NSString isEmpty:request.pid]) {
        
        if (![downLoadModel.pid isEqualToString:request.pid]) {
            
            isExistDifFile = NO;
        }
    }
    
    
    if (![NSString isEmpty:downLoadModel.date] && ![NSString isEmpty:request.date]) {
        
        if (![downLoadModel.date isEqualToString:request.date]) {
            
            isExistDifFile = NO;
        }
    }
    
    
//    downLoadModel.isExistDifFile = isExistDifFile && isExist;
    
    downLoadModel.isExistDifFile = NO;
    
    downLoadModel.allFilePath = allFilePath;
    
    return downLoadModel;
}

@end
