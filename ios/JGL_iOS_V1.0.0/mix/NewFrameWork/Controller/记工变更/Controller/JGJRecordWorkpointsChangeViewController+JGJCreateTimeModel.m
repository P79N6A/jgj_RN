//
//  JGJRecordWorkpointsChangeViewController+JGJCreateTimeModel.m
//  mix
//
//  Created by Tony on 2018/8/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkpointsChangeViewController+JGJCreateTimeModel.h"
#import "JGJRecordWorkpointsChangeModel.h"
@implementation JGJRecordWorkpointsChangeViewController (JGJCreateTimeModel)

- (void)deailTimeGroupWithSource {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = self.changeListArr;
    JGJRecordWorkpointsChangeModel *lastModel = [[JGJRecordWorkpointsChangeModel alloc] init];
    for (int i = 0; i < array.count; i ++) {
        
        JGJRecordWorkpointsChangeModel *changeModel = array[i];
        
        if (i == 0) {
            
            if ([changeModel.record_type integerValue] != 0) {
                
                JGJRecordWorkpointsChangeModel *timeModel = [[JGJRecordWorkpointsChangeModel alloc] init];
                timeModel.create_time = changeModel.create_time;
                timeModel.record_type = @"0";
                [self.changeListArr insertObject:timeModel atIndex:0];
            }
            
            lastModel = changeModel;
            
        }else {
            
            if ([changeModel.record_type integerValue] != 0) {
                
                if (![changeModel.create_time isEqualToString:lastModel.create_time]) {
                    
                    JGJRecordWorkpointsChangeModel *timeModel = [[JGJRecordWorkpointsChangeModel alloc] init];
                    timeModel.create_time = changeModel.create_time;
                    timeModel.record_type = @"0";
                    [self.changeListArr insertObject:timeModel atIndex:i];
                    
                }
            }
            lastModel = changeModel;
        }
    }
}
@end
