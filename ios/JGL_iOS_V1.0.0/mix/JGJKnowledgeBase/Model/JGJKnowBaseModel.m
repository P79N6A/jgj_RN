//
//  JGJKnowBaseModel.m
//  mix
//
//  Created by yj on 17/4/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJKnowBaseModel.h"

#import "NSString+Extend.h"

@implementation JGJKnowBaseCommonModel

@end

@implementation JGJKnowBaseModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"knowBaseId" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {


    return @{@"child" : @"JGJKnowBaseModel"};
}

- (CGFloat)cellHeight {

    _cellHeight = 50.0;
    
//    self.file_name = @"我让二额热热热人儿儿额热热热人儿额热人儿为热热人儿额热热我让娃儿二位惹我惹我人儿二位惹我人儿儿为人儿二位热若    额热热儿儿额热人儿额热人儿额热人";
    
    _cellHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 142 content:self.file_name font:AppFont30Size] + 31;
    
    if (_cellHeight < 50) {
        
        _cellHeight = 50;
    }

    return _cellHeight;
}

- (CGFloat)downloadCellHeight {
    
    _downloadCellHeight = 75.0;
    
    //    self.file_name = @"我让二额热热热人儿儿额热热热人儿额热人儿为热热人儿额热热我让娃儿二位惹我惹我人儿二位惹我人儿儿为人儿二位热若    额热热儿儿额热人儿额热人儿额热人";
    
    _downloadCellHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 103 content:self.file_name font:AppFont30Size] + 57;
    
    if (_downloadCellHeight < 75) {
        
        _downloadCellHeight = 75;
    }
    
    return _downloadCellHeight;
}

MJExtensionCodingImplementation

@end

@implementation JGJWorkCircleMiddleInfoModel

@end
