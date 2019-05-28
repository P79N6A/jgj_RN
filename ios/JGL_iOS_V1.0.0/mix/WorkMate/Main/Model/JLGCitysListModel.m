//
//  JLGCitysListModel.m
//  mix
//
//  Created by Tony on 16/1/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGCitysListModel.h"
#import "MJExtension.h"

@implementation JLGCitysListModel

- (void )setShortname:(NSArray *)shortname{
    _shortname = shortname;
    self.city_name = [shortname componentsJoinedByString:@"-"];
}
@end


