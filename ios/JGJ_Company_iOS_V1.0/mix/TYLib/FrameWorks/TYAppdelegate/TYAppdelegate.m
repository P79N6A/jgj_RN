//
//  TYAppdelegate.m
//  mix
//
//  Created by Tony on 15/12/31.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYAppdelegate.h"

@implementation TYAppdelegate

+(void )addSubView:(UIView *)subView{
    [[[UIApplication sharedApplication] delegate].window addSubview:subView];
}

@end
