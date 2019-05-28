//
//  YZGGetIndexRecordModel.m
//  mix
//
//  Created by Tony on 16/3/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGGetIndexRecordModel.h"

@implementation YZGGetIndexRecordModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedArray = [NSMutableArray array];
    }
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"workday"]) {
        NSArray *valueArr = (NSArray *)value;

        __block NSMutableArray *workDayArr = [NSMutableArray new];
        [valueArr enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray<MateWorkitemsItems *> *mateWorkitemsItem = [MateWorkitemsItems mj_objectArrayWithKeyValuesArray:obj];
            if (mateWorkitemsItem) {
                [workDayArr addObject:mateWorkitemsItem];
   
            }
        }];
        
        self.workday = [workDayArr copy];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
