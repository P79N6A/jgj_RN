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
    NSString *phoneRegex = @"^1[0-9]{10}$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [emailTest evaluateWithObject:candidate];
}

@end
