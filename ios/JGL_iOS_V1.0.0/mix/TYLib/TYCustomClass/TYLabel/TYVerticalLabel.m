//
//  TYVerticalLabel.m
//  mix
//
//  Created by Tony on 16/2/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYVerticalLabel.h"

@implementation TYVerticalLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setText:(NSString *)text{
    [super setText:text];
    self.numberOfLines = text.length;
}
@end
