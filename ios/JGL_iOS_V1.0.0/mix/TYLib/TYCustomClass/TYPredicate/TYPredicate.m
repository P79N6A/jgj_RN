//
//  TYPredicate.m
//  mix
//
//  Created by jizhi on 15/11/16.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYPredicate.h"

@implementation TYPredicate

+ (BOOL)isRightPhoneNumer:(NSString*)candidate{
    NSString *phoneRegex = @"^1[3456789]{1}\\d{9}$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)isRightIDCard:(NSString *)IDCardStr{
    //http://blog.jobbole.com/102601/ 算法地址

    BOOL isRightIDCard = NO;
    NSString *IDCardSubStr = [IDCardStr substringWithRange:NSMakeRange(0, 17)];
    NSString *IDCardLastStr = [IDCardStr substringWithRange:NSMakeRange(17, 1)];
    
    //十七位数字本体码权重
    NSArray *weightArr = @[@7,@9,@10,@5,@8,@4,@2,@1,@6,@3,@7,@9,@10,@5,@8,@4,@2];
    //mod11,对应校验码字符值
    NSArray *validateArr = @[@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2"];
    
    NSUInteger sumInt = 0;
    NSUInteger modeInt = 0;
    for(NSUInteger idx = 0; idx < IDCardSubStr.length; idx++){
        NSUInteger valueInt = [[IDCardSubStr substringWithRange:NSMakeRange(idx, 1)] integerValue];
        sumInt = sumInt + valueInt*([weightArr[idx] integerValue]);
    }
    modeInt = sumInt % 11;
    NSString *validateStr = validateArr[modeInt];
    
    isRightIDCard = [validateStr isEqualToString:IDCardLastStr];
//    NSLog(@"身份证号是 %@,%@身份证",IDCardStr,isRightIDCard?@"是":@"不是");
    return isRightIDCard;
}


+ (BOOL)isRightIDName:(NSString *)IDNameStr{
    BOOL isRightIDName = NO;
    if (IDNameStr.length < 2 || IDNameStr.length > 15) {
        return isRightIDName;
    }
    
    NSString *regexName = @"^[\u4e00-\u9fa5\u00B7]{2,15}$";
    NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexName];
    isRightIDName = [predicateName evaluateWithObject:IDNameStr];
    
    return isRightIDName;
}

//检测URL地址
+ (BOOL)isCheckUrl:(NSString*)url {
    
    if ([NSString isEmpty:url]) {
        
        return NO;
    }
    
    NSString*reg = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    return [predicate evaluateWithObject:url];
    
    
}


@end
