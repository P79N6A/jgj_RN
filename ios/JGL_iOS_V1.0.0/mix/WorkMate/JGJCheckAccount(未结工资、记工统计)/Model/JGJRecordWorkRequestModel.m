//
//  JGJRecordWorkRequestModel.m
//  mix
//
//  Created by yj on 2018/1/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkRequestModel.h"

@implementation JGJRecordWorkRequestModel

@end

@implementation JGJRecordWorkStaRequestModel

@end


@implementation JGJRecordWorkPointRequestModel

MJExtensionCodingImplementation

@end


@implementation JGJSetBatchSalaryTplRequestModel

- (void)requstSetBatchSalaryTplSuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = [self mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/set-batch-salary-tpl" parameters:parameters success:^(id responseObject) {
                
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(NSError *error) {
       
        if (failure) {
            
            failure(error);
        }
    }];
    
}

@end


@implementation JGJSetWorkdayTplRequestModel

- (void)requstSetWorkdayTplSuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = [self mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/set-workday-tpl" parameters:parameters success:^(id responseObject) {
        
        [TYShowMessage showSuccess:@"工资金额设置成功！"];
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
    
}

@end
