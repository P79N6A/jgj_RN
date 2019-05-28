//
//  NSArray+JGJDateSort.m
//  mix
//
//  Created by yj on 2018/8/28.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "NSArray+JGJDateSort.h"

@implementation NSArray (JGJDateSort)

- (NSArray *)sortDataSource{
    
    NSDictionary *dic = nil;
    
    if (self.count > 0) {
        
        dic = self.firstObject;
        
    }else {
        
        return nil;
    }
    
    NSMutableDictionary *pageSizeDic = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *lastPageSizeDic = [[NSMutableDictionary alloc] init];
    
    NSString *lastDate = dic[@"sign_date_str"];
    
    NSInteger length = 0;
    
    NSMutableArray *sectionDataSource = [NSMutableArray new];
    
    pageSizeDic[@"location"] = 0;
    
    pageSizeDic[@"length"] = 0;
    
    [sectionDataSource addObject:pageSizeDic];
    
    for (NSInteger indx = 0; indx < self.count; indx++) {
        
        dic = self[indx];
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            if (![dic[@"sign_date_str"] isEqualToString:lastDate]) {
                
                lastDate = dic[@"sign_date_str"];
                
                lastPageSizeDic = pageSizeDic;
                
                pageSizeDic = [[NSMutableDictionary alloc] init];
                
                pageSizeDic[@"location"] = @(indx);
                
                [sectionDataSource addObject:pageSizeDic];
                
            }
            
            length = indx - ([lastPageSizeDic[@"location"] integerValue] + [lastPageSizeDic[@"length"] integerValue]) + 1;
            
            pageSizeDic[@"length"] = @(length);
        }
    }
    
    //筛选后的数据
    
    NSMutableArray *sortDataSource = [NSMutableArray array];
    
    for (NSMutableDictionary *pageSizeDic in sectionDataSource) {
        
        NSRange range = NSMakeRange([pageSizeDic[@"location"] integerValue], [pageSizeDic[@"length"] integerValue]);
        
        NSMutableDictionary *subDic = [NSMutableDictionary new];
        
        NSArray *subArr = [self subarrayWithRange:range];
        
        subDic[@"sign_list"] = [self subarrayWithRange:range];
        
        if (subArr.count > 0) {
            
            NSDictionary *firSubDic = subArr.firstObject;
            
            subDic[@"sign_date_str"] = firSubDic[@"sign_date_str"];
            
            subDic[@"sign_date"] = firSubDic[@"sign_date"];
            
            subDic[@"sign_date_num"] = firSubDic[@"sign_date_num"];
            
        }
        
        [sortDataSource addObject:subDic];
        
    }
    
    return sortDataSource;
}

- (NSArray *)groupByDataSourceWithGropKey:(NSString *)groupKey dicHeaderKeys:(NSArray *)headerKeys{
    
    if ([NSString isEmpty:groupKey]) {
        
        return nil;
    }
    NSDictionary *dic = nil;
    
    if (self.count > 0) {
        
        dic = self.firstObject;
        
    }else {
        
        return nil;
    }
    
    NSMutableDictionary *pageSizeDic = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *lastPageSizeDic = [[NSMutableDictionary alloc] init];
    
    NSString *lastDate = dic[groupKey];
    
    NSInteger length = 0;
    
    NSMutableArray *sectionDataSource = [NSMutableArray new];
    
    pageSizeDic[@"location"] = 0;
    
    pageSizeDic[@"length"] = 0;
    
    [sectionDataSource addObject:pageSizeDic];
    
    for (NSInteger indx = 0; indx < self.count; indx++) {
        
        dic = self[indx];
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            if (![dic[groupKey] isEqualToString:lastDate]) {
                
                lastDate = dic[groupKey];
                
                lastPageSizeDic = pageSizeDic;
                
                pageSizeDic = [[NSMutableDictionary alloc] init];
                
                pageSizeDic[@"location"] = @(indx);
                
                [sectionDataSource addObject:pageSizeDic];
                
            }
            
            length = indx - ([lastPageSizeDic[@"location"] integerValue] + [lastPageSizeDic[@"length"] integerValue]) + 1;
            
            pageSizeDic[@"length"] = @(length);
        }
    }
    
    //筛选后的数据
    
    NSMutableArray *sortDataSource = [NSMutableArray array];
    
    for (NSMutableDictionary *pageSizeDic in sectionDataSource) {
        
        NSRange range = NSMakeRange([pageSizeDic[@"location"] integerValue], [pageSizeDic[@"length"] integerValue]);
        
        NSMutableDictionary *subDic = [NSMutableDictionary new];
        
        NSArray *subArr = [self subarrayWithRange:range];
        
        subDic[@"list"] = [self subarrayWithRange:range];
        
        if (subArr.count > 0) {
            
            NSDictionary *firSubDic = subArr.firstObject;
            
            if (headerKeys.count > 0) {
                
                for (int i = 0; i < headerKeys.count; i ++) {
                    
                    NSString *keys = headerKeys[i];
                    subDic[keys] = firSubDic[keys];
                }
            }
            
            
        }
        
        [sortDataSource addObject:subDic];
        
    }
    
    return sortDataSource;
}

- (NSArray *)groupBySortDataSourceWithGroupKey:(NSString *)groupKey subListKey:(NSString *)subListKey headerKeys:(NSArray *)headerKeys{
    
    if ([NSString isEmpty:groupKey]) {
        
        return nil;
    }
    NSDictionary *dic = nil;
    
    if (self.count > 0) {
        
        dic = self.firstObject;
        
    }else {
        
        return nil;
    }
    
    NSMutableDictionary *pageSizeDic = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *lastPageSizeDic = [[NSMutableDictionary alloc] init];
    
    NSString *lastDate = dic[groupKey];
    
    NSInteger length = 0;
    
    NSMutableArray *sectionDataSource = [NSMutableArray new];
    
    pageSizeDic[@"location"] = 0;
    
    pageSizeDic[@"length"] = 0;
    
    [sectionDataSource addObject:pageSizeDic];
    
    for (NSInteger indx = 0; indx < self.count; indx++) {
        
        dic = self[indx];
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            BOOL is_unEqual = NO;
            
            if ([dic[groupKey] isKindOfClass:[NSString class]]) {
                
                is_unEqual = ![dic[groupKey] isEqualToString:lastDate];
                
            }
            
            if ([dic[groupKey] isKindOfClass:[NSNumber class]]) {
                
                NSInteger groupKeyValue = [dic[groupKey] integerValue];
                
                NSInteger lastKeyValue = [lastDate integerValue];
                
                is_unEqual = groupKeyValue != lastKeyValue;
                
            }
            
            if (is_unEqual) {
                
                lastDate = dic[groupKey];
                
                lastPageSizeDic = pageSizeDic;
                
                pageSizeDic = [[NSMutableDictionary alloc] init];
                
                pageSizeDic[@"location"] = @(indx);
                
                [sectionDataSource addObject:pageSizeDic];
                
            }
            
            length = indx - ([lastPageSizeDic[@"location"] integerValue] + [lastPageSizeDic[@"length"] integerValue]) + 1;
            
            pageSizeDic[@"length"] = @(length);
        }
    }
    
    //筛选后的数据
    
    NSMutableArray *sortDataSource = [NSMutableArray array];
    
    for (NSMutableDictionary *pageSizeDic in sectionDataSource) {
        
        NSRange range = NSMakeRange([pageSizeDic[@"location"] integerValue], [pageSizeDic[@"length"] integerValue]);
        
        NSMutableDictionary *subDic = [NSMutableDictionary new];
        
        NSArray *subArr = [self subarrayWithRange:range];
        
        if (![NSString isEmpty:subListKey]) {
            
            subDic[subListKey] = [self subarrayWithRange:range];
            
        }else {
            
            subDic[@"list"] = [self subarrayWithRange:range];
        }
        
        if (subArr.count > 0) {
            
            NSDictionary *firSubDic = subArr.firstObject;
            
            if (headerKeys.count > 0) {
                
                for (int i = 0; i < headerKeys.count; i ++) {
                    
                    NSString *keys = headerKeys[i];
                    subDic[keys] = firSubDic[keys];
                }
            }
            
            
        }
        
        [sortDataSource addObject:subDic];
        
    }
    
    return sortDataSource;
}

@end
