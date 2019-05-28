//
//  JLGTableView.m
//  mix
//
//  Created by jizhi on 15/12/16.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGTableView.h"

@implementation JLGTableView
- (void)reloadData {
    TYLog(@"开始 reloadData");
    [super reloadData];
    TYLog(@"结束 reloadData");
    if ([self.JLGdelegate respondsToSelector:@selector(reloadDataCompletion)]) {
        [self.JLGdelegate reloadDataCompletion];
    }
}

@end
