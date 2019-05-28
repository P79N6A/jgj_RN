//
//  JGJRecordStaListVc+filterService.h
//  mix
//
//  Created by yj on 2018/9/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordStaListVc.h"

@interface JGJRecordStaListVc (filterService)

- (void)handleFilterAction;

- (void)loadData;

//第二级样式
- (NSArray *)titles;

@end
