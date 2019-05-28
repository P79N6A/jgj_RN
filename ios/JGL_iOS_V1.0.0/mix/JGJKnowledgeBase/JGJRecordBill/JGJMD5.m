//
//  JGJMD5.m
//  mix
//
//  Created by Tony on 2017/6/26.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMD5.h"
#import<CommonCrypto/CommonDigest.h>

@implementation JGJMD5
+(NSString *)retrunMD5Withdic:(id)parmDic
{
    NSString *MD5Str;
//    MD5Str = [[[[[parmDic[@"client_type"] stringByAppendingString:parmDic[@"edate"]] stringByAppendingString:parmDic[@"role"]] stringByAppendingString:parmDic[@"sdate"]] stringByAppendingString:parmDic[@"uid"]] stringByAppendingString:parmDic[@"week"]];
    NSString *clientStr;
    clientStr = [NSString stringWithFormat:@"client_type=person&"];
    
    NSString *edateStr;
    edateStr = [NSString stringWithFormat:@"edate=%@&",parmDic[@"edate"]];

    NSString *roleStr;
    roleStr = [NSString stringWithFormat:@"role=%@&",parmDic[@"role"]];

    NSString *sdateStr;
    sdateStr = [NSString stringWithFormat:@"sdate=%@&",parmDic[@"sdate"]];

    NSString *uidStr;
    uidStr = [NSString stringWithFormat:@"uid=%@&",[TYUserDefaults objectForKey:JLGUserUid]?:@""];

    NSString *weekStr;
    weekStr = [NSString stringWithFormat:@"week=%@",parmDic[@"week"]];
    MD5Str = [[[[[clientStr stringByAppendingString:edateStr] stringByAppendingString:roleStr] stringByAppendingString:sdateStr] stringByAppendingString:uidStr] stringByAppendingString:weekStr];
    const char *cStr = [MD5Str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}


@end
