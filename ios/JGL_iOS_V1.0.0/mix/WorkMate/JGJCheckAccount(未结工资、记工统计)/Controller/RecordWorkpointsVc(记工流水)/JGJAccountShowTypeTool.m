//
//  JGJAccountShowTypeTool.m
//  mix
//
//  Created by yj on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAccountShowTypeTool.h"

#define JGJShowTypePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"JGJShowType.archive"]

@implementation JGJAccountShowTypeModel

MJExtensionCodingImplementation

@end

@implementation JGJAccountShowTypeTool

+ (void)saveShowTypeModel:(id)showTypeModel {
    
    [NSKeyedArchiver archiveRootObject:showTypeModel toFile:JGJShowTypePath];
}

+ (id)showTypeModel {
    
   JGJAccountShowTypeModel *showTypeModel = [NSKeyedUnarchiver unarchiveObjectWithFile:JGJShowTypePath];
    
    if (!showTypeModel) {
        
        //  默认显示方式

        if (!showTypeModel) {
            
            showTypeModel = [[JGJAccountShowTypeModel alloc] init];
            
            showTypeModel.title = JGJShowTypes[0];
            
            showTypeModel.type = 0;
            
        }
    }
    
    return showTypeModel;
}

@end
