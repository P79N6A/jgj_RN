//
//  JGJProicloudListModel.m
//  JGJCompany
//
//  Created by yj on 2017/7/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProicloudListModel.h"

#import "NSString+Extend.h"

@implementation JGJProicloudListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{@"fileId" : @"id"};
}

- (BOOL)isImage {
    
    return [self.belong_file isEqualToString:@"picture"] || [self.file_broad_type isEqualToString:@"pic"];
}


- (CGFloat)progress {
    if (_progress == NAN) {
        
        _progress = 0;
    }

    return _progress;
}

- (NSString *)file_name {
    
    if ([NSString isEmpty:_file_name] && _file_name.length > 100) {
        
        _file_name = [_file_name substringToIndex:100];
    }
    
    return _file_name;

}

MJExtensionCodingImplementation

@end

@implementation JGJProicloudModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list" : @"JGJProicloudListModel"};
}

@end

@implementation JGJProiCloudUploadFilesModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{@"xId" : @"id"};
}

@end

