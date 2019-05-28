//
//  LBXScanResult.m
//
//
//  Created by lbxia on 15/11/17.
//  Copyright © 2015年 lbxia. All rights reserved.


#import "LBXScanResult.h"

@implementation LBXScanResult

- (instancetype)initWithScanString:(NSString*)str imgScan:(UIImage*)img barCodeType:(NSString*)type
{
    if (self = [super init]) {
        
        self.strScanned = str;
        self.imgScanned = img;
        self.strBarCodeType = type;
    }
    
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"扫码字符串: %@ \n类型: %@\n图片: %@",self.strScanned,self.strBarCodeType,self.imgScanned];
}
@end
