//
//  JGJSHA1.m
//  mix
//
//  Created by Tony on 2017/5/4.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSHA1.h"
#import<CommonCrypto/CommonDigest.h>
@implementation JGJSHA1

+ (NSString *)retrunSha_1Str
{
    NSString *Key;
    NSString *oldStamp = [TYUserDefaults objectForKey:@"userStamp"]?:@"0";
    NSInteger timeStamp =  [[NSDate date] timeIntervalSince1970];
    long stamp = timeStamp + [oldStamp doubleValue];
    NSString *timeStampStr = [NSString stringWithFormat:@"%ld",stamp];
    //  NSString *userToken = [TYUserDefaults objectForKey:JLGToken];
    if (!timeStampStr) {
        timeStampStr = [NSString stringWithFormat:@"%ld",(long)stamp];
    }
    //    if (JLGLogin && userToken) {
    //        Key = [timeStampStr stringByAppendingString:userToken];
    //    }else{
    Key = [@"OaxhSsnvFnRCUql53jVDUVVp26pQkYea" stringByAppendingString:timeStampStr];
    //    }
    const char *cstr = [Key cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:Key.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return [NSString stringWithFormat:@"%@-%@",output,timeStampStr];
}
@end
