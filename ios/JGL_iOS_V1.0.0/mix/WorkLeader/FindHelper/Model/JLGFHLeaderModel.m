//
//  JLGFHLeaderModel.m
//  mix
//
//  Created by jizhi on 15/12/1.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGFHLeaderModel.h"
#import "JGJCustomListView.h"

#define Padding 10
#define Margin 12
#define LableHeight 22
@implementation JLGFHLeaderModel

+ (NSDictionary *)objectClassInArray{
    return @{@"worktype" : [FHLeaderWorktype class]};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"work_type" : [FHLeaderWorktype class]};
}

- (NSArray *)main_filed {

    if (!_main_filed) {
        __block NSMutableArray *main_filedArray = [NSMutableArray array];
        [self.work_type enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [main_filedArray addObject:obj[@"type_name"]];
        }];
        _main_filed = [main_filedArray copy];
    }
    return _main_filed;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"worktype"]) {
        [super setValue:value forKey:key];
        
        __block NSMutableArray *main_filedArray = [NSMutableArray array];
        [value enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [main_filedArray addObject:obj[@"name"]];
        }];
        self.main_filed = [main_filedArray copy];
    }else{
        [super setValue:value forKey:key];
    }
}

- (CGFloat)worktypeViewH {

    JGJCustomListView *jgjCusListView = [[JGJCustomListView alloc] init];
    [jgjCusListView setCustomListViewDataSource:self.main_filed lineMaxWidth:self.lineMaxWidth];
    return jgjCusListView.totalHeight;
 }
@end

@implementation FHLeaderWorktype

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"type_id" : @"id",
                    @"type_name" : @"name"
                    };
}

@end


